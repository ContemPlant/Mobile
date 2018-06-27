//
//  ARPlantViewController.swift
//  ContemPlant
//
//  Created by Gero Embser on 14.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARPlantViewController: UIViewController, ARSCNViewDelegate {

    //MARK: - instance variables
    private var user: User!
    private var plant: Plant!
    
    private var fullyVisibleARFrame: CGRect!
    
    //MARK: - outlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerViewBottomSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundBlurVisualEffectView: UIVisualEffectView!
    @IBOutlet var scrollableContainer: UIView!
    @IBOutlet var backButton: UIButton!
    
    
    //MARK: - actions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // DEBUG:
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
        
        // Lighting setup
        // TODO: improve lighting (maybe also the scn-file-models) so that automaticallyUpdatesLighting works
        sceneView.autoenablesDefaultLighting = true //to support scn-files like daisy
        sceneView.automaticallyUpdatesLighting = true
        
        
        //setup scroll view
        setupScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //navigation controller stuff
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //(re)set tracking
        resetTrackingConfig()
    }
    
    private func resetTrackingConfig() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Reference images not found! This is likely to be a bug!")
        }
        
        //configure the config
        let config = ARWorldTrackingConfiguration()
        config.detectionImages = referenceImages
        config.maximumNumberOfTrackedImages = 1 //  IMPORTANT for faster tracking! (if this is not set, moving a detected object in the world isn't really fast!!!!!
        
        //run the config
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(config, options: options)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //navigation controller stuff
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}

// MARK: - ARSCNViewDelegate
extension ARPlantViewController {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //make sure, an image anchor is provided, because we track images
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return // don't add any additional node to the scene
        }
        
        //get the recognized reference image from the anchor node
        let referenceImage = imageAnchor.referenceImage
        
        //create a image location indicator node
        let imageLocationPlane = SCNPlane(width: referenceImage.physicalSize.width,
                                          height: referenceImage.physicalSize.height)
        imageLocationPlane.firstMaterial?.diffuse.contents = UIColor.white
        
        let imageLocationIndicatorNode = SCNNode(geometry: imageLocationPlane)
        imageLocationIndicatorNode.opacity = 0.0 // 1.0 // -> if plane should be visible
        imageLocationIndicatorNode.eulerAngles.x = -.pi/2
        
        //add the created image location indicator node to the node that is associated with the anchor (automatically by ARKit -> see also the renderer(... nodeFor...)-method)
        node.addChildNode(imageLocationIndicatorNode)
        
        
        //add the plant node
        // Models from https://poly.google.com/
        let assetName = "tree" //daisy" //"forest" //plant" // "tree"
        guard let plantScene = SCNScene(named: "art.scnassets/\(assetName).scn"),
            let plantNode = plantScene.rootNode.childNode(withName: assetName, recursively: false)
            else {
                fatalError("Plant 3D model not found. This is probably a bug!")
        }
        
        //OPTIONAL (may be helpful for some models)
        //scale plant node
        //        let scaleFactor  = 1.0
        //        plantNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        //        //position plant
        //        plantNode.position.y = 0.0 //y is the "height" coordinate in usual 3D-space
        
        //DEFAULT-Styling of nodes
        plantNode.pivot = SCNMatrix4MakeTranslation(0, plantNode.boundingBox.min.y, 0) //change the "origin" so that the plant is on the "plane"
        
        node.addChildNode(plantNode)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


//MARK: - creation of ARPlantViewController
extension ARPlantViewController {
    class func create(withUser user: User, andPlant plant: Plant) -> ARPlantViewController {
        let arVC = UIStoryboard.learningCompletionAR.instantiateViewController(withIdentifier: "ARPlantViewController") as! ARPlantViewController
        arVC.user = user
        arVC.plant = plant
        
        return arVC
    }
}

//MARK: - interactive pop gesture recognizer
extension ARPlantViewController: UIGestureRecognizerDelegate { }


//MARK: - scroll view stuff
extension ARPlantViewController {
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        
        //save fully visible AR-Frame
        fullyVisibleARFrame = scrollView.frame
        fullyVisibleARFrame.size.height -= abs(containerViewBottomSpacingConstraint.constant)
    }
}

extension ARPlantViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //get the current content offset y
        let currentOffset = scrollView.contentOffset
        
        //compute how much of the visible AR-View is covered
        let coveredSpace = (fullyVisibleARFrame.size.height-(scrollableContainer.frame.origin.y-currentOffset.y))/fullyVisibleARFrame.size.height
        
        print(coveredSpace)
        
        backgroundBlurVisualEffectView.alpha = coveredSpace*2 //faster blur...
    }
}
