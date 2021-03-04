//
//  HomeTableViewCell.swift
//  EducationUSA

//  Created by XEONCITY on 25/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topRoundView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.shadowRadius = 2.0
        mainView.layer.shadowColor = UIColor.black.cgColor
        mainView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        mainView.layer.shadowOpacity = 0.1
        mainView.layer.masksToBounds = false
        // Initialization code
        topRoundView.layer.cornerRadius = 10.0
        topRoundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        topRoundView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:EventEvents) {
        lblTitle.text = data.name
        lblType.text = data.type
        if data.type == "Online" {
            lblLocation.text = data.type
        }else{
            lblLocation.text = "Location - " + data.location
        }
        
        let dateComponents = Utility.getDateComponents(data.eventDate)
        lblDay.text = String(describing: (dateComponents?.day)!)
        lblYear.text = String(describing: (dateComponents?.year)!)
        
    
        
        lblMonth.text = Utility.getDateFormat(date: data.eventDate, In: "yyyy-MM-dd", Out: "MMM").uppercased()
        
        let des = data.descriptionValue?.convertHtml().string
        lblDescription.text = des
        
    }

}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
