//
//  NotificationNotifications.swift
//
//  Created by Hamza Hasan on 2/8/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class NotificationNotifications: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let actionType = "action_type"
    static let senderId = "sender_id"
    static let id = "id"
    static let text = "text"
    static let createdAt = "created_at"
    static let read = "read"
    static let refId = "ref_id"
  }

  // MARK: Properties
   @objc dynamic var actionType: String!
   @objc dynamic var senderId = 0
   @objc dynamic var id = 0
   @objc dynamic var text: String!
   @objc dynamic var createdAt: String!
   @objc dynamic var read: String!
    @objc dynamic var refId = 0

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.

  required convenience public init?(map : Map){
    self.init()
  }

  override public class func primaryKey() -> String? {
    return "id"
  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    actionType <- map[SerializationKeys.actionType]
    senderId <- map[SerializationKeys.senderId]
    id <- map[SerializationKeys.id]
    text <- map[SerializationKeys.text]
    createdAt <- map[SerializationKeys.createdAt]
    read <- map[SerializationKeys.read]
    refId <- map[SerializationKeys.refId]
  }


}
