//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Julia Yu on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// Filters View Controller Delegate protocol

@objc protocol FiltersViewControllerDelegate {
    
    // ------------------------------------------   did update filters
    
    optional func filtersViewController(
        filtersViewController: FiltersViewController,
        didUpdateFilters ok: Bool
    )
}

// our controller

class FiltersViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    weak var state: YelpState?
    
    let SECTION_HEIGHT: CGFloat = 30.0
    let ESTIMATE_ROW_HEIGHT: CGFloat = 120.0
    
    // ------------------------------------------ set up nav bar colors
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
        let titleDict: Dictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
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
        
        self.setupNavBar()
        self.setupTable()
    }

    // ------------------------------------------ cancel clicked
    
    @IBAction func onCancelFilters(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        self.state?.resetFilters()
        self.delegate?.filtersViewController?(self, didUpdateFilters: true)
    }
    
    // ------------------------------------------ search clicked
    
    @IBAction func onSearch(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.filtersViewController?(self, didUpdateFilters: true)
    }
}

// SwitchCell delegate methods

extension FiltersViewController: SwitchCellDelegate {
    
    // ------------------------------------------ switch cell value changed
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        
        switch indexPath.section {
            
            case Const.Sections.Deals.rawValue:
                self.state?.setFilterDeals(value)
            
            case Const.Sections.Categories.rawValue:
                self.state?.toggleCategory(indexPath.row, on: value)
            
            default:
                print("a switch cell value changed thats should not exist")
        }
    }
}


// SliderCell delegate methods

extension FiltersViewController: SliderCellDelegate {
    
    // ------------------------------------------ some slider cell value changed
    
    func sliderCell(sliderCell: SliderCell, didChangeValue value: Float) {
        let indexPath = self.tableView.indexPathForCell(sliderCell)!
        
        if indexPath.section == Const.Sections.Distance.rawValue {
            self.state?.setFilterDistance(value)
        }
    }
}

// TableView delegate methods

extension FiltersViewController: UITableViewDelegate {
    
    // ------------------------------------------ row selected, deselect
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // ------------------------------------------ return sections count
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Const.FilterSections.count
    }
    
    // ------------------------------------------ return rows in section
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case Const.Sections.Categories.rawValue:
                return Const.Categories.count
            default:
                return 1
        }
    }
    
    // ------------------------------------------ render section header
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // -- return empty header for the first row

        if section == Const.Sections.Deals.rawValue {
            let emptyHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            return emptyHeaderView
        }
        
        // TODO -- manually add auto layout constraints?
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
        headerView.backgroundColor = Const.YelpRed
        
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 30))
        sectionLabel.frame.origin.x = 20
        sectionLabel.frame.origin.y = 0
        sectionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        sectionLabel.textColor = UIColor.whiteColor()
        
        sectionLabel.text = Const.FilterSections[section]

        headerView.addSubview(sectionLabel)
  
        return headerView
    }
    
    // ------------------------------------------ return section header height
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == Const.Sections.Deals.rawValue {
            return 0
        }
        return SECTION_HEIGHT
    }
    
    // ------------------------------------------ return a slider cell for distance
    
    private func returnDistanceCell(tableView: UITableView, indexPath: NSIndexPath) -> SliderCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! SliderCell
        
        // TODO -- do this in the cell
        
        if let miles = self.state?.getFilterDistanceInMiles() {
            cell.sliderLabel.text = String(miles)
        }
        cell.delegate = self
        
        return cell
    }
    
    // ------------------------------------------ return a switch cell for categories
    
    private func returnCategoriesCell(tableView: UITableView, indexPath: NSIndexPath) -> SwitchCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        
        cell.switchLabel.text = Const.Categories[indexPath.row]["name"]

        if self.state?.filterCategories[indexPath.row] != nil {
            cell.onSwitch.on = true
        } else {
            cell.onSwitch.on = false
        }
        cell.delegate = self

        return cell
    }
    
    // ------------------------------------------ return a switch cell for deals
    
    private func returnDealsCell(tableView: UITableView, indexPath: NSIndexPath) -> SwitchCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

        cell.switchLabel.text = "Offering a Deal"
        cell.onSwitch.on = self.state?.getFilterDeals() ?? false
        cell.delegate = self
        
        return cell
    }
    
    // ------------------------------------------ return a drop down cell for sort by
    
    private func returnSortByCell(tableView: UITableView, indexPath: NSIndexPath) -> DropCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DropCell", forIndexPath: indexPath) as! DropCell
        
        return cell
    }

    // ------------------------------------------ return table cell
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!

        switch indexPath.section {

            case Const.Sections.Distance.rawValue:
                cell = self.returnDistanceCell(tableView, indexPath: indexPath)

            case Const.Sections.Categories.rawValue:
                cell = self.returnCategoriesCell(tableView, indexPath: indexPath)
                
            case Const.Sections.Deals.rawValue:
                cell = self.returnDealsCell(tableView, indexPath: indexPath)
                
            case Const.Sections.Sortby.rawValue:
                cell = self.returnSortByCell(tableView, indexPath: indexPath)
            
            default:
                cell = UITableViewCell()
        }

        
        return cell
    
    }
}
