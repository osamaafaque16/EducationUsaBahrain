//
//  VerifyCodeController.swift
//  EducationUSA
//
//  Created by Shujaat Ali Khan on 1/31/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit

class VerifyCodeController: BaseController, UITextFieldDelegate {

    @IBOutlet weak var txtFldVerifyCode: UITextField!
    @IBOutlet weak var errorLblVerifyCode: UILabel!
    @IBOutlet weak var verifyView: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var btnForgot: UIButton!
    
    var isValidate = true
    var email = ""
    
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
    @IBAction func backToLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        errorLblVerifyCode.text = ""
    }
    @IBAction func submitClicked(_ sender: Any) {
        isValidate = true
        
        if (!Validation.validateStringLength(txtFldVerifyCode.text!)) {
            errorLblVerifyCode.text = NSLocalizedString("Enter verification code", comment: "")
            isValidate = false
            verifyView.shake()
            
        }else if (txtFldVerifyCode.text?.characters.count)! < 4 {
            errorLblVerifyCode.text = NSLocalizedString("Length of pin should be 4", comment: "")
            isValidate = false
            verifyView.shake()
        }
        
        
        
        if isValidate {
            callVerifyCodeService()
        }
    }

    
    // MARK: - APIS
    func callVerifyCodeService() {
        self.view.endEditing(true)
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        let parameter = [
            "verification_code" : txtFldVerifyCode.text!,
            "device_token" : Singleton.sharedInstance.deviceToken
        ]
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        UserBase.signIn_SignUp(urlPath:BASE_URL+VERIFY_CODE , parameters: parameter, header: nil, vc: self) { (user) in
            
            self.removeNormalHud()
            
            if user.code != 200 {
                self.view.makeToast(user.message, duration: 1.5, position: .center)
                return
            }
            
            Constants.UIWINDOW?.makeToast(user.message, duration: 1.5, position: .center)
            
            let changePassVC = AppConstants.APP_STORYBOARD.SETTING.instantiateViewController(withIdentifier: "ChangePasswordController") as! ChangePasswordController
            changePassVC.fromVerifyCode = true
            changePassVC.email = self.email
            self.navigationController?.pushViewController(changePassVC, animated:true)
            
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
        let maxLength = 4
        
        if (textField == txtFldVerifyCode)
        {
            self.errorLblVerifyCode.text = ""
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
