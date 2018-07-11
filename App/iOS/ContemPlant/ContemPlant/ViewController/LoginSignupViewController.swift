//
//  LoginSignupViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 16.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit
import WebKit

//MARK: - main class definition
class LoginSignupViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet var webView: WKWebView!
    private var urlObservation: NSKeyValueObservation?
    private var activityIndicator: UIActivityIndicatorView!
    
    //MARK: actions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        cancelLogin() //just cancel login
    }
    
    //MARK: instance variables
    private var loginType: SupportedLoginType = .login //default is login
    var delegate: LoginSignupViewControllerDelegate?

    private var endpointURL: URL {
        var base = Constants.webUISubpagesEndpointURLString
        
        switch loginType {
        case .login:
            base.append("login")
        case .signup:
            base.append("register")
        }
        
        return URL(string: base)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup webview
        setupWebView()
        
        //setup webview activity indicator
        setupWebViewActivityIndicator()
        
        //start loading the appropriate web endpoint
        reloadLoginPage()
    }
}


//MARK: - WebView stuff
extension LoginSignupViewController {
    private func setupWebViewActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        
        let item = UIBarButtonItem(customView: activityIndicator)
        
        self.navigationItem.rightBarButtonItem = item
    }
    private func setupWebView() {
        webView.navigationDelegate = self
        
        //kvo of webView's url property to know when login/signup was successful
        urlObservation = webView.observe(\WKWebView.url  ) { [weak self] (webView, change) in
            //url changed
            self?.handleLoginCompletionBasedOnWebViewURL()
        }
    }
    
    private func handleLoginCompletionBasedOnWebViewURL() {
        guard let url = webView.url else { //hopefully never happen...
            reloadLoginPage()
            return
        }
        
        //check if its last component is overview (which means login was complete)
        guard url != endpointURL, url.contemPlantRoute == "overview" else {
            //login was maybe failed, reload
            
            //if route is different than the current url, update it
            if url.contemPlantRoute == "register" {
                loginType = .signup
            }
            else if url.contemPlantRoute == "login" {
                loginType = .login
            }
            
            reloadLoginPage()
            return
        }
        
        //handler
        func loginFailed() {
            //something failed, reload
            reloadLoginPage()
            
            delegate?.loginSignupViewControllerLoginFailed(self)
        }
        
        func loginSucceeded(withUsername username: String, email: String, jwt: String) {
            //finish login (store it)
            
            //create a new user
            let newUser = User.login(with: username, email: email, accessToken: jwt)

            //call the appropriate delegate method
            delegate?.loginSignupViewController(self, hasLoggedInUser: newUser)
        }
        
        enum LoginFields: String {
            case username = "username"
            case email = "email"
            case jwt = "jwt"
        }
        //try to get a value out of the session storage of the webView
        let requiredLoginFields: [LoginFields] = [.username, .email, .jwt]
        
        webView.sessionStorage.get(itemsForKeys: requiredLoginFields.map { $0.rawValue } ) { (result) in
            let requiredLoginCredentials = result.compactKeyValueMap { (key: String, value: String?) -> (LoginFields, String)? in
                guard let value = value else {
                    return nil
                }
                
                guard let field = LoginFields(rawValue: key) else {
                    return nil
                }
                
                return (field, value)
            }
            
            guard requiredLoginCredentials.count == requiredLoginFields.count else {
                loginFailed()
                return
            }
            
            loginSucceeded(withUsername: requiredLoginCredentials[.username]!,
                           email: requiredLoginCredentials[.email]!,
                           jwt: requiredLoginCredentials[.jwt]!)
        }
    }
    
    private func reloadLoginPage() {
        let request = URLRequest(url: endpointURL)
        
        webView.load(request)
    }
}

extension LoginSignupViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(navigation)
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //just reload
        reloadLoginPage()
    }
}

//MARK: - helper types
extension LoginSignupViewController {
    ///Defines whether to simply login with existing account or creating a new one
    enum SupportedLoginType {
        case login
        case signup
    }
}

//MARK: - initialization of LoginSignupViewControllers for login/signup
extension LoginSignupViewController {
    class func loginNavigationController(withSupportedLoginType loginType: SupportedLoginType, delegate: LoginSignupViewControllerDelegate?) -> UINavigationController {
        //load the view controller
        let loginViewController = UIStoryboard.login.instantiateViewController(withIdentifier: "LoginSignupViewController") as! LoginSignupViewController
        loginViewController.loginType = loginType //save the appropriate type
        loginViewController.delegate = delegate
        
        //embed in navigation controller
        let navigationController = UINavigationController(rootViewController: loginViewController)
        
        //return the navigation controller as a wrapper
        return navigationController
    }
}

//MARK: - dismissal of LoginSignupViewControllers
extension LoginSignupViewController {
    private func cancelLogin() {
        self.delegate?.loginSignupViewControllerLoginCancelled(self)
    }
}

