//
//  CheckBoxCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class CheckBoxCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}



//@objc protocol SwitchCellDelegate {
//    optional func switchCell(switchCell: SwitchCell, didChangeValue value: Bool)
//}
//
//// table cell containing a switch
//
//class SwitchCell: UITableViewCell {
//    
//    
//    @IBOutlet weak var switchLabel: UILabel!
//    
//    @IBOutlet weak var checkBox: CheckDesuView!
//    
//    
//    weak var delegate: SwitchCellDelegate?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        self.checkBox.addValueChangeCallback(self.checkBoxValueChanged)
//    }
//    
//    func checkBoxValueChanged() {
//        print("check value changed", switchLabel.text);
//        delegate?.switchCell?(self, didChangeValue: self.checkBox.checked)
//    }
//    
//}