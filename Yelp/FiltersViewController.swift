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
    var filterSections: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.categories = Helpers.getCategories()
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
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
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
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
   

        switch indexPath.section {
        case 3:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
            cell.switchLabel.text = self.categories[indexPath.row]["name"]
            cell.delegate = self
            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            
            return cell
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            
//            cell.switchLabel.text = self.categories[indexPath.row]["name"]
//            cell.delegate = self
//            cell.onSwitch.on = switchStates[indexPath.row] ?? false
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! SliderCell
            
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! SliderCell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! SliderCell
            
            return cell
        }
        
        
    }
}
