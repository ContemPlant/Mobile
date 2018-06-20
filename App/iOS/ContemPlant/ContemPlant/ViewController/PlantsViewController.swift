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
        
        user.plantController.resetAndFetchPlants()
        
        
        //setup plant observers
        setupPlantsControllerObservers()
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
        return user.plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell() //tableView.dequeueReusableCell(withIdentifier: "PlantTableViewCell")!
        
        cell.textLabel?.text = user.plants[indexPath.row].name
        
        return cell
    }
}

extension PlantsViewController {
    private func indexPath(forIndex rowIndex: Int) -> IndexPath {
        return IndexPath(row: rowIndex, section: 0)
    }
    
    func setupPlantsControllerObservers() {
        self.user.plantController.plantUpdateBeganHandler = { [weak self] in
            self?.tableView.beginUpdates()
        }
        
        self.user.plantController.plantUpdateFinishedHandler = { [weak self] in
            self?.tableView.endUpdates()
        }
        
        self.user.plantController.plantUpdateAddedPlantHandler = { [weak self] (_, index) in
            self?.tableView.insertRows(at: [self!.indexPath(forIndex: index)], with: .automatic)
        }
        
        self.user.plantController.plantUpdateRemovedPlantHandler = { [weak self] (_, index) in
            self?.tableView.deleteRows(at: [self!.indexPath(forIndex: index)], with: .automatic)
        }
    }
}
