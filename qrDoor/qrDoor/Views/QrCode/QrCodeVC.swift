//
//  QrCodeViewController.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 24.05.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import ProgressHUD
import CoreImage

class QrCodeVC: UIViewController {
        
    @IBOutlet weak var xmarkCircleView: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    let qrService = AFQrService()
    var timer: Timer?
    var remainingTime: Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show()
        let currentUserID = fetchUserData()
        getQrStringAPI(currentUserID: currentUserID)
        
        // Add tap gesture recognizer to xmarkCircleView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xmarkCircleViewTapped))
        xmarkCircleView.addGestureRecognizer(tapGesture)
        xmarkCircleView.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func updateTime() {
        remainingTime -= 1
        
        if remainingTime <= 0 {
            stopTimer()
            resetQRCode()
        }
        
        updateProgressBar()
        updateRemainingTimeLabel()
    }
    
    func updateProgressBar() {
        let progress = Float(remainingTime) / 30.0
        progressBar.progress = progress
    }
    
    func updateRemainingTimeLabel() {
        remainingTimeLabel.text = "\(remainingTime) seconds"
    }
    
    func resetQRCode() {
        remainingTime = 30
        updateProgressBar()
        updateRemainingTimeLabel()
        progressBar.setProgress(1.0, animated: true) // Set progress to 100%
        ProgressHUD.show()
        
        let currentUserID = fetchUserData()
        getQrStringAPI(currentUserID: currentUserID)
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
    
    func getQrStringAPI(currentUserID: String) {
        qrService.getQrString(string: currentUserID) { result in
            
            switch result {
            case .success(let qrResponse):
                print("QR String: \(qrResponse.qr_string)")
                self.generateQRCode(qrString: qrResponse.qr_string)
                
            case .failure(let error):
                print("Error: \(error)")
                ProgressHUD.dismiss()
            }
        }
    }
    
    func generateQRCode(qrString: String) {
        if let qrCodeData = qrString.data(using: String.Encoding.ascii) {
            if let qrCodeFilter = CIFilter(name: "CIQRCodeGenerator") {
                qrCodeFilter.setValue(qrCodeData, forKey: "inputMessage")
                if let qrCodeImage = qrCodeFilter.outputImage {
                    let transform = CGAffineTransform(scaleX: 10, y: 10) // Adjust the scale as per your needs
                    let scaledQrCodeImage = qrCodeImage.transformed(by: transform)
                    let qrCodeUIImage = UIImage(ciImage: scaledQrCodeImage)
                    DispatchQueue.main.async { [weak self] in
                        self?.qrCodeImage.image = qrCodeUIImage
                    }
                    
                    // Convert CIImage to CGImage
                    let context = CIContext()
                    if let cgImage = context.createCGImage(scaledQrCodeImage, from: scaledQrCodeImage.extent) {
                        let qrCodeUIImg = UIImage(cgImage: cgImage)
                        // Print the generated QR code image
                        print(qrCodeUIImg)
                    }
                }
            }
        }
        ProgressHUD.dismiss()
    }

}

