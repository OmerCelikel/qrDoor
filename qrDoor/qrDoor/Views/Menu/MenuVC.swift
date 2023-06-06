//
//  MenuViewController.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 25.05.2023.
//

import UIKit
import Firebase

class MenuVC: UIViewController {
    
    @IBOutlet weak var xmarkCircleView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    let menuItems = ["App Language", "Informations", "Logout"]
    let detailsOfMenu = ["English", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizer to xmarkCircleView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(xmarkCircleViewTapped))
        xmarkCircleView.addGestureRecognizer(tapGesture)
        xmarkCircleView.isUserInteractionEnabled = true
    }
    
    @objc func xmarkCircleViewTapped() {
        self.dismiss(animated: true)
    }
    
    func logout() {
        // Implement your logout logic here
        // For example, you can sign out the user using Firebase Auth
        do {
            try Auth.auth().signOut()
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = windowScene.delegate as? SceneDelegate else {
                return
            }
            
            let loginVC = Router.getViewController(page: .login)
            delegate.window?.rootViewController = loginVC
        } catch  {
            
        }
    }
}

extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemsTableViewCell", for: indexPath) as! MenuItemsTableViewCell
        cell.menuItemTitle.text = menuItems[indexPath.row]
        cell.detailLabel.text = detailsOfMenu[indexPath.row]
        
        if indexPath.row == menuItems.count - 1 {
            cell.menuItemTitle.textColor = .red
        } else {
            cell.menuItemTitle.textColor = .black
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            // Handle "App Language" row selection
            break
        case 1:
            // Handle "Informations" row selection
            break
        case 2:
            // Handle "Logout" row selection
            logout()
            break
        default:
            break
        }
    }
}
