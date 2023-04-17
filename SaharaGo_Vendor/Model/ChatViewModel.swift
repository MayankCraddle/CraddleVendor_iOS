//
//  ChatViewModel.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 18/10/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct ChatViewModel {
    
    private let fdbRef = Database.database().reference()
    
//    func getUsersList(onSuccess:@escaping([FirebaseUser]) -> Void, onError:@escaping(String) -> Void){
//
//        var users = [FirebaseUser]()
//        fdbRef.child("users").child(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID) as! String).observeSingleEvent(of: .value) { (snapshot) in
//
//            if snapshot.exists(){
//
//                let enumrator = snapshot.children
//
//                while let snap = enumrator.nextObject() as? DataSnapshot{
//
//                    if let userDict = snap.value as? [String: AnyObject] {
//                        print(userDict)
//                        let uid = snap.key
//                        let currentUid = Auth.auth().currentUser?.uid
//                        let dict = userDict["conversations"] as? [String:AnyObject]
//                        let conversationDict = dict?[currentUid!] as? [String:AnyObject]
//                        let lastMessage = conversationDict?["lastMessage"] as? String
//                        let timeStamp = conversationDict?["timestamp"] as? String
//                        let email = userDict["email"] as? String
//                        let name = userDict["name"] as? String
//                        let profilePic = userDict["profilePic"] as? String
//
//                        let user = FirebaseUser(uid: uid, email: email, lastMessage: lastMessage, name: name, profilePic: profilePic, timestamp: timeStamp)
//
//                        let currentUser = UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL)
//
//                        if email != currentUser{
//                            users.append(user)
//                        }
//                    }
//                }
//                let sortedUserArray = sortUsersListByTime(usersArray: users)
//                onSuccess(sortedUserArray)
//            }else{
//                onSuccess(users)
//            }
//        }
//
//    }
    
    func getUsersList(onSuccess:@escaping([FirebaseUser]) -> Void, onError:@escaping(String) -> Void){
        
        //.child(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID) as! String)
        //d26b9ed13f83547026ba4859babc086c - user
        var users = [FirebaseUser]()
        fdbRef.child("users").child(UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID) as! String).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                print(snapshot)
                var fcm_key = ""
                var email = ""
                var name = ""
                if let dict = snapshot.value as? NSDictionary, let postContent = dict["fcmKey"] as? String {
                    fcm_key = postContent
                } else {
                    
                }
                if let dict = snapshot.value as? NSDictionary, let postContent = dict["email"] as? String {
                    email = postContent
                } else {
                    
                }
                if let dict = snapshot.value as? NSDictionary, let postContent = dict["name"] as? String {
                    name = postContent
                } else {
                    
                }
                
                let enumrator = snapshot.children
                
                while let snap = enumrator.nextObject() as? DataSnapshot{
                    if let userDict = snap.value as? [String: AnyObject] {
                        print(userDict)
                        for (key, value) in userDict {
                            print("key is - \(key) and value is - \(value)")
                            let metaData = value["metaData"] as! NSMutableDictionary
                            let user = metaData["user"] as! NSMutableDictionary
                            let vendor = metaData["vendor"] as! NSMutableDictionary                            
                            
                            let userInstance = FirebaseUser(uid: key, email: email, lastMessage: value["lastMessage"] as! String, name: user["name"] as! String, profilePic: "", fcm_key: fcm_key, timestamp: value["timestamp"] as! String)
                            users.append(userInstance)
                        }
                    }
                }
                let sortedUserArray = sortUsersListByTime(usersArray: users)
                onSuccess(sortedUserArray)
            }else{
                onSuccess(users)
            }
        }
        
    }
    
    private func sortUsersListByTime(usersArray: [FirebaseUser]) -> [FirebaseUser]{
        
        var arrayWithTimeStamp = [FirebaseUser]()
        var arrayWithoutTimeStap = [FirebaseUser]()
        
        usersArray.forEach { (user) in
            if user.timestamp == nil{
                arrayWithoutTimeStap.append(user)
            }else{
                arrayWithTimeStamp.append(user)
            }
        }
        
        arrayWithTimeStamp = arrayWithTimeStamp.sorted(by: { $0.timestamp! > $1.timestamp! })
        let newArray = arrayWithTimeStamp + arrayWithoutTimeStap
        return newArray
        
    }
    
    func getConversationId(request: Message, onSuccess:@escaping(String?) -> Void, onError:@escaping(String) -> Void){
        
        fdbRef.child("users").child(request.fromID!).child("conversations").child(request.toID!).observe( .value) { (snapshot) in
            
            if snapshot.exists(){
                if let dataDict = snapshot.value as? [String:AnyObject]{
                    let conversationId = dataDict["location"]
                    onSuccess(conversationId as? String)
                }
            }else{
                onSuccess(nil)
            }
        }
    }
    
    func getMessages(conversationId: String? = "abc", onSuccess:@escaping([Message]) -> Void){
        
        var messages = [Message]()
        
        fdbRef.child("conversations").child(conversationId ?? "abc").observe(.childAdded) { (snapshot) in
            print(snapshot)
//            NotificationCenter.default.post(name: NSNotification.Name("Message"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(NotificationKeys.MESSAGE), object: nil)
            guard snapshot.exists() else { return }
            if let dataDict = snapshot.value as? [String:AnyObject]{
                
                let content = dataDict["content"] as? String
                let fromId = dataDict["fromID"] as? String
                let toId = dataDict["toID"] as? String
                let isRead = dataDict["isRead"] as? Bool
                let timestamp = dataDict["timestamp"] as? String
                let queryID = dataDict["queryId"] as? String
                let type = dataDict["type"] as? String
                
                let message = Message(content: content, fromID: fromId, timestamp: timestamp, isRead: isRead, toID: toId, type: type,queryId : queryID)
                messages.append(message)
                onSuccess(messages)
            }
        }
    }
    
    func sendMessage(request: Message, onSuccess:@escaping(String) -> Void){
        
        let messageDict = request.convertToDictionary()!
        var metadataDic: [String:AnyObject] = [:]
        var userDic: [String:AnyObject] = [:]
        var vendorDic: [String:AnyObject] = [:]
        let user = UserDefaults.standard.string( forKey: USER_DEFAULTS_KEYS.TO_LOGIN_NAME)
        let vendor = UserDefaults.standard.string( forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
        
        userDic = [
            "name" : user ?? "",
            
        ] as [String : AnyObject]
        
        vendorDic = [
            "name" : vendor ?? "",
            
        ] as [String : AnyObject]
        
        metadataDic = [
            "user" : userDic,
            "vendor" : vendorDic
        ] as [String : AnyObject]
        
        
        fdbRef.child("users").child(request.fromID!).child("conversations").child(request.toID!).observeSingleEvent(of: .value) { (snapshot) in
            
            var conversationId = ""
            var conversationDict: [String:AnyObject] = [:]
            
            if let dataDict = snapshot.value as? [String : AnyObject]{
                conversationId = dataDict["location"] as! String
                conversationDict = [
                    "timestamp" : request.timestamp!,
                    "lastMessage" : request.content!,
                    "metaData" : metadataDic
                ] as [String : AnyObject]
                
            }else{
                conversationId = NSUUID().uuidString.lowercased()
                
                conversationDict = [
                    "location" : conversationId,
                    "lastMessage" : request.content!,
                    "timestamp" : request.timestamp!,
                    "metaData" : metadataDic
                ] as [String : AnyObject]
                
            }
            
            self.fdbRef.child("users").child(request.fromID!).child("conversations").child(request.toID!).updateChildValues(conversationDict)
            
            self.fdbRef.child("users").child(request.toID!).child("conversations").child(request.fromID!).updateChildValues(conversationDict)
            
            self.fdbRef.child("conversations").child(conversationId).childByAutoId().updateChildValues(messageDict as [String:AnyObject])
            
            onSuccess(conversationId)
        }
        
    }
}
