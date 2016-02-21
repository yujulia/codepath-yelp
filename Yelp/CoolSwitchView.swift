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
    
    var changeCallback: (()->Void)?
    
    var on: Bool = false
    
    // ------------------------------------------ defaults
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    // ------------------------------------------ init that matters
    
    func initSubViews(){
        
        // stuff 
        
        let nib = UINib(nibName: "CoolSwitch", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        // my stuff
        
        self.setToOff()
    }
    
    func setToOff() {
        self.fullImage.alpha = 0
        self.emptyImage.alpha = 1
        self.on = false
    }
    
    func setToOn() {
        self.fullImage.alpha = 1
        self.emptyImage.alpha = 0
        self.on = true
    }
    
    // ------------------------------------------ show on state
    
    func turnOn() {
        UIView.animateWithDuration(0.3,
            animations:  {() in
                self.setToOn()
            }
        )
    }
    
    // ------------------------------------------ show off state
    
    func turnOff() {
        UIView.animateWithDuration(0.3,
            animations:  {() in
                self.setToOff()
            }
        )
    }
    
    // ------------------------------------------ toggle the switch
    
    func toggle() {
        if self.on {
            self.turnOff()
        } else {
            self.turnOn()
        }
        self.changeCallback?()
    }
    
    // ------------------------------------------ such hack much wow?
    
    func addValueChangeCallback(callback: ()-> Void) {
        self.changeCallback = callback
    }
    
    // ------------------------------------------ toggle on click
    
    @IBAction func onTap(sender: AnyObject) {
        self.toggle()
    }
}
