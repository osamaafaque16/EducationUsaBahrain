//
//  BaseNavigationController.swift
//  Versole
//
//  Created by Soomro Shahid on 2/20/16.
//  Copyright © 2016 Muzamil Hassan. All rights reserved.
//

import UIKit
//import Hero

class BaseNavigationController: UINavigationController {
    
    var isInternal = false

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = AppConstants.NAV_BAR_COLOR
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        //self.navigationBar.isTranslucent = false
        
        //heroNavigationAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        
        //Hero.shared.setContainerColorForNextTransition(AppConstants.NAV_BAR_COLOR)
    }
    

    
    
    override func viewWillAppear(_ animated: Bool)    {
        super.viewWillAppear(true)
        
    }
    func test() {

//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close:")
//        this.na
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
//        style:UIBarButtonItemStyleBordered
//        target:self
//        action:@selector(close:)];
        
    }
}


