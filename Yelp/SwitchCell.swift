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
    @IBOutlet weak var CoolSwitch: CoolSwitchView!
    
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.onSwitch.addTarget(
            self,
            action: "switchValueChanged",
            forControlEvents: UIControlEvents.ValueChanged
        )
        
        self.CoolSwitch.turnOff()
        
//        self.CoolSwitch.addTarget(
//            self,
//            action: "coolSwitchClicked",
//            forControlEvents:
//                UIControlEvents.TouchUpInside
//        )
    }
    
    func coolSwitchClicked() {
        print("i clicked it")
    }
    
    func switchValueChanged() {
        delegate?.switchCell?(self, didChangeValue: self.onSwitch.on)
    }


}
