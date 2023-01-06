//
//  AlertVC.swift
//  Acronyms
//
//  Created by Manidhar Gupta Chittanuri on 1/6/23.
//

import Foundation
import UIKit

class AlertVC {
    static let sharedInstance = AlertVC()
    
    private init() {}
    
    func presentAlert(on vc: UIViewController?, with title: String, message: String, buttonTitle: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let btnAction = UIAlertAction(title: buttonTitle,
                                      style: UIAlertAction.Style.cancel) { action in
            
        }
        alertController.addAction(btnAction)
        vc?.present(alertController, animated: true) {
            
        }
    }
}
