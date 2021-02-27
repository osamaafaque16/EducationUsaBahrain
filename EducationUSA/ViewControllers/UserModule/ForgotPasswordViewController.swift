//
//  ForgotPasswordViewController.swift
//  EducationUSA
//
//  Created by XEONCITY on 23/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseController , UITextFieldDelegate {

    
    @IBOutlet weak var txtfldEmail: UITextField!
    @IBOutlet weak var lblErrorEmail: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var btnForgot: UIButton!
    var isValidate = true
    
    override func viewDidLoad() {
        currentController = Controllers.ForgotPassword
        super.viewDidLoad()
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblErrorEmail.text = ""
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        isValidate = true

        if (!Validation.validateStringLength(txtfldEmail.text!)) {
            lblErrorEmail.text = NSLocalizedString("Email is required", comment: "")
            isValidate = false
            emailView.shake()
        }else if (!Validation.isValidEmail(txtfldEmail.text!)) {
            lblErrorEmail.text = "Please enter valid email address"
            isValidate = false
            emailView.shake()
        }

        if isValidate {
            callForgotPassService()
        }
//        let verifyVC = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "VerifyCodeController") as! VerifyCodeController
//                   verifyVC.email = self.txtfldEmail.text!
//                   self.navigationController?.pushViewController(verifyVC, animated:true)
    }

    // MARK: - APIS
    func callForgotPassService() {
        self.view.endEditing(true)
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        let parameter = [
            "email" : txtfldEmail.text!
        ]
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        UserBase.signIn_SignUp(urlPath:BASE_URL+FORGOT_PASS , parameters: parameter, header: nil, vc: self) { (user) in
            
            self.removeNormalHud()
            
            if user.code != 200 {
                self.view.makeToast(user.message, duration: 1.5, position: .center)
                return
            }
            
            Constants.UIWINDOW?.makeToast(user.message, duration: 1.5, position: .center)
            
            let verifyVC = AppConstants.APP_STORYBOARD.USER.instantiateViewController(withIdentifier: "VerifyCodeController") as! VerifyCodeController
            verifyVC.email = self.txtfldEmail.text!
            self.navigationController?.pushViewController(verifyVC, animated:true)
            
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
        
        if (textField == txtfldEmail)
        {
            self.lblErrorEmail.text = ""
        }

        return newLength <= maxLength
        
    }
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  

}
