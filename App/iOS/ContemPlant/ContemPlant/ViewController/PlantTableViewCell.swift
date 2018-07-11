//
//  PlantTableViewCell.swift
//  ContemPlant
//
//  Created by Gero Embser on 20.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import UIKit

class PlantTableViewCell: UITableViewCell {

    //MARK: - outlets
    @IBOutlet var jdenticonImageView: UIImageView!
    @IBOutlet var plantNameLabel: UILabel!
    @IBOutlet var healthIndicatorProgressView: UIProgressView!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var jdenticonWebView: JdenticonWebView!
    
    
    override var detailTextLabel: UILabel? {
        set {
            detailLabel = newValue
        }
        get {
            return detailLabel
        }
    }
    
    override var textLabel: UILabel? {
        set {
            plantNameLabel = newValue
        }
        get {
            return plantNameLabel
        }
    }
    
    override var imageView: UIImageView? {
        set {
            jdenticonImageView = newValue
        }
        get {
            return jdenticonImageView
        }
    }
}
