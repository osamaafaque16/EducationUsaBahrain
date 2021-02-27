//
//  AppDelegate.swift
//  EducationUSA
//
//  Created by XEONCITY on 23/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Hero
import AMXFontAutoScale
import GoogleMaps
import GooglePlaces
import IQKeyboardManagerSwift
import UserNotifications
import FCAlertView
import UserNotifications

import FirebaseAnalytics
import FirebaseCore
import FirebaseInstanceID
import FirebaseMessaging
import FBSDKCoreKit
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //todo:Osama
        //checkFirstTimeAppOpen()
    
        
        //AIzaSyBTVyVHyLiWM7D2seuXgzNKPQV6A5hxPzw
        GMSServices.provideAPIKey("AIzaSyALC2JCUnDTAHqPSzVa7cHUmalOturWGYg")
        GMSPlacesClient.provideAPIKey("AIzaSyALC2JCUnDTAHqPSzVa7cHUmalOturWGYg")
        
        TWTRTwitter.sharedInstance().start(withConsumerKey: "jThh7ujNxzj8wEyUjnhd4Fy4o", consumerSecret: "7jmeFaTUm4AmMAz7xgjpr6eEUfci3azGak6G6S3obaSiTyIata")
        //Setup Push Notification
       // pushRequest(application: application)
        FirebaseApp.configure()
        registerFirebaseNotification(application)
        Messaging.messaging().delegate = self
       
        
//        IQKeyboardManager.shared.disabledToolbarClasses = [ChatViewController.self]
//        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [ChatViewController.self]
        IQKeyboardManager.shared.enable = true
        
        NetworkManager.sharedInstance.observeReachability()
        //setupPushNotification(application)
        UIApplication.shared.statusBarStyle = .lightContent
        
