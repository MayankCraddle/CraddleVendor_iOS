//
//  UserViewModel.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 18/10/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

//struct UserViewModel {
//    
//    private let fdbRef = Database.database().reference()
//
//    
//    func loginWithFirebase(email: String, password: String, id : String, name : String,ID : String,onSuccess:@escaping(Bool) -> Void, onError:@escaping(String) -> Void){
//        
//        Auth.auth().signIn(withEmail: email, password: "123456") { (result, error) in
//            
//            if error != nil{
//                onError(error!.localizedDescription)
//            }else{
//                
//                guard let userId = Auth.auth().currentUser?.uid  else { return }
//                
//                let userDict = [
//                    "email": email,
//                    "name" : name
//                ]
//                
//                fdbRef.child("users").child(userId).updateChildValues(userDict as [AnyHashable : Any])
//                onSuccess(true)
//            }
//            
//        }
//        
//    }
//    
//    func signUpWithFirebase(email: String, password: String ,id : String, name : String,ID : String, onSuccess:@escaping(Bool) -> Void, onError:@escaping(String) -> Void){
//        
//        Auth.auth().createUser(withEmail: email, password: "123456") { (result, error) in
//         
//            if let err = error{
//                let error = err as NSError
//                switch error.code {
//                case AuthErrorCode.emailAlreadyInUse.rawValue:
//                    onSuccess(true)
//                default:
//                    onError(error.localizedDescription)
//                }
//            }else{
//                onSuccess(true)
//            }
//        }
//    }
//
//}
