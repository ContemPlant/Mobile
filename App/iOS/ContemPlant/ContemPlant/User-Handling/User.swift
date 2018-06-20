//
//  User.swift
//  ContemPlant
//
//  Created by Gero Embser on 17.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import SwiftyUserDefaults
import Apollo
import SortedArray

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
    
    //determine what to save
    private enum CodingKeys: String, CodingKey {
        case username
        case email
        case jwt
        case loggedIn
    }
    
    //MARK: - Apollo Server client / server connection
    lazy var apollo: ApolloClient = { [unowned self] in
        let configuration = URLSessionConfiguration.default
        // Add additional headers as needed
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(self.jwt)"]
        
        let url = Constants.subscriptionsEnpointURL
        
        let websocketTransport = WebSocketTransport(url: url,
                                                    sendOperationIdentifiers: false,
                                                    params: nil,
                                                    connectingParams: ["Authorization": "Bearer \(self.jwt)"]) //give authentication parameters!
        
        return ApolloClient(networkTransport: websocketTransport)
    }()
    
    var plants: SortedArray<Plant> {
        return plantController.plants
    }
    
    lazy var plantController: UserPlantController = { [unowned self] in
        return UserPlantController(withApolloClient: apollo)
    }()
   
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
