//
//  CheckBoxCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol CheckBoxCellDelegate {
    optional func checkBoxCell(checkBoxCell: CheckBoxCell, didChangeValue checked: Bool)
}

class CheckBoxCell: UITableViewCell {

    @IBOutlet weak var checkBoxLabel: UILabel!
    @IBOutlet weak var checkBox: CheckDesuView!
    
    weak var delegate: CheckBoxCellDelegate?
    var checked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.checkBox.addValueChangeCallback(self.checkBoxValueChanged)
    }

    func checkBoxValueChanged() {
        self.checked = self.checkBox.checked
        delegate?.checkBoxCell?(self, didChangeValue: self.checked)
    }
}
