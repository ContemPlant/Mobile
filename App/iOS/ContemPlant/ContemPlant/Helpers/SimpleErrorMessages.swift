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
              actionButtonTitle: String? = nil,
              actionButtonAction: SimpleErrorMessageAction? = nil) {
        
        //basic alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        //the actions
        let okAction = UIAlertAction(title: okButtonTitle, style: .cancel) { (_) in
            okButtonAction?()
        }
        alert.addAction(okAction)
        
        let actionAction = UIAlertAction(title: actionButtonTitle, style: .default) { (_) in
            actionButtonAction?()
        }
        alert.addAction(actionAction)
        
        //present the alert
        present(alert, animated: true, completion: nil)
    }
}
