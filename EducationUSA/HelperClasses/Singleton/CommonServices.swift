//
//  CommonServices.swift
//  EducationUSA
//
//  Created by zaidtayyab on 28/08/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//


import Foundation
import Alamofire


class CommonServices {
    static let shared = CommonServices()
    
    
    func registerPushNotification(UDID: String, fcmToken: String){
        
         if !Connectivity.isConnectedToInternet {
            //Utility.showErrorWith(message: "No Network Connection")
            return
        }
       // let udiid = UIDevice.current.identifierForVendor!.uuidString
       // print(udiid)
        let parameters : Parameters = [
            "UDID":UDID,
            "UserId":Singleton.sharedInstance.userData!.id,
            "Token":fcmToken]
        
        print(parameters)
        print(ChatBase_URL+REGISTER_PUSH)
        
        registerPush(urlPath: ChatBase_URL+REGISTER_PUSH,parameter: parameters) { (result) in
            let response = result["statusCode"] as! NSNumber!
            if(response?.intValue == 200){
                
            }
            else{
                
            }
                
        }
    }
    private func registerPush(urlPath: String, parameter: Parameters,completionHandler:@escaping (_ faqs:NSDictionary)->Void){
        
        if let components: NSURLComponents = NSURLComponents(string: (urlPath)){
//            AFWrapper.reques
            AFWrapper.shared.requestChatPOSTURL(route: components.url! as URL, parameters: parameter, success: { (result) in
                
                print(result)
                completionHandler(result as NSDictionary)
            }) { (error) in
                print(error.localizedDescription)
//                vc.view.makeToast("Sorry, something went wrong!", duration: 1.5, position: .center)
//                vc.removeNormalHud()
            }
        }
    }
    
}

