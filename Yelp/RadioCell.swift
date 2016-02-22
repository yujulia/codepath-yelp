//
//  RadioCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol RadioCellDelegate {
    optional func radioCell(radioCell: RadioCell, didChangeValue on: Bool)
}

class RadioCell: UITableViewCell {

    @IBOutlet weak var radioView: RadioView!
    @IBOutlet weak var radioLabel: UILabel!
    
    weak var delegate: RadioCellDelegate?
    var on: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.radioView.addValueChangeCallback(self.radioValueChanged)
    }

    func turnOff() {
        self.radioView.setToOff()
    }
    
    func turnOn() {
        self.radioView.setToOn()
    }
    
    func radioValueChanged() {
        self.on = self.radioView.on
        self.delegate?.radioCell?(self, didChangeValue: self.on)
    }
}
