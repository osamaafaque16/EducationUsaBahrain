//
//  FAQExpendCell.swift
//  EducationUSA
//
//  Created by XEONCITY on 31/12/2017.
//  Copyright © 2017 Ingic. All rights reserved.
//

import UIKit

class FAQExpendCell: UITableViewCell {
    
    @IBOutlet weak var lblAns: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    var url = ""
    var webUrl = NSURL(string: "")


    
    func setData(data:FAQFaq){
        
        self.textViewDescription.attributedText = data.descriptionValue?.convertHtml()
        self.textViewDescription.delegate = self
    }
    
}

extension FAQExpendCell:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//        let urlString = String(URL.absoluteString.reversed())
//        let textViewTextURL = String((textView.text ?? "").reversed())
//        let webURLString = String(textViewTextURL.commonPrefix(with: urlString).reversed())
//        guard let webURL = NSURL(string: webURLString) else {return false}
        //var input = "applewebdata://4885A5B4-438A-4843-BB22-C6FD7F704677/ustraveldocs.com"
        let input = URL.absoluteString
        let finalStr = input.replacingOccurrences(of: ":", with: "" )
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: finalStr, options: [], range: NSRange(location: 0, length: finalStr.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: finalStr) else { continue }
            self.url = String(finalStr[range])
            self.webUrl = NSURL(string: url)
            print(url)
        }
        
        if !(webUrl?.absoluteString?.contains("https://"))!{
           
            if #available(iOS 10.0, *) {
                let str = "https://" + webUrl!.absoluteString!
                let finalUrl = NSURL(string: str)
                UIApplication.shared.open(finalUrl! as URL, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
                let str = "https://" + webUrl!.absoluteString!
                let finalUrl = NSURL(string: str)
                UIApplication.shared.openURL(finalUrl! as URL)
            }
            return true
        }
        
        else{
            
            if #available(iOS 10.0, *) {
         
                UIApplication.shared.open(webUrl! as URL, options: [:], completionHandler: nil)
            } else {
                // openURL(_:) is deprecated in iOS 10+.
        
                UIApplication.shared.openURL(webUrl! as URL)
            }
            return true
        }
        
 
        
//        if #available(iOS 10.0, *) {
//            if UIApplication.shared.canOpenURL(webURL as URL){
//                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
//            }
//            else{
//                if !webURLString.contains("http://"){
//                    let webURL1 = "http://"+webURLString
//                    guard let webURL = NSURL(string: webURL1) else {return false}
//                    if UIApplication.shared.canOpenURL(webURL as URL){
//                        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
//                    }
//                    else{
//                        let webURL2 = "http://"+webURLString
//                        guard let webURL = NSURL(string: webURL2) else {return false}
//                        if UIApplication.shared.canOpenURL(webURL as URL){
//                            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
//                        }
//                    }
//                }
//            }
//        } else {
//            if UIApplication.shared.canOpenURL(webURL as URL){
//                UIApplication.shared.openURL(webURL as URL)
//            }
//            else{
//                if !webURLString.contains("http://"){
//                    let webURL1 = "http://"+webURLString
//                    guard let webURL = NSURL(string: webURL1) else {return false}
//                    if UIApplication.shared.canOpenURL(webURL as URL){
//                        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
//                    }
//                    else{
//                        let webURL2 = "http://"+webURLString
//                        guard let webURL = NSURL(string: webURL2) else {return false}
//                        if UIApplication.shared.canOpenURL(webURL as URL){
//                            UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
//                        }
//                    }
//                }
//            }
//        }
//        return true
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


