//
//  Jdenticion.swift
//  ContemPlant
//
//  Created by Gero Embser on 20.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import UIKit
import JdenticonSwift

///Simple wrapper around JdenticonSwift
struct Jdenticon {
    enum JdenticonError:Error {
        case unknown
    }
    
    let data: Data
    init(from string: String) throws {
        guard let data = string.data(using: .utf8) else {
            throw JdenticonError.unknown
        }
        
        self.data = data
    }
    
    func image(with size: CGFloat) -> UIImage {
        let generator = IconGenerator(size: size*3, hash: data)
        
        return UIImage(cgImage: generator.render()!)
    }
}
