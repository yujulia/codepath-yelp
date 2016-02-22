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
    
    let SECTION_HEIGHT: CGFloat = 30.0
    let ESTIMATE_ROW_HEIGHT: CGFloat = 120.0
    let CAT_ROW_LIMIT: Int = 5
    
    weak var delegate: FiltersViewControllerDelegate?
    weak var state: YelpState?
    var categoryExpanded = false
    var removing = false
    
    // ------------------------------------------ set up nav bar colors
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.barTintColor = Const.YelpRed
        let titleDict: Dictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationBar.translucent = false
    }
    
    // ------------------------------------------ view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavBar()
        self.setupTable()
        
        // if we have less than limit nothing to expand
        if Const.Categories.count <= CAT_ROW_LIMIT {
            self.categoryExpanded = true
        }
        
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

// Checkbox delegate
extension FiltersViewController: CheckBoxCellDelegate {
    
    // ------------------------------------------ switch cell value changed
    
    func checkBoxCell(checkBoxCell: CheckBoxCell, didChangeValue checked: Bool) {
        let indexPath = self.tableView.indexPathForCell(checkBoxCell)!
        
        switch indexPath.section {
            
        case Const.Sections.Deals.rawValue:
            self.state?.setFilterDeals(checked)
            
        case Const.Sections.Categories.rawValue:
            self.state?.toggleFilterCategory(indexPath.row, on: checked)
            
        default:
            print("a check cell value changed thats should not exist")
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

// ExpandCell delegate methods
extension FiltersViewController: ExpandCellDelegate {
    
    private func updateSortRows(deletePaths: [NSIndexPath], insertPaths: [NSIndexPath]) {
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths(deletePaths, withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView.insertRowsAtIndexPaths(insertPaths, withRowAnimation: UITableViewRowAnimation.Top)
        self.tableView.endUpdates()
    }
    
    // ------------------------------------------ expand cell value changed
    
    func expandCell(expandCell: ExpandCell, didChangeValue open: Bool) {
        let indexPath = self.tableView.indexPathForCell(expandCell)!
        if open {
            self.state?.setOpenForSection(indexPath.section)
            self.updateSortRows(Const.SortPlaceholderIndexPath, insertPaths: Const.SortIndexPath)
        }
    }
}

// RadioCell delegate methods
extension FiltersViewController: RadioCellDelegate {
    
    // ------------------------------------------ radio value changed
    
    func radioCell(radioCell: RadioCell, didChangeValue on: Bool) {
        let indexPath = self.tableView.indexPathForCell(radioCell)!
        
        self.state?.setSelectedRadioForSection(indexPath)
        
        if let expandCell = self.state?.getExpandCellFromSection(indexPath.section) {
            expandCell.setToClosed()
            expandCell.expandLabel.text = radioCell.radioLabel.text
            
            self.state?.setClosedForSection(indexPath.section)
            self.updateSortRows(Const.SortIndexPath, insertPaths: Const.SortPlaceholderIndexPath)
        }
    }
}

// LoadMoreCell delegae methods 
extension FiltersViewController: LoadMoreCellDelegate {
    
    // ------------------------------------------ load more clicked
    
    func loadMoreCell(loadMoreCell: LoadMoreCell, didChangeValue expanded: Bool) {
        let indexPath = self.tableView.indexPathForCell(loadMoreCell)!
        
        self.categoryExpanded = true
        self.reloadSection(indexPath.section, animation: UITableViewRowAnimation.Bottom)
    }
    
}

// TableView delegate methods
extension FiltersViewController: UITableViewDelegate {
    
    // ------------------------------------------ set up current table
    
    private func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = ESTIMATE_ROW_HEIGHT
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
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
                if self.categoryExpanded {
                    return Const.Categories.count
                } else {
                    return CAT_ROW_LIMIT + 1
                }
            
            case Const.Sections.Sortby.rawValue:
                let open = self.state?.getStatusForSection(section)
                if open! {
                    return Const.SortOptions.count
                }
                return 1
            
            default:
                return 1
        }
    }
    
    // ------------------------------------------ render section header
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // -- return empty header for the first row

        if section == Const.Sections.Deals.rawValue {
            let emptyHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            emptyHeaderView.backgroundColor = Const.YelpRed
            return emptyHeaderView
        }
        
        // TODO -- manually add auto layout constraints?
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
        headerView.backgroundColor = Const.YelpRed
        
        let sectionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 280, height: 30))
        sectionLabel.frame.origin.x = 20
        sectionLabel.frame.origin.y = 0
        sectionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        sectionLabel.textColor = UIColor.whiteColor()
        
        sectionLabel.text = Const.FilterSections[section]

        headerView.addSubview(sectionLabel)
  
        return headerView
    }
    
    // ------------------------------------------ return section header height
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == Const.Sections.Deals.rawValue {
            return 0.1
        }
        return SECTION_HEIGHT
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    // ------------------------------------------ return a slider cell for distance
    
    private func returnDistanceCell(tableView: UITableView, indexPath: NSIndexPath) -> SliderCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as! SliderCell
        
        if let miles = self.state?.getFilterDistanceInMiles() {
            cell.sliderLabel.text = String(miles)
        }
        cell.delegate = self
        
        return cell
    }
    
    // ------------------------------------------ return a checkbox cell for categories
    
    private func returnCategoriesCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.categoryExpanded || indexPath.row < CAT_ROW_LIMIT {
            let cell = tableView.dequeueReusableCellWithIdentifier("CheckBoxCell", forIndexPath: indexPath) as! CheckBoxCell
            cell.checkBoxLabel.text = Const.Categories[indexPath.row]["name"]
            
            if self.state?.filterCategories[indexPath.row] != nil {
                cell.checkBox.setToChecked()
            } else {
                cell.checkBox.setToUnchecked()
            }
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("LoadMoreCell", forIndexPath: indexPath) as! LoadMoreCell
            
            cell.delegate = self
            
            return cell
        }
    }
    
    // ------------------------------------------ return a checkbox cell for deals
    
    private func returnDealsCell(tableView: UITableView, indexPath: NSIndexPath) -> CheckBoxCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckBoxCell", forIndexPath: indexPath) as! CheckBoxCell

        cell.checkBoxLabel.text = "Offering a Deal"
        
        if self.state?.getFilterDeals() != nil {
            cell.checkBox.setToChecked()
        } else {
            cell.checkBox.setToUnchecked()
        }
        
        cell.delegate = self
        
        return cell
    }
    
    // ------------------------------------------ return expand or radio cells for sort by
    
    private func returnSortByCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        if let open = self.state?.getStatusForSection(indexPath.section) {
            if open {
                let cell = tableView.dequeueReusableCellWithIdentifier("RadioCell", forIndexPath: indexPath) as! RadioCell
                cell.delegate = self
                cell.radioLabel.text = Const.SortOptions[indexPath.row]
                cell.turnOff()
                if let selected = self.state?.getSelectedRadioForSection(indexPath.section) {
                    if selected == indexPath.row {
                        cell.turnOn()
                    }
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("ExpandCell", forIndexPath: indexPath) as! ExpandCell
                cell.delegate = self
                self.state?.saveExpandCellInSection(indexPath.section, cell: cell)
                
                return cell
            }
        }
        
        return UITableViewCell()
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
    
    // ------------------------------------------ reload a section
    
    private func reloadSection(section: Int, animation: UITableViewRowAnimation) {
        self.tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: animation)
    }

}
