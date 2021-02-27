//
//  UserUser.swift
//
//  Created by Hamza Hasan on 1/31/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class UserUser: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let dob = "dob"
    static let name = "name"
    static let email = "email"
    static let token = "token"
    static let address = "address"
    static let gender = "gender"
    static let status = "status"
    static let isGuest = "is_guest"
    static let id = "id"
    static let countryCode = "country_code"
    static let image = "image"
    static let createdAt = "created_at"
    static let phone = "phone"
    static let notificationStatus = "notification_status"
    static let userImage = "user_image"
    static let isVerified = "is_verified"
    static let country = "country"
  }

  // MARK: Properties
    @objc dynamic var dob: String!
    @objc dynamic var name: String!
    @objc dynamic var email: String!
    @objc dynamic var token: String!
    @objc dynamic var address: String!
    @objc dynamic var gender: String!
    @objc dynamic var status: String!
    @objc dynamic var isGuest: String!
    @objc dynamic var id = 0
    @objc dynamic var countryCode: String!
    @objc dynamic var image: String!
    @objc dynamic var createdAt: String!
    @objc dynamic var phone: String!
    @objc dynamic var notificationStatus: String!
    @objc dynamic var userImage: String!
    @objc dynamic var isVerified: String!
    @objc dynamic var country: String!

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
    dob <- map[SerializationKeys.dob]
    name <- map[SerializationKeys.name]
    email <- map[SerializationKeys.email]
    token <- map[SerializationKeys.token]
    address <- map[SerializationKeys.address]
    gender <- map[SerializationKeys.gender]
    status <- map[SerializationKeys.status]
    isGuest <- map[SerializationKeys.isGuest]
    id <- map[SerializationKeys.id]
    countryCode <- map[SerializationKeys.countryCode]
    image <- map[SerializationKeys.image]
    createdAt <- map[SerializationKeys.createdAt]
    phone <- map[SerializationKeys.phone]
    notificationStatus <- map[SerializationKeys.notificationStatus]
    userImage <- map[SerializationKeys.userImage]
    isVerified <- map[SerializationKeys.isVerified]
    country <- map[SerializationKeys.country]
  }


}
