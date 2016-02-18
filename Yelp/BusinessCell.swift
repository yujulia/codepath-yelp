//
//  BusinessCell.swift
//  Yelp
//
//  Created by Julia Yu on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var row: Int! {
        didSet {
            if let row = self.row, bname = business.name {
                nameLabel.text = "\(row + 1). \(bname)"
            }
        }
    }
    
    var business: Business! {
        didSet {
            
            if let imageURL = self.business.imageURL {
                self.thumbImageView.setImageWithURL(imageURL)
            }
            
            if let imageURL = self.business.ratingImageURL {
                self.ratingImageView.setImageWithURL(imageURL)
            }
            
            if let distance = self.business.distance {
                self.distanceLabel.text = distance
            }
            
            if let count = self.business.reviewCount {
                self.reviewCountLabel.text = "\(count) Reviews"
            }
            
            if let address = self.business.address {
                addressLabel.text = address
            }
            
            if let cat = self.business.categories {
                categoryLabel.text = cat
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.thumbImageView.layer.cornerRadius = 3
        self.thumbImageView.clipsToBounds = true
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
