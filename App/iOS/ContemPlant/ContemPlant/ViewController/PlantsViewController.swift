//
//  PlantsViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 17.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit
import JdenticonSwift

class PlantsViewController: UIViewController {

    //MARK: - instance variables
    var plantsNavigationController: PlantsNavigationController {
        return self.navigationController as! PlantsNavigationController
    }
    var user: User {
        return plantsNavigationController.user
    }
    
    private let refreshControl = UIRefreshControl()
    
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
    private func reloadPlants() {
        self.refreshControl.beginRefreshing()
        user.plantController.resetAndFetchPlants() { [weak self] error in
            DispatchQueue.main.async {
                self?.show(simpleErrorMessage: "Netzwerk-Fehler", withTitle: "Wir konnten keine Verbindung mit dem Server herstellen!")
            }
        }
    }
    
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // any further additional setup after loading the view...
        // ...
        
        reloadPlants()
        
        
        //setup plant observers
        setupPlantsControllerObservers()
        
        
        //setup the table view
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedRowIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRowIndexPath, animated: animated)
        }
    }
    

    // MARK: - Navigation

    private var selectedPlant: Plant?
    private func select(plant: Plant) {
        selectedPlant = plant
    }
    private func deselect(plant: Plant) {
        selectedPlant = nil
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailVC = segue.destination as? PlantDetailViewController {
            detailVC.user = user
            detailVC.plant = selectedPlant! //force unwrap, because if it is nil here, we've done a huge mistake!
        }
    }

}

//MARK: - TableView
extension PlantsViewController {
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTableViewManually), for: .valueChanged)
    }
    @objc private func refreshTableViewManually() {
        //just re-initiate fetching
        reloadPlants()
    }
}

extension PlantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get plant
        let plant = user.plants[indexPath.row]
        
        //"select" the plant
        select(plant: plant)
        
        //perform the segue
        performSegue(withIdentifier: "selectedPlantSegue", sender: self)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //get plant
        let plant = user.plants[indexPath.row]
        
        //"deselect" the plant
        deselect(plant: plant)
    }
}

extension PlantsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //just one section at the moment
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantTableViewCell")! as! PlantTableViewCell
        
        let plant = user.plants[indexPath.row]
        
        cell.textLabel?.text = plant.name
        cell.imageView?.image = (try? Jdenticon(from: "öjlasdfjölaksdjfölaskjd").image(with: cell.imageView!.frame.size.width) ) ?? (#imageLiteral(resourceName: "Icons/Logo+Schriftzug.pdf"))
        cell.jdenticonWebView.loadJdenticon(forValue: plant.id)
        
        //health stuff
        let healthValue = plant.currentHealth
        cell.healthIndicatorProgressView.progress = Float(healthValue)
        cell.healthIndicatorProgressView.progressTintColor = UIColor(colorBetween: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), andColor: #colorLiteral(red: 0.175152868, green: 0.7770395279, blue: 0.2203405499, alpha: 1), percent: CGFloat(healthValue)) ?? UIColor.systemsDefaultTintColor //default color is blue
        cell.detailLabel.text = "Health: \(healthValue)"
        
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
            self?.refreshControl.endRefreshing()
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
