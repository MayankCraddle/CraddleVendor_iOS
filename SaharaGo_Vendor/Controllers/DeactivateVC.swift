//
//  DeactivateVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 21/12/22.
//

import UIKit
import SkyFloatingLabelTextField

class DeactivateVC: UIViewController {

    @IBOutlet weak var mailLbl: UILabel!
    @IBOutlet weak var commentTxt: UITextView!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextField!
    
    var status = "Deactivated"
    var mail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mailLbl.text = self.mail
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickConfiirm(_ sender: Any) {
        if self.passwordTxt.text!.isEmpty {
            self.view.makeToast("Please enter your password.")
            return
        }
        self.showAlertWithActions("Are you sure you want to Deactivate your account ?", titles: ["Yes", "No"]) { (value) in
            if value == 1{
                
                self.changeAccountStatusApi()
            }
        }
    }
    
    func changeAccountStatusApi() {
        
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
            
            let param:[String:Any] = [ "status": self.status,"password":self.passwordTxt.text!, "fcmKey": fcmKey,"comment":self.commentTxt.text!]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.CHANGE_ACCOUNT_STATUS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
                    
                    self.showOkAlertWithHandler("Your account has been deactivated.") {
                        let userStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = userStoryboard.instantiateViewController(withIdentifier: "SellerLoginVC") as! SellerLoginVC
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
    

}
