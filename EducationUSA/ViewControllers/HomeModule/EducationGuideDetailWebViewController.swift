//
//  EducationGuideDetailController.swift
//  EducationUSA
//
//  Created by XEONCITY on 05/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import AlamofireImage

class EducationGuideDetailWebViewController: BaseController , UITextViewDelegate{
    
    @IBOutlet weak var imageViewHeader: UIImageView!
    
    //btnViewAttachments and lblNoOfAttachments is temporary disable throughout the application
    @IBOutlet weak var btnViewAttachments: UIButton!
    @IBOutlet weak var lblNoOfAttachments: UILabel!
    
    @IBOutlet weak var btnTopSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var webView: UIWebView!
    
    var eduGuidelineId:Int?
    
    var eduData:EduGuidesEducationGuide?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //webViewDidFinishLoad(webView: webView)
        
        webView.delegate = self
        
        lblNoOfAttachments.isHidden = true
        btnViewAttachments.isHidden = true
        
        imageViewHeader.isHidden = true
        
        imageViewHeader.image = UIImage(named: "no-image1")
        
        let underLineAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11) ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0xCD002E),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let viewAttach = NSMutableAttributedString(string: "\(NSLocalizedString("View Attachment", comment: ""))", attributes: underLineAttribute)
        
       // btnViewAttachments.setAttributedTitle(viewAttach, for: .normal)
        lblTitle.text = eduData?.name ?? ""
        createBackarrow()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
  

    }
    override func viewDidAppear(_ animated: Bool) {
        
        if eduGuidelineId != nil {
            callDetailService()
        }else{
            setData()
        }
    }
    override func viewWillLayoutSubviews() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        imageViewHeader.isHidden = false
        lblTitle.text = eduData?.name.uppercased()
        
        if eduData?.attachment.count == 0 {
            btnTopSpacing.constant = -25
            lblNoOfAttachments.isHidden = true
            btnViewAttachments.isHidden = true
        }else{
            if eduData?.name == "Resources" {
                //btnTopSpacing.constant = -70
                btnTopSpacing.constant = -240
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
            lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" "+NSLocalizedString("Attachment", comment: "")
            //todo:Osama
            lblNoOfAttachments.isHidden = true
            btnViewAttachments.isHidden = true
        }
        
        
        
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
        
        let desc = self.eduData?.descriptionValue.replacingOccurrences(of: "//www", with: "https://www")
        print(eduData?.descriptionValue)
        let finalDesc = matchesIframe(in: desc!)
        print(finalDesc)
        
        
       // desc?.replacingOccurrences(of: "<iframe(.+)</iframe>", with: "", options: .regularExpression, range: nil)
        
        
        //let setVideoWidth = desc?.replacingOccurrences(of: "<#T##StringProtocol#>", with: <#T##StringProtocol#>)
        //.replacingOccurrences(of: "<iframe(.+)</iframe>", with: "", options: .regularExpression, range: nil)
        
    
        webView.loadHTMLString(finalDesc ?? "", baseURL: nil)
        
    }
    
//    func webViewDidFinishLoad(webView: UIWebView) {
//        // Disable user selection
//        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitUserSelect='none'")!
//        // Disable callout
//        webView.stringByEvaluatingJavaScript(from: "document.documentElement.style.webkitTouchCallout='none'")!
//    }
    
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

extension EducationGuideDetailWebViewController: UIWebViewDelegate{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch navigationType {
        case .linkClicked:
            // Open links in Safari
            guard let url = request.url else { return true }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                UIApplication.shared.openURL(url)
            }
            return false
        default:
            // Handle other navigation types...
            return true
        }
    }
    
}


func matchesIframe(in text: String) -> String {
   let iframeRegex = "(?:<iframe[^>]*)(?:(?:/>)|(?:>.*?</iframe>))"
    do {
        let regex = try NSRegularExpression(pattern: iframeRegex)
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        
        var updatedText = text
        let width =  UIScreen.main.bounds.width - 32.0
        let height = Int(width * 0.563)
        let arr = results.map { (item) -> String in
            let frame = String(text[Range(item.range, in: text)!])
            let url = matchesUrl(in: frame).first
            
           
            let iframeTAG = "<iframe src=\"\(url ?? "")\" width=\"\(Int(width))\" height=\"\(height)\" frameborder=\"0\"></iframe>"
            print(iframeTAG)
            updatedText = updatedText.replacingOccurrences(of: iframeRegex, with: iframeTAG, options: .regularExpression, range: Range(item.range, in: updatedText)!)
            return  updatedText
        }
        print(arr)
        return arr.last ?? text
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return text
    }

}

func matchesUrl(in text: String) -> [String] {

    let urlRegEx = "(?:https?://)?([\\w_-]+(?:(?:\\.[\\w_-]+)+))([\\w.,@?^=%&:/~+#-]*[\\w@?^=%&/~+#-])?"
    
    do {
        let regex = try NSRegularExpression(pattern: urlRegEx)
        let results = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return results.map {
            String(text[Range($0.range, in: text)!])
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

