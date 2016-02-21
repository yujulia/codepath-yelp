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
    @IBOutlet weak var detailReviewImage: UILabel!
    @IBOutlet weak var detailDistance: UILabel!
    @IBOutlet weak var detailAddress: UILabel!
    @IBOutlet weak var detailCategories: UILabel!
    
    var business: Business? {
        didSet {
            print("got info about business")
            
            print(business)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
