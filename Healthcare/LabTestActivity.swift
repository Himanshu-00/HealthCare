//
//  LabTestActivity.swift
//  HealthCare
//
//  Created by Athul Sasikumar on 14/03/24.
//

import SwiftUI

struct LabTestActivity: View {
    @State private var packages = [
        Package(name: "Package 1 : Full Body Checkup", price: "999"),
        Package(name: "Package 2 : Blood Glucose Fasting", price: "299"),
        Package(name: "Package 3 : COVID-19 Antibody - IgG", price: "899"),
        Package(name: "Package 4 : Thyroid Check", price: "499"),
        Package(name: "Package 5 : Immunity Check", price: "699")
    ]
    @State private var cart: [Package] = []
    
    var body: some View {

            List {
                ForEach(packages.indices, id: \.self) { index in
                    NavigationLink(destination: LabTestDetailsActivity(package: packages[index])) {
                        LabTestRow(package: packages[index])
                    }
                }
            }
            .navigationTitle("Lab Test Packages")
//            .navigationBarItems(trailing: NavigationLink(destination: CartView(cart: cart)) {
//                Text("Cart")
//            })
        
    }
}

struct LabTestRow: View {
    var package: Package
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(package.name)
                .font(.headline)
            Text("Total Cost: \(package.price)/-")
                .foregroundColor(.gray)
        }
        .padding(10)
    }
}

struct LabTestDetailsActivity: View {
    var package: Package
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(package.name)
                .font(.title)
                .padding()
            Text("Package Details:")
                .font(.headline)
                .padding(.horizontal)
            Text(package.price)
                .padding(.horizontal)
            Spacer()
            Text("Total Cost: \(package.price)/-")
                .font(.headline)
                .padding()
        }
        .navigationTitle("Lab Test Details")
    }
}

//struct CartView: View {
//    var cart: [Package]
//    
//    var body: some View {
//        VStack {
//            Text("Cart")
//                .font(.title)
//                .padding()
//            List(cart, id: \.self) { item in
//                HStack {
//                    Text(item.name)
//                    Spacer()
//                    Text("₹\(item.price)/-")
//                }
//            }
//            .padding(.horizontal)
//            Spacer()
//        }
//        .navigationTitle("Cart")
//    }
//}

struct Package: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: String
}

struct LabTestActivity_Previews: PreviewProvider {
    static var previews: some View {
        LabTestActivity()
    }
}

struct LabTestRow_Previews: PreviewProvider {
    static var previews: some View {
        LabTestRow(package: Package(name: "Package 1 : Full Body Checkup", price: "999"))
    }
}

struct LabTestDetailsActivity_Previews: PreviewProvider {
    static var previews: some View {
        LabTestDetailsActivity(package: Package(name: "Package 1 : Full Body Checkup", price: "999"))
    }
}


