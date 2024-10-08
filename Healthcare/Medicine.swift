//
//  Medicine.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 17/03/24.
//

import SwiftUI
import Combine
import FirebaseFirestore

struct MedicineView: View {
    @StateObject private var viewModel = MedicineViewModel()
    @State private var searchText: String = ""
    @State private var selectedDrug: IdentifiedString?
    @State private var cartItems: [IdentifiedString] = []
    @State private var isShowingCartHistory = false
    
    var body: some View {
    
            VStack {
                List(viewModel.filteredDrugNames(searchText: searchText)) { identifiedDrug in
                    Button(action: {
                        selectedDrug = identifiedDrug
                    }) {
                        DrugListItemView(identifiedDrug: identifiedDrug, isSelected: selectedDrug == identifiedDrug)
                    }
                }
                .listStyle(.inset)
                .padding()
            }
            .navigationTitle("Medical Store")
            .navigationBarItems(trailing: Button(action: {
                isShowingCartHistory = true
            }) {
                Image(systemName: "cart")
            })
            .sheet(isPresented: $isShowingCartHistory) {
                CartHistoryView(cartItems: cartItems)
            }
            .sheet(item: $selectedDrug) { identifiedDrug in
                MedicineDetailView(drugName: identifiedDrug.value, addToCartAction: {
                    addToCart(item: identifiedDrug)
                })
            }
            .onAppear {
                viewModel.fetchData()
            }
        
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for Medicines")
    }
    
    func addToCart(item: IdentifiedString) {
        let db = Firestore.firestore()
        db.collection("cart").addDocument(data: [
            "medicineName": item.value
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
            }
        }
        cartItems.append(item)
    }
}

struct DrugListItemView: View {
    var identifiedDrug: IdentifiedString
    var isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(identifiedDrug.value)
                .font(.headline)
            if isSelected {
                Text("Price: $10.00")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct MedicineDetailView: View {
    var drugName: String
    var addToCartAction: () -> Void
    
    var body: some View {
        VStack {
            Text(drugName)
                .font(.title)
                .padding()
            Text("Price: $10.00")
                .font(.headline)
                .padding(.bottom)
            Button(action: {
                addToCartAction()
            }) {
                Text("Add to Cart")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
            Spacer()
        }
    }
}

class MedicineViewModel: ObservableObject {
    @Published var drugNames: [IdentifiedString] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchData() {
        guard let url = URL(string: "https://api.fda.gov/drug/label.json?count=openfda.brand_name.exact") else {
            fatalError("Invalid URL")
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: OpenFDAResponse.self, decoder: JSONDecoder())
            .map { $0.results.map { IdentifiedString(value: $0.term) } }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.drugNames, on: self)
            .store(in: &cancellables)
    }
    
    func filteredDrugNames(searchText: String) -> [IdentifiedString] {
        if searchText.isEmpty {
            return drugNames
        } else {
            return drugNames.filter { $0.value.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct OpenFDAResponse: Codable {
    let results: [OpenFDADrug]
}

struct OpenFDADrug: Codable {
    let term: String
}

// Wrapper struct conforming to Identifiable and Equatable
struct IdentifiedString: Identifiable, Equatable {
    var id = UUID()
    var value: String
}

struct CartHistoryView: View {
    var cartItems: [IdentifiedString]
    @State private var isOrderConfirmed = false
    
    var body: some View {
        NavigationView {
            VStack {
                List(cartItems) { item in
                    Text(item.value)
                }
                .navigationBarTitle("Cart History")
                
                Divider()
                
                Text("Total Amount: ₹\(calculateTotalAmount(cartItems: cartItems), specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    confirmOrder()
                }) {
                    Text("Pay as Cash On Delivery")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
            .alert(isPresented: $isOrderConfirmed) {
                Alert(title: Text("Order Confirmed"), message: Text("Your order has been confirmed and will be delivered soon."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func calculateTotalAmount(cartItems: [IdentifiedString]) -> Double {
        return Double(cartItems.count) * 10.00 // Assuming each item costs $10.00
    }
    
    func confirmOrder() {
        // Here you can add any logic for confirming the order, such as sending it to the server or updating local data.
        // For demonstration purposes, we'll just show an alert to confirm the order.
        isOrderConfirmed = true
    }
}


struct MedicineView_Previews: PreviewProvider {
    static var previews: some View {
        MedicineView()
    }
}



