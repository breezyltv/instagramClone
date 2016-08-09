//
//  UtilitiesFunc.swift
//  Instagramlone
//
//  Created by kevin le on 6/5/16.
//  Copyright © 2016 kevin le. All rights reserved.
//

import Foundation
import UIKit

class UtilitiesFunc: NSObject {
    func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
    
    if (cString.hasPrefix("#")) {
        cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.grayColor()
    }
    
    var rgbValue:UInt32 = 0
    NSScanner(string: cString).scanHexInt(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
    }
    
    func isValidEmail(email : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = email.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    func isValidURL(url : String) -> Bool {
        let urlRegEx = "www.+[A-Z0-9a-z._%+-].[A-Za-z{2}]"
        let range = url.rangeOfString(urlRegEx, options: .RegularExpressionSearch)
        let result = range != nil ? true : false

        return result
    }
    
    func alertPopup (errorTitle : String, message :  String) -> UIAlertController{
        let alert = UIAlertController(title: errorTitle, message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(ok)
        return alert
    }
    

}

