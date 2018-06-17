//
//  User.swift
//  ContemPlant
//
//  Created by Gero Embser on 17.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

final class User: Codable {
    let username: String
    let email: String
    let jwt: String
    
    var loggedIn = false
    
    init(withUsername username: String, email: String, jwt: String) {
        self.username = username
        self.email = email
        self.jwt = jwt
    }
}

//MARK: - logout
extension User {
    func logout() {
        //mark it as logged out
        loggedIn = false
        
        //remove the user from the defaults as the loggedInUser
        Defaults[.loggedInUser] = nil
    }
}


//MARK: - creation of users
extension User {
    ///Logs in the user with the given credentials and returns the logged in user
    class func login(with username: String, email: String, accessToken jwt: String) -> User {
        //create new user
        let newUser = User(withUsername: username, email: email, jwt: jwt)
        
        //mark it as logged in
        newUser.loggedIn = true
        
        //save the new user to the user defaults
        Defaults[.loggedInUser] = newUser
        
        //return the new user
        return newUser
    }
    
    ///Returns the current logged in user (if one is logged in)
    static var current: User? {
        return Defaults[.loggedInUser]
    }
}

//MARK: - SwiftyUserDefaults-Codable-support
extension User: DefaultsSerializable {
    
}
