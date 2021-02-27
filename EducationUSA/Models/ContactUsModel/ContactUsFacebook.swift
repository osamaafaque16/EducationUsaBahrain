//
//  ContactUsFacebook.swift
//
//  Created by Hamza Hasan on 2/6/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class ContactUsFacebook: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let name = "name"
    static let key = "key"
  }

  // MARK: Properties
  @objc dynamic var name: String!
  @objc dynamic var key: String!

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.

  required convenience public init?(map : Map){
    self.init()
  }

  override public class func primaryKey() -> String? {
    return "name"
  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    name <- map[SerializationKeys.name]
    key <- map[SerializationKeys.key]
  }


}
