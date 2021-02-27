//
//  SignupViewController.swift
//  EducationUSA
//
//  Created by XEONCITY on 23/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import Hero
import RealmSwift

class SignupViewController: BaseController , UITextFieldDelegate {
    
    // MARK: - IBOutlets
    //TextFields
    @IBOutlet weak var txtFldFullName: UITextField!
    @IBOutlet weak var txtFldEmail: UITextField!
    @IBOutlet weak var txtFldPassword: UITextField!
    @IBOutlet weak var txtFldConfirmPassword: UITextField!
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passView: UIView!
    @IBOutlet weak var confirmPassView: UIView!
    
    
    //Labels
    @IBOutlet weak var lblErrorFullname: UILabel!
    @IBOutlet weak var lblErrorEmail: UILabel!
    @IBOutlet weak var lblErrorPassword: UILabel!
    @IBOutlet weak var lblErrorConfirmPass: UILabel!

    @IBOutlet weak var roundedView: UIView!
    //MARK:- Variabels
    var isValidate = true
    
    @IBOutlet weak var btnSignUp: UIButton!
    // MARK: - ViewCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnSignUp.layer.shadowRadius = 3.0
        btnSignUp.layer.shadowColor = UIColor.black.cgColor
        btnSignUp.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnSignUp.layer.shadowOpacity = 0.2
        btnSignUp.layer.masksToBounds = false
        
        roundedView.layer.shadowRadius = 2.0
        roundedView.layer.shadowColor = UIColor.black.cgColor
        roundedView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        roundedView.layer.shadowOpacity = 0.1
        roundedView.layer.masksToBounds = false
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtFldPassword.placeholder = NSLocalizedString("Choose Password", comment: "")
        lblErrorFullname.text = ""
        lblErrorEmail.text = ""
        lblErrorPassword.text = ""
        lblErrorConfirmPass.text = ""
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - IBActions
    
    @IBAction func signupClicked(_ sender: Any) {
        
        isValidate = true
        
        if (!Validation.validateStringLength(txtFldFullName.text!)) {
            lblErrorFullname.text = NSLocalizedString("Full name is required", comment: "")
            isValidate = false
            nameView.shake()
        }
        
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
            passView.shake()
        }else if (txtFldPassword.text?.characters.count)! < 6{
            lblErrorPassword.text = NSLocalizedString("Min. length of password should be 6 characters", comment: "")
            isValidate = false
            passView.shake()
        }
        
        if (!Validation.validateStringLength(txtFldConfirmPassword.text!)) {
            lblErrorConfirmPass.text = NSLocalizedString("Confirm password is required", comment: "")
            isValidate = false
            confirmPassView.shake()
        }else if txtFldPassword.text != txtFldConfirmPassword.text {
            lblErrorConfirmPass.text = NSLocalizedString("Confirm password not matched", comment: "")
            isValidate = false
            confirmPassView.shake()
        }
        
        
        if isValidate {
            print("Validation sucess")
            callSignUpService()
        }
    }

    @IBAction func gotoSigninClicked(_ sender: Any) {
       //  Hero.shared.setDefaultAnimationForNextTransition(.fade)
        Hero.shared.defaultAnimation = .fade
        txtFldPassword.placeholder = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - APIS
    
    func callSignUpService() {
        self.view.endEditing(true)
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        
        let parameter:[String : Any] = [
            "name" : txtFldFullName.text!,
            "email" : txtFldEmail.text!,
            "password" : txtFldPassword.text!,
            "password_confirmation" : txtFldConfirmPassword.text!,
            "device_type" : "ios",
            "device_token" : Singleton.sharedInstance.deviceToken
        ]
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        UserBase.signIn_SignUp(urlPath:BASE_URL+SIGNUP , parameters: parameter, header: nil, vc: self) { (user) in
            
            self.removeNormalHud()
            
            if user.code != 200 {
                self.view.makeToast(user.message ?? NSLocalizedString("some thing wrong", comment: ""), duration: 1, position: .center)
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
    
    // MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool{
        
        
        
        let currentCharacterCount = textField.text?.characters.count ?? 0
        
        if (range.length + range.location > currentCharacterCount)
        {
            return false
        }
        
        let newLength = currentCharacterCount + string.characters.count - range.length
        var maxLength = 50
        
        if (textField == txtFldFullName)
        {
            maxLength = 20
            self.lblErrorFullname.text = ""
        }
        if (textField == txtFldEmail)
        {
            self.lblErrorEmail.text = ""
        }
        if (textField == txtFldPassword)
        {
            self.lblErrorPassword.text = ""
        }
        if (textField == txtFldConfirmPassword)
        {
            self.lblErrorConfirmPass.text = ""
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
