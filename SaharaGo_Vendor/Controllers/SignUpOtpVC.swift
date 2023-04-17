//
//  SignUpOtpVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 20/12/22.
//

import UIKit

class SignUpOtpVC: UIViewController {

    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var otpTxt: UITextField!
    
    var otpId = ""
    var seconds = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.seconds -= 1
            if self.seconds == 0 {
                self.timerLbl.isHidden = true
                self.resendBtn.titleLabel?.textColor = UIColor.black
                self.resendBtn.isUserInteractionEnabled = true
                timer.invalidate()
            } else {
                self.timerLbl.isHidden = false
                self.resendBtn.titleLabel?.textColor = UIColor.lightGray
                self.resendBtn.isUserInteractionEnabled = false
                self.timerLbl.text = "Seconds remaining \(self.seconds)"
            }
        }
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSubmit(_ sender: UIButton) {
        if self.otpTxt.text!.isEmpty {
            self.view.makeToast("Please enter Otp.")
            return
        }
        self.verifyOtpApiCall()
    }
    

    func verifyOtpApiCall() {
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

            let param:[String:Any] = [ "otpId": self.otpId,"otp":self.otpTxt.text!, "channel":"iOS"]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_SIGNUP_OTP_VERIFY, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
     
                    let userStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = userStoryboard.instantiateViewController(withIdentifier: "SellerLoginVC") as! SellerLoginVC
                    let rootNC = UINavigationController(rootViewController: viewController)
                    UIApplication.shared.delegate!.window!!.rootViewController = rootNC
                    
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
    
    @IBAction func onClickResend(_ sender: Any) {
        self.resendOtp()
    }
    
    func resendOtp() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
        let param:[String:Any] = [ "otpId": self.otpId]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.USER_RESEND_OTP, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    
                    UserDefaults.standard.setValue(json["otpId"].stringValue, forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_OTP_ID)
                    var secondss = 30
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        secondss -= 1
                        if secondss == 0 {
                            self.timerLbl.isHidden = true
                            self.resendBtn.titleLabel?.textColor = UIColor.black
                            self.resendBtn.isUserInteractionEnabled = true
                            timer.invalidate()
                        } else {
                            self.timerLbl.isHidden = false
                            self.resendBtn.titleLabel?.textColor = UIColor.lightGray
                            self.resendBtn.isUserInteractionEnabled = false
                            self.timerLbl.text = "Seconds remaining \(secondss)"
                        }
                    }
                    
                    self.view.makeToast("Otp sent successfully.")
                
                    

//                    APP_DELEGATE.showBuyerHomeTab(self)
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
