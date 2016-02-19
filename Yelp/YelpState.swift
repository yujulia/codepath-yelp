//
//  State.swift
//  Yelp
//
//  Created by Julia Yu on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation

class YelpState: NSObject {
    
    let MilestoMeter: Float = 1609.34
    
    var searchDistance: Float = 2000
    var searchCategory: [[String:String]]?
    
    func setDistance(distanceInMiles: Float) {
        self.searchDistance = distanceInMiles * MilestoMeter
        print("setting distance in miles ", distanceInMiles, " to meters ", self.searchDistance)
    }
    
    func getDistance() -> Float {
        return self.searchDistance
    }
    
    
}