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
    
    private var currentPresentedPlantType: ARPlantNodeType?
    private var currentPlantNode: SCNNode?
    
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
    @IBAction func doubleTappedOnScrollView(_ sender: UITapGestureRecognizer) {
        //change plants
        
        let location = sender.location(in: view)
        
        if location.x > view.frame.size.width/2.0 {
            //forward
            nextPlantRepresentation()
        }
        else {
            //backward
            previousPlantRepresentation()
        }
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
        
        //reset
        currentPlantNode = nil
        currentPresentedPlantType = nil
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
        
        //add the plant node
        currentPresentedPlantType = addRandomLSystemPlantNode(asChildOf: node, withHealth: Float(plant.currentHealth))
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


//MARK: - changing plants
extension ARPlantViewController {
    enum FullPlantNodeType: String, ARPlantNodeType, CaseIterable {
        case tree
        case daisy
        case forest
        case simplePlant = "plant"
        case rose = "rose"
        
        var supportsDifferentSizes: Bool {
            return false
        }
        var customScale: Double? {
            switch self {
            case .rose: return 0.005
            default: return nil
            }
        }
    }
    enum LsystemPlantNodeType: String, ARPlantNodeType, CaseIterable {
        case mycelis = "mycelis"
        case ltree = "ltree"
        case ltreerandom = "ltreerandom"
        case lychnis = "lychnis"
        
        var supportsDifferentSizes: Bool {
            return true
        }
    }
    private func addLSystemPlantNode(named lsystemPlantNodeType: LsystemPlantNodeType, asChildOf parent: SCNNode, withHealth health: Float = 1.0) {
        
        let lsystemNode = lsystemPlantNodeType.getNewNode()
        
        //fin the nodes of the l-system node that represent the different steps
        var rootStepNodes = lsystemNode.childNodes { (node, _) in return node.name?.contains("RootStep") ?? false }
        
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
        let plantHealth = (0.0 ... 1.0).clamp(health)
        let plantNode = rootStepNodes[(0 ... rootStepNodes.count-1).clamp(Int(Float(rootStepNodes.count) * plantHealth))] //select a node in the array corresponding to the plant's health
        //alternative? Double(rootStepNodes.count-1)*plantHealth
        
        
        //scale plant node
        let scaleFactor  = 0.007
        plantNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
        
        //add the plant node
        add(plantNode: plantNode, asChildOf: parent)
    }
    
    private func addRandomLSystemPlantNode(asChildOf parent: SCNNode, withHealth health: Float = 1.0) -> LsystemPlantNodeType {
        let randomLSystem = LsystemPlantNodeType.allCases.randomElement()! //it could never be nil!
        
        addLSystemPlantNode(named: randomLSystem, asChildOf: parent, withHealth: health)
        
        return randomLSystem
    }
    
    private func add(plantNode: SCNNode, asChildOf parent: SCNNode) {
        //position plant at origin
        plantNode.position.y = 0.0 //y is the "height" coordinate in usual 3D-space
        plantNode.position.x = 0.0
        plantNode.position.z = 0.0
        
        //DEFAULT-Styling of nodes
        plantNode.pivot = SCNMatrix4MakeTranslation(0, plantNode.boundingBox.min.y, 0) //change the "origin" so that the plant is on the "plane"
        
        //"global" current
        currentPlantNode = plantNode
        
        //add plantNode as child of parent with the default animation
        parent.addChild(node: plantNode, with: .plop)
        
    }
    
    private func removeCurrentPlantNode() {
        currentPlantNode?.removeFromParentNode()
        
        currentPlantNode = nil
        currentPresentedPlantType = nil
    }
    
    ///Defines the order of the plants, if changed
    var allARPlantNodeTypes: [ARPlantNodeType] {
        return LsystemPlantNodeType.allCases as [ARPlantNodeType] + FullPlantNodeType.allCases as [ARPlantNodeType]
    }
    
    private func nextPlantRepresentation() {
        switchPlant(withFindNewIndexFun: { $0 + 1 } )
    }
    
    private func previousPlantRepresentation() {
        switchPlant(withFindNewIndexFun: { $0 - 1 } )
    }
    
    private func switchPlant(withFindNewIndexFun findNewIndex: (Int) -> Int ) {
        guard let currentPlantNode = currentPlantNode, let parent = currentPlantNode.parent else {
            return //nothing to do, if nothing isshown at the moment
        }
        
        let plantToShow: ARPlantNodeType
        if let currentPresentedPlantType = currentPresentedPlantType {
            let currentIndex = allARPlantNodeTypes.firstIndex { $0 == currentPresentedPlantType }!
            
            var index = (findNewIndex(currentIndex))%allARPlantNodeTypes.count
            if index < 0 {
                index = allARPlantNodeTypes.count+index
            }
            //todo: write something like a "rotating subscript"
            plantToShow = allARPlantNodeTypes[index]
        }
        else {
            plantToShow = allARPlantNodeTypes.first! //such an element exists always
        }
        
        //remove...
        removeCurrentPlantNode()
        
        //re-set
        currentPresentedPlantType = plantToShow
        
        //add
        if let plantToShow = plantToShow as? LsystemPlantNodeType {
            addLSystemPlantNode(named: plantToShow, asChildOf: parent, withHealth: Float(plant.currentHealth))
        }
        else {
            add(plantNode: plantToShow.getNewNode(), asChildOf: parent)
        }
    }
}

///Defines what types of nodes can represent AR plants
protocol ARPlantNodeType {
    var assetName: String { get }
    func getNewNode() -> SCNNode
    var supportsDifferentSizes: Bool { get }
    var customScale: Double? { get }
}

//extension Equatable where Self: ARPlantNodeType {
//    static func -* (lhs: Self, rhs: Self) -> Bool {
//        return lhs.assetName == rhs.assetName
//    }
//}
infix operator ==
func == (lhs: ARPlantNodeType, rhs: ARPlantNodeType) -> Bool {
    return lhs.assetName == rhs.assetName
}

extension ARPlantNodeType {
    var customScale: Double? {
        return nil
    }
    func getNewNode() -> SCNNode {
        guard let node = SCNNode.loadNode(withName: assetName) else {
            fatalError("Plant 3D model not found. This is probably a bug!")
        }
        if let customScale = customScale {
            node.scale = SCNVector3(customScale, customScale, customScale)
        }
        return node
    }
}


extension RawRepresentable where RawValue == String, Self: ARPlantNodeType {
    var assetName: String {
        return self.rawValue
    }
}
