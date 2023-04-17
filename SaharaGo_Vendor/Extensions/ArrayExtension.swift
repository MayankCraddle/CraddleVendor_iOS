//
//  ArrayExtension.swift
//  HomeFudd
//
//  Created by Rishabh on 29/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    
    func toJSONString(_ formatted: Bool = false) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: (formatted ? JSONSerialization.WritingOptions.prettyPrinted : []))
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            return nil
        }
    }
    
    func toJSONStringFormatted() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch {
            return nil
        }
    }
    
    func toJSONData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            return jsonData
        } catch {
            return nil
        }
    }
}


extension UIButton {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.frame.height/2

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleLabel?.textColor = UIColor.white
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
