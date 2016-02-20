//
//  State.swift
//  Yelp
//
//  Created by Julia Yu on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

class YelpState: NSObject {
    
    let MilestoMeter: Float = 1609.34 // convert miles/meter
    
    var searchDistance: Float?
    var searchDistanceInMiles: Float?
    
    var searchCategory: [[String:String]]?
    var searchDeals: Bool?
    
    // ------------------ search distance setter getter
    
    func setSearchDistance(distanceInMiles: Float) {
        self.searchDistance = distanceInMiles * MilestoMeter
        self.searchDistanceInMiles = distanceInMiles
    }
    
    func getSearchDistanceInMiles() -> Float? {
        return self.searchDistanceInMiles
    }
    
    func getSearchDistance() -> Float? {
        return self.searchDistance
    }
    
    // ------------------ search deals setter getter
    
    func setSearchDeals(hasDeal: Bool) {
        self.searchDeals = hasDeal
    }
    
    func getSearchDeals() -> Bool? {
        return self.searchDeals
    }
    
    
}