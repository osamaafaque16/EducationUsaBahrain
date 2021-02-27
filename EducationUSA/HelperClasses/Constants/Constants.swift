//
//  Constants.swift
//  Template
//
//  Created by Muzamil Hassan on 02/01/2017.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//
import UIKit
import Foundation


struct Global{

    // static var APP_MANAGER                   = AppStateManager.sharedInstance
    // static var APP_REALM                     = APP_MANAGER.realm
    // static var USER                          = APP_MANAGER.loggedInUser
}

struct Constants{
    
      static let STORYBOARD: UIStoryboard    = UIStoryboard(name: "Home", bundle: nil)
    
    static let kFONT_WIDTH_FACTOR           = UIScreen.main.bounds.width / 414 //resize font according to screen size
    
    static let kWINDOW_FRAME                = UIScreen.main.bounds
    static let kSCREEN_SIZE                 = UIScreen.main.bounds.size
    static let kWINDOW_WIDTH                = UIScreen.main.bounds.size.width
    static let kWINDOW_HIEGHT               = UIScreen.main.bounds.size.height
    
    static let APP_DELEGATE                = UIApplication.shared.delegate as! AppDelegate
    static let UIWINDOW                    = UIApplication.shared.delegate!.window!
    
    static let USER_DEFAULTS               = UserDefaults.standard
    
    static let SINGLETON                   = Singleton.sharedInstance
    

    
    
    
    static let THEME_COLOR_LIGHT            = UIColor(red: 117/255.0, green: 210/255.0, blue: 236/255.0, alpha: 0.3)

    
    static let VALIDATION_FIELD_LENGTH                 = 300
    static let VALIDATION_PASSWORD_LENGTH              = 6
    static let VALIDATION_FIELD_LENGTH_QUANTITY        = 6
    static let VALIDATION_FIELD_LENGTH_PRICE           = 9
    
    static let VALIDATION_USERNAME_MIN                 = "Username must not be more than 15 characters and must not contain any space character."
    static let VALIDATION_VALID_NAME                   = "Please provide a valid name."
    static let VALIDATION_VALID_EMAIL                  = "Please provide a valid Email Address."
    static let VALIDATION_VALID_AGE                    = "Kindly provide a valid age."
    static let VALIDATION_NUMERIC_PHONE                = "Phone number must be numeric with at least 11 digits."
    static let VALIDATION_NUMERIC_CELL                 = "Cell number must be numeric with at least 11 digits."
    
    static let VALIDATION_PASSWORD_MIN                 = "Password should contain atlest 4 characters."
    static let VALIDATION_PASSWORD_MATCH               = "New password and confirm password does not match."
    static let FORGET_PASSWORD                         = "A password has been sent to your email Address!"
    static let PASSWORD_UPDATED                        = "Your Password has been updated"
    
    static let VALIDATION_MAX_FIELD_LENGTH             = "Field must not be more than 15 characters."
    static let VALIDATION_MAX_DESCRIPTION_LENGTH       = "Description must not be more than 300 characters."
    static let VALIDATION_ALL_FIELDS                   = "Kindly fill all the fields."
    static let VALIDATION_VALID_URL                    = "Please provide a valid URL."
    static let VALIDATION_VALID_FILE_NAME              = "Please provide a file name."
    
    static let VALIDATION_IMAGE                        = "Please provide an image."
    static let VALIDATION_TERMS                        = "Kindly select the terms and Conditions."
    
    static let PROFILE_UPDATED                         = "Your Profile has been updated."
    
    static let MESSAGE_LOGOUT                          = "Are you sure you want to logout?"
    
    
    
    static let BaseURL = "http://35.160.175.165"
    
    
    static func VIEWCONTROLLER_WITH_IDENTIFIER(_ identifier: String) -> UIViewController{
        return STORYBOARD.instantiateViewController(withIdentifier: identifier)
    }
    
    static func VIEWCONTROLLER_WITH_IDENTIFIER(_ identifier: String,Storyboard: UIStoryboard) -> UIViewController{
        return Storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
}
struct ChatConstants {
    static let appNameErrorMessage = "Please match App Bundle name and config file app name in order to proceed."
    static let fileErrorMessage = "There is something wrong with Chat Config file"
    static var agentChanel = "EducationUSA" + ":Admin:Request:Subscribe:Channel"
    //static let socketURL = "https://educationusachat.stagingic.com"
    static let socketURL = "https://chat.educationusa.live"
}
enum MediaType: Int{
    case text = 0//"TEXT"
    case image = 1//"IMAGE"
    case typing = 2//"TYPING"
    case stopTyping = 3//"STOP_TYPING"
    case audio = 4//"AUDIO"
    case video = 5//"VIDEO"
}
enum DeliveryType : Int{
    case pending = 0
    case delivered = 1
    case seen = 2
}
enum MessageStatusType: Int{
    case none = 0
    case update = 1
    case delete = 2
}
