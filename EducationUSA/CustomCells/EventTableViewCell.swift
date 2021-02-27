//
//  EventTableViewCell.swift
//  EducationUSA
//
//  Created by XEONCITY on 30/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

protocol EventCellDelegate {
    func btnFollowClicked(_ cell:EventTableViewCell)
}

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblEventDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    //@IBOutlet weak var btnFavorite: UIButton!
    
    var delegate:EventCellDelegate!
    override func layoutSubviews() {
        super.layoutSubviews()
        //redView.roundCorners(corners: [.topRight, .topLeft,.bottomLeft,.bottomRight ], radius: 15.0)
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //btnFavorite.isUserInteractionEnabled = false
       // btnFavorite.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

    func setData(data:EventEvents) {
        //lblEventTitle.text = data.name
       // btnFavorite.isSelected = data.isFollow == "1" ? true:false
        if data.type == "Online" {
            lblLocation.text = data.type
        }else{
            lblLocation.text = data.location
        }
        
        //let des = data.descriptionValue?.convertHtml().string
        lblEventTitle.text = data.name
        print(data.eventURL)
        //let date  = Utility.getDate(date: data.eventDate, format: "yyy-MM-dd")
        
        lblEventDesc.text = data.descriptionValue?.convertHtml().string
        let date = Utility.getDateFormat(date: data.eventDate, In: "yyy-MM-dd", Out: "dd")
        let month = Utility.getDateFormat(date: data.eventDate, In: "yyy-MM-dd", Out: "MMMM")
        print(date)
        print(month)
        //lblDate.text = Utility.getDateFormat(date: data.eventDate, In: "yyy-MM-dd", Out: "MMM dd, yyyy").uppercased()
        lblDate.text = "\(self.formatDate(date: date))\n\(month)"
        lblDate.textAlignment = .center
        lblDate.numberOfLines = 2
    }
    
    @IBAction func favoriteBtnClicked(_ sender: UIButton) {
        delegate.btnFollowClicked(self)
    }
    
    func formatDate(date : String) -> String{
       let currentDate = Int(date)
        var dateString = ""
        switch currentDate {
            case 1, 21, 31:
                dateString = "\(date)st"
                //return "st"
                break
            case 2, 22:
                dateString = "\(date)nd"
                //return "nd"
                break
            case 3, 23:
                dateString = "\(date)rd"
                //return "rd"
                break
            default: //return "th"
                dateString = "\(date)th"
                break
            }
        return dateString
        
    }
    
}
