//
//  ForgetPasswordVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 18/10/22.
//

import UIKit

class ForgetPasswordVC: UIViewController {
    
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    @IBOutlet weak var oldPasswordTxt: UITextField!
    @IBOutlet weak var newPasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickEye(_ sender: UIButton) {
        if sender.tag == 101 {
            sender.isSelected = !sender.isSelected
            sender.tintColor = sender.isSelected ? UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0) : UIColor.lightGray
            self.oldPasswordTxt.isSecureTextEntry = !sender.isSelected
        } else if sender.tag == 102 {
            sender.isSelected = !sender.isSelected
            sender.tintColor = sender.isSelected ? UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0) : UIColor.lightGray
            self.newPasswordTxt.isSecureTextEntry = !sender.isSelected
        } else {
            sender.isSelected = !sender.isSelected
            sender.tintColor = sender.isSelected ? UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0) : UIColor.lightGray
            self.confirmPasswordTxt.isSecureTextEntry = !sender.isSelected
        }
    }
    
    @IBAction func submitAction(_ sender: UIButton) {
        
        if self.oldPasswordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Old Password.")
            return
        } else if self.newPasswordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter New Password.")
            return
        } else if self.confirmPasswordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Confirm Password.")
            return
        }  else if !isPasswordValid(self.newPasswordTxt.text!) {
            //            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 alphabet and 1 special character.", title: "Weak Password !")
            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 Uppercase alphabet , 1 Lowercase Alphabet and 1 special character.", title: "Weak Password !")
            self.newPasswordTxt.tintColor = .red
            //            self.newPasswordTxt.selectedLineColor = .red
            //            self.newPasswordTxt.selectedTitleColor = .red
            self.confirmPasswordTxt.text = ""
            self.newPasswordTxt.becomeFirstResponder()
            return
        } else if self.confirmPasswordTxt.text! != self.newPasswordTxt.text! {
            self.view.makeToast("Passwords not matched.")
            return
        }
        
        self.changePasswordAPI()
    }
    
    func changePasswordAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [ "oldPassword": self.oldPasswordTxt.text!,"newPassword":self.newPasswordTxt.text!]
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_CHANGE_PASSWORD, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    //                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    self.showOkAlertWithHandler(json["message"].stringValue) {
                        self.navigationController?.popViewController(animated: true)
                    }
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
}
