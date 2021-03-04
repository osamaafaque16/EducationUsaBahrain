//
//  AFWrapper.swift
//  MediaVoir
//
//  Created by Faraz Haider on 05/11/2016.
//  Copyright © 2016 OutreachGlobal. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

typealias DefaultArrayResultAPISuccessClosure = (Dictionary<String,AnyObject>) -> Void
typealias DefaultAPIFailureClosure = (NSError) -> Void
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
//    static let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
//    static func startNetworkReachabilityObserver() {
//        
//        reachabilityManager?.listener = { status in
//            switch status {
//                
//            case .notReachable:
//                print("The network is not reachable")
//                
//            case .unknown :
//                print("It is unknown whether the network is reachable")
//                
//            case .reachable(.ethernetOrWiFi):
//                print("The network is reachable over the WiFi connection")
//                 CategoryBase.callCategoryService()
//            case .reachable(.wwan):
//                print("The network is reachable over the WWAN connection")
//                CategoryBase.callCategoryService()
//                
//            }
//        }
//        
//        // start listening
//        
//    }

}

class AFWrapper: NSObject {
   
    var alamoFireManager : Alamofire.Session!
    
    //shared Instance
      public static let shared: AFWrapper = {
          let instance = AFWrapper()
          return instance
      }()
      
      // MARK: - : override
      override init() {
          
          alamoFireManager = Alamofire.Session(
              configuration: URLSessionConfiguration.default
          )
          alamoFireManager.session.configuration.timeoutIntervalForRequest = 120
      }
    
    
      func requestGETURL(_ strURL: String,_ parameters:Parameters?, success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        
        alamoFireManager.request(URL(string: strURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) -> Void in
            
            print(response.request ?? "")
            
            switch response.result {
            case.success(let value):
                guard let data = response.data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>{
                        success(jsonResponse)
                    } else {
                        success(Dictionary<String, AnyObject>())
                    }
                }
                catch let error
                {
                    print("Error: ", error)
                }
                
            case .failure(let error):
                print("👹 Error in calling post request")
                failure(error.localizedDescription as! NSError)
                break
            }
        }
        
//        Alamofire.request(strURL,parameters: parameters).responseJSON { (responseObject) -> Void in
//
//            print(responseObject.request ?? "")
//
//            if responseObject.result.isSuccess {
//                let resJson = responseObject.result.value!
//                success(resJson)
//            }
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
    }
     func requestChatGETURL(route: URL,parameters: Parameters,
                             success:@escaping DefaultArrayResultAPISuccessClosure,
                             failure:@escaping DefaultAPIFailureClosure){
        
        //alamoFireManager.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: getAuthorizationHeader())
        alamoFireManager.request(route, method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Content-Type":"application/json"]).responseJSON{
            response in
            
            switch response.result {
            case.success(let value):
                guard let data = response.data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>{
                        success(jsonResponse)
                    } else {
                        success(Dictionary<String, AnyObject>())
                    }
                }
                catch let error
                {
                    print("Error: ", error)
                }
                
            case .failure(let error):
                print("👹 Error in calling post request")
                //failure(error.localizedDescription as! NSError)
                break
            }
        }
        
        
        
//        Alamofire.request(route, method: .get, encoding: JSONEncoding.prettyPrinted, headers: ["Content-Type":"application/json"]).responseJSON{
//            response in
//
//
//            guard response.result.error == nil else{
//
//                failure(response.result.error! as NSError)
//
//                return;
//            }
//
//
//
//            if response.result.isSuccess {
//                if let jsonResponse = response.result.value as? Dictionary<String, AnyObject>{
//                    success(jsonResponse)
//                } else {
//                    success(Dictionary<String, AnyObject>())
//                }
//            }
//
//
//
//        }
        
    }
     func requestChatPOSTURL(route: URL,parameters: Parameters,
                                 success:@escaping DefaultArrayResultAPISuccessClosure,
                                 failure:@escaping DefaultAPIFailureClosure){
        print("********************")
        print(route)
        print(parameters)
        alamoFireManager.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON{
            response in
            
            switch response.result {
            case.success(let value):
                guard let data = response.data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>{
                        success(jsonResponse)
                    } else {
                        success(Dictionary<String, AnyObject>())
                    }
                }
                catch let error
                {
                    print("Error: ", error)
                }
                
            case .failure(let error):
                print("👹 Error in calling post request")
                //failure(error.localizedDescription as! NSError)
                break
            }
            
            
        }
        
