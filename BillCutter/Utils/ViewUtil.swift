//
//  ViewUtil.swift
//  BillCutter
//
//  Created by Erick Theodorus on 03/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import UIKit

class ViewUtil {
    
    class func showAlert(controller: UIViewController, message: String, title: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        guard !message.isEmpty else { return }
        
        let action = UIAlertAction(title: "OK", style: .default, handler: handler)
        showAlert(controller: controller, style: .alert, actions: [action], title: title, message: message)
    }
    
    class func showAlert(controller: UIViewController,
                         style: UIAlertController.Style = .alert,
                         actions: [UIAlertAction],
                         title: String? = nil,
                         message: String? = nil,
                         preferredAction: UIAlertAction? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        for action in actions {
            alertController.addAction(action)
        }
        
        alertController.preferredAction = preferredAction
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
