//
//  MenuViewController.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 25.05.2023.
//

import UIKit

class MenuVC: UIViewController {

    @IBOutlet weak var xmarkCircleView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add tap gesture recognizer to xmarkCircleView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xmarkCircleViewTapped))
        xmarkCircleView.addGestureRecognizer(tapGesture)
        xmarkCircleView.isUserInteractionEnabled = true
    }
    
    @objc func xmarkCircleViewTapped() {
//        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeViewController else {
//            return
//        }
//        if let navController = navigationController {
//            navController.popToViewController(homeVC, animated: true)
//        }
        self.dismiss(animated: true)
    }
}
