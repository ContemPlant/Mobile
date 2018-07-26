//
//  SCNNode+Animations.swift
//  ContemPlant
//
//  Created by Gero Embser on 26.07.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    enum PlantAppearanceAnimation {
        case plop
    }
    func addChild(node: SCNNode, with animationType: PlantAppearanceAnimation) {
        
        var animationAction: SCNAction? = nil
        switch animationType {
        case .plop:
            let prevScale = node.scale
            node.scale = SCNVector3(0, 0, 0)
            
            animationAction = SCNAction.scale(to: CGFloat(prevScale.x), duration: 1.5)
            animationAction?.timingMode = .linear
            
            animationAction?.timingFunction = easeOutElastic(_:)
        }
        
        //call super class
        self.addChildNode(node)
        
        //run action, if there's one to run
        if let animationAction = animationAction {
            node.runAction(animationAction)
        }
    }
    
    // Timing function that has a "bounce in" effect
    func easeOutElastic(_ t: Float) -> Float {
        let p: Float = 0.3
        let result = pow(2.0, -10.0 * t) * sin((t - p / 4.0) * (2.0 * Float.pi) / p) + 1.0
        return result
    }
}
