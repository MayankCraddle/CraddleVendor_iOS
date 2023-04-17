//
//  SellerSignUpVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 20/12/22.
//

import UIKit
import SkyFloatingLabelTextField

class SellerSignUpVC: UIViewController {
    
    @IBOutlet weak var firstNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var emailIdTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var citytxt: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPaswordTxt: SkyFloatingLabelTextField!
    
    @IBOutlet weak var landmarkTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var zipCodeTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var addressTxt: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTxt: SkyFloatingLabelTextField!

    var metaDataDic: NSMutableDictionary = NSMutableDictionary()
    var finalItemDic: NSMutableDictionary = NSMutableDictionary()
    var addressCode = ""
//    var metaDataDic: NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClickSignIn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickSignUp(_ sender: UIButton) {
        if self.firstNameTxt.text!.isEmpty {
            self.view.makeToast("Please Enter First Name.")
            return
        } else if self.lastNameTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Last Name.")
            return
        } else if self.phoneTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Phone No.")
            return
        } else if self.phoneTxt.text!.count > 11 {
            self.view.makeToast("Please Enter valid Phone No.")
            return
        } else if self.emailIdTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Email.")
            return
        } else if !self.emailIdTxt.text!.isValidEmail() {
            self.view.makeToast("Please enter Valid Email.")
            return
        } else if self.countryTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Country.")
            return
        } else if self.passwordTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Password.")
            return
        } else if !isPasswordValid(self.passwordTxt.text!) {
            showCustomMessageAlertWithTitle(message: "Password must be atleast of 8 characters, 1 Uppercase alphabet , 1 Lowercase Alphabet and 1 special character.", title: "Weak Password !")

            self.passwordTxt.tintColor = .red
            self.passwordTxt.selectedLineColor = .red
            self.passwordTxt.selectedTitleColor = .red
            self.confirmPaswordTxt.text = ""
            self.passwordTxt.becomeFirstResponder()
            return
        } else if self.confirmPaswordTxt.text!.isEmpty {
            self.view.makeToast("Please Confirm your Password")
            return
        } else if self.confirmPaswordTxt.text! != self.passwordTxt.text! {
            self.view.makeToast("Passwords not matched.")
            return
        } else if self.stateTxt.text!.isEmpty {
            self.view.makeToast("Please Enter State.")
            return
        } else if self.citytxt.text!.isEmpty {
            self.view.makeToast("Please Enter City.")
            return
        } else if self.addressTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Address.")
            return
        }
        
        metaDataDic.setValue(self.firstNameTxt.text!, forKey: "firstName")
        metaDataDic.setValue(self.lastNameTxt.text!, forKey: "lastName")
        metaDataDic.setValue(self.addressTxt.text!, forKey: "streetAddress")
        metaDataDic.setValue(self.countryTxt.text!, forKey: "country")
        metaDataDic.setValue(self.stateTxt.text!, forKey: "state")
        metaDataDic.setValue(self.citytxt.text!, forKey: "city")
        metaDataDic.setValue(self.zipCodeTxt.text!, forKey: "zipcode")
        metaDataDic.setValue(self.landmarkTxt.text!, forKey: "landmark")
        
        if let objFcmKey = UserDefaults.standard.object(forKey: "fcm_key") as? String
        {
            fcmKey = objFcmKey
        }
        else
        {
            fcmKey = "abcdef"
        }
        
//        {
//            ""metaData"":{
//                ""firstName"" : ""user"",
//                ""lastName"" : ""Name"",
//                ""phone"" : ""08186782626"",
//                ""streetAddress"" : ""6 Mobolaji Bank Anthony Way"",
//                ""country"" : ""Nigeria"",
//                ""state"" : ""Lagos"",
//                ""city"" : ""Ikeja"",
//                ""zipcode"" : ""201301"",
//                ""landmark"" : ""Near Park"",
//                ""addressType"":""HOME"",
//                ""email"":""nmshmnglk421@gmail.com""
//                }
//        }
        
        self.finalItemDic.setValue(self.firstNameTxt.text!, forKey: "firstName")
        self.finalItemDic.setValue(self.lastNameTxt.text!, forKey: "lastName")
        self.finalItemDic.setValue(self.phoneTxt.text!, forKey: "phone")
        self.finalItemDic.setValue(self.addressTxt.text!, forKey: "streetAddress")
        self.finalItemDic.setValue(self.countryTxt.text!, forKey: "country")
        self.finalItemDic.setValue(self.stateTxt.text!, forKey: "state")
        self.finalItemDic.setValue(self.citytxt.text!, forKey: "city")
        self.finalItemDic.setValue(self.zipCodeTxt.text!, forKey: "zipcode")
        self.finalItemDic.setValue(self.landmarkTxt.text!, forKey: "landmark")
        self.finalItemDic.setValue("HOME", forKey: "addressType")
        self.finalItemDic.setValue(self.emailIdTxt.text!, forKey: "email")
        
        let param:[String:Any] = [ "metaData": self.finalItemDic]
        self.validateAddress(param)
        
    }
    
    func validateAddress(_ param:[String:Any]) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            ServerClass.sharedInstance.postRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VALIDATE_ADDRESS, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    let sellerSignupVC = DIConfigurator.shared.getUploadDocumentsVC()
                    sellerSignupVC.metaDataDic = self.metaDataDic
                    sellerSignupVC.email = self.emailIdTxt.text!
                    sellerSignupVC.mobile = self.phoneTxt.text!
                    sellerSignupVC.password = self.passwordTxt.text!
                    sellerSignupVC.country = self.countryTxt.text!
                    sellerSignupVC.fcmKey = fcmKey
                    sellerSignupVC.addressCode = json["addressCode"].stringValue
                    
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
    
    @IBAction func tapViewPass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.tintColor = sender.isSelected ? UIColor(red: 0/255.0, green: 125/255.0, blue: 67/255.0, alpha: 1.0) : UIColor.lightGray
        if sender.tag == 101 {
            self.passwordTxt.isSecureTextEntry = !sender.isSelected
        } else {
            self.confirmPaswordTxt.isSecureTextEntry = !sender.isSelected
        }
        
    }
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickChooseState(_ sender: UIButton) {
        
        let sellerSignupVC = DIConfigurator.shared.getChooseListVC()
        sellerSignupVC.delegate = self
        self.navigationController?.pushViewController(sellerSignupVC, animated: true)
        
    }
    
    @IBAction func onClickChooseCity(_ sender: Any) {
        if self.stateTxt.text!.isEmpty {
            self.view.makeToast("Please select your State first.")
            return
        }
        let sellerSignupVC = DIConfigurator.shared.getChooseListVC()
        sellerSignupVC.isFrom = "City"
        sellerSignupVC.state = self.stateTxt.text!
        sellerSignupVC.delegate = self
        self.navigationController?.pushViewController(sellerSignupVC, animated: true)
        
//        let sellerStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = sellerStoryboard.instantiateViewController(withIdentifier: "showListVC") as! showListVC
//        vc.isFrom = "City"
//        vc.state = self.stateTxt.text!
//        vc.delegate = self
//        self.present(vc, animated: true, completion: nil)
    }
    
}

extension SellerSignUpVC: ChooseListNamesDelegate{
    func onSelectListNames(country: String, isFrom: String) {
        if isFrom == "City" {
            self.citytxt.text = country
        } else {
            self.stateTxt.text = country
            self.citytxt.text = ""
        }
    }
    
    
}
