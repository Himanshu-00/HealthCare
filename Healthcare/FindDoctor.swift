//
//  FindDoctorActivity.swift
//  HealthCare
//
//  Created by Himanshu Vinchurkar on 14/03/24.
//


import SwiftUI
import FirebaseFirestore

struct Doctor: Identifiable {
    var id: String
    var username: String
    var specialty: String
}

struct FindDoctor: View {
    @State private var doctors: [Doctor] = []
    @State private var searchText: String = ""

    var filteredDoctors: [Doctor] {
        if searchText.isEmpty {
            return doctors
        } else {
            return doctors.filter { $0.username.localizedCaseInsensitiveContains(searchText) || $0.specialty.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        
            VStack {
                List(filteredDoctors) { doctor in
                    DoctorDetails(doctor: doctor)
                }
                .listStyle(.plain)
                .padding(.top, 8)
                
            }
            .navigationBarTitle("Find Doctor")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search for Specialist")
            .onAppear {
                fetchDoctors()
            }
    }

    private func fetchDoctors() {
   
        let db = Firestore.firestore()
        db.collection("Doctors").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching doctors: \(error)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.doctors = documents.map { queryDocumentSnapshot -> Doctor in
                let id = queryDocumentSnapshot.documentID
                let username = queryDocumentSnapshot["username"] as? String ?? ""
                let specialty = queryDocumentSnapshot["specialty"] as? String ?? ""
                return Doctor(id: id, username: username, specialty: specialty)
            }
        }
    }
}

struct FindDoctor_Previews: PreviewProvider {
    static var previews: some View {
        FindDoctor()
            //.preferredColorScheme(.dark)
    }
}

struct DoctorDetails: View {
    let doctor: Doctor

    var body: some View {
        NavigationLink(destination: BookAppointmentView(title: "Book", appointmentTitle: "", backButtonAction: {}, bookAppointmentAction: {},doctorName: doctor.username, specialty: doctor.specialty)) {
            VStack(alignment: .leading) {
                Text(doctor.username)
                    .font(.headline)
                Text(doctor.specialty)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(8)
        }
    }
}
//Doctors Profile
struct DoctorProfile: View {
    let doctor: Doctor
    
    var body: some View {
        VStack {
            Text("Doctor Profile")
                .font(.title)
                .padding()
            Text("Name: \(doctor.username)")
                .padding()
            Text("Specialty: \(doctor.specialty)")
                .padding()
        }
        .navigationTitle("Profile")
    }
}

