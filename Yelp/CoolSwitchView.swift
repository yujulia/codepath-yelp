//
//  CoolSwitchView.swift
//  Yelp
//
//  Created by Julia Yu on 2/20/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class CoolSwitchView: UIView {


    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet var contentView: UIView!
    
    var on = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    func initSubViews(){
        
        let nib = UINib(nibName: "CoolSwitch", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        self.fullImage.alpha = 0
        self.emptyImage.alpha = 1
    }
    
    func turnOn() {
        print("turn on")
        UIView.animateWithDuration(0.6,
            animations:  {() in
                self.fullImage.alpha = 1
                self.emptyImage.alpha = 0
            }
        )
        self.on = true
    }
    
    func turnOff() {
        print("turn off")
        UIView.animateWithDuration(2,
            animations:  {() in
                self.fullImage.alpha = 0
                self.emptyImage.alpha = 1
            }
        )
        self.on = false
    }
    
    @IBAction func onTap(sender: AnyObject) {
        print("its tapped");
    }
}
