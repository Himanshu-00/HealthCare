//
//  ContentView.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 13/03/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    @State private var showPassword = false

    var body: some View {
        NavigationView {
                VStack {
                   
                    Text("Welcome to Healthcare")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .fontDesign(.monospaced)
                        .foregroundColor(.teal)
                        .padding()
                        .offset(x:-55, y:150)

                    Spacer()

                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.teal) // Teal color for icon
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .autocapitalization(.none)
                    }
                    .padding(.horizontal)

                    // Password SecureField with Icon and Show Password Toggle
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.teal) // Teal color for icon
                        if showPassword {
                            TextField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        } else {
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)

                    // Login Button
                    Button(action: {
                        login()
                    }) {
                        Text("Login")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.teal) // Teal background for button
                            .foregroundColor(.white) // White text color
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                    }
                    .padding(.top) // Add top padding to button

                    Spacer()

                    // Navigation Link to Register View
                    NavigationLink(destination: RegisterView()) {
                        Text("New User? Register Here")
                            .foregroundColor(.teal) // Teal color for link
                    }
                    .padding(.bottom, 20) // Add bottom padding for spacing
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .padding()
                .navigationBarTitle("") // Keep the navigation bar title empty
                .navigationBarHidden(true) // Hide the navigation bar for a cleaner look
                .fullScreenCover(isPresented: $isLoggedIn) {
                    if UserDefaults.standard.bool(forKey: "isDoctor") {
                        // DocHomeView()
                    } else {
                        MainView()
                    }
                }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    func login() {
        if email.isEmpty || password.isEmpty {
            showAlert = true
            alertMessage = "Please fill in all fields"
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else if let uid = result?.user.uid {
                let db = Firestore.firestore()
                db.collection("Doctors").document(uid).getDocument { snapshot, error in
                    if let snapshot = snapshot, snapshot.exists {
                        // User is a doctor
                        UserDefaults.standard.set(true, forKey: "isDoctor")
                    } else {
                        // User is not a user
                        UserDefaults.standard.set(false, forKey: "isDoctor")
                    }
                    isLoggedIn = true
                }
            } else {
                showAlert = true
                alertMessage = "Unexpected error occurred. Please try again."
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
