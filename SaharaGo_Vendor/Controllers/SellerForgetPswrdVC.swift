//
//  SellerForgetPswrdVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 13/10/22.
//

import UIKit
import Toast_Swift

class SellerForgetPswrdVC: UIViewController {

    @IBOutlet weak var mailTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitAction(_ sender: Any) {
        if self.mailTxt.text!.isEmpty {
            self.view.makeToast("Please Enter your Email.")
            return
        } else if !self.mailTxt.text!.isValidEmail() {
            self.view.makeToast("Please enter Valid Email.")
            return
        }
        self.forgotPswrdApi()
    }
    
    func forgotPswrdApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = ["emailMobile": self.mailTxt.text!]
                        
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_FORGOT_PASSWORD, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    UserDefaults.standard.setValue(json["otpId"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)
                    let sellerLoginVC = DIConfigurator.shared.getSellerForgetPswrdOtpVC()
                    self.navigationController?.pushViewController(sellerLoginVC, animated: true)
                }
                else {
                    self.view.makeToast("\(json["message"].stringValue)")
                   // UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
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
