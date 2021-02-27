//
//  GuidelineResult.swift
//
//  Created by sierra on 9/24/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class GuidelineResult: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let educationGuideline = "education_guideline"
  }

  // MARK: Properties
  public var educationGuideline: EduGuidesEducationGuide?

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public required init?(map: Map){

  }

  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.
  public func mapping(map: Map) {
    educationGuideline <- map[SerializationKeys.educationGuideline]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
//  public func dictionaryRepresentation() -> [String: Any] {
//    var dictionary: [String: Any] = [:]
//    if let value = educationGuideline { dictionary[SerializationKeys.educationGuideline] = value.dictionaryRepresentation() }
//    return dictionary
//  }
//
  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.educationGuideline = aDecoder.decodeObject(forKey: SerializationKeys.educationGuideline) as? EduGuidesEducationGuide
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(educationGuideline, forKey: SerializationKeys.educationGuideline)
  }

}
