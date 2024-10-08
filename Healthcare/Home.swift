//
//  Home.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 13/03/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore



struct HomeView: View {
    
    
    @State private var doctorname: String = ""
    @State private var username: String = ""
    @State private var specialty: String = ""
    @State private var isLoggedOut = false
    @State private var greeting: String = ""
    @State private var textOffset: CGFloat = -40
    @State private var appointmentDetails: [AppointmentDetails] = []
    @State private var isLoading = false
    
    
    
    let db = Firestore.firestore() // Reference to Firestore
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // Define 2 flexible columns
    let spacing: CGFloat = 15 // Adjust spacing between items
    
    let currentDate: Date
    let week = Calendar.current
    let appointment: AppointmentDetails
    
    
    private func formattedCurrentDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    private func dayOfWeek(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
    
    var body: some View {
            NavigationView {
                ZStack {
                    
                    Color(UIColor.systemGray6).ignoresSafeArea(.all)
            
                    ScrollView {
                        VStack(spacing: spacing) {
                            Spacer()
                            HStack{
                                Text(greeting + "\(username)")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .offset(x:textOffset)
                                    .fontDesign(.monospaced)
                                    .opacity(0.7)
                                
                            }
                            Spacer()
                            
                            ZStack {
                                HStack {
                                   
                                }
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(35)
                                
                                VStack {
          
                                    Text("Today's Appointments?")
                                        .font(.system(size: 24))
                                        .offset(x:-5, y:10)
                                    
                                    if isLoading {
                                        ProgressView()
                                    } else if appointmentDetails.isEmpty {
                                        Text("There are no appointments today")
                                            .font(.headline)
                                            .offset(x:-65,y:-40)
                                            .frame(width: 200)
                                            .padding(.top, 80)
                                    } else {
                                        ScrollView {
                                            
                                            ForEach(appointmentDetails) { appointment
                                                in
                                                
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        Text(appointment.doctorName)
                                                            .font(.title2)
                                                            .offset(x:10)
                                                        Text(appointment.specialty)
                                                            .padding(5)
                                                            .foregroundColor(Color.white)
                                                            .font(.subheadline)
                                                            .background(Color.mint.opacity(1))
                                                            .cornerRadius(10)
                                                            .offset(x:10, y:-10)
                                                            
                                                    }
                                                    Spacer(minLength: 50)
                                                    Text(formatDate(appointment.selectedDate))
                                                        .font(.headline)
                                                        .padding(10)
                                                        .background(Color(.systemBackground))
                                                        .cornerRadius(10)
                                                  
                                                }
                                                
                                                
                                            }
                                        }
                                        .offset(y:20)
                                    }
                                    
                                  
                                        
                                }
                                .opacity(0.7)
                                .padding()
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .fontDesign(.monospaced)
                                
                            }
                            
                            NavigationLink(destination: FindDoctor()) {
                                
                                HStack(spacing: spacing) {
                                    
                                    ZStack {
                                    
                                    VStack {
                                        
                                        Spacer()
                                    }
                                    .frame(height: 150)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(35)
                                    
                                        VStack(alignment: .leading) {
                                            Text("Make an Appointment")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.leading)
                                                .offset(x:-10)
                                            
                                            Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 60))
                                                .foregroundColor(Color(.systemGray))
                                                .offset(x:70, y:15)
                                                                                    
                                        }
                                        .padding(.leading, 10)
                                        
                                        
                                        
                                }
                                    
                                    
                                    HStack {
                                       
                                        
                                        VStack(alignment: .leading) {
                                           
                                            Text("\(week.component(.day, from: currentDate))")
                                                .font(.system(size: 100))
                                                .offset(x:30)
                                            
                                                
                                              
                                            
                                            Text("\(formattedCurrentDate(currentDate))")
                                                .font(.system(size: 25))
                                                .offset(x:15, y: -10)
                                            
                                        }
                                        .padding(.leading, 10)
                                        .foregroundColor(Color(.systemBackground))
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .fontDesign(.monospaced)
                                        
                                        Spacer()
                                    }
                                    .frame(height: 150)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.mint.opacity(0.8))
                                    .cornerRadius(35)
                                 
                                    
                                }
                                
                            }
                            
