//
//  RadioView.swift
//  Yelp
//
//  Created by Julia Yu on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class RadioView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var filledCircleImage: UIImageView!
    @IBOutlet weak var emptyCircleImage: UIImageView!
    
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
        let nib = UINib(nibName: "Radio", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        self.setToOff()
    }
    
    // ------------------------------------------ tapped

    @IBAction func onTap(sender: AnyObject) {
        self.toggle()
    }
    
    // ------------------------------------------ set the alpha and value
    
    func setToOff() {
        self.emptyCircleImage.alpha = 1
        self.filledCircleImage.alpha = 0
        self.on = false
    }
    
    func setToOn() {
        self.emptyCircleImage.alpha = 0
        self.filledCircleImage.alpha = 1
        self.on = true
    }
    
    // ------------------------------------------ animate to on state
    
    func turnOn() {
        UIView.animateWithDuration(0.3,
            animations:  {() in
                self.setToOn()
            }
        )
    }
    
    // ------------------------------------------ animate to off state
    
    func turnOff() {
        UIView.animateWithDuration(0.3,
            animations:  {() in
                self.setToOff()
            }
        )
    }
    
    // ------------------------------------------ toggle the checkbox
    
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

}