//        Alamofire.request(route, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON{
//            response in
//
//
//            guard response.result.error == nil else{
//
//                failure(response.result.error! as NSError)
//
//                return;
//            }
//
//
//
//            if response.result.isSuccess {
//                if let jsonResponse = response.result.value as? Dictionary<String, AnyObject>{
//                    success(jsonResponse)
//                } else {
//                    success(Dictionary<String, AnyObject>())
//                }
//            }
//
//
//
//        }
        
    }
     func requestGETURLWithHeader(_ strURL: String,_ parameters:Parameters?,_ headers:[String:String], success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void) {
        
        var httpHeader : HTTPHeaders = [:]
        for (key,value) in headers {
            httpHeader[key] = value
        }
        print(httpHeader)
        alamoFireManager.request(URL(string: strURL)!,parameters: parameters,headers: httpHeader).responseJSON { (response) -> Void in
            
            print(response.request ?? "")

            switch response.result {
            case.success(let value):
                guard let data = response.data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>{
                        success(jsonResponse)
                    } else {
                        success(Dictionary<String, AnyObject>())
                    }
                }
                catch let error
                {
                    print("Error: ", error)
                }
                
            case .failure(let error):
                print("👹 Error in calling post request")
                //failure(error.localizedDescription as! NSError)
                break
            }
        }
        
//        Alamofire.request(strURL,parameters: parameters,headers: headers).responseJSON { (responseObject) -> Void in
//
//            print(responseObject.request ?? "")
//
//            if responseObject.result.isSuccess {
//                let resJson = responseObject.result.value!
//                success(resJson)
//            }
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
    }
    
    
     func requestPOSTURL(_ strURL : String, params : Parameters, headers : [String : String]?, success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void){
        
        var httpHeader : HTTPHeaders? = nil
        if let allHeader = headers {
            httpHeader = [:]
            for (key,value) in allHeader {
                httpHeader![key] = value
            }
        }
        
        print(httpHeader)
  
        alamoFireManager.request(URL(string: strURL)!, method: .post,  parameters: params,headers: httpHeader).responseJSON { (response) -> Void in
            
            print(response.request ?? "")
            
            switch response.result {
            case.success(let value):
                guard let data = response.data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>{
                        success(jsonResponse)
                    } else {
                        success(Dictionary<String, AnyObject>())
                    }
                }
                catch let error
                {
                    print("Error: ", error)
                }
                
            case .failure(let error):
                print("👹 Error in calling post request")
                failure(error)
                break
            }
        }
        
        
//        Alamofire.request(strURL, method: .post, parameters: params,headers: headers).responseJSON { (responseObject) -> Void in
//
//            print(responseObject.request ?? "")
//
//            if responseObject.result.isSuccess {
//                let resJson = responseObject.result.value!
//                success(resJson)
//                print(resJson)
//            }
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
    }
    
     func requestGetInBackground(_ strURL : String, params : Parameters, headers : [String : String]?, success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void){
        
        var httpHeader : HTTPHeaders = [:]
        for (key,value) in headers! {
            httpHeader[key] = value
        }
        print(httpHeader)
        let queue = DispatchQueue.global(qos: .background)
        alamoFireManager.request(URL(string: strURL)!,parameters: params,headers: httpHeader).responseJSON(queue: queue) { (response) -> Void in
            
            print(response.request ?? "")
            switch response.result {
            case.success(let value):
                guard let data = response.data else { return }
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>{
                        success(jsonResponse)
                    } else {
                        success(Dictionary<String, AnyObject>())
                    }
                }
                catch let error
                {
                    print("Error: ", error)
                }
                
            case .failure(let error):
                print("👹 Error in calling post request")
                failure(error.localizedDescription as! NSError)
                break
            }
        }
//        let queue = DispatchQueue.global(qos: .background)
//        Alamofire.request(strURL,parameters: params,headers: headers).responseJSON(queue: queue) { (responseObject) -> Void in
//
//            print(responseObject.request ?? "")
//
//            if responseObject.result.isSuccess {
//                let resJson = responseObject.result.value!
//                success(resJson)
//
//            }
//
//            if responseObject.result.isFailure {
//                let error : Error = responseObject.result.error!
//                failure(error)
//            }
//        }
        
    }
    
    
    
    
    
