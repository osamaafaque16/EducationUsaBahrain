//
//  EducationGuideDetailController.swift
//  EducationUSA
//
//  Created by XEONCITY on 05/01/2018.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit
import AlamofireImage
import WebKit
class FullBirghtController: BaseController , UITextViewDelegate{
    
    @IBOutlet weak var imageViewHeader: UIImageView!
    //@IBOutlet weak var btnViewAttachments: UIButton!
    //@IBOutlet weak var lblNoOfAttachments: UILabel!
    
    @IBOutlet weak var wkWebViewHeight: NSLayoutConstraint!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var btnTopSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var webView: UIWebView!
    
    var eduGuidelineId:Int?
    
    var eduData:FullBrightDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //webView.delegate = self
        wkWebView.navigationDelegate = self
        //lblNoOfAttachments.isHidden = true
        //btnViewAttachments.isHidden = true
        
        imageViewHeader.isHidden = true
        
        imageViewHeader.image = UIImage(named: "no-image1")
        
        let underLineAttribute = [ NSAttributedStringKey.font: UIFont.init(name: "Roboto-Regular", size: 18.0)! ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0xCD002E),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
        let viewAttach = NSMutableAttributedString(string: "\(NSLocalizedString("View Attachment", comment: ""))", attributes: underLineAttribute)
        
        //btnViewAttachments.setAttributedTitle(viewAttach, for: .normal)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = eduData?.name ?? ""
        createBackarrow()
    }
    override func viewDidAppear(_ animated: Bool) {
        
        callDetailService()
//        if eduGuidelineId != nil {
//            callDetailService()
//        }else{
//            setData()
//        }
    }
    override func viewWillLayoutSubviews() {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setData(){
        imageViewHeader.isHidden = false
        lblTitle.text = eduData?.name
        
//        if eduData?.attachment.count == 0 {
//            btnTopSpacing.constant = -25
//            lblNoOfAttachments.isHidden = true
//            btnViewAttachments.isHidden = true
//        }else{
//            if eduData?.name == "Resources" {
//                //btnTopSpacing.constant = -70
//                btnTopSpacing.constant = -180
//                imageViewHeader.isHidden = true
//            }
//            if (eduData?.attachment.count)! > 1 {
//                let underLineAttribute = [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 11) ,NSAttributedStringKey.foregroundColor : Utility.UIColorFromRGB(rgbValue: 0xCD002E),NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue] as [NSAttributedStringKey : Any]
//                let viewAttach = NSMutableAttributedString(string: "\(NSLocalizedString("View Attachments", comment: ""))", attributes: underLineAttribute)
//                btnViewAttachments.setAttributedTitle(viewAttach, for: .normal)
//
//                lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" "+NSLocalizedString("Attachments", comment: "")
//            }else{
//                lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" "+NSLocalizedString("Attachment", comment: "")
//            }
//            //lblNoOfAttachments.text = String((eduData?.attachment.count)!)+" "+NSLocalizedString("Attachment", comment: "")
//            lblNoOfAttachments.isHidden = false
//            btnViewAttachments.isHidden = false
//        }
        
        
        
        let URL = Foundation.URL(string: eduData?.image ?? "")
        
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
        let finalDesc = matchesIframe(in: desc!)
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        wkWebView.loadHTMLString(headerString + finalDesc, baseURL: nil)
        
       // desc?.replacingOccurrences(of: "<iframe(.+)</iframe>", with: "", options: .regularExpression, range: nil)
        
        
        //let setVideoWidth = desc?.replacingOccurrences(of: "<#T##StringProtocol#>", with: <#T##StringProtocol#>)
        //.replacingOccurrences(of: "<iframe(.+)</iframe>", with: "", options: .regularExpression, range: nil)
        
        
        //webView.loadHTMLString(finalDesc ?? "", baseURL: nil)
        //wkWebView.loadHTMLString(finalDesc , baseURL: nil)
        
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
        //api/full-bright?offset=1&user_id=2218
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)!]
        
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        
        let url = "\(BASE_URL)full-bright"
        
        FullBrightBase.getFullBright(urlPath: url, parameter: parameter, vc: self) { (data) in
            self.removeNormalHud()
            
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
            
            self.eduData = data.result?.educationGuide[0]
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

extension FullBirghtController: UIWebViewDelegate{
    
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

extension FullBirghtController: WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.wkWebView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in
            if complete != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.wkWebViewHeight.constant = self.wkWebView.scrollView.contentSize.height
                }
//                self.wkWebView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
//                    self.wkWebViewHeight.constant = height as! CGFloat
//                })
            }

            })
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        
        if navigationAction.navigationType == .linkActivated{
            
            let url = navigationAction.request.url
            
            UIApplication.shared.canOpenURL(url!)
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        }
        
        else{
            decisionHandler(.allow)
        }
        
        
        
//        if navigationAction.navigationType == .linkActivated  {
//            if let url = navigationAction.request.url,
//                /*let host = url.host, !host.hasPrefix("www.google.com"),*/
//                UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url)
//                print(url)
//                print("Redirected to browser. No need to open it locally")
//                decisionHandler(.cancel)
//            } else {
//                print("Open it locally")
//                decisionHandler(.allow)
//            }
//        } else {
//            print("not a user click")
//            decisionHandler(.allow)
//        }

        // This is a HTTP link
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        } else {
//            // openURL(_:) is deprecated in iOS 10+.
//            UIApplication.shared.openURL(url)
//        }
        }
     
}
