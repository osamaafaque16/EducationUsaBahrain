//
//  SettingsController.swift
//  Kitchenesta
//
//  Created by Muzamil Hassan on 07/09/2017.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//

import UIKit
import EZAlertController
import RealmSwift



class SettingsController: BaseController , UITableViewDataSource, UITableViewDelegate , SettingCellDelegate{
    
    
    struct settings {
        var settingsOptions: String?
        var optionImage:String?
        var englishLanguage: String?
        var arabiLanguage: String?
        //var changeLanguage: UIButton?
    }
    
    var settingOptions = [settings]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad(){
        currentController = Controllers.Settings
        super.viewDidLoad()
        
        if Singleton.sharedInstance.isGuest == true {
            settingOptions = [
                            settings(settingsOptions: NSLocalizedString("Terms and Conditions", comment: ""), optionImage:"set_terms_icon", englishLanguage: "", arabiLanguage: ""),
                            //  settings(settingsOptions: NSLocalizedString("Language", comment: ""), optionImage:"set_lanuage_icon", englishLanguage: NSLocalizedString("EN", comment: ""), arabiLanguage: NSLocalizedString("AR", comment: "")),
                             settings(settingsOptions: NSLocalizedString("About", comment: ""), optionImage:"set_about_icon", englishLanguage: "", arabiLanguage: ""),
                              settings(settingsOptions: NSLocalizedString("Login", comment: ""), optionImage:"set_logout_icon", englishLanguage: "", arabiLanguage: "")]
        }else{
            settingOptions = [settings(settingsOptions: NSLocalizedString("Notifications", comment: ""), optionImage:"set_not_icon", englishLanguage: "", arabiLanguage: ""),
                            //  settings(settingsOptions: NSLocalizedString("Change Password", comment: ""), optionImage:"set_password_icon", englishLanguage: "", arabiLanguage: ""),
                              settings(settingsOptions: NSLocalizedString("Profile", comment: ""), optionImage:"set_profile_icon", englishLanguage: "", arabiLanguage: ""),
                              settings(settingsOptions: NSLocalizedString("Terms and Conditions", comment: ""), optionImage:"set_terms_icon", englishLanguage: "", arabiLanguage: ""),
                               settings(settingsOptions: NSLocalizedString("About", comment: ""), optionImage:"set_about_icon", englishLanguage: "", arabiLanguage: ""),
                            //  settings(settingsOptions: NSLocalizedString("Language", comment: ""), optionImage:"set_lanuage_icon", englishLanguage: NSLocalizedString("EN", comment: ""), arabiLanguage: NSLocalizedString("AR", comment: "")),
                              settings(settingsOptions: NSLocalizedString("Logout", comment: ""), optionImage:"set_logout_icon", englishLanguage: "", arabiLanguage: "")]
        }
        

        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingOptions.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as! SettingsTableViewCell
        
        cell.lblSettingsOptions.text = settingOptions[indexPath.row].settingsOptions
        cell.imgViewOption?.image = UIImage(named: settingOptions[indexPath.row].optionImage!)
        cell.lblEnglish.text = settingOptions[indexPath.row].englishLanguage
        cell.lblArabi.text = settingOptions[indexPath.row].arabiLanguage
        
        cell.delegate = self
        
        if Singleton.sharedInstance.isGuest == true {
            
            if indexPath.row == 1 {
                cell.btnChangeLanguage.isHidden = false
                
                let pre = Locale.preferredLanguages[0]
                if pre.hasPrefix("en") {
                    cell.btnChangeLanguage.isSelected = false
                }else{
                    cell.btnChangeLanguage.isSelected = true
                }
                
            }

        }else{
            if indexPath.row == 0 {
                cell.btnChangeLanguage.setImage(#imageLiteral(resourceName: "toggleoff"), for: .normal)
                cell.btnChangeLanguage.setImage(#imageLiteral(resourceName: "toggleon"), for: .selected)
                cell.btnChangeLanguage.isHidden = false
                cell.btnChangeLanguage.isSelected = Singleton.sharedInstance.userData?.notificationStatus == "1" ? true:false
            }
            
            //todo:Osama
//            if indexPath.row == 4 {
//                cell.btnChangeLanguage.isHidden = false
//
//                let pre = Locale.preferredLanguages[0]
//                if pre.hasPrefix("en") {
//                    cell.btnChangeLanguage.isSelected = false
//                }else{
//                    cell.btnChangeLanguage.isSelected = true
//                }
//
//            }
        }
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (Constants.kWINDOW_WIDTH*0.168)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("DID TAP")
        
        if Singleton.sharedInstance.isGuest == true {
            switch indexPath.row {
                
            case settingSelectedGuest.termsAndCondition.rawValue:
                let storyBoard = AppConstants.APP_STORYBOARD.SETTING
                let termsVC = storyBoard.instantiateViewController(withIdentifier: "TermAndConditionController") as! TermAndConditionController
                self.navigationController?.pushViewController(termsVC, animated:true)
                break
            //todo:Osama
            case settingSelectedGuest.about.rawValue:
                let storyBoard = AppConstants.APP_STORYBOARD.SETTING
                let aboutVC = storyBoard.instantiateViewController(withIdentifier: "AboutController") as! AboutController
                self.navigationController?.pushViewController(aboutVC, animated:true)
                break
                
            case settingSelectedGuest.login.rawValue:
                    
                let mainViewController = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "loginNavigation")
                Constants.UIWINDOW?.rootViewController = mainViewController
                UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                break
                
            default:
                print("jshdj")
            }
        }else{
            switch indexPath.row {
                
              //todo:Osama
              //Change Password remove
//            case settingSelected.changePassword.rawValue:
//
//                if Singleton.sharedInstance.isGuest == true {
//                    self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("Guest can't change password.", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Login", comment: ""),NSLocalizedString("Cancel", comment: "")], type: "guest")
//
//                }else{
//                    let storyBoard = AppConstants.APP_STORYBOARD.SETTING
//
//                    let changePassVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
//                    self.navigationController?.pushViewController(changePassVC, animated:true)
//                }
//
//                break
                
            case settingSelected.termsAndCondition.rawValue:
                let storyBoard = AppConstants.APP_STORYBOARD.SETTING
                let termsVC = storyBoard.instantiateViewController(withIdentifier: "TermAndConditionController") as! TermAndConditionController
                self.navigationController?.pushViewController(termsVC, animated:true)
                break
                
                
            case settingSelected.profile.rawValue:
                
                if Singleton.sharedInstance.isGuest == true {
                    
                    self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("To view profile, kindly login.", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Login", comment: ""),NSLocalizedString("Cancel", comment: "")], type: "guest")
                    
                }else{
                    let storyBoard = AppConstants.APP_STORYBOARD.USER
                    
                    let profileVC = storyBoard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
                    self.navigationController?.pushViewController(profileVC, animated:true)
                }
                break
                
            case settingSelected.about.rawValue:
                let storyBoard = AppConstants.APP_STORYBOARD.SETTING
                let aboutVC = storyBoard.instantiateViewController(withIdentifier: "AboutController") as! AboutController
                self.navigationController?.pushViewController(aboutVC, animated:true)
                
            case settingSelected.logout.rawValue:
                
                if Singleton.sharedInstance.isGuest == true {
                    
                    let mainViewController = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "loginNavigation")
                    Constants.UIWINDOW?.rootViewController = mainViewController
                    UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
                }else{
                    self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("Are you sure you want to logout", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Yes", comment: ""),NSLocalizedString("No", comment: "")], type: "logout")
                }
                break
                
                
            default:
                print("jshdj")
            }
        }
    }
    
    
    
    func notificationAction(_ sender: UIButton) {
        
        if Singleton.sharedInstance.isGuest == true {
            self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("For notifications, kindly login.", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Login", comment: ""),NSLocalizedString("Cancel", comment: "")], type: "guest")
            
        }else{
            
            if !Connectivity.isConnectedToInternet {
                self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
                return
            }
            self.showNormalHud("")
            let isOn = sender.isSelected == true ? "1":"0"
            
            let parameters:[String:Any] = [ "user_id" : (Singleton.sharedInstance.userData?.id)!,
                                            "response" :  isOn]
            
            NotificationBase.deleteNotification(urlPath: BASE_URL+NOTI_ON_OFF, parameters: parameters, vc: self) { (data) in
                self.removeNormalHud()
                if data.code != 200 {
                    self.view.makeToast(data.message, duration: 1.5, position: .center)
                    return
                }
                
                //remove device token for push 
                let token = isOn == "0" ? "asd123":Singleton.sharedInstance.deviceToken
                CommonServices.shared.registerPushNotification(UDID: (UIDevice.current.identifierForVendor?.uuidString)!, fcmToken: token)
                
                //sender.isSelected = !sender.isSelected
                
                let realm = try! Realm()
                try! realm.write {
                    Singleton.sharedInstance.userData?.notificationStatus = isOn
                }
            }
        }

    }
    
    func langChange(_ sender:UIButton) {
        
       
        if sender.isSelected == true {
            sender.isSelected = !sender.isSelected
            let alertController = UIAlertController (title:NSLocalizedString("Restart Required", comment: "") , message: NSLocalizedString("This requires restarting the Application. Are you sure you want to close the app now?", comment: "") , preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default){ (_) -> Void in
                sender.isSelected = !sender.isSelected
            }
            let doneAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (_) -> Void in
                
                //                UserDefaults.standard.set("en", forKey: "lang")
                //                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(0)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            
            
            
            
            //callCategoryService(lang: "ar")
        }else{

            sender.isSelected = !sender.isSelected
            
            let alertController = UIAlertController (title:NSLocalizedString("Restart Required", comment: "") , message: NSLocalizedString("This requires restarting the Application. Are you sure you want to close the app now?", comment: "") , preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .default){ (_) -> Void in
                sender.isSelected = !sender.isSelected
            }
            let doneAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { (_) -> Void in
                
                //                UserDefaults.standard.set("ar", forKey: "lang")
                //                UserDefaults.standard.synchronize()
                
                UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                exit(0)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            
            
            //callCategoryService(lang: "en")
        }
    }
    

    
} // end class

enum settingSelected:Int{
  
   // case changePassword = 1
    case profile = 1
    case termsAndCondition = 2
    case about = 3
    case logout = 4
}
enum settingSelectedGuest:Int{
    
    case termsAndCondition = 0
    case about = 1
    case login = 2
}






