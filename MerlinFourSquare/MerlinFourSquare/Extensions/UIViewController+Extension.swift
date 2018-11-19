//
//  UIViewController+Extension.swift
//  MerlinFourSquare
//
//  Created by Gonzalinho on 11/18/18.
//  Copyright © 2018 Gonzalinho. All rights reserved.
//

import Foundation
import UIKit

struct UIViewControllerExtensionConfig {
    static let okText = "OK"
}

extension UIViewController {
    func presentAlertController(title: String?, message:String?, actions:[UIAlertAction]?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let actions = actions {
            for action in actions {
                alertController.addAction(action)
            }
        } else {
            alertController.addAction(UIAlertAction(title: UIViewControllerExtensionConfig.okText, style: .default, handler: nil))
        }
        
        present(alertController, animated: true, completion: nil)
    }
}
