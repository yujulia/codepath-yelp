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
    @IBOutlet weak var myCoolSwitch: CoolSwitchView!
    
    weak var delegate: SwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.myCoolSwitch.addValueChangeCallback(self.coolSwitchValueChanged)
    }
    
    func coolSwitchValueChanged() {
        print("cool switch value changed", switchLabel.text);
        delegate?.switchCell?(self, didChangeValue: self.myCoolSwitch.on)
    }
    
}

