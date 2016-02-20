//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let ESTIMATE_ROW_HEIGHT: CGFloat = 120.0
    
    var previousSearch = ""
    var state: YelpState!
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
    
    // ------------------------------------------ view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = YelpState()
        
        self.setupNavBar()
        self.setupTable()
    
        Business.searchWithTerm(
            "Restaurants",
            sort: nil,
            categories: nil,
            deals: nil,
            distance: nil) { (business, error) -> Void in
                self.businesses = business
                self.tableView.reloadData()
        }
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
        
        let categories = self.state?.getFilterCategories() as? [String]
        let deals = self.state.getFilterDeals()
        let distance = self.state.getFilterDistance()
        
        Business.searchWithTerm(
            "Restaurants",
            sort: nil,
            categories: categories,
            deals: deals,
            distance: distance) { (business, error) -> Void in
                self.businesses = business
                self.tableView.reloadData()
        }
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
//        self.searchData(searchBar.text)
    }
    
    //-------------------------------------------- search
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
//        self.searchData(searchBar.text)
    }
    
    //-------------------------------------------- searc text change
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        self.searchData(searchBar.text)
    }
    
}
