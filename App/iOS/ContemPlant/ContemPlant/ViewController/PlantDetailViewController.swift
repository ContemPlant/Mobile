//
//  PlantDetailViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 21.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit
import AVFoundation
import UICircularProgressRing

class PlantDetailViewController: UIViewController {
    
    //MARK: - instance variables
    var user: User!
    var plant: Plant!
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup ui
        updateUI(accordingToPlant: plant)
    }
    
    //MARK: - outlets
    @IBOutlet var healthCircularProgressRing: UICircularProgressRing!
    
    
    //MARK: - actions
    @IBAction func activatePlantTapped(_ sender: UIButton) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            //setup the camera session (which includes checks if camera is working)
            self.startPlantActivation()
        case .notDetermined:
            //request acces
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                guard granted else {
                    //show error
                    self.showCameraAccessDeniedError()
                    return
                }
                //setup camera session if access is granted
                self.startPlantActivation()
            }
        case .denied:
            //show error
            self.showCameraAccessDeniedError()
        case .restricted:
            //show error!
            self.showCameraAccessRestrictedError()
        }
    }
    

}


//MARK: - UI-setup
extension PlantDetailViewController {
    private func updateUI(accordingToPlant plant: Plant) {
        //set title
        self.title = plant.name
        self.healthCircularProgressRing.value = CGFloat(plant.currentHealth*100)
        self.healthCircularProgressRing.innerRingColor = UIColor(colorBetween: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), andColor: #colorLiteral(red: 0.175152868, green: 0.7770395279, blue: 0.2203405499, alpha: 1), percent: CGFloat(plant.currentHealth)) ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
}

//MARK: - camera access setup
extension PlantDetailViewController {
    private func showCameraAccessDeniedError() {
        show(simpleErrorMessage: "Kamera-Zugriff wird benötigt, um die Pflanze zu aktivieren. Ohne geht es leider nicht!",
             withTitle: "Kamera-Zugriff verweigert",
             actionButton:(title: "Einstellungen", action: {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                    self.show(simpleErrorMessage: "Öffnen fehlgeschlagen", withTitle: "Einstellungen können nicht geladen werden!")
                    return
                }
                
                UIApplication.shared.open(settingsURL)
        }))
    }
    
    private func showCameraAccessRestrictedError() {
        show(simpleErrorMessage: "Zugriff auf die Kamera aufgrund von Restriktionen nicht möglich! Laden der Pflanze ist nicht möglich!", withTitle: "Zugriff restringiert!")
        
    }
    
    private func startPlantActivation() {
        //create the new ViewController that handles
        do {
            let loadPlantVC = try LoadPlantViewController.create(forUser: user, withPlant: plant)
        
            //present the VC
            show(loadPlantVC, sender:self)
        }
        catch let error as LoadPlantViewController.LoadPlantError {
            switch error {
            case .cameraProblem:
                //camera not working, show error
                show(simpleErrorMessage: "Es sieht so aus, als gäbe es einen Fehler mit deiner Kamera! Ist sie kaputt? Ohne funktionierende Kamera, kannst du leider keine Pflanze aktivieren!", withTitle: "Kamera kaputt?", okButtonTitle: "😡")
            case .unknownError:
                showSimpleGeneralPurposeErrorMessage()
            }
        }
        catch {
            showSimpleGeneralPurposeErrorMessage()
        }
    }
}

extension PlantDetailViewController {
    private func showSimpleGeneralPurposeErrorMessage() {
        show(simpleErrorMessage: "Es sieht so aus, als ist etwas schiefgelaufen!", withTitle: "Mist 😡", okButtonTitle: "ok...")
    }
}
