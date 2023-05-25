//
//  QrCodeViewController.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 24.05.2023.
//

import UIKit

class QrCodeViewController: UIViewController {
    
    
    @IBOutlet weak var xmarkCircleView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add tap gesture recognizer to xmarkCircleView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xmarkCircleViewTapped))
        xmarkCircleView.addGestureRecognizer(tapGesture)
        xmarkCircleView.isUserInteractionEnabled = true
    }
    
    @objc func xmarkCircleViewTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}
