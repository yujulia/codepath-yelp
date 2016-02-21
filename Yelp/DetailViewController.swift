//
//  DetailViewController.swift
//  Yelp
//
//  Created by Julia Yu on 2/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailName: UILabel!
    @IBOutlet weak var detailRating: UIImageView!
    @IBOutlet weak var detailDistance: UILabel!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailCategories: UILabel!
    @IBOutlet weak var detailReviewCount: UILabel!
    
    var business: Business? {
        didSet {

//            if let business = self.business {
//                
//                if let url = business.imageURL {
//                    print("wtf is this img url", url)
//                    print(self.detailImage)
//                    
////                    self.detailImage.setImageWithURL(url)
//                }
//                
//            }
            
//            if let imageURL = self.business?.imageURL {
//                self.detailImage.setImageWithURL(imageURL)
//            }
//            
//            if let imageURL = self.business?.ratingImageURL {
//                self.detailRating.setImageWithURL(imageURL)
//            }
//            
//            if let distance = self.business?.distance {
//                self.detailDistance.text = distance
//            }
//            
//            if let count = self.business?.reviewCount {
//                self.detailReviewCount.text = "\(count) Reviews"
//            }
//            
//            if let address = self.business?.address {
//                self.detailAddress.text = address
//            }
//            
//            if let cat = self.business?.categories {
//                self.detailCategories.text = cat
//            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height*1.6)
        
        if let biz = self.business {
            if let url = biz.imageURL {
                
                var stringURL = String(url)
                stringURL = stringURL.stringByReplacingOccurrencesOfString("ms.jpg", withString: "o.jpg")
                let newURL = NSURL(string: stringURL)
              
                self.detailImage.setImageWithURL(newURL!)
            }
            
        }
        
        

        // Do any additional setup after loading the view.
    }

}
