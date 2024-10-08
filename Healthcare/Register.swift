//
//  Register.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 13/03/24.
//


import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegisterView: View {
    @State private var phoneno: String = ""
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var address: String = ""
    @State private var specialty: String = ""
    @State private var isRegistered = false
    @State private var userType: UserType = .regular

    enum UserType {
        case regular
        case doctor
    }

    var body: some View {
        NavigationView {
            VStack {
                // User Type Picker
                Picker(selection: $userType, label: Text("Register as")) {
                    Text("User").tag(UserType.regular)
                        .fontDesign(.monospaced)
                    Text("Doctor").tag(UserType.doctor)
                        .fontDesign(.monospaced)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Form Fields
                Group {
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    TextField("+91 ", text: $phoneno)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    if userType == .doctor {
                        TextField("Address", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)

                        TextField("Specialty", text: $specialty)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                    }
                }
                .fontWeight(.heavy)
                .fontDesign(.monospaced)

                // Register Button
                Button(action: {
                    register()
                }) {
                    Text("Register")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .fontWeight(.heavy)
                        .fontDesign(.monospaced)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.top)

                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding()
            .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Create Account")
                                    .foregroundColor(.teal)
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .fontDesign(.monospaced)
                                    .offset(x:0, y: 40)
                            }
                        }
            .fullScreenCover(isPresented: $isRegistered) {
                if userType == .doctor {
                    // DocHomeView()
                } else {
                    HomeView(currentDate: Date(), appointment: AppointmentDetails(id: "", fullName: "", doctorName: "", specialty: "", selectedDate: Date()))
                }
            }
        }
    }

    func register() {
        if username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showAlert = true
            alertMessage = "Please fill in all fields"
            return
        }

        if password != confirmPassword {
            showAlert = true
            alertMessage = "Password and Confirm Password didn't match"
            return
        }

        // Register logic based on user type
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showAlert = true
                alertMessage = error.localizedDescription
            } else {
                // Registration successful, proceed to store additional user data
                let db = Firestore.firestore()
                if userType == .doctor {
                    // Register as a doctor
                    let doctorData: [String: Any] = [
                        "username": username,
                        "email": email,
                        "address": address,
                        "+Phone No": phoneno,
                        "specialty": specialty
                    ]

                    // Store doctor data in Firestore collection for doctors
                    db.collection("Doctors").document(authResult!.user.uid).setData(doctorData) { error in
                        if let error = error {
                            print("Error registering as a doctor: \(error.localizedDescription)")
                        } else {
                            print("Successfully registered as a doctor")
                        }
                    }
                } else {
                    // Register as a regular user
                    let userData: [String: Any] = [
                        "username": username,
                        "email": email,
                        "+91": phoneno,
                        "Password": password
                    ]

                    // Store user data in Firestore collection for users
                    db.collection("users").document(authResult!.user.uid).setData(userData) { error in
                        if let error = error {
                            print("Error registering as a user: \(error.localizedDescription)")
                        } else {
                            print("Successfully registered as a user")
                        }
                    }
                }
                isRegistered = true
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
