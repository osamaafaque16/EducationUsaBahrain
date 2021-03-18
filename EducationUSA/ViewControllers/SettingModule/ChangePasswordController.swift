//
//  ChangePasswordController.swift
//  EducationUSA
//
//  Created by XEONCITY on 28/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class ChangePasswordController: BaseController ,UITextFieldDelegate{

    @IBOutlet weak var lblTitleConfirmPassword: UITextField!
    @IBOutlet weak var lblTitleNewPassword: UITextField!
    @IBOutlet weak var lblTitleExistingPassword: UITextField!
    @IBOutlet weak var txtfldExistingPass: UITextField!
    @IBOutlet weak var txtfldNewPass: UITextField!
    @IBOutlet weak var txtfldConfirmNewPass: UITextField!
    @IBOutlet weak var lblErrorExistingPass: UILabel!
    @IBOutlet weak var lblErrorNewPass: UILabel!
    @IBOutlet weak var lblErrorConfirmNewPass: UILabel!
    @IBOutlet weak var newPassView: UIView!
    @IBOutlet weak var existingPassView: UIView!
    @IBOutlet weak var confirmPassView: UIView!
    //@IBOutlet weak var lblTagLine: UILabel!
    //@IBOutlet weak var topSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var btnForgot: UIButton!
    
    var fromVerifyCode = false
    var email:String = ""
    var isValidate = true
    
    override func viewDidLoad() {
        if fromVerifyCode {
            currentController = Controllers.ResetPasssword
        }else{
            currentController = Controllers.ChangePassword
        }
        
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        btnForgot.layer.shadowRadius = 3.0
        btnForgot.layer.shadowColor = UIColor.black.cgColor
        btnForgot.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        btnForgot.layer.shadowOpacity = 0.2
        btnForgot.layer.masksToBounds = false
        
        roundedView.layer.shadowRadius = 2.0
        roundedView.layer.shadowColor = UIColor.black.cgColor
        roundedView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        roundedView.layer.shadowOpacity = 0.1
        roundedView.layer.masksToBounds = false
        
        // Do any additional setup after loading the view.
        if fromVerifyCode {
            confirmPassView.isHidden = true
            lblErrorConfirmNewPass.isHidden = true
            //lblTagLine.text = NSLocalizedString("Please enter your new password to reset your password", comment: "")
            txtfldExistingPass.placeholder = NSLocalizedString("Enter New Password", comment: "")
            txtfldNewPass.placeholder = NSLocalizedString("Enter Confirm Password", comment: "")
            
            lblTitleNewPassword.text = txtfldNewPass.placeholder
            lblTitleExistingPassword.text = txtfldExistingPass.placeholder
            //topSpacing.constant = 114
        }else{
            txtfldConfirmNewPass.placeholder = NSLocalizedString("Enter Confirm Password", comment: "")
            lblTitleConfirmPassword.text = txtfldConfirmNewPass.placeholder
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblErrorExistingPass.text = ""
        lblErrorNewPass.text = ""
        lblErrorConfirmNewPass.text = ""

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        isValidate = true
        
        if (!Validation.validateStringLength(txtfldExistingPass.text!)) {
            lblErrorExistingPass.text = NSLocalizedString("This field is required", comment: "")
            isValidate = false
            existingPassView.shake()
        }else if (txtfldExistingPass.text?.characters.count)! < 6{
            lblErrorExistingPass.text = NSLocalizedString("Min. length of password should be 6 characters", comment: "")
            isValidate = false
            existingPassView.shake()
        }
        
        if (!Validation.validateStringLength(txtfldNewPass.text!)) {
            lblErrorNewPass.text = NSLocalizedString("This field is required", comment: "")
            isValidate = false
            newPassView.shake()
        }else if (txtfldNewPass.text?.characters.count)! < 6{
            lblErrorNewPass.text = NSLocalizedString("Min. length of password should be 6 characters", comment: "")
            isValidate = false
            newPassView.shake()
        }

        if fromVerifyCode {
            if txtfldExistingPass.text != txtfldNewPass.text {
                lblErrorNewPass.text = NSLocalizedString("Confirm password not matched", comment: "")
                isValidate = false
                newPassView.shake()
            }
        }else{
            if (!Validation.validateStringLength(txtfldConfirmNewPass.text!)) {
                lblErrorConfirmNewPass.text = NSLocalizedString("This field is required", comment: "")
                isValidate = false
                confirmPassView.shake()
            }else if txtfldNewPass.text != txtfldConfirmNewPass.text {
                lblErrorConfirmNewPass.text = NSLocalizedString("Confirm password not matched", comment: "")
                confirmPassView.shake()
                isValidate = false
                
            }
        }
        
        if isValidate {
            callUpdatePasswordService()
        }
    }
    
    
    // MARK: - APIS
    func callUpdatePasswordService() {
        self.view.endEditing(true)
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        
        var header:[String:String]? //= ["Authorization" : "Bearer "+(Singleton.sharedInstance.accessToken ?? "")]
        
        var parameter = [String:Any]()
        var updatePassUrl = ""
        
        if fromVerifyCode {

            header = nil
            parameter = [
                "email" : email,
                "password" : txtfldExistingPass.text!,
                "password_confirmation" : txtfldNewPass.text!,
                "device_token" : Singleton.sharedInstance.deviceToken
            ]
            updatePassUrl = BASE_URL+RESET_PASS
            
        }else{
            header = ["Authorization" : "Bearer "+(Singleton.sharedInstance.accessToken)!]
            parameter = [
                "user_id" : String(describing: (Singleton.sharedInstance.userData?.id)!),
                "password" : txtfldNewPass.text!,
                "old_password" : txtfldExistingPass.text!,
                "device_token" : Singleton.sharedInstance.deviceToken
            ]
            updatePassUrl = BASE_URL+CHANGE_PASS
        }
        
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        UserBase.signIn_SignUp(urlPath:updatePassUrl , parameters: parameter, header: header, vc: self) { (user) in
            
            self.removeNormalHud()
            
            if user.code != 200 {
                self.view.makeToast(user.message, duration: 1.5, position: .center)
                return
            }
            
            Constants.UIWINDOW?.makeToast(user.message, duration: 1.5, position: .center)
            if self.fromVerifyCode {
                self.popToRootViewController()
            }else{
                self.popViewController()
            }
            
            
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
        let maxLength = 15
        
        if (textField == txtfldExistingPass)
        {
            self.lblErrorExistingPass.text = ""
        }
        if (textField == txtfldNewPass)
        {
            self.lblErrorNewPass.text = ""
        }
        if (textField == txtfldConfirmNewPass)
        {
            self.lblErrorConfirmNewPass.text = ""
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
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
