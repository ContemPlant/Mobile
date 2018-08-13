//
//  PlantsNavigationController.swift
//  ContemPlant
//
//  Created by Gero Embser on 17.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit

class PlantsNavigationController: UINavigationController {
    var user: User!
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assert that the user is not nil, because otherwise using a plantsViewController is useless
        assert(user != nil, "User is nil. But PlantsNavigationController can be used only if the user is not nil!")
        
        // any further additional setup after loading the view...
        // ...
    }
}
