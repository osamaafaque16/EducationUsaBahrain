//
//  Enums.swift
//  Versole
//
//  Created by Soomro Shahid on 2/21/16.
//  Copyright © 2016 Muzamil Hassan. All rights reserved.
//

import Foundation
import UIKit

enum Controllers {
    case Splash
    case SignIn
    case SignUp
    case ForgotPassword
    case VerifyCode
    case Home
    case Events
    case EventDetail
    case EducationGuide
    case Profile
    case Settings
    case Notification
    case TermsAndCondition
    case ChangePassword
    case ResetPasssword
    case FAQS
    case ContactUs
    case EditProfile
    case About
}


enum AppStoryboard : String {
    
    //Add all the storyboard names you wanted to use in your project
    case UserModule//Main, LoginModule, Homuzamme, Settings, ChatModule, Discover, ProfileModule,SearchSegmentModule
    
    var instance : UIStoryboard {
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
//    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
//        
//        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
//        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
//            
//            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
//        }
//        
//        return scene
//    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
}
