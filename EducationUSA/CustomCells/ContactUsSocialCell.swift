//
//  ContactUsSocialCell.swift
//  EducationUSA
//
//  Created by Shujaat Ali Khan on 1/21/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit

class ContactUsSocialCell: UITableViewCell {

    @IBOutlet weak var socialLogoImgView: UIImageView!
    @IBOutlet weak var lblPageName: UILabel!
    @IBOutlet weak var lblSocialMediaName: UILabel!
    @IBOutlet weak var bottomSpacing: NSLayoutConstraint!
    @IBOutlet weak var topSpacing: NSLayoutConstraint!
    
    var faceBookData:ContactUsFacebook?
    var InstaData:ContactUsInstagram?
    var twitterData:ContactUsTwitter?
    
    var type = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureEmail = UITapGestureRecognizer(target: self, action: #selector(ContactUsSocialCell.handleTapEmail(_:)))
        lblPageName.addGestureRecognizer(tapGestureEmail)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setData(_ data:Any,_ type:String,Index:Int) {
        let underLineAttribute = [
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0x0645AD),
            NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 11.0)!]
            as [NSAttributedStringKey : Any]
//        let underLineAttribute = [ NSAttributedStringKey.font.rawValue: UIFont(name: "Roboto-Regular", size: 11.0)! ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0x0645AD) ,NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as! [NSAttributedStringKey : Any]
        
        self.type = type
        
        if Index > 0 {
            lblSocialMediaName.isHidden = true
            socialLogoImgView.isHidden = true
            topSpacing.constant = 0
            bottomSpacing.constant = 8
        }else{
            lblSocialMediaName.isHidden = false
            socialLogoImgView.isHidden = false
            bottomSpacing.constant = 8
            topSpacing.constant = 8
        }
        
        if type == "fb" {
            faceBookData = data as? ContactUsFacebook
            
            lblSocialMediaName.text = NSLocalizedString("Facebook", comment: "")
            socialLogoImgView.image = #imageLiteral(resourceName: "fb")
            lblPageName.attributedText = NSMutableAttributedString(string: (faceBookData?.name)!, attributes: underLineAttribute)
            
        }else if type == "insta"{
            InstaData = data as? ContactUsInstagram
            
            lblSocialMediaName.text = NSLocalizedString("Instagram", comment: "")
            socialLogoImgView.image = #imageLiteral(resourceName: "instagram")
            lblPageName.attributedText = NSMutableAttributedString(string: (InstaData?.name)!, attributes: underLineAttribute)
            
            
        }else{
            twitterData = data as? ContactUsTwitter
            
            lblSocialMediaName.text = NSLocalizedString("Twitter", comment: "") 
            socialLogoImgView.image = #imageLiteral(resourceName: "twitter")
            lblPageName.attributedText = NSMutableAttributedString(string: (twitterData?.name)!, attributes: underLineAttribute)
            
        }
        
    }


    
    @objc func handleTapEmail(_ sender: UITapGestureRecognizer) {
        
        if type == "fb" {
            let username = URL(string: (faceBookData?.key)!)
            if #available(iOS 10.0, *) {
                let webUrl = URL(string: "https://facebook.com/\(username!)")
               // let webUrl = URL(string: "fb://profile/\(username)")
                print(faceBookData?.name)
                print(faceBookData?.key)

                UIApplication.shared.open(webUrl!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                let webUrl = URL(string: "https://facebook.com/\(username!)")
                UIApplication.shared.openURL(webUrl!)
            }
        }else if type == "insta"{
            
            let username = InstaData?.name.replacingOccurrences(of: "@", with: "")
            
            let appUrl = URL(string: "instagram://user?username=\(username!)")
            let webUrl = URL(string: "http://instagram.com/\(username!)")
            
            if UIApplication.shared.canOpenURL(appUrl!) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appUrl!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(appUrl!)
                }
            } else {
                //redirect to safari because the user doesn't have Instagram
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(webUrl!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(webUrl!)
                }
            }
        }else{
            let webUrl = URL(string: (twitterData?.key)!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webUrl!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(webUrl!)
            }
        }
        
    }
    
}