//        if Constants.kWINDOW_WIDTH == 320 {
//            UILabel.amx_autoScaleFont(forReferenceScreenSize: .size4p7Inch)
//        }else{
//            UILabel.amx_referenceScreenSize = .size4p7Inch
//        }
        
        UILabel.amx_referenceScreenSize = .size4p7Inch
        

        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        window?.endEditing(true)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        if Singleton.sharedInstance.isUserLoggedInApp(){
            SocketIOManager.sharedInstance.closeConnection()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        if Singleton.sharedInstance.isUserLoggedInApp(){
            SocketIOManager.sharedInstance.establishConnection()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if Singleton.sharedInstance.isUserLoggedInApp(){
            SocketIOManager.sharedInstance.establishConnection()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func ShowHomeController(_ viewController:UIViewController){
        //homeNavController = viewController
        
        Constants.UIWINDOW?.rootViewController = viewController
        Constants.UIWINDOW?.makeKeyAndVisible()
    }
    
    
    func showAlert(subTitle:String) {
        
        let alert = FCAlertView();
        
        alert.showAlert(in: Constants.UIWINDOW!,
                        withTitle:nil,
                        withSubtitle:subTitle,
                        withCustomImage:#imageLiteral(resourceName: "popupLogo"),
                        withDoneButtonTitle:nil,
                        andButtons:nil)
        //alert.cornerRadius = 4
        alert.colorScheme = Utility.UIColorFromRGB(rgbValue: 0x032951)
        alert.hideSeparatorLineView = true
        alert.detachButtons = true
        alert.subTitleColor = UIColor.darkGray
        alert.titleColor = Utility.UIColorFromRGB(rgbValue: 0x032951)
        alert.firstButtonTitleColor = .white
        alert.secondButtonTitleColor = .white
        alert.firstButtonBackgroundColor = Utility.UIColorFromRGB(rgbValue: 0x032951)
        alert.secondButtonBackgroundColor = Utility.UIColorFromRGB(rgbValue: 0x032951)
        
    }
    
    fileprivate func pushToEventDetailController( data:NSDictionary) {
        print(data)
        let eventVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "EventDetailController") as! EventDetailController
        eventVC.fromNotification = true
//        eventVC.eventId = String(describing: data["ref_id"] as! Int)
//        eventVC.notiId = String(describing: data["notification_id"] as! Int)
        eventVC.eventId = String(describing: data["ref_id"] as! String)
        eventVC.notiId = String(describing: data["notification_id"] as! String)
        eventVC.actionType = (data["action_type"] as! String)
        
        
        if let selectedNav = Constants.UIWINDOW?.rootViewController as? UINavigationController {
            selectedNav.pushViewController(eventVC, animated: false)
        }
        
    }
    
    fileprivate func pushToChatController( data:NSDictionary) {
        print(data)

        let chatVC = AppConstants.APP_STORYBOARD.CHAT.instantiateViewController(withIdentifier: "AgentChatViewController") as! AgentChatViewController
        chatVC.fromPush = true
        if let selectedNav = Constants.UIWINDOW?.rootViewController as? UINavigationController {

            selectedNav.pushViewController(chatVC, animated: false)
        }

    }
}

extension AppDelegate  {
    
    func tokenRefreshNotification() {
        let fcmDeviceToken = InstanceID.instanceID().token()
        print(fcmDeviceToken ?? "")
        Singleton.sharedInstance.deviceToken = fcmDeviceToken ?? ""
        // TODO: Send token to server
    }
    
    
    func registerFirebaseNotification(_ application : UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        }
        else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        tokenRefreshNotification()
    }
    
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
        
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Handle push from background or closed")
        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
        print("\(response.notification.request.content.userInfo)")
        
        let userInfo = response.notification.request.content.userInfo
        
        if let action_type = userInfo["action_type"] as? String {
            if action_type == "post_event" {
                pushToEventDetailController(data: userInfo as NSDictionary)
            }else{
                let aps =  userInfo["aps"]! as! [AnyHashable: Any]
                let alert = aps["alert"]! as! [AnyHashable: Any]
                showAlert(subTitle: alert["body"] as! String)
            }
        }else{
            if !(Utility().topViewController() is AgentChatViewController) {
                pushToChatController(data: userInfo as NSDictionary)
            }
            
        }
        
    }
    
}

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
//        print(userInfo)
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("Handle push from background or closed")
//        // if you set a member variable in didReceiveRemoteNotification, you  will know if this is from closed or background
//        print("\(response.notification.request.content.userInfo)")
//
//
//        let notificationData = response.notification.request.content.userInfo["aps"] as! NSDictionary
//        let alert = notificationData["alert"] as! NSDictionary
//        let extraPayLoad = notificationData["extraPayLoad"] as! NSDictionary
//
//        if extraPayLoad["action_type"] as! String == "post_event" {
//            pushToEventDetailController(data: extraPayLoad)
//        }else{
//            showAlert(subTitle: alert["body"] as! String)
//        }
     
        print(userInfo)
        
        if let action_type = userInfo["action_type"] as? String {
            if action_type == "post_event" {
                pushToEventDetailController(data: userInfo as NSDictionary)
            }else{
                let aps =  userInfo["aps"]! as! [AnyHashable: Any]
                let alert = aps["alert"]! as! [AnyHashable: Any]
                showAlert(subTitle: alert["body"] as! String)
            }
        }else{
            
        }
        
//        if userInfo["action_type"] as! String == "post_event" {
//            pushToEventDetailController(data: userInfo as NSDictionary)
//        }else{
//            let aps =  userInfo["aps"]! as! [AnyHashable: Any]
//            let alert = aps["alert"]! as! [AnyHashable: Any]
//            showAlert(subTitle: alert["body"] as! String)
//        }

        
    }

    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
        Singleton.sharedInstance.deviceToken = fcmToken
        if Singleton.sharedInstance.isUserLoggedInApp(){
          //  CommonServices.shared.registerPushNotification(UDID: (UIDevice.current.identifierForVendor?.uuidString)!, fcmToken: fcmToken)
        }
        
        
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
extension AppDelegate {
    
    @available(iOS 9.0, *)
        func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
            -> Bool {
                print(url.path)
                let facebookDidHandle = ApplicationDelegate.shared.application(application,open: url,options: options)

                //let googleDidhandle = GIDSignIn.sharedInstance().handle(url)

                let twitterDidHandle = TWTRTwitter.sharedInstance().application(application, open: url, options: options)

                return /*googleDidhandle ||*/ facebookDidHandle || twitterDidHandle
                
        }
        
        
        func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
            print(url.path)
            
            if TWTRTwitter.sharedInstance().application(application, open: url, options: [:]){
                return true
            }
            return false
            //return GIDSignIn.sharedInstance().handle(url)
        }
    
}


