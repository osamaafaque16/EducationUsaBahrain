//
//  AppConstants.swift
//  Template
//
//  Created by Muzamil Hassan on 02/01/2017.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//
import UIKit
import Foundation
//import RESideMenu

struct AppConstants{


    
    struct APP_STORYBOARD {

        static let HOME: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        static let USER: UIStoryboard = UIStoryboard(name: "UserModule", bundle: nil)
        static let SETTING: UIStoryboard = UIStoryboard(name: "SettingModule", bundle: nil)
        static let CHAT: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)

    }
    
    
    static let grayBarColor = UIColor(red: (94/255), green: (132/255), blue: (146/255), alpha: (255/255))
    static let pinkBarColor = UIColor(red: (197/255), green: (177/255), blue: (224/255), alpha: (255/255))
    static let greenBarColor = UIColor(red: (120/255), green: (190/255), blue: (119/255), alpha: (255/255))
    
    static let lightGrayTitleColor = UIColor(red: (54/255), green: (84/255), blue: (97/255), alpha: (255/255))
    static let lightGreenTitleColor = UIColor(red: (46/255), green: (192/255), blue: (202/255), alpha: (255/255))
    static let lightGrayLineColor = UIColor(red: (212/255), green: (227/255), blue: (232/255), alpha: (255/255))
    
    
    static let NAV_BAR_COLOR  = UIColor(red: 0/255.0, green: 52/255.0, blue: 103/255.0, alpha: 1.0)
    static let NAV_INTERNAL_BAR_COLOR      = UIColor.white
    static let VIEW_BG_GRAY = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
    
    static let APP_TEXT_RED = UIColor(red: 198/255, green: 18/255, blue: 57/255, alpha: 1)
    static let BTN_BLUE = UIColor(red: 222/255, green: 64/255, blue: 106/255, alpha: 1)
    
    
    
//    static func getEventCategory() -> [String] {
//        
//        return [
//            "Conference",
//            "Meeting",
//            "Seminar",
//            "Team Building Event",
//            "Trade Show",
//            "Business Dinner",
//            "Gold Events",
//            "Press Conferences",
//            "Networking Events"
//             ]
//        
//    }
    
    

    static func sideMenuList() -> [[String:String]]{
        
        return [
            [
                "title":"Home",
                "icon":"sidebar_0"
            ],
            [
                "title":"My Profile",
                "icon":"sidebar_1"
            ],
            [
                "title":"Inbox",
                "icon":"sidebar_2"
            ],
            [
                "title":"My Favorites",
                "icon":"sidebar_3"
            ],
            [
                "title":"Discover People",
                "icon":"sidebar_4"
            ],
            
            [
                "title":"Settings",
                "icon":"sidebar_5"
            ],
            
            [
                "title":"Logout",
                "icon":"sidebar_6"
            ],
        ]
        
    }
    
    //MARK:- Dummy Data - Remove in beta

    static func eventInDay() -> [[String:Any]?]{
        
        return [
            [
                "eventTitle" : "International Exhibition For Arts & Science",
                "eventTime" : "12PM - 1PM",
                "color" : AppConstants.grayBarColor
            ],
            [
                "eventTitle" : "Chicago Musical Exhibition",
                "eventTime" : "3PM - 4PM",
                "color" : AppConstants.grayBarColor
            ],
            [
                "eventTitle" : "Fashion Week 2017",
                "eventTime" : "07PM - 8PM",
                "color" : AppConstants.grayBarColor
            ],
            [
                "eventTitle" : "Texas Mega Dance Event",
                "eventTime" : "8PM - 9PM",
                "color" : AppConstants.grayBarColor
            ],
            [
                "eventTitle" : "Toronto - MegaMusic",
                "eventTime" : "11PM - 12PM",
                "color" : AppConstants.grayBarColor
            ]

        ]
    }
    
}


struct AppString{
    
    static let internetUnreachable = "Internet is not reachable"
    static let betaFeature = "Feature will be implement in next phase"

}

struct pullToRereshVariables{
    
    static var isRefreshingView:Bool! = false
    static var isLoadingProgress:Bool = false
    static var isShowLoadingProgress:Bool = true
    static var recordOffset:Int = 0
    static var recordLimit:Int = 20
    static var isReloadData:Bool = true

}

enum AppActionType:String {
    case favorite = "favourite"
//    case order = "order"
//    case rejectedOrder = "rejected_order"
    //*Remove Later
}
