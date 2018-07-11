//
//  Constants.swift
//  ContemPlant
//
//  Created by Gero Embser on 16.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation

enum Constants {
    static let defaultProtocol = "ws"
    static let serverIP = "167.99.240.197"
    
    static let serverURLString = "\(defaultProtocol)://\(serverIP)"
    static let serverURL = URL(string: serverURLString)!
    
    static var graphQlEndpointURLString = "\(defaultProtocol)://\(serverIP):8000/graphql"
    static var graphQlEndpointURL: URL {
        return URL(string: graphQlEndpointURLString)!
    }
    static var subscriptionsEndpointURLString = "\(defaultProtocol)://\(serverIP):8000/subscriptions"
    static var subscriptionsEnpointURL: URL {
        return URL(string: subscriptionsEndpointURLString)!
    }
    
    static var webUIEndpointURLString = "http://\(serverIP):8080"
    static var webUIEndpointURL = URL(string: webUIEndpointURLString)!
    static var webUISubpagesEndpointURLString = webUIEndpointURLString.appending("/#/")
}
