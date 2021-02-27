//
//  EventEvents.swift
//
//  Created by Hamza Hasan on 2/4/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class EventEvents: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let updatedAt = "updated_at"
    static let audience = "audience"
    static let descriptionValue = "description"
    static let type = "type"
    static let latitude = "latitude"
    static let status = "status"
    static let location = "location"
    static let id = "id"
    static let image = "image"
    static let createdAt = "created_at"
    static let eventDate = "event_date"
    static let longitude = "longitude"
    static let isFollow = "is_follow"
    static let eventURL = "pdf_file"
    
    static let startTime = "start_time"
    static let endTime = "end_time"
    
  }

  // MARK: Properties
    @objc dynamic var name: String!
    @objc dynamic var updatedAt: String!
    @objc dynamic var audience: String!
    @objc dynamic var descriptionValue: String!
    @objc dynamic var type: String!
    @objc dynamic var latitude: String!
    @objc dynamic var status: String!
    @objc dynamic var location: String!
    @objc dynamic var id = 0
    @objc dynamic var image: String!
    @objc dynamic var createdAt: String!
    @objc dynamic var eventDate: String!
    @objc dynamic var longitude: String!
    @objc dynamic var isFollow: String!
    @objc dynamic var eventURL: String!

    @objc dynamic var startTime: String!
    @objc dynamic var endTime: String!
    
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
        name <- map[SerializationKeys.name]
        updatedAt <- map[SerializationKeys.updatedAt]
        audience <- map[SerializationKeys.audience]
        descriptionValue <- map[SerializationKeys.descriptionValue]
        type <- map[SerializationKeys.type]
        //print(latitude)
        //print(map[SerializationKeys.latitude])
        latitude <- map[SerializationKeys.latitude]
        //print(latitude)
        status <- map[SerializationKeys.status]
        location <- map[SerializationKeys.location]
        id <- map[SerializationKeys.id]
        image <- map[SerializationKeys.image]
        createdAt <- map[SerializationKeys.createdAt]
        eventDate <- map[SerializationKeys.eventDate]
        longitude <- map[SerializationKeys.longitude]
        isFollow <- map[SerializationKeys.isFollow]
         eventURL <- map[SerializationKeys.eventURL]
        
        startTime <- map[SerializationKeys.startTime]
         endTime <- map[SerializationKeys.endTime]
    }


}
