//
//  Dictionary+Helper.swift
//  ContemPlant
//
//  Created by Gero Embser on 16.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation

extension Dictionary {
    ///Can be used, to delete some of the optional values out of the dictionary (maybe under ceratin circumstances which are defined in the closure)
    func compactValueMap(_ transform: ((key: Key, value: Value)) -> Value?) -> [Key: Value] {
        var newDictionary = [Key:Value]()
        
        for (existingKey, correspondingValue) in self {
            if let newValue = transform((key:existingKey, value: correspondingValue)) {
                newDictionary[existingKey] = newValue
            }
        }
        
        return newDictionary
    }
    
    ///Rewrites the dictionary in a way that each key-value-pair can be mapped to a new key-value-pair (or to nil, which means: don't include in new dict) and from all new key-value-pairs, the function will create a new dictionary
    func compactKeyValueMap<S,T>(_ transform: ((key: Key, value: Value)) -> (S, T)? ) -> [S: T] where S: Hashable {
        let tupleArrayRepresentation = self.compactMap(transform)
        
        return Dictionary<S,T>(uniqueKeysWithValues: tupleArrayRepresentation)
    }
}
