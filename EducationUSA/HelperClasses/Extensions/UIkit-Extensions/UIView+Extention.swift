//
//  UIView+Extention.swift
//  MediaVoir
//
//  Created by Soomro Shahid on 11/21/16.
//  Copyright © 2016 OutreachGlobal. All rights reserved.
//

import UIKit

extension UIView {
    
    
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    
    func SetViewCurve()  {
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }
    
    
}
