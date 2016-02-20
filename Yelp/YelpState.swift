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
    var searchDeals: Bool?
    
    var filterCategories = [Int:String]()
    
    // ------------------ filter distance
    
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
    
    // ------------------ filter deals
    
    func setSearchDeals(hasDeal: Bool) {
        self.searchDeals = hasDeal
    }
    
    func getSearchDeals() -> Bool? {
        return self.searchDeals
    }
    
    // ------------------ filter category
    
    func addToCategory(index: Int, category: String) {
        self.filterCategories[index] = category
    }
    
    func removeFromCategory(index: Int) {
        self.filterCategories[index] = nil
    }

    func toggleCategory(index: Int, on: Bool) {
        if on {
            let categoryCode = Const.Categories[index]["code"]!
            self.addToCategory(index, category: categoryCode)
        } else {
            self.removeFromCategory(index)
        }
    }
    
    func getFilterCategories() -> NSArray? {
        
        print(self.filterCategories, self.filterCategories.count)
        
        // conver dictionary to array
        
        return nil
    }
    
    
}