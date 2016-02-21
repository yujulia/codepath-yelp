//
//  DropCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// cell prototype

@objc protocol DropCellDelegate {
    optional func dropCell(dropCell: DropCell, didTap dropped: Bool)
}

class DropCell: UITableViewCell {

    @IBOutlet weak var selecteLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!

    var dropped = false
    
    weak var delegate: DropCellDelegate?
    
    // ------------------------------------------ 
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func onArrowTap(sender: AnyObject) {
        self.dropped = !self.dropped
        delegate?.dropCell?(self, didTap: self.dropped)
    }
}
