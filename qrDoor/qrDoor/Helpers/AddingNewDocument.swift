//
//  AddingNewDocument.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 12.05.2023.
//

import Foundation

//        // Get a reference to the current user's document
//        guard let currentUser = Auth.auth().currentUser else {
//            // If there is no logged in user, show an error message and return
//            return
//        }
//
//        let db = Firestore.firestore()
//        let userRef = db.collection("users").document(currentUser.uid)
//        let houseData: [String: Any] = [
//            "address": "123 Main St",
//            "city": "San Francisco",
//            "state": "CA",
//            "owner": userRef
//        ]
//
//        // Add the new house document to the "houses" collection
//        db.collection("houses").addDocument(data: houseData) { error in
//            if let error = error {
//                // Show error message if there was an error adding the new house document
//                print("Error adding new house: \(error.localizedDescription)")
//            } else {
//                // Show success message if the new house document was added successfully
//                print("Success", "New house added successfully!")
//            }
//
//        }
