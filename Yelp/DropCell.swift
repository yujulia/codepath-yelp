//
//  DropCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DropCell: UITableViewCell {


    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var downImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.BGView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.BGView.layer.borderWidth = 1

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
