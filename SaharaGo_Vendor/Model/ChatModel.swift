//
//  ChatModel.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 18/10/22.
//

import Foundation

struct Message: Encodable {
    
    var content: String?
    var fromID: String?
    var timestamp: String?
    var isRead: Bool?
    var toID: String?
    var type: String?
    var queryId: String?
    
}

struct FirebaseUser {
    var uid, email, lastMessage, name, profilePic, fcm_key: String?
    var timestamp: String?
}
