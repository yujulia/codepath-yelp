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
    weak var state: YelpState?
    
    var filters = [String:AnyObject]()
    var categories: [[String:String]]!
    var catStates = [Int:Bool]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
        let titleDict: Dictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict

        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.categories = Const.Categories
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
        
        
        // ------------ check category
        
        var selectedCat = [String]()

        for (row, isSelected) in catStates {
            if isSelected {
                selectedCat.append(self.categories[row]["code"]!)
            }
        }
        
        if selectedCat.count > 0 {
            filters["categories"] = selectedCat
        }
        
        self.delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
}

// ---------------------------- SwitchCell delegate

extension FiltersViewController: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        
        if indexPath.section == 0 {
            self.state?.setDeals(value)
        }
        if indexPath.section == 3 {
            self.catStates[indexPath.row] = value
        }
        
    }
}


// ---------------------------- SliderCell delegate

extension FiltersViewController: SliderCellDelegate {
    
    func sliderCell(sliderCell: SliderCell, didChangeValue value: Float) {

        if let state = self.state {
            state.setDistance(value)
        }
        
    }
}

// ---------------------------- table delegate

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select", indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Const.FilterSections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 3:
                if let cat = self.categories {
                        return cat.count
                    } else {
                        return 0
                }
            case 0,1,2:
                return 1
            default:
                return 0
            
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let emptyHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            return emptyHeaderView
        }
        
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   

        switch indexPath.section {
        
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! SliderCell
            
            if let miles = self.state?.getDistanceInMiles() {
                cell.sliderLabel.text = String(miles)
            }
            cell.delegate = self
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("DropCell", forIndexPath: indexPath) as! DropCell
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            cell.switchLabel.text = self.categories[indexPath.row]["name"]
            cell.delegate = self
            
            cell.onSwitch.on = catStates[indexPath.row] ?? false
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            cell.switchLabel.text = "Offering a Deal"
            cell.delegate = self
            
            cell.onSwitch.on = self.state?.getDeals() ?? false
            
            return cell

        }
    
    }
}
