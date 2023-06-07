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
    var remainingTime: Int?
    
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
        self.remainingTime = secondsRemainingToNextBlock()
        remainingTime! -= 1
        
        if remainingTime ?? 10 <= 0 {
            stopTimer()
            resetQRCode()
        }
        
        updateProgressBar()
        updateRemainingTimeLabel()
    }
    
    func updateProgressBar() {
        let progress = Float(remainingTime ?? 10) / 30.0
        progressBar.progress = progress
    }
    
    func updateRemainingTimeLabel() {
        if let remainingTime = remainingTime {
            remainingTimeLabel.text = "\(remainingTime) seconds"
        } else {
            remainingTimeLabel.text = "0 seconds" // Or any default value you want to display
        }
    }
    
    func resetQRCode() {
        remainingTime = secondsRemainingToNextBlock()
        updateProgressBar()
        updateRemainingTimeLabel()
        progressBar.setProgress(1.0, animated: true) // Set progress to 100%
        ProgressHUD.show()

        let currentUserID = fetchUserData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            // Remove previous image
            self?.qrCodeImage.image = nil
            
            // Delay the network request for a few seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                self?.getQrStringAPI(currentUserID: currentUserID)
                self?.startTimer()
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
                    let transform = CGAffineTransform(scaleX: 10, y: 10)
                    let scaledQrCodeImage = qrCodeImage.transformed(by: transform)
                    
                    let context = CIContext()
                    if let cgImage = context.createCGImage(scaledQrCodeImage, from: scaledQrCodeImage.extent) {
                        let qrCodeUIImg = UIImage(cgImage: cgImage)
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.qrCodeImage.image = qrCodeUIImg
                            self?.qrCodeImage.contentMode = .scaleAspectFit
                        }
                    }
                }
            }
        }
        ProgressHUD.dismiss()
    }


        func secondsRemainingToNextBlock() -> Int {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.second], from: Date())
            
            if let seconds = components.second {
                let remainingSeconds = 30 - (seconds % 30)
                return remainingSeconds
            }
            return 10
        }
}

