//
//  BankAccountVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 02/01/23.
//

import UIKit

class BankAccountVC: UIViewController {

    @IBOutlet weak var signUpBtnView: UIView!
    @IBOutlet weak var addBtnView: UIView!
    @IBOutlet weak var bankNameTxt: UITextField!
    @IBOutlet weak var accountNymberTxt: UITextField!
    @IBOutlet weak var accountNameTxt: UITextField!
    
    var email = ""
    var mobile = ""
    var password = ""
    var country = ""
    var metaDataDic: NSMutableDictionary = NSMutableDictionary()
    var uploadedDocsArr: NSMutableArray = NSMutableArray()
    var accountDic: NSMutableDictionary = NSMutableDictionary()
    var isFromAddAccount = false
    var addressCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if isFromAddAccount {
            self.addBtnView.isHidden = false
            self.signUpBtnView.isHidden = true
        } else {
            self.addBtnView.isHidden = true
            self.signUpBtnView.isHidden = false
        }
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapSignUp(_ sender: UIButton) {
        
        if self.accountNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Account Name.")
            return
        } else if self.accountNymberTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Account Number.")
            return
        } else if self.bankNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Bank Name.")
            return
        }

        accountDic.setValue(self.accountNameTxt.text!, forKey: "accountName")
        accountDic.setValue(self.accountNameTxt.text!, forKey: "accountNumber")
        accountDic.setValue(self.bankNameTxt.text!, forKey: "bankName")
        
        metaDataDic.setValue(uploadedDocsArr, forKey: "documents")
        
        let param:[String:Any] = [ "emailMobile": self.email, "email": self.email, "mobile": self.mobile, "password":self.password,"country":self.country, "fcmKey": fcmKey,"metaData":self.metaDataDic, "accountMetadata": accountDic, "addressCode": self.addressCode]
        print(param)
        self.signupApiCall(param)
    }
    
    func signupApiCall(_ param:[String:Any]) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
           
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_SIGNUP_API, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    let otpId = json["otpId"].stringValue
                    
                    let sellerSignupVC = DIConfigurator.shared.getSignUpOtpVC()
                    sellerSignupVC.otpId = otpId
                    self.navigationController?.pushViewController(sellerSignupVC, animated: true)
                    
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
    
    @IBAction func onClickAddAddress(_ sender: UIButton) {
        if self.accountNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Account Name.")
            return
        } else if self.accountNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Account Number.")
            return
        } else if self.bankNameTxt.text!.isEmpty {
            self.view.makeToast("Please enter your Bank Name.")
            return
        }
        self.addBankAccountAPI()
    }
    
    
    

    func addBankAccountAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let dataDic: NSMutableDictionary = NSMutableDictionary()
            dataDic["accountName"] = self.accountNameTxt.text!
            dataDic["accountNumber"] = self.accountNymberTxt.text!
            dataDic["bankName"] = self.bankNameTxt.text!
            
            let param:[String:Any] = [ "accountMetadata": dataDic ]
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.ADD_BANK_ACCOUNTS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.view.makeToast("\(json["message"].stringValue)")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
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
