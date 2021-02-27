//
//  Message.swift
//  IngicChat
//
//  Created by zaidtayyab on 26/05/2018.
//  Copyright © 2018 zaidtayyab. All rights reserved.
//

import UIKit
import Realm
import RealmSwift


class Message: Object {
    
    
    @objc dynamic var id : String? = ""
    
    @objc dynamic var message : String? = ""
    
    @objc dynamic var date: String? = ""
    
    @objc dynamic var senderUserName: String? = ""
    
    @objc dynamic var senderUserId = 0
    
    @objc dynamic var recieverUserId = 0
    
    @objc dynamic var senderUserImage : String? = ""
    
    @objc dynamic var isMedia = 0
    
      var mediaURL = List<Media>()
    
    @objc dynamic var channel : String? = ""
    
    @objc dynamic var channelHistory : String? = ""
    
    @objc dynamic var messageType = 0
    
    @objc dynamic var messageDeliveryStatus = 1

    @objc dynamic var messageStatusType = 0
    

    
}
class PendingMessage: Object {
    
    
    @objc dynamic var id : String? = ""
    
    @objc dynamic var message : String? = ""
    
    @objc dynamic var date: String? = ""
    
    @objc dynamic var senderUserName: String? = ""
    
    @objc dynamic var senderUserId = 0
    
    @objc dynamic var recieverUserId = 0
    
    @objc dynamic var senderUserImage : String? = ""
    
    @objc dynamic var isMedia = 0
    
    var mediaURL = List<Media>()
    
    @objc dynamic var channel : String? = ""
    
    @objc dynamic var channelHistory : String? = ""
    
    @objc dynamic var messageType = 0
    
    @objc dynamic var messageDeliveryStatus = 1
    
    @objc dynamic var messageStatusType = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
   
}
class RequestUser: Object {
    
    @objc dynamic var receiver_id = 0
    
    @objc dynamic var sender_id  = 0
    
    @objc dynamic var sender_username : String?
    
    @objc dynamic var reciever_username : String?
    
    @objc dynamic var Channel : String?
    
    @objc dynamic var isAlive = false
    
    @objc dynamic var fcmToken : String?
    
    
}
class Push: Object {
    
    @objc dynamic var Id = 0
    
    var Devices = List<PushDetail>()
}

class PushDetail: Object {
    
    @objc dynamic var Token : String?
    
    @objc dynamic var UDID  : String?
    
    @objc dynamic var isAndroid = false
    
}

class Media: Object {
    
    @objc dynamic var imagePath : String?
    
    @objc dynamic var imageThumbnailPath: String?
}


class UserMessage: Object {
    
    @objc dynamic var channelName : String?
    
    var messages = List<Message>()
    
    
    
    override static func primaryKey() -> String? {
        return "channelName"
    }
    
    
    
}


