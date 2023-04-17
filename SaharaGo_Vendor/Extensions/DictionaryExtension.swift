//
//  DictionaryExtension.swift
//  HomeFudd
//
//  Created by Rishabh on 23/05/19.
//  Copyright © 2019 Mobulous. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func toJSONString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0))
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
            return jsonData
        } catch {
            return nil
        }
    }
}

