//
//  MainView.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 01/09/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MainView: View {
    
    @State private var selectedTab: String = "Home"
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                       VStack {
                           // Navigation to different views based on selectedTab
                           if selectedTab == "Home" {
                               HomeView(currentDate:Date(), appointment: AppointmentDetails(id: "", fullName: "", doctorName: "", specialty: "", selectedDate: Date()))
                           } else if selectedTab == "Upcoming" {
                               MessageView()
                           } else if selectedTab == "Profile" {
                               ProfileView()
                           }
                       }
                       .navigationBarHidden(true)
                   }
        //FloatingNavigationBar
            FloatingNavigationBar(selectedTab: $selectedTab)
                .edgesIgnoringSafeArea(.bottom)
        }
        

    }
}

struct FloatingNavigationBar: View {
    
    @Binding var selectedTab: String
    @Environment(\.colorScheme) var colorScheme
    @State private var tabPosition: CGFloat = -UIScreen.main.bounds.width / 3.5

    var body: some View {
        ZStack {
        
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.6))
                .frame(width: 70, height: 60)
                .offset(x: tabPosition)
                .animation(.spring(), value: tabPosition)
                

            HStack {
                Spacer()

                // Home Button
                Button(action: {
                    withAnimation {
                        selectedTab = "Home"
                        tabPosition = -UIScreen.main.bounds.width / 3.5
                    }
                }) {
                    Image(selectedTab == "Home" ? (colorScheme == .dark ? "home-w" : "home-w") : "home-w")
                        .resizable()
                        .frame(width: 30, height: 25)
                        .padding(.vertical, 10)
                }
                .frame(width: 60, height: 60)
                .padding(.horizontal, 20)

                Spacer()

                // Message Button
                Button(action: {
                    withAnimation {
                        selectedTab = "Upcoming"
                        tabPosition = 0
                    }
                }) {
                    Image(selectedTab == "Upcoming" ? (colorScheme == .dark ? "clock-w" : "clock-w" ): "clock-w")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.vertical, 10)
                        .foregroundColor(selectedTab == "Upcoming" ? .white : .white)
                }
                .frame(width: 60, height: 60)
                .padding(.horizontal, 20)

                Spacer()

                // Profile Button
                Button(action: {
                    withAnimation {
                        selectedTab = "Profile"
                        tabPosition = UIScreen.main.bounds.width / 3.5
                    }
                }) {
                    Image(systemName: selectedTab == "Profile" ? "person.circle.fill" : "person.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.vertical, 10)
                        .foregroundColor(selectedTab == "Profile" ? .white : .white)
                }
                .frame(width: 60, height: 60)
                .padding(.horizontal, 20)

                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(Color(UIColor {
            traitCollection in
            return traitCollection.userInterfaceStyle == .dark ?
            UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 0.9) :
            UIColor(red:0.1, green: 0.74, blue: 0.74, alpha: 0.8)
        }))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.horizontal, 20)
        .shadow(radius: 1)
    }
}

struct MessageView: View {
    @State private var isLoading = false
    @State private var appointmentDetails: [AppointmentDetails] = []
    
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
                        return formatter.string(from: appointment.selectedDate) > today
                    }
                    
                    if isToday.isEmpty {
                        self.appointmentDetails = []
                    } else {
                        self.appointmentDetails = Array(isToday)
                       
                        
                    }
                case .failure(let error):
                    print("Error fetching appointment details: \(error)")
                    // You might want to update UI here to show an error message
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("Upcoming Appointments")
                .font(.largeTitle)
                .offset(x:-50, y:10)
                .fontDesign(.monospaced)
                .fontWeight(.heavy)
            
            Spacer(minLength: 40)
            
            if isLoading {
                ProgressView()
            } else if appointmentDetails.isEmpty {
                Text("There are no appointments")
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
                                    .offset(x:10, y:-5)
                                    
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
        .onAppear {
                fetchAppointmentDetails()
            }
        .opacity(0.7)
        .padding()
        .font(.largeTitle)
        .fontWeight(.bold)
        .fontDesign(.monospaced)
        
    }
}

struct ProfileView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var isLoading = false
    @State private var isLoggedOut = false
    
    
    let db = Firestore.firestore()
    
    func fetchUserdetails() {
        guard let user = Auth.auth().currentUser else {
            username = "No User Found!!"
            return
        }
        
        
        let uid = user.uid
        db.collection("users").document(uid).getDocument { (document, error) in
            
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                
                return
            }
            
            if let document = document, document.exists {
                 let name = document.data()?["username"] as? String
                username = String(name ?? "")
                 let useremail = document.data()?["email"] as? String
                    email = String(useremail ?? "")
                 let phonenum = document.data()?["phoneno"] as? String
                    phone = String(phonenum ?? "+91 9687536543")
                }
                    else {
                        print("Document does not exist: \(error?.localizedDescription ?? "Unknown error")")
                        username = ""
                        email = ""
                        phone = "+91 9484638746"
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
    
    
        var body: some View {
            
            ZStack {

                
                Color(UIColor.systemGray6).ignoresSafeArea(.all)
                
            VStack {
                
                Spacer()
                
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .fontDesign(.monospaced)
                    .offset(x:-100)
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .padding()
     
                Spacer()
                
                if isLoading {
                    ProgressView()
                } else if username.isEmpty {
                    Text("There are no users")
                        .font(.headline)
                        .offset(x:-65,y:-40)
                        .frame(width: 200)
                        .padding(.top, 80)
                } else {
                    ScrollView {
                        Spacer()
                        VStack() {
                            if isLoading {
                                ProgressView()
                            } else {
                                ZStack {
                                    Button(action: {
                                        logout()
                                    }) {
                                        Text("Sign Out")
                                            .font(.title3)
                                            .foregroundColor(Color.white)
                                            .padding()
                                            .background(Color.teal)
                                            .cornerRadius(25)
                                            .fontWeight(.heavy)
                                            .fontDesign(.monospaced)
                                    }
                                    .offset(y:135)
                                    VStack {
                                        Text("Name: \(username)")
                                            .font(.title3)
                                            .fontWeight(.heavy)
                                            .fontDesign(.monospaced)
                                            .padding(.vertical, 10)
                                            .offset(x:-22)
                                        Text("Email: \(email)")
                                            .font(.title3)
                                            .fontWeight(.heavy)
                                            .fontDesign(.monospaced)
                                            .padding(.vertical, 10)
                                            .offset(x:-5)
                                        Text("Phone No: \(phone)")
                                            .font(.title3)
                                            .fontWeight(.heavy)
                                            .fontDesign(.monospaced)
                                            .padding(.vertical, 10)
                                            .offset(x:-26)
                                        
                                        
                                        
                                    }
                                    .frame(width: 280)
                                    .offset(y:-40)
                                }
                            }
                            
                        }
                        .frame(width: 300, height: 400)
                        .background(Color(.systemBackground))
                        .cornerRadius(35)
                    
                        
                            
                            
                        
                    }
                    .offset(y:20)
                    
                    
                }
                
                
                
                
                
                
            }
            .onAppear {
                fetchUserdetails()
            }
            .fullScreenCover(isPresented: $isLoggedOut) {
                LoginView()
            }
            }
        }
    }



struct MainView_Previews: PreviewProvider{
    static var previews: some View {
        MainView()
    }
}
