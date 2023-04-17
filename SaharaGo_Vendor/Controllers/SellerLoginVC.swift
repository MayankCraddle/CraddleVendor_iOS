//
//  SellerLoginVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 13/10/22.
//

import UIKit
import Toast_Swift
import SwiftyJSON
import FirebaseDatabase

class SellerLoginVC: UIViewController {

    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var mailtxt: UITextField!
    
    let data = JSON()
//    private let loginViewModel = UserViewModel()
    var PZip = ""
    var fName = ""
    var lName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.mailtxt.text!.isEmpty {
            self.view.makeToast("Please Enter Email.")
            return
        } else if self.passwordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Password.")
            return
        }
        UserDefaults.standard.set(self.mailtxt.text!, forKey:USER_DEFAULTS_KEYS.LOGIN_EMAIL)
        UserDefaults.standard.set(self.passwordTxt.text!, forKey:USER_DEFAULTS_KEYS.LOGIN_PASSWORD)
        self.loginApiCall()
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
        let sellerLoginVC = DIConfigurator.shared.getSellerForgetPswrdVC()
        self.navigationController?.pushViewController(sellerLoginVC, animated: true)
        
    }
    
    @IBAction func viewPaswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = sender.isSelected ? UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0) : UIColor.lightGray
        self.passwordTxt.isSecureTextEntry = !sender.isSelected
    }
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        let sellerSignupVC = DIConfigurator.shared.getSellerSignUpVC()
        self.navigationController?.pushViewController(sellerSignupVC, animated: true)
    }
    
    
    func loginApiCall() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                //                fcmKey = ""
                fcmKey = "abcdef"
            }
            
            let param:[String:Any] = [ "emailMobile": self.mailtxt.text!,"password":self.passwordTxt.text!, "fcmKey": fcmKey,"channel":"iOS"]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_LOGIN_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    //save data in userdefault..
                    UserDefaults.standard.setValue(json["token"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    UserDefaults.standard.setValue(json["type"].stringValue, forKey: USER_DEFAULTS_KEYS.USER_TYPE)
                    UserDefaults.standard.setValue(json["encryptedId"].stringValue, forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                    UserDefaults.standard.setValue(json["name"].stringValue, forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
                    UserDefaults.standard.setValue(fcmKey, forKey: "fcm_key")
                    
                    
//                    APP_DELEGATE.showSellerHomeTab(self)
                    
                    let emailid = UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.LOGIN_EMAIL)
                    let encryptedId = UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID)
                                        
                    let userDict = [
                        "email": self.mailtxt.text!,
                        "name" : json["name"].stringValue,
                        "fcmKey" : fcmKey
                    ]
                    
                    Database.database().reference().child("users").child("\(encryptedId ?? "")").updateChildValues(userDict as [AnyHashable : Any])
                    
                    if json["deactivated"].boolValue {
                        self.showAlertWithActions("Your account has been deactivated. Do you want to reactivate your account ?", titles: ["Yes", "No"]) { (value) in
                            if value == 1{
                                self.reactivateAccountApi()
                            }
                        }
                        
                        return
                    }
                    
                    let userStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = userStoryboard.instantiateViewController(withIdentifier: "SellerTabBarVC") as! SellerTabBarVC
                    let rootNC = UINavigationController(rootViewController: viewController)
                    UIApplication.shared.delegate!.window!!.rootViewController = rootNC
                                        
//                    self.loginWithFirebase( email: emailid!,id : "id", name : emailid!,ID : "ID")
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                    //UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
    func reactivateAccountApi() {
        
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
            {
                fcmKey = objFcmKey
            }
            else
            {
                fcmKey = "abcdef"
            }
            UserDefaults.standard.set(fcmKey, forKey: "fcm_key")
            
            let param:[String:Any] = [ "status": "Active","password":self.passwordTxt.text!, "fcmKey": fcmKey,"comment":""]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CHANGE_ACCOUNT_STATUS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {

                    self.showOkAlertWithHandler("Your account has been Reactivated.") {
                        let userStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = userStoryboard.instantiateViewController(withIdentifier: "SellerTabBarVC") as! SellerTabBarVC
                        let rootNC = UINavigationController(rootViewController: viewController)
                        UIApplication.shared.delegate!.window!!.rootViewController = rootNC
                        
                    }
                    
                                        
                }
                else {
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                }
            }, errorBlock: { (NSError) in
                UIAlertController.showInfoAlertWithTitle("Alert", message: kUnexpectedErrorAlertString, buttonTitle: "Okay")
                hideAllProgressOnView(appDelegateInstance.window!)
            })
            
        }else{
            hideAllProgressOnView(appDelegateInstance.window!)
            UIAlertController.showInfoAlertWithTitle("Alert", message: "Please Check internet connection", buttonTitle: "Okay")
        }
    }
    
//    private func loginWithFirebase(email: String,id : String, name : String,ID : String){
//        let pass = UserDefaults.standard.string(forKey: USER_DEFAULTS_KEYS.LOGIN_PASSWORD) ?? ""
//        loginViewModel.loginWithFirebase(email: email, password: pass,id : id, name : name,ID : ID) { (success) in
//
//            //  if self.user != nil{
//            //   self.saveDataToUserDefaults(user: self.user!)
//            DispatchQueue.main.async {
//                hideProgressOnView(self.view)
//                self.fName = ""
//                self.lName = ""
//                print("Logged in with firebase successfully")
//                let userStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController = userStoryboard.instantiateViewController(withIdentifier: "SellerTabBarVC") as! SellerTabBarVC
//                let rootNC = UINavigationController(rootViewController: viewController)
//                UIApplication.shared.delegate!.window!!.rootViewController = rootNC
//            }
//        } onError: { (errorMessage) in
//            DispatchQueue.main.async {
//                UserDefaults.standard.set(nil, forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
//                hideProgressOnView(self.view)
//                showMessageAlert(message: errorMessage)
//            }
//        }
//    }
}
