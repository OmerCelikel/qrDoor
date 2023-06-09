//
//  SuccessfulVC.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 7.06.2023.
//

import UIKit

class SuccessfulVC: UIViewController {

    @IBOutlet weak var xmarkCircleView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add tap gesture recognizer to xmarkCircleView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xmarkCircleViewTapped))
        xmarkCircleView.addGestureRecognizer(tapGesture)
        xmarkCircleView.isUserInteractionEnabled = true
    }
    
    @objc func xmarkCircleViewTapped() {
        present(.home)
    }

}
