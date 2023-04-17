//
//  SellerReceivedDetailVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 08/11/22.
//

import UIKit

class SellerReceivedDetailVC: UIViewController {

    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderStatusBulletTxtLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var itemQuantityWeightLbl: UILabel!
    @IBOutlet weak var itemCountPriceLbl: UILabel!
    @IBOutlet weak var itemTotalPriceLbl: UILabel!
    @IBOutlet weak var itemTotalPriceSummaryLbl: UILabel!
    @IBOutlet weak var itemDeliveryFeeSummaryLbl: UILabel!
    @IBOutlet weak var itemGrandTotalSummaryLbl: UILabel!
    @IBOutlet weak var customerProfileImg: UIImageView!
    @IBOutlet weak var customerNameLbl: UILabel!
    @IBOutlet weak var customerEmailIdLbl: UILabel!
    @IBOutlet weak var customerAddressLbl: UILabel!
    @IBOutlet weak var customerCityLbl: UILabel!
    @IBOutlet weak var customerPincodeLbl: UILabel!
    @IBOutlet weak var customerPaymentTypeLbl: UILabel!
    
    @IBOutlet weak var orderStatusBtn: UIButton!
    @IBOutlet weak var orderStatusBackView: UIView!

    @IBOutlet weak var orderStatusBackViewHeightConstraint: NSLayoutConstraint!
    
    
    var orderDetailArr = SellerOrdersStruct()
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDetail()
        if isFrom == "ReceivedOrder"
        {
            self.orderStatusBackView.isHidden = false
            self.orderStatusBtn.isHidden = false
            self.orderStatusBackViewHeightConstraint.constant = 80
        }
        else if isFrom == "ProcessingOrder"
        {
            self.orderStatusBackView.isHidden = true
            self.orderStatusBtn.isHidden = true
            self.orderStatusBackViewHeightConstraint.constant = 0
        }
        else if isFrom == "DeliveredOrder" || isFrom == "CancelledOrder"
        {
            self.orderStatusBackView.isHidden = true
            self.orderStatusBtn.isHidden = true
            self.orderStatusBackViewHeightConstraint.constant = 0
        }
        
    }
    func setDetail()
    {
        let info = orderDetailArr
        self.orderIdLbl.text = info.orderId
        self.orderDateLbl.text = getFormattedDateString(dateStr: info.createdOn, dateFormat: "MMM dd , yyyy h:mm a") //info.createdOn
        //self.orderStatusBulletTxtLbl.text = info.
        self.orderStatusLbl.text = info.orderState
        //self.itemImg: UIImageView!////////firstImg
        self.itemImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.firstImg)"), placeholderImage: UIImage(named: "loading"))
        var currency = ""
        if info.currency.lowercased() == "usd"
        {
            currency = "$"
        }
        else if info.currency.lowercased() == "ngn"{
            currency = "₦"
        }

        self.itemNameLbl.text = info.name
        self.itemQuantityWeightLbl.text = "\(info.quantity) Item"
        self.itemCountPriceLbl.text = "\(currency) \(info.discountedPrice) * \(info.quantity)"
        self.itemTotalPriceLbl.text = "\(currency) \(info.totalPrice)"
        self.itemTotalPriceSummaryLbl.text = "\(currency) \(info.totalPrice)"
        self.itemDeliveryFeeSummaryLbl.text = "\(currency) 0.0"
        self.itemGrandTotalSummaryLbl.text = "\(currency) \(info.totalPrice)"
        //self.customerProfileImg: UIImageView!
        self.customerProfileImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.userImage)"), placeholderImage: UIImage(named: "avatar"))

        self.customerNameLbl.text = "\(info.firstName) \(info.lastName)"
        self.customerEmailIdLbl.text = "test@yopmail.com"//info
        self.customerAddressLbl.text = info.streetAddress
        self.customerCityLbl.text = info.city
        self.customerPincodeLbl.text = info.zipcode
        self.customerPaymentTypeLbl.text = "Card"   
        
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapChangeStatusBtn(_ sender: Any) {
        self.changeOrderStateApi("Confirmed", orderID: orderDetailArr.orderId)
    }
    
    func changeOrderStateApi(_ state: String, orderID: String) {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            var  apiUrl =  BASE_URL + PROJECT_URL.VENDOR_CHANGE_ORDER_STATE
            apiUrl = apiUrl + "\(orderID)/"
            
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            
            let param:[String:Any] = ["state": state]
            
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    //self.view.makeToast(json["message"].stringValue)
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay",viewController: self)

                    
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
    
}
