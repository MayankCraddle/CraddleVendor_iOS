//
//  Helper.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 22/07/22.
//

import Foundation
import UIKit

var APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

func print_debug<T>(_ obj:T,file: String = #file, line: Int = #line, function: String = #function) {
    //    print("File:'\(file.description)' Line:'\(line)' Function:'\(function)' ::\(obj)")
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func isPasswordValid(_ password : String) -> Bool{
//    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}")    
    return passwordTest.evaluate(with: password)
}
