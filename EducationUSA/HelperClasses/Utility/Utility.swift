//
//  Utility.swift
//  Template
//
//  Created by Muzamil Hassan on 02/01/2017.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftMessages
//import JGProgressHUD
//import EZAlertController


class Utility{
    
    //static var HUD:JGProgressHUD! = nil
    
    func roundAndFormatFloat(floatToReturn : Float, numDecimalPlaces: Int) -> String{
        
        let formattedNumber = String(format: "%.\(numDecimalPlaces)f", floatToReturn)
        return formattedNumber
        
    }
    static func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }

    func topViewController(base: UIViewController? = (Constants.APP_DELEGATE).window?.rootViewController) -> UIViewController? {
    
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    
    static func showAlert(title:String?, message:String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in })
        Utility().topViewController()!.present(alert, animated: true){}
    }
    

    
    func getDate(dateStr: String)-> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        if let date = dateFormatter.date(from: dateStr){
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            let finalDate = calendar.date(from:components)
            return finalDate!
        }
        else{
            return Date()
        }
    }
    static func showErrorWith(message: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.error)
        error.configureContent(title: "", body: message)
        //error.button?.setTitle("Stop", for: .normal)
        error.button?.isHidden = true
        SwiftMessages.show(config: config, view: error)
        
    }
    static func showSuccessWith(message: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        let error = MessageView.viewFromNib(layout: .tabView)
        error.configureTheme(.success)
        error.configureContent(title: "", body: message)
        //error.button?.setTitle("Stop", for: .normal)
        error.button?.isHidden = true
        SwiftMessages.show(config: config, view: error)
        
    }
    static func showInAppNotification(message: String,title: String){
        var config = SwiftMessages.Config()
        config.presentationStyle = .top
        let error = MessageView.viewFromNib(layout: .messageView)
        error.configureTheme(.info)
        error.configureContent(title: title, body: message)
        //        error.button?.isHidden = true
        error.button?.addTarget(self, action: #selector(requestTapped), for: .touchUpInside)
        SwiftMessages.show(config: config, view: error)
        
    }
    @objc func requestTapped(){
        
    }
    static func resizeImage(image: UIImage,  targetSize: CGFloat) -> UIImage {
        
        guard (image.size.width > 1024 || image.size.height > 1024) else {
            return image;
        }
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newRect: CGRect = CGRect.zero;
        
        if(image.size.width > image.size.height) {
            newRect.size = CGSize(width: targetSize, height: targetSize * (image.size.height / image.size.width))
        } else {
            newRect.size = CGSize(width: targetSize * (image.size.width / image.size.height), height: targetSize)
        }
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newRect.size, false, 1.0)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    static func thumbnailForVideoAtURL(url: URL) -> UIImage? {
    
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform=true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
    
    
    static func applyBlurEffect(image: UIImage) -> UIImage{
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage.init(ciImage: resultImage)
        return blurredImage
        
    }
    
   static func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    static func convertToRatio(_ value:CGFloat) -> CGFloat {
        
        /*
         iPhone6 Hight:667   =====  0.90625
         iPhone5 Hight:568  ====== 0.77173913043478
         iPhone4S Hight:480
         iPAd Hight:1024 ===== 1.39130434782609
         //--
         (height/736.0)
        */
        let deviceRatio:CGFloat = UIScreen.main.bounds.height / 736.0;
        return value * deviceRatio;
    }
    
    static func UTCToLocalDate(date:String) -> String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormator.date(from: date)
        dateFormator.timeZone = TimeZone.current
        dateFormator.dateFormat = "d MMM yyyy"
        
        return dateFormator.string(from: dt!)
    }
    
    static func UTCToLocalTime(date:String) -> String {
        let dateFormator = DateFormatter()
        dateFormator.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormator.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormator.date(from: date)
        dateFormator.timeZone = TimeZone.current
        dateFormator.dateFormat = "h:mm a"
        
        return dateFormator.string(from: dt!)
    }

    
    static func dateFormat( date:Date ) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date)

    }
    
    

