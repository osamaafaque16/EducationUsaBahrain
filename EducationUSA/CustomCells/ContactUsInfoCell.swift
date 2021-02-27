//
//  ContactUsInfoCell.swift
//  EducationUSA
//
//  Created by Shujaat Ali Khan on 1/21/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsInfoCell: UITableViewCell {

    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNo: UILabel!
    
    var contactController:ContactUsController?
    var data : ContactUsAddress!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureLocation = UITapGestureRecognizer(target: self, action: #selector(ContactUsInfoCell.handleTapLocation(_:)))
        lblLocation.addGestureRecognizer(tapGestureLocation)
        
        let tapGestureEmail = UITapGestureRecognizer(target: self, action: #selector(ContactUsInfoCell.handleTapEmail(_:)))
        lblEmail.addGestureRecognizer(tapGestureEmail)
        
        let tapGesturePhone = UITapGestureRecognizer(target: self, action: #selector(ContactUsInfoCell.handleTapPhone(_:)))
        lblPhoneNo.addGestureRecognizer(tapGesturePhone)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:ContactUsAddress) {
        
        
        let underLineAttribute = [
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0x0645AD),
            NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 11.0)!]
            as [NSAttributedStringKey : Any]
        
        self.data = data
        
        //Making outline here
//        labelOutLine.attributedText = NSMutableAttributedString(string: “Your outline text”, attributes: strokeTextAttributes)
        
        
//        let underLineAttribute = [ NSAttributedStringKey.font.rawValue: UIFont(name: "Roboto-Regular", size: 11.0)! ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0x0645AD) ,NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [AnyHashable : Any] //as! [NSAttributedStringKey : Any]
        
        //lblLocation.text = data.location
//        let emailAttributedString = NSMutableAttributedString(
        let phnNumAttributedString = NSMutableAttributedString()
        
        lblLocation.attributedText = NSMutableAttributedString(string: data.location!, attributes: underLineAttribute )
        lblEmail.attributedText = NSMutableAttributedString(string: data.address!, attributes: underLineAttribute )
        lblPhoneNo.attributedText = NSMutableAttributedString(string: data.phone!, attributes: underLineAttribute )
        
    }
    
//    func handleTapLocation(_ sender: UITapGestureRecognizer) {
////        let url = "http://maps.apple.com/maps?saddr=\(addresData.),\(coord.longitude)"
////        UIApplication.shared.openURL(URL(string:url)!)
//    }
    
    @objc func handleTapEmail(_ sender: UITapGestureRecognizer) {
       // openEmailController()
       // contactUs()
        openGmail()

        
//        let email = "jack@yopmail.com"
//        if let url = URL(string: "mailto:\(email)") {
//           UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        
   
    }
    
    @objc func handleTapPhone(_ sender: UITapGestureRecognizer) {
        phoneCall(phoneNum: lblPhoneNo.text!)
        
    }
    
    @objc func handleTapLocation(_ sender :UITapGestureRecognizer){
        openAddressOnGoogleMap()
    }
    
}

extension ContactUsInfoCell{
    
    //open google map app
    func openAddressOnGoogleMap(){
        
        print("open maps address")
        let finalStr = data.location
        let str = finalStr?.replacingOccurrences(of: " ", with: "+")
        //https://www.google.com/search?q=\(str) //for opening in web
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://search?q=\(str!)")!)
        } else {
            
            print("Can't use comgooglemaps://")
        }
    }
    
    //open gmail app
    func openGmail(){
        
        let googleUrlString = "googlegmail:///co?to=\(lblEmail.text!)"
        if let googleUrl = URL(string: googleUrlString) {
            // show alert to choose app
            if UIApplication.shared.canOpenURL(googleUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(googleUrl, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(googleUrl)
                }
            }
        }
        else{
            
            let message = "Email Address is not valid"
            Constants.UIWINDOW?.makeToast(message)
        }
        
    }
    
    //Open phone call controller
    func phoneCall(phoneNum: String) {
        let phoneNumber = phoneNum
        var validPhoneNumber = ""
        for character in phoneNumber.characters {
            switch character {
            case "0","1","2","3","4","5","6","7","8","9":
                validPhoneNumber += String(character)
                break
            default:
                break
            }
        }
        
        if let url = URL(string:"tel://\(validPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    print(url)
                    print(success)
                    
                })
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
}

//extension ContactUsInfoCell:MFMailComposeViewControllerDelegate {
//
//    func contactUs() {
//
//        let email = "info@example.com" // insert your email here
//        let subject = "your subject goes here"
//        let bodyText = "your body text goes here"
//
//        // https://developer.apple.com/documentation/messageui/mfmailcomposeviewcontroller
//        if MFMailComposeViewController.canSendMail() {
//
//            let mailComposerVC = MFMailComposeViewController()
//            mailComposerVC.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
//
//            mailComposerVC.setToRecipients([email])
//            mailComposerVC.setSubject(subject)
//            mailComposerVC.setMessageBody(bodyText, isHTML: false)
//
//           // present(mailComposerVC, animated: true, completion: nil)
//            if contactController != nil {
//                  contactController?.present(mailComposerVC, animated: true, completion: nil)
//             }
//
//        } else {
//            print("Device not configured to send emails, trying with share ...")
//
//            let coded = "mailto:\(email)?subject=\(subject)&body=\(bodyText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//            if let emailURL = URL(string: coded!) {
//                if #available(iOS 10.0, *) {
//                    if UIApplication.shared.canOpenURL(emailURL) {
//                        UIApplication.shared.open(emailURL, options: [:], completionHandler: { (result) in
//                            if !result {
//                                print("Unable to send email.")
//                            }
//                        })
//                    }
//                }
//                else {
//                    UIApplication.shared.openURL(emailURL as URL)
//                }
//            }
//        }
//    }


//    func openEmailController(){
//        if !MFMailComposeViewController.canSendMail() {
//            Constants.UIWINDOW?.makeToast(NSLocalizedString("Your device could not send e-mail.  Please check e-mail configuration and try again.", comment: ""), duration: 1, position: .center)
//            return
//        }else{
//            let composeVC = MFMailComposeViewController()
//            composeVC.mailComposeDelegate = self
//
//            // Configure the fields of the interface.
//            composeVC.setToRecipients([lblEmail.text!])
//            composeVC.setSubject("")
//            composeVC.setMessageBody("", isHTML: false)
//
//            // Present the view controller modally.
//            if contactController != nil {
//                 contactController?.present(composeVC, animated: true, completion: nil)
//            }
//
//        }
//    }
//
//    // MARK: MFMailComposeViewControllerDelegate Method
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }


//
//}
