//
//  ProfileAccountsVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 02/01/23.
//

import UIKit

class ProfileAccountsVC: UIViewController {

    var accountArr = [account_Struct]()
    
    @IBOutlet weak var accTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getBankAccountsAPI()
    }
    

    func getBankAccountsAPI() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            let apiUrl = BASE_URL + PROJECT_URL.GET_BANK_ACCOUNTS
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.accountArr.removeAll()
                    
                    for i in 0..<json["accountDetailList"].count {

                        let id = json["accountDetailList"][i]["id"].intValue
                        let isDefault = json["accountDetailList"][i]["isDefault"].boolValue
                        let bankSortCode = json["accountDetailList"][i]["accountMetadata"]["bankName"].stringValue
                        let accountName = json["accountDetailList"][i]["accountMetadata"]["accountName"].stringValue
                        let accountNumber = json["accountDetailList"][i]["accountMetadata"]["accountNumber"].stringValue
                        
                        self.accountArr.append(account_Struct.init(id: id, bankSortCode: bankSortCode, accountName: accountName, accountNumber: accountNumber, isDefault: isDefault))

                        

                    }
//
                    DispatchQueue.main.async {
                        self.accTableView.reloadData()
                    }

                    if self.accountArr.count > 0 {
                        self.accTableView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.accTableView.isHidden = true
                        self.emptyView.isHidden = false
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
    
    @IBAction func onClickBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func onCLickAdd(_ sender: UIButton) {
        let vc = DIConfigurator.shared.getBankAccountVC()
        vc.isFromAddAccount = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cellDeleteAction(_ sender: UIButton) {
        
        let indexPath: IndexPath? = self.accTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.accTableView))
        
        var info = self.accountArr[indexPath!.row]
        
        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Make Default", style: .default , handler:{ (UIAlertAction)in
            self.defaultAddressAPI(info.id)
        }))
        
//        alert.addAction(UIAlertAction(title: "Delete", style: .default , handler:{ (UIAlertAction)in
//            self.deleteAccountApi("\(info.id)")
//
//        }))
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func deleteAccountApi(_ id: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            let apiUrl = BASE_URL + PROJECT_URL.DELETE_ACCOUNT + "id"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {

                    
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
    
    func defaultAddressAPI(_ id: Int) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = [:]
            
            var apiUrl = BASE_URL + PROJECT_URL.USER_MARK_DEFAULT_ACCOUNT
            apiUrl = apiUrl + "\(id)"
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: apiUrl, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    
                    self.view.makeToast(json["message"].stringValue)
                    self.getBankAccountsAPI()
                    
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

extension ProfileAccountsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        
        let info = self.accountArr[indexPath.row]
        cell.cellAccountNameLbl.text = info.accountName
        cell.cellAccountNumberLbl.text = "A/C No. - \(info.accountNumber)"
        cell.cellBankCodeLbl.text = "Bank Name - \(info.bankSortCode)"
        cell.cellDefaultImg.isHidden = !info.isDefault
        
        return cell
    }
    
    
}
