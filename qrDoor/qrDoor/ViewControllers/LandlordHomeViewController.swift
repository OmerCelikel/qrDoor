//
//  landlordHomeViewController.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 9.05.2023.
//

import UIKit
import Firebase

class LandlordHomeViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get a reference to the current user's document
        guard let currentUser = Auth.auth().currentUser else {
            // If there is no logged in user, show an error message and return
            print("No logged in user")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        
        // Retrieve the user's document from the "users" collection
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                // If the document exists, retrieve the first name and last name fields
                let data = document.data()!
                let firstName = data["firstname"] as! String
                let lastName = data["lastname"] as! String
                
                // Update the welcome label to display the user's name
                self.welcomeLabel.text = "Welcome, \(firstName) \(lastName)!"
            } else {
                // If the document does not exist, show an error message
                print("User document does not exist")
            }
        }
    
    }
    
}

//        if let user = Auth.auth().currentUser {
//            let email = user.email ?? "No email"
//            let displayName = user.displayName ?? "No display name"
//            let uid = user.uid
//            print("Logged in user info:")
//            print("Email: \(email)")
//            print("Display name: \(displayName)")
//            print("UID: \(uid)")
//        } else {
//            print("No logged in user")
//        }
