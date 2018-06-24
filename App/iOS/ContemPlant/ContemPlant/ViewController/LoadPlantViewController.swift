//
//  LoadPlantViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 24.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit
import AVFoundation

class LoadPlantViewController: UIViewController {
    //MARK: - instance variables
    private var captureSession: AVCaptureSession!
    private var photoOutput: AVCapturePhotoOutput!
    private var captureDevice: AVCaptureDevice!
    private var captureTimer: Timer?
    
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
        settings.isHighResolutionPhotoEnabled = true
        
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    private func analyse(image: UIImage) {
        
        print("image analyse starts...")
        
        // TODO:
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


//MARK: - creating an instance
extension LoadPlantViewController {
    class func create() throws -> LoadPlantViewController{
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
        
        return vc
    }
    
    enum LoadPlantError:Error {
        case cameraProblem
        case unknownError
    }
}
