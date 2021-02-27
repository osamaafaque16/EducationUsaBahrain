


import Foundation
import UIKit
class Validation {
    
    
    
    func roundAndFormatFloat(_ floatToReturn : Float, numDecimalPlaces: Int) -> String{
        
        let formattedNumber = String(format: "%.\(numDecimalPlaces)f", floatToReturn)
        return formattedNumber
        
    }
    
    static func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func validateStringLength(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return !trimmed.isEmpty
    }
    static func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
}
