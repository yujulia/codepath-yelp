//
//  CheckDesuView.swift
//  Yelp
//
//  Created by Julia Yu on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class CheckDesuView: UIView {

    @IBOutlet weak var uncheckedImage: UIImageView!
    @IBOutlet weak var checkedImage: UIImageView!
    @IBOutlet var contentView: UIView!
    
    var changeCallback: (()->Void)?
    var checked: Bool = false
    
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
        let nib = UINib(nibName: "CheckDesu", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        self.setToUnchecked()
    }
    
    // ------------------------------------------ set the alpha and value
    
    func setToUnchecked() {
        self.uncheckedImage.alpha = 1
        self.checkedImage.alpha = 0
        self.checked = false
    }
    
    func setToChecked() {
        self.uncheckedImage.alpha = 0
        self.checkedImage.alpha = 1
        self.checked = true
    }
    
    // ------------------------------------------ animate to on state
    
    func check() {
        UIView.animateWithDuration(0.3,
            animations:  {() in
                self.setToChecked()
            }
        )
    }
    
    // ------------------------------------------ animate to off state
    
    func uncheck() {
        UIView.animateWithDuration(0.3,
            animations:  {() in
                self.setToUnchecked()
            }
        )
    }
    
    // ------------------------------------------ toggle the checkbox
    
    func toggle() {
        if self.checked {
            self.uncheck()
        } else {
            self.check()
        }
        self.changeCallback?()
    }
    
    // ------------------------------------------ such hack much wow?
    
    func addValueChangeCallback(callback: ()-> Void) {
        self.changeCallback = callback
    }
    
    // ------------------------------------------ area tap
    
    @IBAction func onTap(sender: AnyObject) {
        self.toggle()
    }
    
}
