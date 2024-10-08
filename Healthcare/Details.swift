//
//  CartLabActivity.swift
//  HealthCare
//
//  Created by Himanshu Vinchurkar on 14/03/24.
//

import SwiftUI
import Firebase

import SwiftUI
import Firebase

struct AppointmentDetails: Identifiable {
    let id: String
    let fullName: String
    let doctorName: String
    let specialty: String
    let selectedDate: Date
}

struct OrderDetailsView: View {
    @State private var appointmentDetails: [AppointmentDetails] = []
    @State private var isLoading = false
    @State private var searchText: String = ""
    
    var filteredAppointments: [AppointmentDetails] {
        if searchText.isEmpty {
            return appointmentDetails
        } else {
            return appointmentDetails.filter { appointment in
                appointment.doctorName.localizedCaseInsensitiveContains(searchText) ||
                appointment.specialty.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(filteredAppointments) { appointment in
            AppointmentView(appointmentDetails: appointment)
                .padding(.vertical, 20)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by doctor name or specialty")
        .onAppear {
            fetchAppointmentDetails()
        }
    }
    
    func fetchAppointmentDetails() {
        isLoading = true
        
       
        AppointmentService.shared.fetchAppointmentDetails { result in
                    DispatchQueue.main.async {
                        isLoading = false
                        switch result {
                        case .success(let appointments):
                            appointmentDetails = appointments
                        case .failure(let error):
                            print("Error fetching appointment details: \(error)")
                        }
                    }
                }
            }
}

struct AppointmentView: View {
    let appointmentDetails: AppointmentDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Full Name: \(appointmentDetails.fullName)")
            Text("Doctor Name: \(appointmentDetails.doctorName)")
            Text("Specialty: \(appointmentDetails.specialty)")
            Text("Date: \(formattedDate)")
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: appointmentDetails.selectedDate)
    }
    
}

struct OrderDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetailsView()
    }
}


