//
//  EduGuidesResult.swift
//
//  Created by Hamza Hasan on 2/4/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class FullBrightResult: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let educationGuide = "full-bright"
  }

  // MARK: Properties
  var educationGuide = List<FullBrightDetail>()
    @objc dynamic var id = 0

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
    educationGuide <- (map[SerializationKeys.educationGuide], ListTransform<FullBrightDetail>())
  }


}
