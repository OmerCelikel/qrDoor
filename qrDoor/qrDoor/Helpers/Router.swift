//
//  Router.swift
//  qrDoor
//
//  Created by Ömer Oğuz Çelikel on 25.05.2023.
//

import Foundation
import UIKit

enum Page {
    case tab
    case login
    case home
    case qrCode
    case menu
    //case howToUse(_ state: HowToUseState)
}

class Router {
    static func getViewController(page: Page) -> UIViewController {
        switch page {

//        case .tab:
//            let vc = TabVC.getNC()
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .fullScreen
//            return vc

        case .home:
            let vc = HomeVC.instantiate()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            return vc
        case .qrCode:
            let vc = QrCodeVC.instantiate()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            return vc
        case .menu:
            let vc = MenuVC.instantiate()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            return vc
        case .login:
            let vc = LoginVC.instantiate()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            return vc
        
//        case .howToUse(let state):
//            let vc = HowToUseVC.instantiate()
//            vc.state = state
//            vc.modalTransitionStyle = .crossDissolve
//            vc.modalPresentationStyle = .fullScreen
//            return vc

        default: break
        }
        return UIViewController()
    }
}

extension UIViewController {
    
    class func getNC() -> UINavigationController {
        let vcName = String(describing: self)
        let storyboardName =  vcName.hasSuffix("VC") ? String(vcName.dropLast(2)) : vcName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        guard let nc = storyboard.instantiateViewController(
            withIdentifier: storyboardName + "NC"
        ) as? UINavigationController else {
            fatalError("NC Not Found")
        }
        
        return nc
    }
    
    func present(_ page: Page, animated: Bool = true, completion: (() -> Void)? = nil) {
        let vc = Router.getViewController(page: page)
        present(vc, animated: animated, completion: completion)
    }
    
    func push(_ page: Page, animated: Bool = true) {
        let vc = Router.getViewController(page: page)
        navigationController?.pushViewController(vc, animated: animated)
    }
}

extension UIViewController {
    class func instantiate() -> Self {
        let vcName = String(describing: self)
        let storyboardName =  vcName.hasSuffix("VC") ? String(vcName.dropLast(2)) : vcName
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        
        
        guard let vc = storyboard.instantiateViewController(
            withIdentifier: vcName
        ) as? Self else {
            fatalError(
                "ERROR: UIViewController not found."
            )
        }
        return vc
    }
}

