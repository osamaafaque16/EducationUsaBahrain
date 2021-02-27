//
//  String+Extension.swift
//  EducationUSA
//
//  Created by Shujaat Ali on 2/3/18.
//  Copyright © 2018 Ingic. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }

    
    func decode() -> String? {
        let data = self.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
}
extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    var intValue: Int {
        if let i = Int(self) {
            return i
        }
        return 0
    }
}
//Date Extension
extension Date{
    var timeStamp: String {
        return String(self.timeIntervalSince1970 * 100000)
    }
}
extension String{
    var encodeEmoji: String? {
        let encodedStr = NSString(cString: self.cString(using: String.Encoding.nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        return encodedStr as! String
    }
    
    var decodeEmoji: String {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if data != nil {
            let valueUniCode = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue) as? String
            if valueUniCode != nil {
                return valueUniCode!
            } else {
                return self
            }
        } else {
            return self
        }
    }
}
extension Object {
    func toDictionary() -> [AnyHashable: Any] {
        let properties = self.objectSchema.properties.map { $0.name }
        var mutableDictionary = self.dictionaryWithValues(forKeys: properties)
        for prop in self.objectSchema.properties {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutableDictionary[prop.name] = nestedObject.toDictionary()
            } else if let nestedListObject = self[prop.name] as? ListBase {
                var objects = [Any]()
                for index in 0..<nestedListObject._rlmArray.count  {
                    let object = nestedListObject._rlmArray[index] as! Object
                    objects.append(object.toDictionary())
                }
                mutableDictionary[prop.name] = objects
            }
        }
        return mutableDictionary
    }
    
}
