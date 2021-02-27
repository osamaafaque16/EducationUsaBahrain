//
//  SigninViewController.swift
//  EducationUSA
//
//  Created by XEONCITY on 23/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import UITextField_Shake
import UIView_Shake
import Hero
import RealmSwift
import FBSDKLoginKit
import TwitterKit

class SigninViewController: BaseController, UITextFieldDelegate {
    @IBOutlet weak var rounderView: UIView!
    
    @IBOutlet weak var btnSignIn: UIButton!
    // MARK: - IBOutlets
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var lblErrorEmail: UILabel!
    @IBOutlet weak var lblErrorPassword: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    
    // MARK: - Variables
    var isValidate = true
    
    // MARK: - ViewCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //btnSignIn.imageView.layer.cornerRadius = 7.0f;
        btnSignIn.layer.shadowRadius = 3.0
        btnSignIn.layer.shadowColor = UIColor.black.cgColor
        btnSignIn.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnSignIn.layer.shadowOpacity = 0.2
        btnSignIn.layer.masksToBounds = false
        
        rounderView.layer.shadowRadius = 2.0
        rounderView.layer.shadowColor = UIColor.black.cgColor
        rounderView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        rounderView.layer.shadowOpacity = 0.1
        rounderView.layer.masksToBounds = false
        
        
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        lblErrorEmail.text = ""
        lblErrorPassword.text = ""
        txtFldPassword.placeholder = NSLocalizedString("Password", comment: "")
        
    }
    override func viewDidAppear(_ animated: Bool) {
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    
    @IBAction func signinClicked(_ sender: Any) {
        
        isValidate = true
        
        if (!Validation.validateStringLength(txtFldEmail.text!)) {
            lblErrorEmail.text = NSLocalizedString("Email is required", comment: "")
            isValidate = false
            emailView.shake()
        }else if (!Validation.isValidEmail(txtFldEmail.text!)) {
            lblErrorEmail.text = NSLocalizedString("Please provide valid email address", comment: "")
            isValidate = false
            emailView.shake()
        }
        
        if (!Validation.validateStringLength(txtFldPassword.text!)) {
            lblErrorPassword.text = NSLocalizedString("Password is required", comment: "")
            isValidate = false
            passwordView.shake()
        }
        
        if isValidate {
            callSignInService()
        }
        
    }
    
    
    @IBAction func facebookClicked(_ sender: Any) {
        self.loginWithFacebook()
    }
    @IBAction func twitterClicked(_ sender: Any) {
        self.loginWithTwitter()
    }

    @IBAction func guestClicked(_ sender: Any) {
        
        callGuestSignInService()
//        Singleton.sharedInstance.isGuest = true
//        let mainViewController = AppConstants.APP_STORYBOARD.HOME.instantiateInitialViewController()
//        Constants.UIWINDOW?.rootViewController = mainViewController
//        UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }
    
    @IBAction func forgetPasswordClicked(_ sender: Any) {
        //self.navigationController?.heroNavigationAnimationType =
  
        let forgotVC = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotVC, animated:true)
    }
    
    @IBAction func signupClicked(_ sender: Any) {
//        Hero.shared.setDefaultAnimationForNextTransition(.selectBy(presenting: .zoomSlide(direction: .left), dismissing: .zoomSlide(direction: .right)))
        Hero.shared.defaultAnimation = .fade
        //Hero.shared.setDefaultAnimationForNextTransition(.fade)
        
        let signupVC = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        txtFldPassword.placeholder = ""
        
       // hero.replaceViewController(with: vc)
        
        self.navigationController?.pushViewController(signupVC, animated:true)
    }
    
    // MARK: - APIS
    func callSignInService() {
        self.view.endEditing(true)
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        let parameter = [
            "email" : txtFldEmail.text!,
            "password" : txtFldPassword.text!,
            "device_type" : "ios",
            "device_token" : Singleton.sharedInstance.deviceToken
        ]
        print(parameter)
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        UserBase.signIn_SignUp(urlPath:BASE_URL+SIGNIN , parameters: parameter, header: nil, vc: self) { (user) in
            
            self.removeNormalHud()
            
            if user.code != 200  {
                self.view.makeToast(user.message, duration: 1.5, position: .center)
                return
            }
            
            
            Singleton.sharedInstance.isGuest = false
            Singleton.sharedInstance.userData = user.result?.user
            Singleton.sharedInstance.accessToken = user.result?.user?.token
           
            // save user token in userdefault
            let userDefaults = UserDefaults.standard
            userDefaults.set(Singleton.sharedInstance.accessToken, forKey: "token")
            
            
            let realm = try! Realm()
            try! realm.write(){
                realm.add(Singleton.sharedInstance.userData!, update: .all)
            }
            SocketIOManager.sharedInstance.establishConnection()
            // Set Root Controller
            let mainViewController = AppConstants.APP_STORYBOARD.HOME.instantiateInitialViewController()
            Constants.UIWINDOW?.rootViewController = mainViewController
            UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            
            
        }
        
    }
    
   func callGuestSignInService() {
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
    
    // MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool{
        
        
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        
        if (range.length + range.location > currentCharacterCount)
        {
            return false
        }
        
        let newLength = currentCharacterCount + string.characters.count - range.length
        let maxLength = 50
        
        if (textField == txtFldEmail)
        {
            self.lblErrorEmail.text = ""
        }
        if (textField == txtFldPassword)
        {
            self.lblErrorPassword.text = ""
        }
        
        return newLength <= maxLength
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SigninViewController {
    
    
    
    func loginWithFacebook() {
        
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            
            guard let result = result else {
                print("No result found")
                return
            }
            
            guard AccessToken.current != nil else {
                return
            }
            if result.isCancelled {
                print("Cancelled \(error?.localizedDescription ?? "")")
            } else if let error = error {
                print("Process error \(error.localizedDescription)")
            } else {
                print("Logged in")
                self.getFBUserData()
            }
            
        }
    }
    public func getFBUserData(){
        
//        DispatchQueue.main.async {
//            AFNetwork.shared.showSpinner(nil)
//        }
        if AccessToken.current != nil{
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    guard let res = result as? NSDictionary else {return}
                    let FullName = (res["name"] as? String) ?? ""
                    let ProviderKey = (res["id"] as? String) ?? ""
                    var ProfileImage = ""
                    if let picture = res["picture"] as? NSDictionary{
                        if let data = picture["data"] as? NSDictionary{
                            if let url = data["url"] as? String{
                                ProfileImage = "https://graph.facebook.com/\(ProviderKey)/picture?type=large&width=400&height=400"
                                //ProfileImage = url
                            }
                        }
                    }
                    /*
                     social_media_id
                     *social_media_platform(e.g. instagram,facebook,twitter)
                     *name
                     *email
                     *device_type
                     *device_token
                     */
                    let EmailID = (res["email"] as? String) ?? ""
                    let param:[String:Any] = ["name": FullName,
                                                         "email": EmailID,
                                                         "social_media_id": ProviderKey,
                                                         "device_type" : "ios",
                                                         "device_token" : Singleton.sharedInstance.deviceToken,
                                                         "social_media_platform": "facebook"]
                    self.callSocialSignInService(parameter: param, loginType: .facebook)
                }
                else {
//                    DispatchQueue.main.async {
//                        AFNetwork.shared.hideSpinner()
//                    }
                }
            })
        }
    }
    func loginWithTwitter() {

            TWTRTwitter.sharedInstance().logIn { (session, error) in
                
                print(session)
                
                if (session != nil)
                {
//                    DispatchQueue.main.async {
//                        AFNetwork.shared.showSpinner(nil)
//                    }
                    print(session!);
                    print("signed in as \(session!.userName)");
                    
                    let client = TWTRAPIClient.withCurrentUser()
                    let request = client.urlRequest(withMethod: "GET",
                                                    urlString: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                    parameters: ["include_email": "true", "skip_status": "true"],
                                                    error: nil)
                    client.sendTwitterRequest(request) { response, data, connectionError in
                        
                        
                        
                        if (connectionError == nil)
                        {
                            do
                            {
                                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                                let email = json["email"] as? String
                               // self.socialType = "twitter"
                                
                                client.loadUser(withID: session!.userID, completion: { (user, error) in
                                    
                                    let FullName = user?.name ?? ""
                                    let ProviderKey = user?.userID ?? ""
                                    let ProfileImage = user?.profileImageLargeURL ?? ""
                                    let EmailID = email ?? ProviderKey + "@twitter.com"
                                    
                                    print("name: ", FullName)
                                    print("email: ", EmailID)
                                    print("avatar: ", ProfileImage)
                                    print("socialId: ", ProviderKey)
                                    print("JSON response: ", json)
                                    let param:[String:Any] = ["name": FullName,
                                    "email": EmailID,
                                    "social_media_id": ProviderKey,
                                    "device_type" : "ios",
                                    "device_token" : Singleton.sharedInstance.deviceToken,
                                    "social_media_platform": "twitter"]
                                    self.callSocialSignInService(parameter: param, loginType: .twitter)
                                    
                                })
                            }
                            catch
                            {
//                                DispatchQueue.main.async {
//                                    AFNetwork.shared.hideSpinner()
//                                }
                            }
                        }
                        else
                        {
//                            DispatchQueue.main.async {
//                                AFNetwork.shared.hideSpinner()
//                            }
                            print("Error: \(String(describing: connectionError))")
                        }
                    }
                }
                else
                {
                    //Constants.UIWINDOW?.makeToast(NSLocalizedString("Kindly login to your twitter account in setting", comment: ""), duration: 2, position: .center)
    //                self.btnTwitter.isUserInteractionEnabled = true
                    print("error: \(String(describing: error?.localizedDescription))");
                }
            }

            
        }
    
    
    func callSocialSignInService(parameter:[String:Any], loginType : UserSocialLoginType) {
        self.view.endEditing(true)
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        print(parameter)
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        UserBase.signIn_SocialMedia(urlPath:BASE_URL+SOCIAL_LOGIN , parameters: parameter, header: nil, vc: self) { (user) in
            
            self.removeNormalHud()
            
            if user.code != 200  {
                self.view.makeToast(user.message, duration: 1.5, position: .center)
                return
            }
            //CurrentUser.userLoginType = .user
            
            Singleton.sharedInstance.isGuest = false
            Singleton.sharedInstance.userData = user.result?.user
            Singleton.sharedInstance.accessToken = user.result?.user?.token
           
            // save user token in userdefault
            let userDefaults = UserDefaults.standard
            userDefaults.set(Singleton.sharedInstance.accessToken, forKey: "token")
            
            
            let realm = try! Realm()
            try! realm.write(){
                realm.add(Singleton.sharedInstance.userData!, update: .all)
            }
            SocketIOManager.sharedInstance.establishConnection()
            // Set Root Controller
            let mainViewController = AppConstants.APP_STORYBOARD.HOME.instantiateInitialViewController()
            Constants.UIWINDOW?.rootViewController = mainViewController
            UIView.transition(with: Constants.UIWINDOW!, duration: 0.3, options: [.transitionCrossDissolve], animations: nil, completion: nil)
            
            
        }
        
    }
}
enum UserSocialLoginType : Int{
        case facebook = 1
        case twitter = 2
        case google = 3
        case apple = 4
}
