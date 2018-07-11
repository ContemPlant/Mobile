//
//  API+Extensions.swift
//  ContemPlant
//
//  Created by Gero Embser on 11.07.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//
//  convenience extensions for API-access

import Foundation

extension Plant {
    var currentHealth: Double {
        return self.plantStates?.last?.health ?? 0.0 //default health value is zero
    }
}
