//
//  ContactUsBase.swift
//
//  Created by Hamza Hasan on 2/6/18
//  Copyright (c) . All rights reserved.
//


import ObjectMapper
import RealmSwift
import ObjectMapper_Realm
import Alamofire

public class ContactUsBase: Object, Mappable {

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
  @objc dynamic var message = ""
  @objc dynamic var result: ContactUsResult?
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

    
    static func getContactDetail(urlPath:String,parameter:[String:Any]?,vc:BaseController,completionHandler:@escaping (_ faqs:ContactUsBase)->Void){
        
        let header = ["Authorization" : "Bearer "+(Singleton.sharedInstance.accessToken)!]
        
        AFWrapper.shared.requestGETURLWithHeader(urlPath, parameter, header, success: { (JSONResponse) in
            
            print(JSONResponse)
            let contact = Mapper<ContactUsBase>().map(JSONObject: JSONResponse as Any)
            
            
            //                if schedule?.isBlocked == "1" {
            //
            //                    RecipesBase.userBlocked(message: (schedule?.message)!,view:vc)
            //
            //                    vc.stopLoading()
            //                    return
            //                }
            completionHandler(contact!)
            
        }) { (error) in
            print(error.localizedDescription)
            vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
            vc.removeNormalHud()
        }
        
    }
    static func getChatHistory(urlPath:String,parameter:Parameters,vc:BaseController,completionHandler:@escaping (_ faqs:NSDictionary)->Void){
        

        let chanel = (parameter["channel"] as! String)//.replacingOccurrences(of: ":", with: "%3")
        let URLwithParam = urlPath.replacingOccurrences(of: "{channel}", with: chanel)
        
        
        if let components: NSURLComponents = NSURLComponents(string: (URLwithParam)){
            AFWrapper.shared.requestChatGETURL(route: components.url! as URL, parameters: parameter, success: { (result) in
                
                print(result)
                completionHandler(result as! NSDictionary)
            }) { (error) in
                print(error.localizedDescription)
                vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
                vc.removeNormalHud()
            }
        }
        
        
        
    }
   


}
