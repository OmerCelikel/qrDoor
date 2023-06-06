//
//  QrCodeViewController.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 24.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore

class QrCodeVC: UIViewController {
    
    
    @IBOutlet weak var xmarkCircleView: UIImageView!
    
    
    let qrService = AFQrService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add tap gesture recognizer to xmarkCircleView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xmarkCircleViewTapped))
        xmarkCircleView.addGestureRecognizer(tapGesture)
        xmarkCircleView.isUserInteractionEnabled = true
        let currentUserID = fetchUserData()
        
        qrService.getQrString(string: currentUserID) { result in
            switch result {
            case .success(let qrResponse):
                print("QR String: \(qrResponse.qr_string)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    @objc func xmarkCircleViewTapped() {
        self.dismiss(animated: true)
    }
    
    func fetchUserData() -> String {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // User is not logged in or user ID not available
            return ""
        }
        print("currentUserID \(currentUserID)")
        return currentUserID
    }
    
}
