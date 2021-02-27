//
//  CMSBase.swift
//
//  Created by Hamza Hasan on 2/2/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm

public class CMSBase: Object, Mappable {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let code = "Code"
    static let message = "Message"
    static let result = "Result"
    static let userBlocked = "UserBlocked"
    static let pages = "pages"
  }

  // MARK: Properties
  @objc dynamic var code = 0
  @objc dynamic var message: String? = ""
  @objc dynamic var result: CMSResult?
  @objc dynamic var userBlocked = 0
  @objc dynamic var pages = 0

  // MARK: ObjectMapper Initializers
  /// Map a JSON object to this class using ObjectMapper.
  ///
  /// - parameter map: A mapping from ObjectMapper.

  required convenience public init?(map : Map){
    self.init()
  }

  override public class func primaryKey() -> String? {
    return "code"
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

    
    static func getTermsAndCond(urlPath:String,parameter:[String:Any]?,vc:BaseController,completionHandler:@escaping (_ cms:CMSBase)->Void){
        
        let header = ["Authorization" : "Bearer "+(Singleton.sharedInstance.accessToken)!]
        
        AFWrapper.shared.requestGETURLWithHeader(urlPath, parameter, header, success: { (JSONResponse) in
            
            print(JSONResponse)
            let about = Mapper<CMSBase>().map(JSONObject: JSONResponse as Any)
            
            
            //                if schedule?.isBlocked == "1" {
            //
            //                    RecipesBase.userBlocked(message: (schedule?.message)!,view:vc)
            //
            //                    vc.stopLoading()
            //                    return
            //                }
            completionHandler(about!)
            
        }) { (error) in
            print(error.localizedDescription)
            vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
            vc.removeNormalHud()
        }
        
        
        
    }

}