//    static func dateFormat( date:String ) -> Date {
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM dd yyyy"
//        return dateFormatter.date(from: date)!
//        
//    }
    
    static func getDateFormat(date:String ,In inFormat:String , Out outFormat:String ) -> String {
        
        let date = self.getDate(date: date, format: inFormat)
        let dateToString = self.getDateFormat(by: date, format: outFormat)
        return dateToString
    }
    
    static func getDateFormat(by date:Date, format:String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
        
    }
    
    static func getDate(date:String , format:String) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let newDate = formatter.date(from: date)
        
        return newDate ?? Date()
    }
    
    static func getDateComponents(_ today:String) -> DateComponents? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let dateComponents = myCalendar.dateComponents([.day,.month,.year,.weekday], from: todayDate)
        return dateComponents
    }
    
    static func commentWithName(name:String, comment:String) -> NSMutableAttributedString {
       
        let nameWithSpace = "\(name) "
        
        let attributesName = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.black,
            NSAttributedStringKey.font: UIFont.init(name: "RobotoCondensed-Regular", size: 15)
            ] as! [NSAttributedStringKey : Any]
        
        let attributesComment = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.init(red: 109/255, green: 109/255, blue: 109/255, alpha: 1),
            NSAttributedStringKey.font: UIFont.init(name: "RobotoCondensed-Regular", size: 13)
        ] as! [NSAttributedStringKey : Any]
        
        let attrName = NSAttributedString(string: nameWithSpace, attributes: attributesName)
        let attrcomment = NSAttributedString(string: comment, attributes: attributesComment)
        
        let combination = NSMutableAttributedString()
        
        combination.append(attrName)
        combination.append(attrcomment)
        
        return combination
        
    }
    
//    static func getCurrentPlace(_ actualCoordinates: CLLocationCoordinate2D) {
//        let placeClient = GMSPlacesClient.shared()
//        placeClient.currentPlace { (placeLikelihoodList, error) in
//            
//            if error != nil {
//                print("Pick Place error \(error?.localizedDescription)")
//                return
//            }
//            if placeLikelihoodList != nil {
//                let place: GMSPlace? = placeLikelihoodList?.likelihoods.first?.place
//                if place != nil {
//                    
//                    print(place)
//                    print(place?.addressComponents)
//                    //Singleton.sharedInstance.currentAddress = (place?.formattedAddress)!
//                    //currentPlaceName = place?.name
//                }
//            }
//        }
//        
//    }
    
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
//    static func showNormalHud(_ message : String , _ view : UIView) {
//        
//        HUD = JGProgressHUD.init(style: .dark)
//        HUD.textLabel.text = message
//        HUD.show(in: view)
//    }
//    static func removeNormalHud() {
//        HUD.dismiss()
//        
//    }
    
    
//    static func blockAlert() {
//        EZAlertController.alert(NSLocalizedString("Alert", comment: ""), message: NSLocalizedString("You have been blocked by admin. For more details kindly Contact to admin", comment: ""), acceptMessage: NSLocalizedString("OK", comment: "")){ () -> ()
//            in
//            
//            Singleton.sharedInstance.userData = nil
//            let userDefault = Constants.USER_DEFAULTS
//            userDefault.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//            userDefault.synchronize()
//            let storyboard = AppConstants.APP_STORYBOARD.USER
//            let mainViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
//            Constants.APP_DELEGATE.ShowHomeController(mainViewController)
//        }
//    }
    
    
    static func getDateFormatChat(date:String ,In inFormat:String , Out outFormat:String ,convertUTCtoCurrent:Bool) -> String {
        // let
        // convertUTCtoCurrent = false
        let date = self.getDateChat(date: date, format: inFormat, convertUTCtoCurrent: convertUTCtoCurrent)
        let dateToString = self.getDateFormatChat(by: date, format: outFormat, convertUTCtoCurrent: convertUTCtoCurrent)
        return dateToString
    }
    
    static func getDateFormatChat(by date:Date, format:String ,convertUTCtoCurrent:Bool) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if convertUTCtoCurrent == true {
            formatter.timeZone = TimeZone.current
        }
        return formatter.string(from: date)
        
    }
    
    static func getDateChat(date:String , format:String ,convertUTCtoCurrent:Bool) -> Date {
        
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if convertUTCtoCurrent == true {
            formatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        let newDate = formatter.date(from: date)
        return newDate ?? Date()
    }
}