                            NavigationLink(destination: GenrativeAI()) {
                                HStack(spacing: spacing) {
                                    
                                    ZStack {
                                        
                                        VStack {
                                            
                                            
                                        }
                                        .frame(height: 150)
                                        .frame(width: 150)
                                        .padding()
                                        .background(Color(.systemBackground))
                                        .cornerRadius(35)
                                        
                                        VStack(alignment: .leading) {
                                            Text("Accura")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.gray)
                                                .multilineTextAlignment(.leading)
                                                .offset(x:-10)
                                            
                                            Image(systemName: "circle")
                                                .font(.system(size: 60))
                                                .foregroundColor(Color(.systemGray))
                                                .offset(x:-5, y:15)
                                            
                                        }
                                        .padding(.leading, 10)
                                        
                                        
                                        
                                    }
                                    .offset(x:-95)
                                    
                                    
                                    
                                    
                                }
                                
                            }
                            
                           
                            
                         
                            
                            // Other Boxes Below
        //                    LazyVGrid(columns: columns, spacing: spacing) {
        //
        //
        //                        Button(action: {
        //                            logout()
        //                        }) {
        //                            CardView(title: "Log out", iconName: "arrow.right.square", gradientColors: [.red.opacity(0.6), .blue.opacity(0.8)], iconSize: 100, iconWidth: 170, iconHeight: 180)
        //                        }
        //                    }
                        }
                        .padding()
                    }
                    .onAppear {
                            fetchUsername()
                            fetchAppointmentDetails()
                        }
                                
                    .fullScreenCover(isPresented: $isLoggedOut) {
                        LoginView()
                    }
         
                }
                       }
    }
    
    
    
    
    func fetchAppointmentDetails() {
        isLoading = true
        
        AppointmentService.shared.fetchAppointmentDetails { result in
            DispatchQueue.main.async {
                self.isLoading = false
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let today = formatter.string(from: Date())
                
                switch result {
                case .success(let appointments):
                    let isToday = appointments.filter { appointment in
                        return formatter.string(from: appointment.selectedDate) == today
                    }
                    
                    if isToday.isEmpty {
                        self.appointmentDetails = []
                    } else {
                        self.appointmentDetails = Array(isToday.prefix(2))
                       
                        
                    }
                case .failure(let error):
                    print("Error fetching appointment details: \(error)")
                    // You might want to update UI here to show an error message
                }
            }
        }
    }
    
    
    
    
    func setGreeting() {
            let hour = Calendar.current.component(.hour, from: Date())
            if hour < 12 {
                greeting = "Rise and shine,  "
                textOffset = 0
            } else if hour < 18 {
                greeting = "Hope your day’s going well,  "
                textOffset = -10
            } else {
                greeting = "Hope you had a good day,  "
                textOffset = -20
            }
        }
    
    

    
    func fetchDocnames(completion: @escaping ([String]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Doctors").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching doctors: \(error.localizedDescription)")
                completion([])
                return
            }
            
            
            let usernames = querySnapshot?.documents.compactMap { document in
           
                return document.data()["username"] as? String
            } ?? []
            
            
            completion(usernames)
        }
    }

    
    
    func fetchUsername() {
        guard let user = Auth.auth().currentUser else {
            username = "No User Found!!"
            greeting = "Good Day"
            textOffset = 0
            return
        }
        
        
        let uid = user.uid
        db.collection("users").document(uid).getDocument { (document, error) in
            
            if let error = error {
                            print("Error fetching document: \(error.localizedDescription)")
                            username = "Error"
                            greeting = "Good Day"
                            textOffset = 0
                
                            return
                        }
            
            if let document = document, document.exists {
                if let name = document.data()?["username"] as? String {
                    let firstName = name.split(separator: " ").first ?? ""
                        username = String(firstName)
                } else {
                    username = ""
                }
                setGreeting()
            } else {
                print("Document does not exist: \(error?.localizedDescription ?? "Unknown error")")
                username = ""
            }
        }
    }
    
    
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedOut = true
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
}


struct CardView: View {
    
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let iconName: String
    let gradientColors: [Color]
    let iconSize: CGFloat
    let iconWidth: CGFloat
    let iconHeight: CGFloat

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .font(.system(size: iconSize))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .padding()

            Text(title)
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.white)
        }
        .padding(15)
        .frame(width: iconWidth, height: iconHeight)
        .background(LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .center, endPoint: .topLeading))
        .cornerRadius(35)
    }
}

struct ComingSoonView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Coming Soon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.indigo)
            
            Text("Stay tuned for updates!")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            Spacer()
            
            Image(systemName: "clock")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.indigo)
            
            Spacer()
        }
        .padding()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(currentDate: Date(), appointment: AppointmentDetails(id: "", fullName: "", doctorName: "", specialty: "", selectedDate: Date()))
    }
}
