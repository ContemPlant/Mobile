//
//  SimpleErrorMessages.swift
//  ContemPlant
//
//  Created by Gero Embser on 24.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    typealias SimpleErrorMessageAction = () -> Void
    func show(simpleErrorMessage message: String,
              withTitle title: String?,
              okButtonTitle: String = "ok",
              okButtonAction: SimpleErrorMessageAction? = nil,
              actionButton: (title: String, action: SimpleErrorMessageAction)? = nil) {
        
        //basic alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the actions
        let okAction = UIAlertAction(title: okButtonTitle, style: .cancel) { (_) in
            okButtonAction?()
        }
        alert.addAction(okAction)
        
        if let actionButtonSetup = actionButton {
            let actionAction = UIAlertAction(title: actionButtonSetup.title, style: .default) { (_) in
                actionButtonSetup.action()
            }
            alert.addAction(actionAction)
        }
        
        //haptic feedback
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        //present the alert
        present(alert, animated: true, completion: nil)
    }
}
