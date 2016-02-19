//
//  PickerCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol PickerCellDelegate {
    optional func pickerCell(pickerCell: PickerCell, didChangeValue value: Bool)
}

class PickerCell: UITableViewCell {

    @IBOutlet weak var pickerLabel: UILabel!
    @IBOutlet weak var pickerPicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func sliderValueChanged() {
//        print("slider value changed", slider.value)
        //        delegate?.sliderCell?(self, didChangeValue: self.onSwitch.on)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
