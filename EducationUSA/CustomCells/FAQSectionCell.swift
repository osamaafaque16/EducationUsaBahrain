//
//  FAQSectionCell.swift
//  EducationUSA
//
//  Created by XEONCITY on 31/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import ExpyTableView

class FAQSectionCell: UITableViewCell ,ExpyTableViewHeaderCell{

    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var downImage: UIImageView!
    @IBOutlet weak var lblQuesNo: UILabel!
    
    var canAnimate:Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool) {
        
        if !canAnimate {
            return
        }
        
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            arrowDown(animated: !cellReuse)
            
        case .willCollapse:
            print("WILL COLLAPSE")
            arrowRight(animated: !cellReuse)
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            print("DID COLLAPSE")
        }
    }
    
    private func arrowDown(animated: Bool) {
        
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            let pre = Locale.preferredLanguages[0]
            if pre.hasPrefix("ar") {
                self.downImage.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
            }else{
                self.downImage.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
            }
            
        }
    }
    
    private func arrowRight(animated: Bool) {
        UIView.animate(withDuration: (animated ? 0.3 : 0)) {
            self.downImage.transform = CGAffineTransform(rotationAngle: 0)
        }
    }

}
