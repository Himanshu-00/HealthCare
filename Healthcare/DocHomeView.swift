////
////  DocHomeView.swift
////  Healthcare
////
////  Created by Himanshu Vinchurkar on 14/03/24.
////
//
//import SwiftUI
//import FirebaseAuth
//
//struct DocHomeView: View {
//    
//    @State private var username: String = ""
//    @State private var isLoggedOut = false
//    
//    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2) // Define 2 flexible columns
//    let spacing: CGFloat = 20 // Adjust spacing between items
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: spacing) {
//                    NavigationLink(destination: Schedules()) {
//                        CardView(title: "Schedule", iconName: "person.fill", gradientColors: [.blue, .purple], iconSize: 100, iconWidth: 0, iconHeight: 0)
//                    }
//
//                    NavigationLink(destination: LabTestActivity()) {
//                        CardView(title: "Lab Test", iconName: "eyedropper", gradientColors: [.green, .blue], iconSize: 100, iconWidth: 0, iconHeight: 0)
//                    }
//                    NavigationLink(destination: CreateMeetingView()) {
//                        CardView(title: "Create Meet", iconName: "video.circle", gradientColors: [.green, .blue], iconSize: 100, iconWidth: 0, iconHeight: 0)
//                    }
//                    
//                    // Button to join  meeting
//                    NavigationLink(destination: CreateMeetingView()) {
//                        CardView(title: "Join Zoom Meeting", iconName: "video.fill", gradientColors: [.yellow, .orange], iconSize: 100, iconWidth: 0, iconHeight: 0)
//                    }
//
//                   
//                    
//                    Button(action: {
//                                            logout()
//                                        }) {
//                                            CardView(title: "Log out", iconName: "arrow.right.square", gradientColors: [.red, .blue], iconSize: 100, iconWidth: 0, iconHeight: 0)
//                                        }
//                    
//                }
//                .padding()
//            }
//            .navigationTitle("Healthcare")
//            .fullScreenCover(isPresented: $isLoggedOut) {
//         LoginView()
//        }
//            
//           
//        
//}
//    }
//    
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//            isLoggedOut = true
//        } catch {
//            print("Error signing out: \(error.localizedDescription)")
//        }
//    }
//    
//}
//
//struct Schedules: View {
//    var body: some View {
//        Text("Coming Soon")
//    } 
//}
//
//
//#Preview {
//    DocHomeView()
//}
//
//
//
