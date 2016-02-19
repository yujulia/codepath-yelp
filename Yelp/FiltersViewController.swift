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
    
    var filters = [String:AnyObject]()
    var categories: [[String:String]]!
    
    var dealStates = [Int:Bool]()
    var catStates = [Int:Bool]()
    
    var filterSections: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.categories = Helpers.Categories
        self.filterSections = Helpers.FilterSections
        
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
        
        // ----------- check deals
        
        if let hasDeal = dealStates[0] {
            if hasDeal {
                filters["deals"] = true
            } else {
                filters["deals"] = false
            }
        }
    
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
        
    }
}

// ---------------------------- SwitchCell delegate

extension FiltersViewController: SwitchCellDelegate {
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        
        if indexPath.section == 0 {
            self.dealStates[indexPath.row] = value
        }
        if indexPath.section == 3 {
            self.catStates[indexPath.row] = value
        }
        
    }
}


// ---------------------------- SliderCell delegate

extension FiltersViewController: SliderCellDelegate {
    
    func sliderCell(sliderCell: SliderCell, didChangeValue value: Float) {
        print("filters heard slider change", value)
        
//         let indexPath = self.tableView.indexPathForCell(sliderCell)!
        
        // inform search i guess?
        
    }
}

// ---------------------------- table delegate

extension FiltersViewController: UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.filterSections.count
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
        headerView.backgroundColor = UIColor.lightGrayColor()
        
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 30))
        sectionLabel.frame.origin.x = 20
        sectionLabel.frame.origin.y = 0
        sectionLabel.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        sectionLabel.textColor = UIColor.whiteColor()
        sectionLabel.text = self.filterSections?[section]

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
            
            cell.sliderLabel.text = "Within \(cell.slider.value) Miles"
            cell.delegate = self
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SegmentCell", forIndexPath: indexPath) as! SegmentCell
            
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
            
            cell.onSwitch.on = dealStates[indexPath.row] ?? false
            
            return cell

        }
    
    }
}
