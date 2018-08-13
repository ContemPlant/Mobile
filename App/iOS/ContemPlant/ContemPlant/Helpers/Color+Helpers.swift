//
//  Color+Helpers.swift
//  ContemPlant
//
//  Created by Gero Embser on 11.07.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var systemsDefaultTintColor: UIColor {
        return UIButton().tintColor
    }
}

extension UIColor {
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat)? {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: nil) else {
            return nil
        }
        
        return (red: red, green: green, blue: blue)
    }
}

extension UIColor {
    ///Creates a new color that is percentually in the "middle" of the two given colors. The new colors default alpha value is 1
    convenience init?(colorBetween colorA: UIColor, andColor colorB: UIColor, percent: CGFloat, defaultAlpha: CGFloat = 1.0) {
        guard let rgbA = colorA.rgb,
            let rgbB = colorB.rgb else {
                return nil
        }
        
        let rDiff = rgbB.red-rgbA.red
        let gDiff = rgbB.green-rgbA.green
        let bDiff = rgbB.blue-rgbA.blue
        
        self.init(red: rgbA.red+rDiff*percent,
                  green: rgbA.green+gDiff*percent,
                  blue: rgbA.blue+bDiff*percent,
                  alpha: defaultAlpha)
    }
}
