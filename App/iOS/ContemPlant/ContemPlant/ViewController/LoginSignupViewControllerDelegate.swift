//
//  LoginSignupViewControllerDelegate.swift
//  ContemPlant
//
//  Created by Gero Embser on 17.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import UIKit

protocol LoginSignupViewControllerDelegate: class {
    func loginSignupViewControllerLoginCancelled(_ viewController: LoginSignupViewController)
    func loginSignupViewControllerLoginFailed(_ viewController: LoginSignupViewController)
    func loginSignupViewController(_ viewController: LoginSignupViewController, hasLoggedInUser user: User)
}
