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
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var previousSearch = ""
    var state: YelpState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = YelpState()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.backgroundColor = Const.YelpRed
        searchBar.translucent = false
        searchBar.placeholder = "Restaurants"
        self.navigationItem.titleView = searchBar
        
        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navController = segue.destinationViewController as! UINavigationController
        let filterViewController = navController.topViewController as! FiltersViewController
        
        filterViewController.delegate = self
        filterViewController.state = self.state
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject]) {
        
        let categories = filters["categories"] as? [String]

        let deals = self.state.getDeals()
        let distance = self.state.getDistance()
        
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

extension BusinessesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = self.businesses {
            return businesses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = self.businesses[indexPath.row]
        cell.row = indexPath.row
        
        return cell
    }
    
}

// Search bar delegate methods

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
