//
//  StartViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 14.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: actions
    
    @IBAction func loginTapped(_ sender: UIButton) {
        startLoginProcess(forType: .login)
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        startLoginProcess(forType: .signup)
    }
}


//MARK: - starting the login
extension StartViewController {
    private func startLoginProcess(forType type: LoginSignupViewController.SupportedLoginType) {
        let loginNavigationVC = LoginSignupViewController.loginNavigationController(withSupportedLoginType: type)
        
        
        self.present(loginNavigationVC, animated: true, completion: nil)
    }
}
