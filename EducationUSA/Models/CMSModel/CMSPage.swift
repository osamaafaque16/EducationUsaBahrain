//
//  CMSPage.swift
//
//  Created by Hamza Hasan on 2/2/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class CMSPage: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let content = "content"
    static let status = "status"
    static let updatedAt = "updated_at"
    static let id = "id"
    static let createdAt = "created_at"
    static let type = "type"
  }

  // MARK: Properties
  @objc dynamic var content: String!
  @objc dynamic var status: String!
  @objc dynamic var updatedAt: String!
  @objc dynamic var id = 0
  @objc dynamic var createdAt: String!
  @objc dynamic var type: String!

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
    content <- map[SerializationKeys.content]
    status <- map[SerializationKeys.status]
    updatedAt <- map[SerializationKeys.updatedAt]
    id <- map[SerializationKeys.id]
    createdAt <- map[SerializationKeys.createdAt]
    type <- map[SerializationKeys.type]
  }


}
