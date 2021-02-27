//
//  EduGuidesEducationGuide.swift
//
//  Created by Hamza Hasan on 2/4/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class StudentVisaDetail: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    
    static let id = "id"
    static let name = "name"
    static let image = "image"
    static let descriptionValue = "description"
    static let status = "status"
    static let createdAt = "created_at"
    static let updatedAt = "updated_at"
    
    
    //static let attachment = "attachment"
  }

  // MARK: Properties
    @objc dynamic var status: String!
   @objc dynamic var name: String!
   @objc dynamic var updatedAt: String!
   @objc dynamic var id = 0
   @objc dynamic var image: String!
   @objc dynamic var educationImage: String!
   @objc dynamic var createdAt: String!
   @objc dynamic var descriptionValue: String!
   var attachment = List<EduGuidesAttachment>()

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
    image <- map[SerializationKeys.image]
    //educationImage <- map[SerializationKeys.educationImage]
    createdAt <- map[SerializationKeys.createdAt]
    descriptionValue <- map[SerializationKeys.descriptionValue]
    //attachment <- (map[SerializationKeys.attachment], ListTransform<EduGuidesAttachment>())
  }


}
