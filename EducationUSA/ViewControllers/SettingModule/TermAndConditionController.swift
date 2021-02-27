//
//  TermAndConditionController.swift
//
//  Created by Shujaat on 07/09/2017.
//  Copyright © 2017 Shujaat. All rights reserved.
//

import UIKit


class TermAndConditionController: BaseController {
    
    var isFromSettings = false
    var key: String!
    @IBOutlet var txtViewDescription: UITextView!
    
    
    override func viewDidLoad() {
    currentController = Controllers.TermsAndCondition
        super.viewDidLoad()
        txtViewDescription.text = ""
       getDataFromCMS()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func getDataFromCMS(){
        
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)! , "type":"terms"]
        self.showNormalHud(NSLocalizedString("Loading...", comment: ""))
        CMSBase.getTermsAndCond(urlPath: BASE_URL+TERMS, parameter: parameter, vc: self) { (data) in
            self.removeNormalHud()
            if data.code != 200 {
                self.view.makeToast(data.message, duration: 1.5, position: .center)
                return
            }
           
            self.setHTMLText(htmlText: (data.result?.page?.content)!)
            
        }
    }
    
    func setHTMLText(htmlText:String) {
        
        do {
             self.txtViewDescription.attributedText = try NSAttributedString(data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print(error)
        }

    }

}

