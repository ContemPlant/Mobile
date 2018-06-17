//
//  PlantsViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 17.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit

class PlantsViewController: UIViewController {

    //MARK: - instance variables
    var plantsNavigationController: PlantsNavigationController {
        return self.navigationController as! PlantsNavigationController
    }
    var user: User {
        return plantsNavigationController.user
    }
    
    //MARK: - outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: - actions
    @IBAction func logoutBarButtonItemTapped(_ sender: UIBarButtonItem) {
        //just logout the user
        user.logout()
        
        //and change the root view controller of the application
        AppDelegate.current.changeRootViewController(basedOnLoggedInUser: nil, animated: true, completion: nil)
    }
    
    //MARK: - plants fetching/handling
    
    
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // any further additional setup after loading the view...
        // ...
        
        user.startPlantFetching()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - TableView
extension PlantsViewController: UITableViewDelegate {
    
}

extension PlantsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //just one section at the moment
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 //plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
