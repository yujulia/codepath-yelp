//
//  LoadMoreCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol LoadMoreCellDelegate {
    optional func loadMoreCell(loadMoreCell: LoadMoreCell, didChangeValue expanded: Bool)
}

class LoadMoreCell: UITableViewCell {
    
    weak var delegate: LoadMoreCellDelegate?
    var expanded: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func loadMoreClicked(sender: AnyObject) {
        self.expanded = true
        self.delegate?.loadMoreCell?(self, didChangeValue: self.expanded)
    }
}
