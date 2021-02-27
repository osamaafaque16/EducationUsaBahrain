//
//  EducationGuideDetailController.swift
//  EducationUSA
//
//  Created by XEONCITY on 05/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import AlamofireImage

class EducationGuideDetailController: BaseController , UITextViewDelegate{
    
    @IBOutlet weak var imageViewHeader: UIImageView!
    @IBOutlet weak var btnViewAttachments: UIButton!
    @IBOutlet weak var lblNoOfAttachments: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var btnTopSpacing: NSLayoutConstraint!
  
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
 
    
    var eduGuidelineId:Int?
    
    var eduData:EduGuidesEducationGuide?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textViewDescription.delegate = self
        textViewDescription.text = ""
        textViewDescription.isHidden = true
        lblNoOfAttachments.isHidden = true
        btnViewAttachments.isHidden = true
        
        imageViewHeader.isHidden = true
        
        imageViewHeader.image = UIImage(named: "no-image1")
        
        let underLineAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11) ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0xCD002E),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any] 
        let viewAttach = NSMutableAttributedString(string: "\(NSLocalizedString("View Attachment", comment: ""))", attributes: underLineAttribute)
        
        btnViewAttachments.setAttributedTitle(viewAttach, for: .normal)

        
    }
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = eduData?.name ?? ""
        createBackarrow()
    }
    override func viewDidAppear(_ animated: Bool) {

        if eduGuidelineId != nil {
            callDetailService()
        }else{
            setData()
        }
    }
    override func viewWillLayoutSubviews() {
        textViewHeight.constant = textViewDescription.intrinsicContentSize.height
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
       imageViewHeader.isHidden = false
        lblTitle.text = eduData?.name
        
        if eduData?.attachment.count == 0 {
            btnTopSpacing.constant = -30
            lblNoOfAttachments.isHidden = true
            btnViewAttachments.isHidden = true
        }else{
            if eduData?.name == "Resources" {
                btnTopSpacing.constant = -70
                imageViewHeader.isHidden = true
            }
            if (eduData?.attachment.count)! > 1 {
                 let underLineAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11) ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0xCD002E),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
                let viewAttach = NSMutableAttributedString(string: "\(NSLocalizedString("View Attachments", comment: ""))", attributes: underLineAttribute)
                btnViewAttachments.setAttributedTitle(viewAttach, for: .normal)
                
                lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" "+NSLocalizedString("Attachments", comment: "")
            }else{
                lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" "+NSLocalizedString("Attachment", comment: "")
            }
            //lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" "+NSLocalizedString("Attachment", comment: "")
            lblNoOfAttachments.isHidden = false
            btnViewAttachments.isHidden = false
        }
        
//        if eduData?.name == "Resources" {
//            btnTopSpacing.constant = -140
//            imageViewHeader.isHidden = true
//            lblNoOfAttachments.isHidden = true
//            btnViewAttachments.isHidden = true
//
//        }else{
//            if eduData?.attachment.count == 0 {
//                btnTopSpacing.constant = -25
//                lblNoOfAttachments.isHidden = true
//                btnViewAttachments.isHidden = true
//            }else{
//                lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" Attachment"
//                lblNoOfAttachments.isHidden = false
//                btnViewAttachments.isHidden = false
//            }
//        }

        let URL = Foundation.URL(string: eduData?.educationImage ?? "")
        
        if URL != nil
        {
            imageViewHeader.af_setImage(
                withURL: URL!,
                placeholderImage:UIImage(named: "no-image1")?.af_imageAspectScaled(toFill: imageViewHeader.frame.size),
                filter: AspectScaledToFillSizeFilter(size: imageViewHeader.frame.size),
                imageTransition: .crossDissolve(0.3)
            )
        }
        

        
        
        // Set data in textView
        DispatchQueue.main.async {
            self.textViewDescription.attributedText = self.eduData?.descriptionValue.convertHtml()
        }

        textViewHeight.constant = textViewDescription.intrinsicContentSize.height
        textViewDescription.isHidden = false
    }
    
    @IBAction func viewAttachmentClicked(_ sender: Any) {
        
        let popup =  Bundle.main.loadNibNamed("PopUp", owner: self, options: nil)?.first as! PopUp
        
        popup.frame = CGRect(x: 0, y: 0 , width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        popup.attachmentData = (eduData?.attachment)!
        Constants.UIWINDOW?.addSubview(popup)
        
        popup.openAttachment = { index in
            print("open pdf")
            
            let webVC = AppConstants.APP_STORYBOARD.HOME.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            webVC.attachment = self.eduData?.attachment[index]
            self.navigationController?.pushViewController(webVC, animated:true)
            
            popup.removeFromSuperview()
        }
        
    }
    
    
    
    
    func callDetailService(){
        
        if !Connectivity.isConnectedToInternet {
            self.view.makeToast(AppString.internetUnreachable, duration: 1.5, position: .center)
            return
        }
        
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!]
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        let url = "\(BASE_URL)get-education-guideline/\(eduGuidelineId!)"
        
        GuidelineBase.getGuidelineDetail(urlPath: url, parameter: parameter, vc: self) { (data) in
            self.removeNormalHud()
            
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            self.eduData = data.result?.educationGuideline
            self.setData()
        }

    }

    // MARK: - TextView Delegate
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        print("Link Selected!")
        //https://educationusachat.stagingic.com/advisor
        if URL.absoluteString == "https://chat.educationusa.live/advisor" {
            
            let contactVC = AppConstants.APP_STORYBOARD.SETTING.instantiateViewController(withIdentifier: "ContactUsController") as! ContactUsController
            self.navigationController?.pushViewController(contactVC
                , animated:true)
            
            return false
        }
        return true
    }

}


