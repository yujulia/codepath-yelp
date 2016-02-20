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
    
    var previousSearch = ""
    var state: YelpState!
    var businesses: [Business]!
    
    // ------------------------------------------ add search to navbar
    
    private func setupNavBar() {
        
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundColor = Const.YelpRed
        searchBar.translucent = false
        searchBar.placeholder = "Restaurants"
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
    }
    
    
    // ------------------------------------------ set up current table
    
    private func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // ------------------------------------------ view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = YelpState()
        
        self.setupNavBar()
        self.setupTable()
    
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
        
            // TODO -- append business on infinite scroll
            
            self.businesses = businesses
            self.tableView.reloadData()
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
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
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject]) {
        
        // TODO -- read from self.state not filters
        
        let categories = filters["categories"] as? [String]

        let deals = self.state.getSearchDeals()
        let distance = self.state.getSearchDistance()
        
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
