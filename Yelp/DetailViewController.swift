//
//  DetailViewController.swift
//  Yelp
//
//  Created by Julia Yu on 2/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailRating: UIImageView!
    @IBOutlet weak var detailDistance: UILabel!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailCategories: UILabel!
    @IBOutlet weak var detailReviewCount: UILabel!
    
    var business: Business?
    
    func detailImageLoaded() {
        UIView.animateWithDuration(0.6,
            animations:  {() in
                self.detailImage.alpha = 1
            }
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let biz = self.business {
            
            if let url = biz.imageURL {
                var stringURL = String(url)
                stringURL = stringURL.stringByReplacingOccurrencesOfString("ms.jpg", withString: "o.jpg")
                detailImage.alpha = 0
                ImageLoader.loadImage(stringURL, imageview: self.detailImage, callback: detailImageLoaded)
            }
            
            if let name = biz.name {
                self.detailName.text = name
            }
            
            if let ratingUrl = biz.ratingImageURL {
                self.detailRating.setImageWithURL(ratingUrl)
            }

            if let distance = biz.distance {
                self.detailDistance.text = distance
            }

            if let count = biz.reviewCount {
                self.detailReviewCount.text = "\(count) Reviews"
            }

            if let address = biz.address {
                self.detailAddress.text = address
            }

            if let cat = biz.categories {
                self.detailCategories.text = cat
            }
        }
    }

}
