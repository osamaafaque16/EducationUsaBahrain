//
//  SplashController.swift
//  LetsGo
//
//  Created by Muzamil Hassan on 12/19/17.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//

import UIKit
import RealmSwift
import Shimmer

class SplashController: BaseController {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var imgViewLogo2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.imageViewLogo.alpha = 0.0
        self.imgViewLogo2.alpha = 0.0
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showAnimateImg1()

        
//        UIView.animate(withDuration: 1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
//            self.imageViewLogo.alpha = 1.0
//        }) { (success) in
//            let shimmerView = FBShimmeringView(frame: self.imageViewLogo.frame)
//            shimmerView.contentView = self.imageViewLogo
//            self.view.addSubview(shimmerView)
//           // shimmerView.shimmeringBeginFadeDuration = 0.3
//            
//            shimmerView.shimmeringSpeed = 150
//            shimmerView.shimmeringPauseDuration = 0.1
//            //shimmerView.shimmeringHighlightLength = 1
//            shimmerView.isShimmering = true
//            self.delay(3) {
//                
//                self.checkUserLoggedIn()
//            }
//        }
        
    
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    func showAnimateImg1()
    {
        
        self.imageViewLogo.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1.5, animations: {
            
            self.imageViewLogo.alpha = 1
            self.imageViewLogo.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        })
        { (success) in
            
            UIView.animate(withDuration: 0.5, animations: {
                self.imageViewLogo.frame.origin.x = 0.088*Constants.kWINDOW_WIDTH
                
            }, completion: { (success) in
                
                self.imgViewLogo2.frame.origin = CGPoint(x: self.imageViewLogo.frame.maxX + 10, y: self.imageViewLogo.frame.minY)
                self.imgViewLogo2.center = CGPoint(x: self.imgViewLogo2.center.x, y: self.imageViewLogo.center.y + 15)
                self.showAnimationImg2()
                
            })
        
           
        }
    }
    
    func showAnimationImg2() {
        
        UIView.animate(withDuration: 1, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.imgViewLogo2.alpha = 1.0
        }) { (success) in
            self.delay(1) {
                
               self.checkUserLoggedIn()
            }
        }
    }
    
    func checkUserLoggedIn(){
        
//        let realm = try! Realm()
//        Singleton.sharedInstance.userData = realm.objects(UserUser.self).first
        
//            let value = Constants.USER_DEFAULTS.value(forKey: "check") as? Bool
//
//            if value == nil {
//                print("App First Time Open")
//                callGuestSignInServicesss()
//                Constants.USER_DEFAULTS.set(true, forKey: "check")
//            }
//            else{
                print("Login Flow")
                let userDefaults = UserDefaults.standard
                if let token  = userDefaults.object(forKey: "token") as? String {
                    Singleton.sharedInstance.accessToken = token
                }

                if Singleton.sharedInstance.userData != nil {

                    UserDefaults.standard.removeObject(forKey: "check")
                    let mainViewController = AppConstants.APP_STORYBOARD.HOME.instantiateInitialViewController()
                    Constants.APP_DELEGATE.ShowHomeController(mainViewController!)
                }
                
                let guest = UserDefaults.standard.value(forKey: "check") as? String

                 if guest == "0"{
                    callGuestSignInServicesss()
                    let mainViewController = AppConstants.APP_STORYBOARD.HOME.instantiateInitialViewController()
                    Constants.APP_DELEGATE.ShowHomeController(mainViewController!)
                }
                    
                if Singleton.sharedInstance.userData == nil {

                    //  UserDefaults.standard.removeObject(forKey: "check")
                     let loginVC = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "loginNavigation")
                     Constants.APP_DELEGATE.ShowHomeController(loginVC)
                }
                    
        
                
//                else{
//                   // UserDefaults.standard.removeObject(forKey: "check")
//                    let loginVC = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "loginNavigation")
//                    Constants.APP_DELEGATE.ShowHomeController(loginVC)
//
//                }
 //          }
    }
}

extension SplashController {

    func callGuestSignInServicesss() {

    self.view.endEditing(true)

       if !Connectivity.isConnectedToInternet {
           self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
           return
       }

       let parameter = [
           "device_type" : "ios",
           "device_token" : Singleton.sharedInstance.deviceToken
       ]
       print(parameter)
       self.showNormalHud(NSLocalizedString("Loading...", comment: ""))

       UserBase.signIn_SignUp(urlPath:BASE_URL+GUEST_SIGNIN, parameters: parameter, header: nil, vc: self) { (user) in

           self.removeNormalHud()

           if user.code != 200  {
               self.view.makeToast(user.message, duration: 1.5, position: .center)
               return
           }


           Singleton.sharedInstance.isGuest = true
           Singleton.sharedInstance.userData = user.result?.guest
           Singleton.sharedInstance.accessToken = user.result?.guest?.token
           let mainViewController = AppConstants.APP_STORYBOARD.HOME.instantiateInitialViewController()
           Constants.UIWINDOW?.rootViewController = mainViewController
           UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)


       }
    }
}
