//
//  SliderCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SliderCellDelegate {
    optional func sliderCell(sliderCell: SliderCell, didChangeValue value: Bool)
}

class SliderCell: UITableViewCell {
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    
    weak var delegate: SliderCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.slider.addTarget(
            self,
            action: "sliderValueChanged",
            forControlEvents: UIControlEvents.ValueChanged
        )
    }
    
    func sliderValueChanged() {
        print("slider value changed", slider.value)
//        delegate?.sliderCell?(self, didChangeValue: self.onSwitch.on)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
