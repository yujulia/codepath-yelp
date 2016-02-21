//
//  DetailViewController.swift
//  Yelp
//
//  Created by Julia Yu on 2/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var restaurant: Business? {
        didSet {
            print("got info about business")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
