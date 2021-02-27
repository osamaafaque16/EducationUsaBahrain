//
//  UserBase.swift
//
//  Created by Hamza Hasan on 1/31/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import Alamofire
import Toast_Swift
import SwiftyJSON

public class UserBase: Object, Mappable {

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
  @objc dynamic var message: String!
  @objc dynamic var result: UserResult?
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

    static func signIn_SignUp(urlPath:String,parameters:Parameters,header:[String:String]?,vc:BaseController,completionHandler:@escaping (_ user:UserBase)->Void){
        
        
        AFWrapper.shared.requestPOSTURL(urlPath, params: parameters, headers: header, success: { (JSONResponse) in
            
            let json = JSON.init(JSONResponse)
            print(json)
            let user = Mapper<UserBase>().map(JSONObject: JSONResponse as Any)
            
            completionHandler(user!)
            
        }) { (error) in
            print(error.localizedDescription)
            vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
            vc.removeNormalHud()
        }
    }
    
    static func signIn_SocialMedia(urlPath:String,parameters:Parameters,header:[String:String]?,vc:BaseController,completionHandler:@escaping (_ user:UserBase)->Void){
        
        
        AFWrapper.shared.requestPOSTURL(urlPath, params: parameters, headers: header, success: { (JSONResponse) in
            
            let json = JSON.init(JSONResponse)
            print(json)
            let user = Mapper<UserBase>().map(JSONObject: JSONResponse as Any)
            
            completionHandler(user!)
            
        }) { (error) in
            print(error.localizedDescription)
            vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
            vc.removeNormalHud()
        }
    }
    
    static func updateUserProfile(urlPath:String,parameters:Parameters,imageData:[String:Any]?, header:[String:String]?, completionHandler:@escaping (_ user:UserBase)->Void,Failure:@escaping (_ error:String)->Void)
    {
        AFWrapper.shared.requestPOSTWithSingleImage(urlPath, parameters: parameters, dataImage: imageData!, headers: header , success: { (JSONResponse) in
           
//            print(JSONResponse)
//            print(JSONResponse.dictionaryObject)
//            print(JSONResponse.dictionaryValue)
//            print(JSONResponse.dictionary)
            
            
            let user = Mapper<UserBase>().map(JSONObject: JSONResponse as Any)
            completionHandler(user!)
            
        }) { (error) in
            Failure(error.localizedDescription)
            
        }
    }
    
//    static func changePassword(urlPath:String,parameters:Parameters,vc:BaseController,completionHandler:@escaping (_ user:UserBase)->Void){
//        
//        let header:[String:String] = ["x-access-token":Singleton.sharedInstance.userData.accessToken!]
//        
//        AFWrapper.requestPOSTURL(urlPath, params: parameters, headers: header, success: { (JSONResponse) in
//            
//            print(JSONResponse)
//            let user = Mapper<UserBase>().map(JSONObject: JSONResponse as Any)
//            
//            if user?.isBlocked == "1" {
//                
//                RecipesBase.userBlocked(message: (user?.message)!,view:vc)
//                
//                vc.stopLoading()
//                return
//            }
//            
//            completionHandler(user!)
//            
//        }) { (error) in
//            print(error.localizedDescription)
//            vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
//            vc.stopLoading()
//            
//        }
//        
//    }

}
