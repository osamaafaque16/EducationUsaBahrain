//
//  NotificationTableCell.swift
//  EducationUSA
//
//  Created by XEONCITY on 28/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
