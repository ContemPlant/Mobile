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
    
    private var applicationActiveObserver: NSObjectProtocol?
    
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
        
        //setup application active notification
        setupApplicationActiveNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigation controller stuff
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        //(re)set tracking
        resetTrackingConfig()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //(re)set tracking
        resetTrackingConfig()
    }
    
    private var isRunning = false
    private func resetTrackingConfig() {
        guard UIApplication.shared.applicationState != .background else {
            return //don't reset tracking if in background (does not work...)...
        }
        
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
        isRunning = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //navigation controller stuff
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        // Pause the view's session
        sceneView.session.pause()
        isRunning = false
    }

    
    deinit {
        unsetupApplicationActiveNotification()
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
        
        
        let lsystemAssetNames = ["mycelis", "ltree", "ltreerandom", "lychnis"]
        
        //add the plant node
        // Models from https://poly.google.com/
        let assetName = lsystemAssetNames.randomElement() ?? "tree" // "mycelis" //tree" //daisy" //"forest" //plant" // "tree"
        guard let plantScene = SCNScene(named: "art.scnassets/\(assetName).scn"),
            let rootNode = plantScene.rootNode.childNode(withName: assetName, recursively: true)
            else {
                fatalError("Plant 3D model not found. This is probably a bug!")
        }
        
        var rootStepNodes = rootNode.childNodes { (node, _) in return node.name?.contains("RootStep") ?? false }
        
        guard !rootStepNodes.isEmpty else {
            fatalError("Not enough plant models found. This is probably a bug!")
        }
        
        //a method important for sorting correct by the numbers
        func rootStepNumber(from node: SCNNode) -> Int {
            return Int((node.name ?? "").replacingOccurrences(of: "RootStep", with: "")) ?? -1
        }
        
        //order the rootStep nodes alphabetically by name
        rootStepNodes.sort { rootStepNumber(from: $0) < rootStepNumber(from: $1) }
        
        
        //make sure, plant Health is inside the allowed range
        let plantHealth = (0.0 ... 1.0).clamp(plant.currentHealth) //plant.currentHealth
        let plantNode = rootStepNodes[(0 ... rootStepNodes.count-1).clamp(Int(Double(rootStepNodes.count) * plantHealth))] //select a node in the array corresponding to the plant's health
        //alternative? Double(rootStepNodes.count-1)*plantHealth
        
        //OPTIONAL (may be helpful for some models)
        //scale plant node
        let scaleFactor  = 0.03
        plantNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        //position plant
        plantNode.position.y = 0.0 //y is the "height" coordinate in usual 3D-space
        plantNode.position.x = 0.0
        plantNode.position.z = 0.0
        
        //DEFAULT-Styling of nodes
        plantNode.pivot = SCNMatrix4MakeTranslation(0, plantNode.boundingBox.min.y, 0) //change the "origin" so that the plant is on the "plane"
        
        node.addChildNode(plantNode)
        
//        add3DFractal(toNode: node)
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

//MARK: - foreground/background stuff
extension ARPlantViewController {
    private func setupApplicationActiveNotification() {
        applicationActiveObserver = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.resetTrackingConfig()
        })
    }
    private func unsetupApplicationActiveNotification() {
        if let observer = applicationActiveObserver {
            NotificationCenter.default.removeObserver(observer)
            applicationActiveObserver = nil
        }
    }
}

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
        
        
        backgroundBlurVisualEffectView.alpha = coveredSpace*2 //faster blur...
    }
}


//MARK: - 3D fractal
extension ARPlantViewController {
    private func add3DFractal(toNode node: SCNNode) {
        let depth = 12
        
        //draw root/trunk
        let squareNode = self.squareNode(ofSize: 0.05)
        
        node.addChildNode(squareNode)
        
        //draw "leaves"
        add3DFractalLeaves(uponNode: squareNode, depth: depth)
    }
    
    private func add3DFractalLeaves(uponNode node: SCNNode, depth: Int) {
        guard depth > 0 else {
            return
        }
        
        let a = squareNode(ofSize: node.boundingBox.max.x)
        let b = squareNode(ofSize: node.boundingBox.max.x)
        let aPos = SCNVector3(node.boundingBox.max.x/2, node.boundingBox.max.y+node.boundingBox.max.y/2, node.position.z)
        a.position = aPos
        a.rotation = SCNVector4(1, 1, 0, -Float.pi/2)
        
        let bPos = SCNVector3(node.boundingBox.min.x/2, node.boundingBox.max.y+node.boundingBox.max.y/2, node.position.z)
        b.position = bPos
        b.rotation = SCNVector4(-1, 1, 0, Float.pi/2)
        
        node.addChildNode(a)
        node.addChildNode(b)
        
        add3DFractalLeaves(uponNode: a, depth: depth-1)
        add3DFractalLeaves(uponNode: b, depth: depth-1)
    }
    
    private func squareNode(ofSize size: Float) -> SCNNode {
        let geom = SCNBox(width: CGFloat(size), height: CGFloat(size), length: CGFloat(size), chamferRadius: 0)
        geom.firstMaterial?.diffuse.contents = UIColor.green
        
        let node = SCNNode(geometry: geom)
        
        return node
    }
}
