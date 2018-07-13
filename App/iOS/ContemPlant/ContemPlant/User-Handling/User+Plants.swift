//
//  User+Plants.swift
//  ContemPlant
//
//  Created by Gero Embser on 20.06.18.
//  Copyright © 2018 Gero Embser. All rights reserved.
//

import Foundation
import Apollo
import SortedArray

typealias Plant = BasicPlantDetails
class UserPlantController {
    private var apollo: ApolloClient
    
    init(withApolloClient apolloClient: ApolloClient) {
        self.apollo = apolloClient
    }
    
    var plants: SortedArray<BasicPlantDetails> = SortedArray(sorted: [], areInIncreasingOrder: { $0.id > $1.id })
    
    
    private var subscribeHandler: Cancellable?
    func setupSubscribeHandler() {
        guard subscribeHandler == nil else {
            return //nothing to setup
        }
        
        //setup the subscription
        subscribeHandler = apollo.subscribe(subscription: NewPlantsSubscription()) { [weak self] (result, error) in
            guard let id = result?.data?.newPlant?.node?.id, let name = result?.data?.newPlant?.node?.name else {
                return
            }
            
            //begin plant update (if no error occurred...)
            self?.beginPlantUpdate()
            
            //insert the plant to the appropriate position
            let plant = Plant(id: id, name: name)
            self?.insert(plants: [plant])
            
            
            //end plant update
            self?.endPlantUpdate()
        }
    }
    
    typealias PlantFetchingErrorHandler = (_ error: Error) -> Void
    func resetAndFetchPlants(errorHandler: PlantFetchingErrorHandler? = nil) {
        //begin plant update
        beginPlantUpdate()
        
        //reset
        removeAllPlants()
        
        //clear cache
        _ = apollo.clearCache()
        
        //re-fetch
        apollo.fetch(query: PlantsQuery()) { [weak self] (result, error) in
            if let error = error {
                //call the optional error handler
                errorHandler?(error)
            }
            
            guard let newPlants: [Plant] = result?.data?.plants.map({ $0.fragments.basicPlantDetails }) else {
                //end plant update
                self?.endPlantUpdate()
                
                return
            }
            
            self?.insert(plants: newPlants)
            
            // DEBUG:
            //            print(String(describing:result?.data?.plants))
            
            //end plant update
            self?.endPlantUpdate()
        }
        
        //also, setup a subscribe handler, if not yet done...
        setupSubscribeHandler()
    }
    
    
    //MARK: - observing plant changes
    typealias PlantUpdateBeganHandler = () -> Void
    var plantUpdateBeganHandler: PlantUpdateBeganHandler?
    
    typealias PlantUpdateFinishedHandler = () -> Void
    var plantUpdateFinishedHandler: PlantUpdateFinishedHandler?
    
    typealias PlantUpdateAddedPlantHandler = (_ plant: Plant, _ position: Int) -> Void
    var plantUpdateAddedPlantHandler: PlantUpdateAddedPlantHandler?
    
    typealias PlantUpdateDeletedPlantHandler = (_ plant: Plant, _ position: Int) -> Void
    var plantUpdateRemovedPlantHandler: PlantUpdateAddedPlantHandler?
}

extension UserPlantController {
    func insert(plants: [Plant]) {
        for plant in plants {
            add(plant: plant)
        }
    }
    
    func removeAllPlants() {
        for i in (0..<plants.count).reversed() {
            self.remove(plant: plants[i], atPosition: i)
        }
    }
}


extension UserPlantController {
    private func beginPlantUpdate() {
        self.plantUpdateBeganHandler?()
    }
    
    private func endPlantUpdate() {
        self.plantUpdateFinishedHandler?()
    }
    
    private func remove(plant: Plant, atPosition removePosition: Int) {
        self.plants.remove(at: removePosition)
        self.plantUpdateRemovedPlantHandler?(plant, removePosition)
    }
    
    private func remove(plant: Plant) {
        guard let removePosition = self.plants.index(of: plant) else {
            //discard removing that plant
            return
        }
        
        self.remove(plant: plant, atPosition: removePosition)
    }
    
    private func add(plant: Plant) {
        //make sure, it isn't already contained
        guard !self.plants.contains(plant) else {
            return //nothing to insert
        }
        
        let insertPosition = self.plants.insert(plant)
        self.plantUpdateAddedPlantHandler?(plant, insertPosition)
    }
}
