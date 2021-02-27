//
//  ContactUsContact.swift
//
//  Created by Hamza Hasan on 2/6/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class ContactUsContact: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let web = "web"
    static let updatedAt = "updated_at"
    static let id = "id"
    static let twitter = "twitter"
    static let address = "address"
    static let createdAt = "created_at"
    static let facebook = "facebook"
    static let instagram = "instagram"
    static let aboutUs = "about_us"
  }

  // MARK: Properties
  var web = List<ContactUsWeb>()
    @objc dynamic var updatedAt: String!
  @objc dynamic var id = 0
  var twitter = List<ContactUsTwitter>()
  var address = List<ContactUsAddress>()
  @objc dynamic var createdAt: String!
  var facebook = List<ContactUsFacebook>()
  var instagram = List<ContactUsInstagram>()
  @objc dynamic var aboutUs: String!

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
    web <- (map[SerializationKeys.web], ListTransform<ContactUsWeb>())
    updatedAt <- map[SerializationKeys.updatedAt]
    id <- map[SerializationKeys.id]
    twitter <- (map[SerializationKeys.twitter], ListTransform<ContactUsTwitter>())
    address <- (map[SerializationKeys.address], ListTransform<ContactUsAddress>())
    createdAt <- map[SerializationKeys.createdAt]
    facebook <- (map[SerializationKeys.facebook], ListTransform<ContactUsFacebook>())
    instagram <- (map[SerializationKeys.instagram], ListTransform<ContactUsInstagram>())
    aboutUs <- map[SerializationKeys.aboutUs]
  }


}
