//
//  ViewController.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 8.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore


class HomeViewController: UIViewController {

    @IBOutlet weak var nameSurnameTextLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
    }
    
    func fetchUserData() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // User is not logged in or user ID not available
            return
        }
        print("currentUserID \(currentUserID)")
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                if let firstName = data?["firstname"] as? String,
                    let lastName = data?["lastname"] as? String {
                    self.nameSurnameTextLabel.text = "\(firstName) \(lastName)"
                }
            } else {
                print("User document does not exist")
            }
        }
    }
}

