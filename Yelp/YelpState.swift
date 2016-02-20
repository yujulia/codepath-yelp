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
    let MilesDefault: Float = 12.50
    
    var filterDistance: Float?
    var filterDistanceInMiles: Float?
    var filterDeals: Bool?
    var filterCategories = [Int:String]()
    
    var resultOffset: Int?
    
    // ------------------ filter distance
    
    func setFilterDistance(distanceInMiles: Float) {
        self.filterDistance = distanceInMiles * MilestoMeter
        self.filterDistanceInMiles = distanceInMiles
    }
    
    func getFilterDistanceInMiles() -> Float? {
        return self.filterDistanceInMiles
    }
    
    func getFilterDistance() -> Float? {
        return self.filterDistance
    }
    
    // ------------------ filter deals
    
    func setFilterDeals(hasDeal: Bool) {
        self.filterDeals = hasDeal
    }
    
    func getFilterDeals() -> Bool? {
        return self.filterDeals
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
        
        var codeList = [String]()
        
        for (_, code) in self.filterCategories {
            codeList.append(code)
        }
        
        if codeList.count > 0 {
            return codeList
        } else {
            return nil
        }
    }
    
    // ------------------ result offset
    
    func setResultOffset(offset: Int) {
        self.resultOffset = offset
    }
    
    func getResultOffset() -> Int? {
        return self.resultOffset
    }
    
    // ------------------ reset all filters 
    
    func resetFilters() {
        self.filterDistance = nil
        self.filterDistanceInMiles = nil
        self.filterDeals = nil
        self.filterCategories = [Int:String]()
    }
    
}