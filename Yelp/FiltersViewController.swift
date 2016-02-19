//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Julia Yu on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(
        filtersViewController: FiltersViewController,
        didUpdateFilters filters: [String:AnyObject]
    )
}


class FiltersViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.categories = Helpers.getCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onCancelFilters(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearch(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String:AnyObject]()
        var selectedCat = [String]()
        
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCat.append(self.categories[row]["code"]!)
            }
        }
        
        if selectedCat.count > 0 {
            filters["categories"] = selectedCat
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
}

// ---------------------------- SwitchCell delegate

extension FiltersViewController: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        self.switchStates[indexPath.row] = value
        
    }
}

// ---------------------------- table delegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let cat = self.categories {
            return cat.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        cell.switchLabel.text = self.categories[indexPath.row]["name"]
        cell.delegate = self
        cell.onSwitch.on = switchStates[indexPath.row] ?? false
        
        return cell
    }
}
