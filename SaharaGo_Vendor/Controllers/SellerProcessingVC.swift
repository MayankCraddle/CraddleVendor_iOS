//
//  SellerProcessingVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 17/10/22.
//

import UIKit

class SellerProcessingVC: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ordersProcessingTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!

    var processingOrdersArr = [SellerOrdersStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.ordersProcessingTableView.register(UINib(nibName: "SellerOrdersCell", bundle: nil), forCellReuseIdentifier: "SellerOrdersCell")
        self.mainView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getInProgressOrders()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getInProgressOrders() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_GET_INPROGRESS_ORDER, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    self.processingOrdersArr.removeAll()
                    for i in 0..<json["orderList"].count {
                        
                        let firstImg = json["orderList"][i]["cartMetaData"]["items"][0]["metaData"]["images"][0].stringValue
                        let orderId = json["orderList"][i]["orderId"].stringValue
                        let name = json["orderList"][i]["cartMetaData"]["items"][0]["name"].stringValue
                        let currency = json["orderList"][i]["cartMetaData"]["items"][0]["currency"].stringValue
                        let totalPrice = json["orderList"][i]["cartMetaData"]["items"][0]["totalPrice"].stringValue
                        let quantity = json["orderList"][i]["cartMetaData"]["items"][0]["quantity"].stringValue
                        let createdOn = json["orderList"][i]["createdOn"].stringValue
                        let firstName = json["orderList"][i]["addressMetaData"]["firstName"].stringValue
                        let lastName = json["orderList"][i]["addressMetaData"]["lastName"].stringValue
                        let phoneCode = json["orderList"][i]["addressMetaData"]["phoneCode"].stringValue
                        let phone = json["orderList"][i]["addressMetaData"]["phone"].stringValue
                        let streetAddress = json["orderList"][i]["addressMetaData"]["streetAddress"].stringValue
                        let city = json["orderList"][i]["addressMetaData"]["city"].stringValue
                        let state = json["orderList"][i]["addressMetaData"]["state"].stringValue
                        let country = json["orderList"][i]["addressMetaData"]["country"].stringValue
                        let zipcode = json["orderList"][i]["addressMetaData"]["zipcode"].stringValue
                        let landmark = json["orderList"][i]["addressMetaData"]["landmark"].stringValue
                        let addressType = json["orderList"][i]["addressMetaData"]["addressType"].stringValue
                        let orderBy = json["orderList"][i]["orderBy"].stringValue
                        let orderState = json["orderList"][i]["orderState"].stringValue
                        let userImage = json["orderList"][i]["userImage"].stringValue
                        let discountedPrice = json["orderList"][i]["cartMetaData"]["items"][0]["discountedPrice"].stringValue
                        
                        self.processingOrdersArr.append(SellerOrdersStruct.init(firstImg: firstImg, orderId: orderId, name: name, currency: currency, totalPrice: totalPrice, quantity: quantity, createdOn: createdOn, phoneCode: phoneCode, firstName: firstName, lastName: lastName, country: country, state: state, city: city, zipcode: zipcode, landmark: landmark, streetAddress: streetAddress, addressType: addressType, phone: phone, orderBy:orderBy, orderState:orderState, userImage:userImage,discountedPrice:discountedPrice))
                        
                    }
                    print(self.processingOrdersArr)
                    
                    DispatchQueue.main.async {
                        self.ordersProcessingTableView.reloadData()
                    }
                    
                    if self.processingOrdersArr.count > 0 {
                        self.ordersProcessingTableView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.ordersProcessingTableView.isHidden = true
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
    
    func openActionSheet(orderID: String) {
        
        //        let indexPath: IndexPath? = self.ordersReceivedTableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.ordersReceivedTableView))
        //        var info = address_Struct()
        //        info = self.addressArr[indexPath!.row]
       
        
        let alert = UIAlertController(title: "", message: "Change your Order State.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirmed", style: .default , handler:{ (UIAlertAction)in
            self.changeOrderStateApi("Confirmed", orderID: orderID)
        }))
        
        alert.addAction(UIAlertAction(title: "Packed", style: .default , handler:{ (UIAlertAction)in
            self.changeOrderStateApi("Packed", orderID: orderID)
        }))
        
        alert.addAction(UIAlertAction(title: "Shipped", style: .default , handler:{ (UIAlertAction)in
            self.changeOrderStateApi("Shipped", orderID: orderID)
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
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
                    UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
                    self.getInProgressOrders()
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
    
    @IBAction func onClickChat(_ sender: UIButton) {
        let vc = DIConfigurator.shared.getUsersListVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func onClickAcceptBtn(sender: UIButton)
    {
        let index = sender.tag
        let info = self.processingOrdersArr[index]
        self.changeOrderStateApi("Confirmed", orderID: info.orderId)
    }
    
    @objc func onClickRejectBtn(sender: UIButton)
    {
        let index = sender.tag
        let info = self.processingOrdersArr[index]
        self.changeOrderStateApi("Reject", orderID: info.orderId)
    }
    
    @objc func onClickDetailButton(sender: UIButton)
    {
    }
    
    @objc func onClickThreeDotsButton(sender: UIButton)
    {
        let index = sender.tag
        let info = self.processingOrdersArr[index]
        self.openActionSheet(orderID: info.orderId)
    }
    @IBAction func onClickChatBtn(_ sender: Any) {
    }
    
    
    
}

extension SellerProcessingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.processingOrdersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrdersCell", for: indexPath) as! SellerOrdersCell
        cell.selectionStyle = .none
        cell.threeDotsButton.isHidden = false
        cell.detailButton.isHidden = true
        cell.acceptBtn.isHidden = true
        cell.orderStatusLbl.isHidden = false
        
        let info = self.processingOrdersArr[indexPath.row]
        
        cell.itemImage.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.firstImg)"), placeholderImage: UIImage(named: "loading"))
        
        cell.orderIdLbl.text = info.orderId
        cell.itemNameLbl.text = info.name
       // cell.itemCurrencyPriceQquantityLbl.text = "\(info.currency) \(info.totalPrice) | \(info.quantity) Item"
        var currency = ""
        if info.currency.lowercased() == "usd"
        {
            currency = "$"
        }
        else if info.currency.lowercased() == "ngn"{
            currency = "₦"
        }
        cell.itemCurrencyPriceQquantityLbl.text = "\(currency) \(info.discountedPrice) | \(info.quantity) Item"

        cell.itemCreatedOnDateLbl.text = getFormattedDateString(dateStr: info.createdOn, dateFormat: "MMM dd , yyyy h:mm a") //info.createdOn
        cell.itemOrderByNameLbl.text = "Order By: \(info.orderBy)"
        let orderState = info.orderState
        
        if orderState.lowercased() == "confirmed"
        {
            cell.orderStatusLbl.textColor = .systemGreen
        }
        else  if orderState.lowercased() == "packed"
        {
            cell.orderStatusLbl.textColor = UIColor(red: 209.00/255.00, green: 189.00/255.00, blue: 5.00/255.00, alpha: 1.00)
        }
        else  if orderState.lowercased() == "shipped"
        {
            cell.orderStatusLbl.textColor = .black
        }
        cell.orderStatusLbl.text = orderState
        cell.itemOrderByProfileImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.userImage)"), placeholderImage: UIImage(named: "avatar"))
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        cell.detailButton.tag = indexPath.row
        cell.threeDotsButton.tag = indexPath.row

        cell.acceptBtn.addTarget(self, action: #selector(onClickAcceptBtn(sender:)), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(onClickRejectBtn(sender:)), for: .touchUpInside)
        cell.detailButton.addTarget(self, action: #selector(onClickDetailButton(sender:)), for: .touchUpInside)
        cell.threeDotsButton.addTarget(self, action: #selector(onClickThreeDotsButton(sender:)), for: .touchUpInside)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerOrderDetailVC = DIConfigurator.shared.getSellerReceivedDetailVC()
        sellerOrderDetailVC.orderDetailArr = self.processingOrdersArr[indexPath.row]
        sellerOrderDetailVC.isFrom = "ProcessingOrder"

        self.navigationController?.pushViewController(sellerOrderDetailVC, animated: true)
    }
    
    
}

