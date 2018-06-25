//
//  LoadPlantViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 24.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftOCR
import ImageDetect
import Vision

class LoadPlantViewController: UIViewController {
    //MARK: - instance variables
    private var captureSession: AVCaptureSession!
    private var photoOutput: AVCapturePhotoOutput!
    private var captureDevice: AVCaptureDevice!
    private var captureTimer: Timer?
    
    private var user: User!
    private var plant: Plant!
    
    
    ///The instance for analysing the OCR content
    private let swiftOCR = SwiftOCR()
    
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start the capture session
        captureSession.startRunning()
        
        //also start a timer that captures a photo every second
        startCaptureTimer()
    }
    
    deinit {
        //stop the capture timer
        stopCaptureTimer()
    }

}

//MARK: - capturing stuff
extension LoadPlantViewController {
    private func startCaptureTimer() {
        guard captureTimer == nil else {
            return //nothing to do, because timer is already running...
        }
        captureTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [unowned self] (timer) in
            //capture photo and analyse
            self.capturePhoto()
        }
    }
    private func stopCaptureTimer() {
        captureTimer?.invalidate()
        captureTimer = nil //set also to nil
    }
    
    private func capturePhoto() {
        //first, focus on the default point in the box (may differ for different phones)
        //focus, to get the best results
        do {
            try captureDevice.lockForConfiguration()
            
            // TODO: determine exact/best focus point
            let focusPoint = CGPoint(x: 0.5, y: 0.5) //just focus in the center of the image
            if captureDevice.isFocusPointOfInterestSupported { //only if focus is supported
                captureDevice.focusPointOfInterest = focusPoint
                captureDevice.focusMode = .autoFocus
            }
            if captureDevice.isExposureModeSupported(.continuousAutoExposure) {
                captureDevice.exposurePointOfInterest = focusPoint
                captureDevice.exposureMode = .continuousAutoExposure
            }
            
            captureDevice.unlockForConfiguration()
        }
        catch {
            //try without focus
            
            //-> ignore
        }
        
        //configure settings for the photo
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off
        settings.isHighResolutionPhotoEnabled = false
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func analyse(image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        
        //create vision request
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:]) //basic request handler
        
        //detect barcodes
        let barcodeDetectionRequest = VNDetectBarcodesRequest()
        barcodeDetectionRequest.symbologies = [.EAN8, .EAN13, .code128, .QR]
        
        
        //stop capture timer before performing the detection
        stopCaptureTimer()
        
        //perform the detection
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                //perform request
                try imageRequestHandler.perform([barcodeDetectionRequest])
                
                //get results
                if let barcodeObservations = barcodeDetectionRequest.results as? [VNBarcodeObservation],
                    let firstObservedBarcode = barcodeObservations.first,
                    let readBarcodeContent = firstObservedBarcode.payloadStringValue {
                    //just select the first one...
                    
                    print(readBarcodeContent)
                    self.loadPlant(onArduWithId: readBarcodeContent, completionHandler: { [weak self] (error) in
                        DispatchQueue.main.async { //UI stuff always on the main queue
                            if let error = error {
                                //do error handling
                                self?.userInterfaceHandle(loadPlantError: error)
                                
                                self?.startCaptureTimer()
                                return //return and restart the capture timer
                            }
                            
                            //show the screen that indicates a loaded plant
                            self?.blockUIWithLoadedPlantIndicator()
                        }
                    })
                    
                    return //don't start capture timer again (belowe)
                }
            } catch let error as NSError {
                //just print out the error
                print("Failed to perform image request: \(error)")
            }
            
            //start capture timer again! (on the main queue)
            DispatchQueue.main.async {
                self.startCaptureTimer()
            }
        }
        
        
        return
    }
}

extension LoadPlantViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        //get the photo data
        guard let photoData = photo.fileDataRepresentation() else {
            //just log an error
            NSLog("Captured photo cannot be converted to data!")
            return
        }
        
        guard let image = UIImage(data: photoData) else {
            NSLog("Captured photo cannot be converted to a UIImage")
            return
        }
        
        //analyse the image
        analyse(image: image)
    }
}

//MARK: - loading a plant
extension LoadPlantViewController {
    private func loadPlant(onArduWithId arduID: String, completionHandler: @escaping User.LoadPlantCompletionHandler) {
        //check the ardu ID
        guard arduID.count == 4, Int(arduID) != nil else {
                completionHandler(User.LoadPlantServerError.invalidArduID)
            return
        }
        
        user.load(plant: plant, onArdu: arduID, completion: completionHandler)
    }
    
    private func blockUIWithLoadedPlantIndicator() {
        //show the loaded plant indicator
        let loadedPlantIndicator = PlantLoadedIndicatorViewController.create(forUser: user, withLoadedPlant: plant)
        
        //do success haptic feedback
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        //show the VC (but not with push in the navigation controller)
        self.navigationController?.present(loadedPlantIndicator, animated: true, completion: {
            //close the load plant view controller instance by popping it from the navigation stack
            self.navigationController?.popViewController(animated: false)
        })
    }
}


//MARK: - creating an instance
extension LoadPlantViewController {
    class func create(forUser user: User, withPlant plant: Plant) throws -> LoadPlantViewController{
        //create the session
        guard let captureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            //camera not working,
            throw LoadPlantError.cameraProblem
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: captureDevice) else {
            throw LoadPlantError.unknownError
        }
        
        //create a capture session
        let captureSession = AVCaptureSession()
        
        guard captureSession.canAddInput(videoInput) else {
            throw LoadPlantError.unknownError
        }
        captureSession.addInput(videoInput)
        
        
        // CONFIGURE WHICH WHAT IS RECOGNIZED
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        guard captureSession.canAddOutput(photoOutput) else {
            throw LoadPlantError.unknownError
        }
        
        
        captureSession.addOutput(photoOutput)
        
        
        
        
        // finally load the VC from the storyboard and return it
        let vc = UIStoryboard.plantsLearning.instantiateViewController(withIdentifier: "LoadPlantViewController") as! LoadPlantViewController
        
        vc.captureSession = captureSession
        vc.photoOutput = photoOutput
        vc.captureDevice = captureDevice
        
        vc.user = user
        vc.plant = plant
        
        return vc
    }
    
    enum LoadPlantError:Error {
        case cameraProblem
        case unknownError
    }
}


//MARK: - general error handling
extension LoadPlantViewController {
    private func userInterfaceHandle(loadPlantError: Error) {
        //for the moment, just show an error that indicates that loading the plant was not successfull, in the future advanced error handling can be done here, like error sound or vibration etc.
        show(simpleErrorMessage: "Das Laden der Pflanze an deinen Lernplatz war leider nicht erfolgreich! Bitte versuche es erneut! Nicht aufgeben! Weiter lernen!", withTitle: "Laden fehlgeschlagen 😭")
    }
}
