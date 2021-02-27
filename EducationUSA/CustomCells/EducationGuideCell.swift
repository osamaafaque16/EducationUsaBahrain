//
//  EducationGuideCell.swift
//  EducationUSA
//
//  Created by XEONCITY on 27/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit
import AlamofireImage

class EducationGuideCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cellBgImgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellBgImgView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(data:EduGuidesEducationGuide) {
        
        let URL = Foundation.URL(string: data.educationImage ?? "")
        
        //print(URL!)
        cellBgImgView.image = UIImage(named: "no-image")?.af_imageAspectScaled(toFit: cellBgImgView.frame.size)
       // cellBgImgView.image = UIImage(named: "")?.af.ima

        if URL != nil
        {
            cellBgImgView.af_setImage(
                withURL: URL!,
                placeholderImage:UIImage(named: "no-image")?.af_imageAspectScaled(toFit: cellBgImgView.bounds.size),
                filter: AspectScaledToFitSizeFilter(size: cellBgImgView.bounds.size),
                imageTransition: .crossDissolve(0.3)
            )
            
       

        }
        
        lblTitle.text = data.name
    }
    


}
