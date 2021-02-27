//
//  GuidelineBase.swift
//
//  Created by sierra on 9/24/18
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public final class GuidelineBase: Mappable, NSCoding {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let code = "Code"
    static let message = "Message"
    static let result = "Result"
    static let userBlocked = "UserBlocked"
    static let pages = "pages"
  }

  // MARK: Properties
  public var code: Int?
  public var message: String?
  public var result: GuidelineResult?
  public var userBlocked: Int?
  public var pages: Int?

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
    code <- map[SerializationKeys.code]
    message <- map[SerializationKeys.message]
    result <- map[SerializationKeys.result]
    userBlocked <- map[SerializationKeys.userBlocked]
    pages <- map[SerializationKeys.pages]
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
//  public func dictionaryRepresentation() -> [String: Any] {
//    var dictionary: [String: Any] = [:]
//    if let value = code { dictionary[SerializationKeys.code] = value }
//    if let value = message { dictionary[SerializationKeys.message] = value }
//    if let value = result { dictionary[SerializationKeys.result] = value.dictionaryRepresentation() }
//    if let value = userBlocked { dictionary[SerializationKeys.userBlocked] = value }
//    if let value = pages { dictionary[SerializationKeys.pages] = value }
//    return dictionary
//  }
//
  // MARK: NSCoding Protocol
  required public init(coder aDecoder: NSCoder) {
    self.code = aDecoder.decodeObject(forKey: SerializationKeys.code) as? Int
    self.message = aDecoder.decodeObject(forKey: SerializationKeys.message) as? String
    self.result = aDecoder.decodeObject(forKey: SerializationKeys.result) as? GuidelineResult
    self.userBlocked = aDecoder.decodeObject(forKey: SerializationKeys.userBlocked) as? Int
    self.pages = aDecoder.decodeObject(forKey: SerializationKeys.pages) as? Int
  }

  public func encode(with aCoder: NSCoder) {
    aCoder.encode(code, forKey: SerializationKeys.code)
    aCoder.encode(message, forKey: SerializationKeys.message)
    aCoder.encode(result, forKey: SerializationKeys.result)
    aCoder.encode(userBlocked, forKey: SerializationKeys.userBlocked)
    aCoder.encode(pages, forKey: SerializationKeys.pages)
  }
    
    static func getGuidelineDetail(urlPath:String,parameter:[String:Any]?,vc:BaseController,completionHandler:@escaping (_ event:GuidelineBase)->Void){
        
        let header = ["Authorization" : "Bearer "+(Singleton.sharedInstance.accessToken)!]
        
        AFWrapper.shared.requestGETURLWithHeader(urlPath, parameter, header, success: { (JSONResponse) in
            
            print(JSONResponse)
            let events = Mapper<GuidelineBase>().map(JSONObject: JSONResponse as Any)
            
            
            //                if schedule?.isBlocked == "1" {
            //
            //                    RecipesBase.userBlocked(message: (schedule?.message)!,view:vc)
            //
            //                    vc.stopLoading()
            //                    return
            //                }
            completionHandler(events!)
            
        }) { (error) in
            print(error.localizedDescription)
            vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
            vc.removeNormalHud()
        }
        
        
        
    }

}
