//
//  ContactUsAddress.swift
//
//  Created by Hamza Hasan on 2/6/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class ContactUsAddress: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let phone = "phone"
    static let location = "location"
    static let address = "address"
  }

  // MARK: Properties
  @objc dynamic var phone: String!
  @objc dynamic var location: String!
  @objc dynamic var address: String!

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.

  required convenience public init?(map : Map){
    self.init()
  }

  override public class func primaryKey() -> String? {
    return "phone"
  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    phone <- map[SerializationKeys.phone]
    location <- map[SerializationKeys.location]
    address <- map[SerializationKeys.address]
  }


}
