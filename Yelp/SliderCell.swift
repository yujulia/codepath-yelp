//
//  SliderCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// cell prototype

@objc protocol SliderCellDelegate {
    optional func sliderCell(sliderCell: SliderCell, didChangeValue value: Float)
}

// slider table cell

class SliderCell: UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var afterLabel: UILabel!
    @IBOutlet weak var beforeLabel: UILabel!
    
    weak var delegate: SliderCellDelegate?

    // ------------------------------------------ 
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.slider.addTarget(
            self,
            action: "sliderValueChanged",
            forControlEvents: UIControlEvents.ValueChanged
        )
    }
    
    // ------------------------------------------
    
    func sliderValueChanged() {
        self.sliderLabel.text = String(format: "%.2f", self.slider.value)
        delegate?.sliderCell?(self, didChangeValue: self.slider.value)
    }

}
