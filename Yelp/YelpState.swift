//
//  State.swift
//  Yelp
//
//  Created by Julia Yu on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

class YelpState: NSObject {
    
    let MilestoMeter: Float = 1609.34 // convert miles/meter
    let MilesDefault: Float = 12.50
    
    var filterDistance: Float?
    var filterDistanceInMiles: Float?
    var filterDeals: Bool?
    var filterCategories = [Int:String]()
    var resultOffset: Int?
    var openSections = [Int:Bool]()
    
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

    func toggleFilterCategory(index: Int, on: Bool) {
        if on {
            let categoryCode = Const.Categories[index]["code"]!
            self.filterCategories[index] = categoryCode
        } else {
            self.filterCategories[index] = nil
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
    
    // ------------------ do the actual search
    
    func doSearch(callback:([Business], error: NSError?) -> Void) {
        
        let categories = self.getFilterCategories() as? [String]
        let deals = self.getFilterDeals()
        let distance = self.getFilterDistance()
        let offset = self.getResultOffset()
        let term = "Restaurants"
        
        // TODO -- implement sort
        // let sort = self.state.getSortBy()
        
        Business.searchWithTerm(
            term,
            sort: nil,
            categories: categories,
            deals: deals,
            distance: distance,
            offset: offset
            ) { (business, error) -> Void in
                callback(business, error: error)
        }
    }
    
    // ------------------
    
    func setOpen(section: Int) {
        print("section open", section)
        self.openSections[section] = true
    }
    
    func setClosed(section: Int) {
        print("section  closed", section)
        self.openSections[section] = false
    }
    
    func getOpen(section: Int) -> Bool {
        print("trying to get dropped for section ", section)
        print(self.openSections)
        return self.openSections[section] ?? false
    }
    
}