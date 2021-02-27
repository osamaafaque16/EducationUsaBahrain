//
//  CustomTitleView.swift
//  SocketClient
//
//  Created by Ali Zain Prasla on 2/9/18.
//  Copyright © 2018 Ali Zain Prasla. All rights reserved.
//

import UIKit



extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}

class CustomTitleView: UIView {
    
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblIsTyping:UILabel!
    @IBOutlet weak var constraintRight:NSLayoutConstraint!
    
    
    func configureView(title:String,isTyping:Bool){
        
        lblTitle.text = title
        
        self.lblIsTyping.isHidden = !isTyping

//        UIView.animate(withDuration: 0.2, delay: 0.01, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.lblIsTyping.isHidden = !isTyping
//            self.lblIsTyping.sizeToFit()
//            self.lblTitle.sizeToFit()
//        }, completion: nil)
        
    }
    
    func updateContraint(){
//        let x = self.frame.origin.x
//        constraintRight.constant = x
//        self.layoutSubviews()
    }
}
