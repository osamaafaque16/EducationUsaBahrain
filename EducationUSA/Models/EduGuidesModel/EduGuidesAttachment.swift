//
//  EduGuidesAttachment.swift
//
//  Created by Hamza Hasan on 2/4/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class EduGuidesAttachment: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let fileUrl = "file_url"
    static let eduId = "edu_id"
    static let id = "id"
    static let updatedAt = "updated_at"
    static let createdAt = "created_at"
    static let file = "file"
  }

  // MARK: Properties
   @objc dynamic var fileUrl: String!
   @objc dynamic var eduId: String!
   @objc dynamic var id = 0
   @objc dynamic var updatedAt: String!
   @objc dynamic var createdAt: String!
   @objc dynamic var file: String!

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
    fileUrl <- map[SerializationKeys.fileUrl]
    eduId <- map[SerializationKeys.eduId]
    id <- map[SerializationKeys.id]
    updatedAt <- map[SerializationKeys.updatedAt]
    createdAt <- map[SerializationKeys.createdAt]
    file <- map[SerializationKeys.file]
  }


}
