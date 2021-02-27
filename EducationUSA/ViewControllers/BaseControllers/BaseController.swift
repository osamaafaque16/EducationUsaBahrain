//
//  BaseController.swift
//  Template
//
//  Created by Muzamil Hassan on 02/01/2017.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//

import UIKit
import Hero
import FCAlertView
import JGProgressHUD
import RealmSwift
//import Toast_Swift
var kSomeKey = "s"
var kIndex = "s"

class BaseController: UIViewController ,FCAlertViewDelegate{

    var HUD:JGProgressHUD! = nil
    var currentController: Controllers!
    var lblTitle: UILabel!
    var viewSearchBar: UIView!
    var txtSearch: UITextField?
    var alertType:String!
    
    override func viewWillDisappear(_ animated: Bool) {
    
//        if (currentController != Controllers.searchUser) {
//            
//            if (viewSearchBar != nil) {
//                viewSearchBar.removeFromSuperview()
//                viewSearchBar = nil
//            }
//        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        Hero.shared.containerColor = UIColor(patternImage: UIImage(named: "bg1")!)
       // Hero.shared.setContainerColorForNextTransition(UIColor(patternImage: UIImage(named: "bg1")!))
//        UIApplication.shared.statusBarStyle = .default
//        self.navigationController?.navigationBar.tintColor = AppConstants.NavigationColor
        //UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarStyle = .lightContent

        if (currentController == Controllers.Splash) {
            
        }
        else if (currentController == Controllers.SignIn) {
            
        }else if (currentController == Controllers.SignUp) {
            
        }else if (currentController == Controllers.ForgotPassword) {
            lblTitle.text = NSLocalizedString("Forgot Password", comment: "")
        }else if (currentController == Controllers.Home) {
            lblTitle.text = ""//NSLocalizedString("Home", comment: "")
            let logoContainer = UIView(frame: CGRect(x: 2, y: 0, width: 130, height: 50))
            let imageView = UIImageView(frame: CGRect(x: 2, y: -5, width: 130, height: 44))
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "footer-logo")
            logoContainer.addSubview(imageView)
            self.navigationItem.titleView = logoContainer
            
            
        }else if (currentController == Controllers.Events) {
            lblTitle.text = NSLocalizedString("Education Events Title", comment: "")
        }else if (currentController == Controllers.EventDetail) {
            //lblTitle.text = "Events"
        }else if (currentController == Controllers.Notification) {
            lblTitle.text = NSLocalizedString("Notifications Title", comment: "")
        }else if (currentController == Controllers.EducationGuide) {
            lblTitle.text = NSLocalizedString("EDUCATION GUIDELINE BOOK TITLE", comment: "")
        }else if (currentController == Controllers.Settings) {
            lblTitle.text = NSLocalizedString("Settings", comment: "")
        }else if (currentController == Controllers.Profile) {
            lblTitle.text = NSLocalizedString("ProfileTitle", comment: "")
        }else if (currentController == Controllers.EditProfile) {
            lblTitle.text = NSLocalizedString("EditProfileTitle", comment: "")
        }else if (currentController == Controllers.ChangePassword) {
            lblTitle.text = NSLocalizedString("Change Password", comment: "")
        }else if (currentController == Controllers.ResetPasssword) {
            lblTitle.text = NSLocalizedString("Reset Passsword", comment: "")
        }else if (currentController == Controllers.FAQS) {
            lblTitle.text = NSLocalizedString("Frequently Asked Question Title", comment: "")
        }else if (currentController == Controllers.TermsAndCondition) {
            lblTitle.text = NSLocalizedString("Terms and Conditions Title", comment: "")
        }else if (currentController == Controllers.ContactUs) {
            lblTitle.text = NSLocalizedString("CONSULT ADVISER TITLE", comment: "")
        }
        else if (currentController == Controllers.About) {
            lblTitle.text = NSLocalizedString("About", comment: "")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navController = self.navigationController {
            for view in (navController.navigationBar.subviews) {
                
                if (view.tag == 10) {
                    lblTitle = view as! UILabel
                }
            }
            
            if (lblTitle == nil) {
                //print(self.navigationController?.navigationBar.subviews)
                lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-100, height: (self.navigationController?.navigationBar.frame.size.height)!))
                lblTitle.center.x = self.view.center.x
                lblTitle.textAlignment = NSTextAlignment.center
                //lblTitle.text = "Test"
                lblTitle.font = UIFont (name: "Archivo-Bold", size: 17)
                lblTitle.textColor = UIColor.white//AppConstants.TitleGrayTextColor
                lblTitle.tag = 10
                self.navigationController?.navigationBar.addSubview(lblTitle)
                
            }
        }


        if (currentController == Controllers.Splash) {
            
        }
        else if (currentController == Controllers.SignIn) {
            
            
        }else if (currentController == Controllers.SignUp) {
            
        }else if (currentController == Controllers.ForgotPassword) {
            createBackarrow()
        }else if (currentController == Controllers.Home) {
            createHomeButtons()
        }else if (currentController == Controllers.Events) {
            createBackarrow()
            createSearchButton()
        }else if (currentController == Controllers.EventDetail) {
            createBackarrow()
        }else if (currentController == Controllers.Notification) {
            createBackarrow()
        }else if (currentController == Controllers.EducationGuide) {
            createBackarrow()
            createSearchButton()
        }else if (currentController == Controllers.Settings) {
            createBackarrow()
        }else if (currentController == Controllers.Profile) {
            createBackarrow()
        }else if (currentController == Controllers.EditProfile) {
            createBackarrow()
        }else if (currentController == Controllers.ChangePassword) || (currentController == Controllers.ResetPasssword) || (currentController == Controllers.ContactUs) || (currentController == Controllers.TermsAndCondition) || (currentController == Controllers.About){
            createBackarrow()
        }else if (currentController == Controllers.About){
            createBackarrow()
        }else if (currentController == Controllers.FAQS) {
            createBackarrow()
            createSearchButton()
        }
        
    }
    func getCurrentDateStr()-> String{
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .medium
        formatter.string(from: currentDateTime)
        return formatter.string(from: currentDateTime)
    }
    
    func commentListButtons() {
        
        let imgAdd: UIImage = UIImage(named: "add-top")!
        let btnAdd: UIButton = UIButton(type: .custom)
        btnAdd.bounds = CGRect(x: 0, y: 0, width: imgAdd.size.width, height: imgAdd.size.height)
        btnAdd.setImage(imgAdd, for: UIControlState())
        btnAdd.addTarget(self, action: #selector(BaseController.newMessageScreen), for: .touchUpInside)
        let btnAddItem: UIBarButtonItem = UIBarButtonItem(customView: btnAdd)
        self.navigationItem.rightBarButtonItem = btnAddItem
    }

    func createBackarrow()  {
        
        let imgBack: UIImage = UIImage(named: "back_btn")!
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.bounds = CGRect(x: 0, y: 0, width: imgBack.size.width+20, height: imgBack.size.height+20)
        btnBack.setImage(imgBack, for: UIControlState())
        btnBack.addTarget(self, action: #selector(BaseController.popViewController), for: .touchUpInside)
        let btnBackItem: UIBarButtonItem = UIBarButtonItem(customView: btnBack)
        
        self.navigationItem.leftBarButtonItem = btnBackItem
    }
    

    func createHomeButtons() {
        
        let imgSetting: UIImage = UIImage(named: "settings")!
        let btnSetting: UIButton = UIButton(type: .custom)
        btnSetting.bounds = CGRect(x: 0, y: 0, width: imgSetting.size.width, height: imgSetting.size.height)
        btnSetting.setImage(imgSetting, for: UIControlState())
        btnSetting.addTarget(self, action: #selector(BaseController.ShowSettingScreen), for: .touchUpInside)
        let btnSettingItem: UIBarButtonItem = UIBarButtonItem(customView: btnSetting)
        self.navigationItem.leftBarButtonItem = btnSettingItem
        
        let imgSearch: UIImage = UIImage(named: "search")!
        let btnSearch: UIButton = UIButton(type: .custom)
        btnSearch.bounds = CGRect(x: 0, y: 0, width: imgSearch.size.width+10, height: imgSearch.size.height)
        btnSearch.setImage(imgSearch, for: UIControlState())
        btnSearch.addTarget(self, action: #selector(BaseController.showCommentListing), for: .touchUpInside)
        let btnSearchItem: UIBarButtonItem = UIBarButtonItem(customView: btnSearch)
        
        let imgNotification: UIImage = UIImage(named: "notification")!
        let btnNotification: UIButton = UIButton(type: .custom)
        btnNotification.bounds = CGRect(x: 0, y: 0, width: imgNotification.size.width+10, height: imgNotification.size.height)
        btnNotification.setImage(imgNotification, for: UIControlState())
        btnNotification.addTarget(self, action: #selector(BaseController.showNotificationController), for: .touchUpInside)
        let btnNotificationItem: UIBarButtonItem = UIBarButtonItem(customView: btnNotification)

        self.navigationItem.rightBarButtonItems = [btnNotificationItem]
    }
    
    func createNotificationButton() {
        
        let imgNotification: UIImage = UIImage(named: "notification")!
        let btnNotification: UIButton = UIButton(type: .custom)
        btnNotification.bounds = CGRect(x: 0, y: 0, width: imgNotification.size.width+10, height: imgNotification.size.height)
        btnNotification.setImage(imgNotification, for: UIControlState())
        btnNotification.addTarget(self, action: #selector(BaseController.showNotificationController), for: .touchUpInside)
        let btnNotificationItem: UIBarButtonItem = UIBarButtonItem(customView: btnNotification)
        
        self.navigationItem.rightBarButtonItem = btnNotificationItem
    }
    
    func createSearchButton() {
        
        let imgSearch: UIImage = UIImage(named: "search")!
        let btnSearch: UIButton = UIButton(type: .custom)
        btnSearch.bounds = CGRect(x: 0, y: 0, width: imgSearch.size.width+10, height: imgSearch.size.height)
        btnSearch.setImage(imgSearch, for: UIControlState())
        btnSearch.addTarget(self, action: #selector(BaseController.searchPressed), for: .touchUpInside)
        let btnSearchItem: UIBarButtonItem = UIBarButtonItem(customView: btnSearch)
        
        self.navigationItem.rightBarButtonItem = btnSearchItem
    }
    
    func createSearchBarView() {
        
        
        // //print(self.navigationItem.leftBarButtonItem)
        viewSearchBar = UIView(frame: CGRect(x: 0, y: 0, width: (self.navigationController?.navigationBar.frame.size.width)!, height: (self.navigationController?.navigationBar.frame.size.height)!))

        viewSearchBar.backgroundColor = AppConstants.NAV_BAR_COLOR//Utility.UIColorFromRGB(rgbValue: 0x003566)
        //viewSearchBar.backgroundColor = UIColor.green
        
        let imgBack: UIImage = UIImage(named: "back_btn")!
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.setImage(imgBack, for: UIControlState())
        btnBack.center.y = viewSearchBar.center.y
        btnBack.addTarget(self, action: #selector(BaseController.popViewController), for: .touchUpInside)
        viewSearchBar.addSubview(btnBack)
        
        //        let txtBg: UIImage = #imageLiteral(resourceName: "search-box")
        //        let imgSearchBg = UIImageView(image: txtBg)
        //        imgSearchBg.frame = CGRect(x: 0  , y: 0, width: txtBg.size.width, height: txtBg.size.height)
        //        //imgLogo.tag = 2
        //        imgSearchBg.center = viewSearchBar.center
        //        viewSearchBar.addSubview(imgSearchBg)
        
        txtSearch = UITextField(frame: CGRect(x: imgBack.size.width + 51 , y: 10, width: (self.navigationController?.navigationBar.frame.size.width)!*0.68, height: (self.navigationController?.navigationBar.frame.size.height)!-20))
        txtSearch?.borderStyle = .none
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: (txtSearch?.frame.height)! - 1, width: (txtSearch?.frame.width)!, height:1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        txtSearch?.layer.addSublayer(bottomLine)
        txtSearch?.backgroundColor = UIColor.clear
        txtSearch?.font = UIFont (name: "Roboto-Regular", size: 13)
        txtSearch?.textColor = UIColor.white
        txtSearch?.keyboardType = .default
        txtSearch?.autocorrectionType = .no
        txtSearch?.returnKeyType = .search
        txtSearch?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Search", comment: ""), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
        
        viewSearchBar.addSubview(txtSearch!)
        
        
        let imgCancel: UIImage = #imageLiteral(resourceName: "cancel")
        let btnCancel: UIButton = UIButton(type: .custom)

        let pre = Locale.preferredLanguages[0]
        if pre.hasPrefix("en") {
            btnBack.frame = CGRect(x: 6, y: 0, width: imgBack.size.width + 20, height: imgBack.size.height + 20)
        }else{
            btnBack.frame = CGRect(x: (txtSearch?.frame.size.width)! + (txtSearch?.frame.origin.x)! + 20, y: 3, width: imgBack.size.width + 20, height: imgBack.size.height + 20)
        }
        
        if pre.hasPrefix("en") {
            btnCancel.frame = CGRect(x: (txtSearch?.frame.size.width)! + (txtSearch?.frame.origin.x)! + 10, y: 0, width: imgCancel.size.width + 20, height: imgCancel.size.height + 20)
        }else{
            btnCancel.frame = CGRect(x: 16, y: 0, width: imgCancel.size.width + 20, height: imgCancel.size.height + 20)
        }

        btnCancel.setImage(imgCancel, for: UIControlState())
        btnCancel.center.y = viewSearchBar.center.y
        btnCancel.addTarget(self, action: #selector(BaseController.cancelSearchBar), for: .touchUpInside)
        viewSearchBar.addSubview(btnCancel)
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFromBottom
        //transition.subtype = kCATransition
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.navigationBar.layer.add(transition, forKey: nil)
        self.navigationController?.navigationBar.addSubview(self.viewSearchBar)
        //        self.viewSearchBar.transform = CGAffineTransform(scaleX: -1, y: 1)
        //        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
        //            self.viewSearchBar.transform = CGAffineTransform(scaleX: 1, y: 1)
        //        }, completion: nil)
        
        
        // self.navigationController?.navigationBar.addSubview(viewSearchBar)
    }
    
    @objc func cancelSearchBar() {
        
    }
    
    @objc func searchPressed() {
        
    }
    
    @objc func showNotificationController() {
        if Singleton.sharedInstance.isGuest == true {
            
            self.showAlert(title: NSLocalizedString("Alert!", comment: ""), subTitle: NSLocalizedString("To view notifications, Kindly login", comment: ""), doneBtnTitle: nil, buttons: [NSLocalizedString("Login", comment: ""),NSLocalizedString("Cancel", comment: "")], type: "guest")
            
        }else{
            let controller = AppConstants.APP_STORYBOARD.SETTING.instantiateViewController(withIdentifier: "NotificationController")
            self.navigationController?.pushViewController(controller, animated: true)
        }
    
    }
    @objc func newMessageScreen() {
        
        let controller = Constants.VIEWCONTROLLER_WITH_IDENTIFIER("NewMessageController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func ShowSettingScreen() {
        
        let controller = AppConstants.APP_STORYBOARD.SETTING.instantiateViewController(withIdentifier: "SettingsController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func searchScreen() {
        
        let controller = Constants.VIEWCONTROLLER_WITH_IDENTIFIER("SearchController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func showCommentListing() {
        
        let controller = Constants.VIEWCONTROLLER_WITH_IDENTIFIER("CommentListController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @objc func popViewController() {
        _ = self.navigationController?.popViewController(animated: true);
    }
    func popToRootViewController() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showAlert(title:String? , subTitle:String? , doneBtnTitle:String? , buttons:[String]? ,type:String?) {
        
         //UILabel.amx_autoScaleFont(forReferenceScreenSize: .size5p5Inch)
        
        alertType = type
        
        let alert = FCAlertView();
        
        alert.delegate = self
        
        alert.showAlert(inView: self,
                        withTitle:title,
                        withSubtitle:subTitle,
                        withCustomImage:#imageLiteral(resourceName: "popupLogo"),
                        withDoneButtonTitle:doneBtnTitle,
                        andButtons:buttons)
        
        
        //alert.cornerRadius = CGFloat(4.0)
        alert.colorScheme = Utility.UIColorFromRGB(rgbValue: 0x032951)
        alert.hideSeparatorLineView = true
        alert.detachButtons = true
        alert.subTitleColor = UIColor.darkGray
        alert.titleColor = Utility.UIColorFromRGB(rgbValue: 0x032951)
        alert.firstButtonTitleColor = .white
        alert.secondButtonTitleColor = .white
        alert.firstButtonBackgroundColor = Utility.UIColorFromRGB(rgbValue: 0x032951)
        alert.secondButtonBackgroundColor = Utility.UIColorFromRGB(rgbValue: 0x032951)
        
        if alertType != "general" {
            alert.hideDoneButton = true
        }
    }
    //FCAlertView Delegate
    func fcAlertView(_ alertView: FCAlertView, clickedButtonIndex index: Int, buttonTitle title: String) {
        
        if index == 0 {
            // Set Root Controller
            if alertType == "guest" {
                let mainViewController = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "loginNavigation")
                Constants.UIWINDOW?.rootViewController = mainViewController
                UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            }else if alertType == "logout" {
                callLogoutService()

            }
    
            
        }else if index == 1{
            //UILabel.amx_autoScaleFont(forReferenceScreenSize: .size4p7Inch)
            alertView.dismiss()
        }
    }
    
    
    func showNormalHud(_ message : String) {
        HUD = JGProgressHUD.init(style: .dark)
        HUD.textLabel.text = message
        HUD.show(in: Constants.UIWINDOW!)
    }
    func removeNormalHud() {
        if HUD != nil {
            HUD.dismiss()
        }
    }
    
    func updateTick() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- API
    
    func callLogoutService(){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        //remove device token for push
        CommonServices.shared.registerPushNotification(UDID: (UIDevice.current.identifierForVendor?.uuidString)!, fcmToken: "asd123")
        
        let header = ["Authorization" : "Bearer "+(Singleton.sharedInstance.accessToken)!]
        let params = ["device_token" : Singleton.sharedInstance.deviceToken]
        
        self.showNormalHud("")
        
        
        UserBase.signIn_SignUp(urlPath: BASE_URL+LOGOUT, parameters: params, header: header, vc: self) { (data) in
            self.removeNormalHud()
            
            if data.code != 200  {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            let realm = try! Realm()
            try! realm.write {
                realm.delete(Singleton.sharedInstance.userData!)
            }
            
            
            UserDefaults.standard.removeObject(forKey: "token")
            
            let mainViewController = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "loginNavigation")
            Constants.UIWINDOW?.rootViewController = mainViewController
            UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            
            
        }
        
        
    }



}
