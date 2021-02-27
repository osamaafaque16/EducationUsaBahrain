//
//  WebViewController.swift
//  EducationUSA
//
//  Created by Shujaat Ali on 2/6/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import UIKit

class WebViewController: BaseController , UIWebViewDelegate{

    @IBOutlet weak var webView: UIWebView!
    
    var attachment:EduGuidesAttachment?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBackarrow()
        lblTitle.text = attachment?.file
        // Do any additional setup after loading the view.
        webView.delegate = self
        
        //URL(string: (attachment?.fileUrl)!)
        
        let pdfUrl = URL(string: (attachment?.fileUrl)!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        webView.loadRequest(URLRequest(url: pdfUrl!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // WebView Delegates
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.showNormalHud("Loading...")
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.removeNormalHud()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.removeNormalHud()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
