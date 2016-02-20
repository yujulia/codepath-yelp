//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let ESTIMATE_ROW_HEIGHT: CGFloat = 120.0
    
    var previousSearch: String?
    var state: YelpState!
    
    var allBusinesses: [Business]!
    var businesses: [Business]!
    
    // ------------------------------------------ add search to navbar
    
    private func setupNavBar() {
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
    }
    
    // ------------------------------------------ set up current table
    
    private func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = ESTIMATE_ROW_HEIGHT
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // ------------------------------------------ perform the search
    
    private func searchWithFilters() {
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let categories = self.state?.getFilterCategories() as? [String]
        let deals = self.state.getFilterDeals()
        let distance = self.state.getFilterDistance()
        
        // TODO -- implement sort
        // let sort = self.state.getSortBy()
        
        Business.searchWithTerm(
            "Restaurants",
            sort: nil,
            categories: categories,
            deals: deals,
            distance: distance) { (business, error) -> Void in
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                
                self.allBusinesses = business
                self.applySearch(self.previousSearch)
                
        }
    }
    
    // ------------------------------------------ view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = YelpState()
        self.setupNavBar()
        self.setupTable()
        self.searchWithFilters()
    }
    
    // ------------------------------------------ prepare for segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let navController = segue.destinationViewController as! UINavigationController
        let filterViewController = navController.topViewController as! FiltersViewController
        
        filterViewController.delegate = self
        filterViewController.state = self.state
    }
}

// filtersViewController delegate methods

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    // ------------------------------------------ did update filters
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters ok: Bool) {
        self.searchWithFilters()
    }
}

// tableview delegate methods

extension BusinessesViewController: UITableViewDelegate {
    
    // ------------------------------------------ return business count
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = self.businesses {
            return businesses.count
        } else {
            return 0
        }
    }
    
    // ------------------------------------------ return business cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = self.businesses[indexPath.row]
        cell.row = indexPath.row
        
        return cell
    }
    
}

// search delegate methods

extension BusinessesViewController: UISearchBarDelegate {
    
    // ------------------------------------------ search the current result set
    
    func applySearch(searchTerm: String?){
        
        print("trying to search ", searchTerm)
        
        if searchTerm == nil {
            self.previousSearch = ""
        } else {
            self.previousSearch = searchTerm?.lowercaseString
        }
        
        self.businesses = self.allBusinesses
        
        if self.previousSearch != "" {
            self.businesses = self.businesses.filter({
                $0.name?.lowercaseString.rangeOfString(self.previousSearch!) != nil
            })
        }
        
        self.tableView.reloadData()
    }
    
    //-------------------------------------------- search begin
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    //-------------------------------------------- search end
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    //-------------------------------------------- search cancel
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.applySearch(searchBar.text)
    }
    
    //-------------------------------------------- search
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.applySearch(searchBar.text)
    }
    
    //-------------------------------------------- searc text change
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.applySearch(searchBar.text)
    }
    
}
