//
//  ContemPlantUI+URL.swift
//  ContemPlant
//
//  Created by Gero Embser on 11.07.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation

extension URL {
    var contemPlantRoute: String? {
        let components = self.absoluteString.split(separator: "/")
        
        guard let lastComponent = components.last else {
            return nil
        }
        
        let lastComponentString = String(lastComponent)
        
        ///The routes allowed for the contemPlant web UI
        let routes = ["register", "login", "overview"]
        
        guard routes.contains(lastComponentString) else {
            //no contem plant valid route
            return nil
        }
        //otherwise contemPlant valid route, return component
        return lastComponentString
    }
}
