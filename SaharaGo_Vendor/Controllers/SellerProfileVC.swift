//
//  SellerProfileVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 14/10/22.
//

import UIKit
import Toast_Swift

class SellerProfileVC: UIViewController {
    
    @IBOutlet weak var vendorProfileImg: UIImageView!
    @IBOutlet weak var vendorCountryLbl: UILabel!
    @IBOutlet weak var vendorNameLbl: UILabel!
    
    var vendorProfileInfo = vendorProfile_Struct()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getVendorProfile()
    }
    
    func getVendorProfile() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_DETAIL_BY_TOKEN, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    let firstName = json["metaData"]["firstName"].stringValue
                    let lastName = json["metaData"]["lastName"].stringValue
                    let userImage = json["metaData"]["image"].stringValue
                    let coverImage = json["metaData"]["coverImage"].stringValue
                    let state = json["metaData"]["state"].stringValue
                    let streetAddress = json["metaData"]["streetAddress"].stringValue
                    let landmark = json["metaData"]["landmark"].stringValue
                    let city = json["metaData"]["city"].stringValue
                    let zipcode = json["metaData"]["zipcode"].stringValue
                    let sourcing = json["metaData"]["sourcing"].stringValue
                    let country = json["country"].stringValue
                    let emailMobile = json["emailMobile"].stringValue
                    let companyName = json["metaData"]["companyName"].stringValue
                    let about = json["metaData"]["about"].stringValue
                    
                    self.vendorProfileInfo = vendorProfile_Struct.init(firstName: firstName, lastName: lastName, country: country, state: state, city: city, zipcode: zipcode, landmark: landmark, streetAddress: streetAddress, sourcing: sourcing, emailMobile: emailMobile, userImage: userImage, coverImage: coverImage, companyName: companyName, about: about)
                    
                    
                    
                    self.setDetails(self.vendorProfileInfo)
                    
                } else {
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
    
    func setDetails(_ profileInfo: vendorProfile_Struct) {
        
        self.vendorNameLbl.text = "\(profileInfo.firstName) \(profileInfo.lastName)"
        self.vendorCountryLbl.text = profileInfo.country
        
        //        self.cityTxt.text = profileInfo.city
        //        self.stateTxt.text = profileInfo.state
        //        self.zipcodeTxt.text = profileInfo.zipcode
        //        self.countryTxt.text = profileInfo.country
        //        self.firstNameTxt.text = profileInfo.firstName
        //        self.lastNameTxt.text = profileInfo.lastName
        //        self.emailMobileTxt.text = profileInfo.emailMobile
        //        self.streetAddressTxt.text = profileInfo.streetAddress
        //        self.landmarkTxt.text = profileInfo.landmark
        // self.userProfileImg.contentMode = .scaleToFill
        self.vendorProfileImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(profileInfo.userImage)"), placeholderImage: UIImage(named: "avatar"))
        //        self.metadataDic.setValue(profileInfo.userImage, forKey: "image")
        
    }
    
    @IBAction func onClickNotification(_ sender: UIButton) {
        let vc = DIConfigurator.shared.getNotificationVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func profileActions(_ sender: UIButton) {
        if sender.tag == 101 {
            let vc = DIConfigurator.shared.getEditProfileVC()
            vc.vendorProfileInfo = self.vendorProfileInfo
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 102 {
            let vc = DIConfigurator.shared.getForgetPasswordVC()
            //            let vc = DIConfigurator.shared.getChatVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 103 {
            let vc = DIConfigurator.shared.getDeactivateVC()
            vc.mail = self.vendorProfileInfo.emailMobile
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 104 {
            let vc = DIConfigurator.shared.getDeleteVC()
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if sender.tag == 105 {
            self.showAlertWithActions("Are you sure you want to LogOut ?", titles: ["Yes", "No"]) { (value) in
                if value == 1{
                    //let domain = Bundle.main.bundleIdentifier!
                    //UserDefaults.standard.removePersistentDomain(forName: domain)
                    //UserDefaults.standard.synchronize()
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.VENDOR_SIGNUP_TOKEN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
                    UserDefaults.standard.set("", forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
                    
                    let userStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = userStoryboard.instantiateViewController(withIdentifier: "SellerLoginVC") as! SellerLoginVC
                    let rootNC = UINavigationController(rootViewController: viewController)
                    UIApplication.shared.delegate!.window!!.rootViewController = rootNC
                }
            }
        } else {
            let sellerOrderDetailVC = DIConfigurator.shared.getProfileAccountsVC()
            self.navigationController?.pushViewController(sellerOrderDetailVC, animated: true)
        }
    }

}
