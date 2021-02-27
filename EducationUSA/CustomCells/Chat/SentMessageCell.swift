//
//  SentMessageCell.swift
//  SideMenuTemplate
//
//  Created by Zuhair Hussain on 23/04/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit

class SentMessageCell: UITableViewCell {

    @IBOutlet weak var deliveryStatus: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
}
