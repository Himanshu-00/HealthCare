//
//  AppointmentService.swift
//  Healthcare
//
//  Created by Himanshu Vinchurkar on 01/09/24.
//

import Foundation

import Foundation
import FirebaseFirestore


class AppointmentService {
    static let shared = AppointmentService()
    
    private init() {}
    
// This function gets the appointment details
    func fetchAppointmentDetails(completion: @escaping (Result<[AppointmentDetails], Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("Appointments").getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
           
            let appointments = documents.compactMap { document -> AppointmentDetails? in
                if let doctorName = document["doctorName"] as? String,
                   let fullName = document["fullName"] as? String,
                   let specialty = document["specialty"] as? String,
                   let selectedDateTimestamp = document["selectedDate"] as? Timestamp {
                   let selectedDate = selectedDateTimestamp.dateValue()
                    
                   return AppointmentDetails(id: document.documentID,
                                              fullName: fullName,
                                              doctorName: doctorName,
                                              specialty: specialty,
                                              selectedDate: selectedDate)
                } else {
                    return nil
                }
            }
            
            completion(.success(appointments)) 
        }
    }
}
