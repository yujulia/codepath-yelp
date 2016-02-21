//
//  SwitchCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// cell prototype

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
}

// table cell containing a switch

class SwitchCell: UITableViewCell {


    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var myCoolSwitch: CoolSwitchView!
    
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.onSwitch.addTarget(
            self,
            action: "switchValueChanged",
            forControlEvents: UIControlEvents.ValueChanged
        )
        
        self.myCoolSwitch.addValueChangeCallback(self.coolSwitchValueChanged)
    }
    
    func coolSwitchValueChanged() {
        print("cool switch value changed", switchLabel.text);
    }
    
    func switchValueChanged() {
        delegate?.switchCell?(self, didChangeValue: self.onSwitch.on)
    }
}

//extension SwitchCell: CoolSwitchDelegate {
//    
//    func CoolSwitchView(coolSwitchView: UIView, didChangeValue value: Bool) {
//        print("this is switch cell i heard it ", value);
//    }
//    
////    func sliderCell(sliderCell: SliderCell, didChangeValue value: Float) {
////        let indexPath = self.tableView.indexPathForCell(sliderCell)!
////        
////        if indexPath.section == Const.Sections.Distance.rawValue {
////            self.state?.setFilterDistance(value)
////        }
////    }
//}
