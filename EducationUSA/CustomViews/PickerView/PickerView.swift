//
//  PickerView.swift
//  CloudMadeFood
//
//  Created by Manoj Kumar on 6/16/17.
//  Copyright © 2017 Muzamil Hassan. All rights reserved.
//

import UIKit
import MRCountryPicker
class PickerView: UIView,MRCountryPickerDelegate {
    var DoneCallback : ((_ phoneCode:String,_ country:String) -> Void)?
    var CancelCallback : (() -> Void)?
    var CountryCode = "+93"
    var countryName = "Afghanistan"
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var CountryPicker: MRCountryPicker!
    var height:CGFloat!
    override func awakeFromNib() {
        CountryPicker.countryPickerDelegate = self
        CountryPicker.selectRow(0, inComponent: 0, animated: false)
        
        
    }
    @IBAction func CancelButtonClicked(_ sender: Any) {
        //removeAnimate()
        CancelCallback!()
        
    }
    
    
    @IBAction func DoneButtonClicked(_ sender: Any) {
        
        DoneCallback!(CountryCode,countryName)
        
    }
    
    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage){
        
        
        CountryCode = phoneCode
        countryName = name
    }
    
    
    
    
    func showAnimate()
    {
        height = mainView.frame.size.height
        self.pickerView.frame = CGRect(x: 0, y: height, width: mainView.frame.width, height: pickerView.frame.height)
        print(height)
        UIView.animate(withDuration: 0.25, animations: {
            
        
            print(self.height - self.pickerView.frame.size.height)
            self.pickerView.frame = CGRect(x: 0, y: self.height - self.pickerView.frame.size.height, width: self.mainView.frame.width, height: self.pickerView.frame.height)
            
        })
    }
    func removeAnimate()    {
        height = mainView.frame.size.height
        self.pickerView.frame = CGRect(x: 0, y: height - self.pickerView.frame.size.height, width: mainView.frame.width, height: self.pickerView.frame.height)
        print(height)
        UIView.animate(withDuration: 0.25, animations: {
            print(self.height - self.pickerView.frame.size.height)
            self.pickerView.frame = CGRect(x: 0, y: self.height, width: self.mainView.frame.width, height: self.pickerView.frame.height)
            
        })
        // For Delay
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.removeFromSuperview()
        }
    }
    
}