/*    class func requestPOSTWithSingleImage(_ strURL : String, parameters : Parameters,headers : [String : String]?,dataImage : [String:Any] ,  success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
    
        let imageValue = dataImage["value"] as! UIImage?
        let imageKey = dataImage["key"] as! String?
        let URLSTR = try! URLRequest(url: strURL, method:.post,headers:headers)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            // code
            
            if(imageValue != nil) {
                let imageData = UIImagePNGRepresentation(imageValue!)
                multipartFormData.append(imageData!, withName: imageKey!, fileName: "image.png", mimeType: "image/png")
            }
            for (key, value) in parameters {
                //multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                
                print(key)
                print(value)
                
                if value is Int {
                    multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                }else{
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }

            }
        },
                         with: URLSTR, encodingCompletion: { (result) in
                            switch result {
                            case .success(let upload, _, _):
                                upload.responseString { responseObject in
                                    if responseObject.result.isSuccess {
                                        
                                        if let data = (responseObject.result.value! as NSString).data(using: String.Encoding.utf8.rawValue) {
                                            let json = JSON(data: data)
                                            print(json)
                                            success(Data)
                                        }
                                        
                                    }
                                    if responseObject.result.isFailure {
                                        let error : Error = responseObject.result.error!
                                        failure(error)
                                    }
                                    
                                }
                                
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
        
        
        
    }*/

    func requestPOSTWithSingleImage(_ strURL : String, parameters : Parameters,dataImage : [String:Any]? , headers : [String : String]?, success:@escaping (Any) -> Void, failure:@escaping (Error) -> Void){
        //var dictionary = ["Item 1": "description", "Item 2": "description"]
        
        print(dataImage)
        let imageValue = dataImage?["value"] as! UIImage?
        let imageKey = dataImage?["key"] as! String?
        
        var httpHeader : HTTPHeaders = [:]
        for (key,value) in headers! {
            httpHeader[key] = value
        }
        print(httpHeader)
        
        let URLSTR = try! URLRequest(url: strURL, method:.post,headers: httpHeader)
        print(URLSTR)
        
        alamoFireManager.upload(multipartFormData: { (multipartFormData) in
            // code
            
            if(imageValue != nil) {
                let imageData = UIImagePNGRepresentation(imageValue!)
                multipartFormData.append(imageData!, withName: imageKey!, fileName: "image.png", mimeType: "image/png")
            }
            for (key, value) in parameters {
                //multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                print(key)
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, with: URLSTR)
        .responseJSON(completionHandler: {(data) in
            
            switch data.result {
            case .success(let value):
              print("SUCCESS")
             guard let data = data.data else { return }
             do {
                 if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>{
                     success(jsonResponse)
                 } else {
                     success(Dictionary<String, AnyObject>())
                 }
             }
             catch let error
             {
                 print("Error: ", error)
             }
            case .failure(let error):
                  print("FAIL")
             //failure(error as NSError)
                print(error as NSError)
            }
            
            
//                            switch result {
//                            case .success(let upload, _, _):
//                                upload.responseJSON { responseObject in
//                                    debugPrint(responseObject)
//                                    if responseObject.result.isSuccess {
//                                        let resJson = responseObject.result.value!
//                                        success(resJson)
//                                    }
//                                    if responseObject.result.isFailure {
//                                        let error : Error = responseObject.result.error!
//                                        failure(error)
//                                    }
//
//                                }
//
//                            case .failure(let encodingError):
//                                print(encodingError)
//                            }
        })
        
        
        
        
        
        
        
        
        
        
//        print(dataImage)
//        let imageValue = dataImage?["value"] as! UIImage?
//        let imageKey = dataImage?["key"] as! String?
//
//        let URLSTR = try! URLRequest(url: strURL, method:.post,headers: headers)
//        print(URLSTR)
//
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            // code
//
//            if(imageValue != nil) {
//                let imageData = UIImagePNGRepresentation(imageValue!)
//                multipartFormData.append(imageData!, withName: imageKey!, fileName: "image.png", mimeType: "image/png")
//            }
//            for (key, value) in parameters {
//                //multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//                print(key)
//                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//            }
//        },
//                         with: URLSTR, encodingCompletion: { (result) in
//                            switch result {
//                            case .success(let upload, _, _):
//                                upload.responseJSON { responseObject in
//                                    debugPrint(responseObject)
//                                    if responseObject.result.isSuccess {
//                                        let resJson = responseObject.result.value!
//                                        success(resJson)
//                                    }
//                                    if responseObject.result.isFailure {
//                                        let error : Error = responseObject.result.error!
//                                        failure(error)
//                                    }
//
//                                }
//
//                            case .failure(let encodingError):
//                                print(encodingError)
//                            }
//        })
//
//
//
    }
    
}
