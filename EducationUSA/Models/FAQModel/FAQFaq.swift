//
//  FAQFaq.swift
//
//  Created by Hamza Hasan on 2/6/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class FAQFaq: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let status = "status"
    static let name = "name"
    static let updatedAt = "updated_at"
    static let id = "id"
    static let createdAt = "created_at"
    static let descriptionValue = "description"
    static let guidelineId = "edu_guideline_id"
    
  }

  // MARK: Properties
  @objc dynamic var status: String!
  @objc dynamic var name: String!
  @objc dynamic var updatedAt: String!
  @objc dynamic var id = 0
    @objc dynamic var guidelineId = 0
  @objc dynamic var createdAt: String!
  @objc dynamic var descriptionValue: String!

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
    status <- map[SerializationKeys.status]
    name <- map[SerializationKeys.name]
    updatedAt <- map[SerializationKeys.updatedAt]
    id <- map[SerializationKeys.id]
    guidelineId <- map[SerializationKeys.guidelineId]
    createdAt <- map[SerializationKeys.createdAt]
    descriptionValue <- map[SerializationKeys.descriptionValue]
    
  }


}
