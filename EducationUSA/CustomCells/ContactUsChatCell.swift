//
//  ContactUsChatCell.swift
//  EducationUSA
//
//  Created by Shujaat Ali Khan on 1/21/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit

class ContactUsChatCell: UITableViewCell {

    var btnChatCallBack : (() -> Void)?
    
    @IBOutlet weak var lblAboutUs: UILabel!
    @IBOutlet weak var btnChat: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let pre = Locale.preferredLanguages[0]
        if pre.hasPrefix("ar") {
            btnChat.titleEdgeInsets.right = 10
            btnChat.imageEdgeInsets.right = 5
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @IBAction func chatClicked(_ sender: Any) {
        
        btnChatCallBack!()
        
       // Constants.UIWINDOW?.makeToast(AppString.betaFeature, duration: 1.5, position: .center)
        
    }
    
    
}
