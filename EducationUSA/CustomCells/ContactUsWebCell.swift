//
//  ContactUsWebCell.swift
//  EducationUSA
//
//  Created by Shujaat Ali Khan on 1/21/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit

class ContactUsWebCell: UITableViewCell {

    @IBOutlet weak var lblWebAddress: UILabel!
    
    var webData:ContactUsWeb?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureEmail = UITapGestureRecognizer(target: self, action: #selector(ContactUsWebCell.handleTapWebUrl(_:)))
        lblWebAddress.addGestureRecognizer(tapGestureEmail)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func setData(data:ContactUsWeb) {
        
        let underLineAttribute = [
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
            NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0x0645AD),
            NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 11.0)!]
            as [NSAttributedStringKey : Any]
        let normalAttribute = [
            NSAttributedStringKey.foregroundColor : UIColor.darkGray,
            NSAttributedStringKey.font : UIFont(name: "Roboto-Regular", size: 11.0)!]
            as [NSAttributedStringKey : Any]
        
//        let underLineAttribute = [ NSAttributedStringKey.font.rawValue: UIFont(name: "Roboto-Regular", size: 11.0)! ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0x0645AD) ,NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as! [NSAttributedStringKey : Any]
//        let normalAttribute = [ NSAttributedStringKey.font.rawValue: UIFont(name: "Roboto-Regular", size: 11.0)! ,NSAttributedStringKey.foregroundColor : UIColor.darkGray] as! [NSAttributedStringKey : Any]
        
        let nameAttribString = NSMutableAttributedString(string: data.name, attributes: normalAttribute)
        let nextLine = NSMutableAttributedString(string: "\n")
        let urlAttribString = NSMutableAttributedString(string: data.url, attributes: underLineAttribute)
        
        nameAttribString.append(nextLine)
        nameAttribString.append(urlAttribString)
        
        webData = data
        lblWebAddress.attributedText = nameAttribString
    }
    
    @objc func handleTapWebUrl(_ sender: UITapGestureRecognizer) {
        
        UIApplication.shared.openURL(URL(string: (webData?.url)!)!)
    }

}
