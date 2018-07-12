//
//  PlantLoadedIndicatorViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 25.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit
import SwiftGif

class PlantLoadedIndicatorViewController: UIViewController {

    //MARK: - instance variables
    private var user: User!
    private var loadedPlant: Plant!
    
    private var deviceOrientationObserver: NSObjectProtocol!
    
    //MARK: - outlets
    @IBOutlet var plantGifImageView: UIImageView!
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load the gif programmatically, because it does not work using the usual asset catalog
        self.plantGifImageView.loadGif(asset: "Gifs/funnyPlantDanceAnimation")
        
        //setup device orientation changes
        setupDeviceOrientationChanges()
    }
    
    
    //MARK: - deinit
    deinit {
        unsetupDeviceOrientationChanges()
    }

}

//MARK: - creation
extension PlantLoadedIndicatorViewController {
    class func create(forUser user: User, withLoadedPlant loadedPlant: Plant) -> PlantLoadedIndicatorViewController {
        let vc = UIStoryboard.plantsLearning.instantiateViewController(withIdentifier: "PlantLoadedIndicatorViewController") as! PlantLoadedIndicatorViewController
        
        vc.user = user
        vc.loadedPlant = loadedPlant
        
        return vc
    }
}

//MARK: - setup device orientation changes
extension PlantLoadedIndicatorViewController {
    private func unsetupDeviceOrientationChanges() {
        NotificationCenter.default.removeObserver(deviceOrientationObserver)
    }
    
    private func setupDeviceOrientationChanges() {
        deviceOrientationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) {[weak self] (_) in
            self?.endLearningIfAllConditionsMet()
        }
    }
}

//MARK: - dismissal
extension PlantLoadedIndicatorViewController {
    private func forceEndLearning() {
        //end learning
        //unload, but dismiss whether was successful or not (this is just as fallback and for easier testing...)
        user.unload(plant: loadedPlant)
        
        //create ar vc
        let arVC = ARPlantViewController.create(withUser: user, andPlant: loadedPlant)
        
        //show it on the PlantsNavigationController
        (self.presentingViewController as? PlantsNavigationController)?.pushViewController(arVC, animated: false)
        
        unsetupDeviceOrientationChanges()
        
        dismiss(animated: true, completion: nil)
    }
    private func endLearningIfAllConditionsMet() {
        let currentOrientation = UIDevice.current.orientation
        if currentOrientation != .faceUp && currentOrientation != .faceDown {
            forceEndLearning()
        }
    }
    
}


