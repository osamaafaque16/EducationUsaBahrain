//
//  SettingsTableViewCell.swift
//  Kitchenesta
//
//  Created by Shujaat on 9/7/17.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//

import UIKit

protocol SettingCellDelegate {
    func langChange(_ sender:UIButton)
    func notificationAction(_ sender:UIButton)
}


class SettingsTableViewCell: UITableViewCell
{

    @IBOutlet weak var lblSettingsOptions: UILabel!
    @IBOutlet weak var lblEnglish: UILabel!
    @IBOutlet weak var lblArabi: UILabel!
    @IBOutlet weak var btnChangeLanguage: UIButton!
    @IBOutlet weak var imgViewOption: UIImageView!
    @IBOutlet weak var langStack: UIStackView!
    
    var delegate :SettingCellDelegate!
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        //todo:Osama
        if Singleton.sharedInstance.isGuest == true{
        langStack.isHidden = true
        }
        else{

        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
  
    }

    
    @IBAction func changeLanguage(_ sender: UIButton){
        
        if lblSettingsOptions.text == NSLocalizedString("Notifications", comment: "") {
            sender.isSelected = !sender.isSelected
            delegate.notificationAction(sender)
        }else{
            delegate.langChange(sender)
            //Constants.UIWINDOW?.makeToast(AppString.betaFeature, duration: 1.5, position: .center)
        }
        
    }
    
    
    
}

