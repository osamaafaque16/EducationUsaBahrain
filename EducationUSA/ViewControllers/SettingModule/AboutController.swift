//
//  AboutController.swift
//  EducationUSA
//
//  Created by Muhammad Osama Afaque on 22/02/2021.
//  Copyright © 2021 Ingic. All rights reserved.
//

import UIKit

class AboutController: BaseController {

    @IBOutlet weak var textViewDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentController = Controllers.About
        createBackarrow()
        textViewDescription.text = ""
        getDataFromCMS()
    }
    
    func getDataFromCMS(){
        
        let parameter:[String:Any] = ["user_id":(Singleton.sharedInstance.userData?.id)! , "type":"about"]
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
             self.textViewDescription.attributedText = try NSAttributedString(data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            print(error)
        }

    }

    


}
