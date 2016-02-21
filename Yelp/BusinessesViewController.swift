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
    let refreshControl = UIRefreshControl()
    
    var hud: MBProgressHUD? {
        didSet {
            self.setupCustomHUD()
        }
    }
    
    var loading = false
    var filtering = false
    var previousSearch: String?
    var state: YelpState!
    var allBusinesses: [Business]!
    var businesses: [Business]!
    
    
    // ------------------------------------------ toggle HUD, set/release locks
    
    private func isLoading() {
        self.loading = true
        self.refreshControl.endRefreshing()
        self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    }
    
    private func notLoading() {
        self.loading = false
        self.refreshControl.endRefreshing()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
    }
    
    // ------------------------------------------ search returned
    
    func searchReturned(business: [Business], error: NSError?) -> Void {

        if business.count != 0 {
            if self.filtering {
                self.allBusinesses = business
                self.filtering = false
            } else {
                var biz = self.allBusinesses
                if self.allBusinesses != nil {
                    biz.appendContentsOf(business)
                } else {
                    biz = business
                }
                self.allBusinesses = biz
            }
        } else {
            self.allBusinesses.removeAll()
        }
        
        self.filterResults(self.previousSearch)
        
        print("response length", business.count)
        // if no results display something
        
        self.notLoading()
    }
    
    // ------------------------------------------ perform the search
    
    private func searchWithFilters() {
        
        if self.loading {
            return
        }
        
        self.isLoading()
        self.state.doSearch(self.searchReturned)
    }
    
    // ------------------------------------------ set up refresh control
    
    private func setupRefresh() {
        self.refreshControl.tintColor = UIColor.blackColor()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
    }
    
    //-------------------------------------------- pull to refresh load data
    
    func refresh(refreshControl: UIRefreshControl) {
        self.searchWithFilters()
    }
    
    //-------------------------------------------- add custom spinner to the hud
    
    private func setupCustomHUD() {
        
        var imgListArray = [UIImage]()
        let testimage = UIImage(named: "red1")
        let spinner = UIImageView(image: testimage)
        
        for countValue in 1...12
        {
            let strImageName: String = "red\(countValue)"
            let image  = UIImage(named:strImageName)
            imgListArray.append(image!)
        }
        
        spinner.animationImages = imgListArray
        spinner.animationDuration = 1.0
        spinner.startAnimating()
        
        self.hud?.mode = .CustomView
        self.hud?.customView = spinner
        self.hud?.color = Const.YelpRed
    }
    
    // ------------------------------------------ view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = YelpState()
        
        self.setupSearchBar()
        self.setupTable()
        self.setupRefresh()
        
        self.searchWithFilters()
    }
    
    // ------------------------------------------ prepare for segue

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toFilterSegue" {
            let navController = segue.destinationViewController as! UINavigationController
            let filterViewController = navController.topViewController as! FiltersViewController
            
            filterViewController.delegate = self
            filterViewController.state = self.state
        }
        
        if segue.identifier == "toDetailSegue" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            
            detailViewController.business = self.businesses[indexPath!.row]
        }
    }
}

// filtersViewController delegate methods

extension BusinessesViewController: FiltersViewControllerDelegate {
    
    // ------------------------------------------ did update filters
    
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters ok: Bool) {
        self.filtering = true
        self.state.setResultOffset(0) // fresh search
        self.searchWithFilters()
    }
}

// tableview delegate methods

extension BusinessesViewController: UITableViewDelegate {
    
    // ------------------------------------------ set up current table
    
    private func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = ESTIMATE_ROW_HEIGHT
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
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
        
        if indexPath.row >= self.allBusinesses.count-1 {
            self.state.setResultOffset(self.allBusinesses.count)
            self.searchWithFilters()
        }
        
        return cell
    }
}

// Search delegate

extension BusinessesViewController: UISearchBarDelegate {
    
    // ------------------------------------------ add search to navbar
    
    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
        self.navigationController?.navigationBar.translucent = false
    }
    
    // ------------------------------------------ search the current result set
    
    func filterResults(searchTerm: String?){
        
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
    
    //-------------------------------------------- search begin edit
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    //-------------------------------------------- search end edit
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    //-------------------------------------------- search cancel
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.filterResults(searchBar.text)
    }
    
    //-------------------------------------------- search enter
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.filterResults(searchBar.text)
    }
    
    //-------------------------------------------- searc text change
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterResults(searchBar.text)
    }
    
}
