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

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // DEBUG:
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        //run the config
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(config, options: options)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
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
        let assetName = "daisy" //"forest" //plant" // "tree"
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
