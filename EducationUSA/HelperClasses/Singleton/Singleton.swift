//
//  Singleton.swift
//  Versole
//
//  Created by Soomro Shahid on 5/13/16.
//  Copyright © 2016 Muzamil Hassan. All rights reserved.
//

import Foundation
import RealmSwift
class Singleton: NSObject {

    static let sharedInstance = Singleton()
  
    var userData:UserUser?
    var accessToken:String?
    var deviceToken:String = "a4s6d5sa4d"
    var deviceId:String = ""
    var realm: Realm!
    var isGuest:Bool = false
    var historyMessages = [UserMessage]()
    
    var pendingMessages = [PendingMessage]()
    
    override init() {
        
        super.init()
        
        if(!(realm != nil)){
            realm = try! Realm()
        }
        
        userData = realm.objects(UserUser.self).first
        for object in realm.objects(UserMessage.self){
            historyMessages.append(object)
        }
        for object in realm.objects(PendingMessage.self){
            pendingMessages.append(object)
        }
    }
    func isUserLoggedInApp()-> Bool{
        if (userData) != nil{
            if (userData?.isInvalidated)!{
                return false
            }
            return true
        }
        else{
            return false
        }
    }
    
    
    func agentChatChannel()->String{
        return "\(userData!.id):" + "EducationUSA" + ":agent"
    }
}
