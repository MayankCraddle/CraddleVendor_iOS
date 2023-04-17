//
//  SellerReceivedVC.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 13/10/22.
//

import UIKit
import Toast_Swift

class SellerReceivedVC: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var ordersReceivedTableView: UITableView!
    
    var currentOrdersArr = [SellerOrdersStruct]()
    var pageNo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.ordersReceivedTableView.register(UINib(nibName: "SellerOrdersCell", bundle: nil), forCellReuseIdentifier: "SellerOrdersCell")
        self.mainView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getCurrentOrders()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.pageNo = 1
    }
    
    func getCurrentOrders() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            let apiUrl = BASE_URL + PROJECT_URL.VENDOR_GET_CURRENT_ORDER + "?pageNumber=\(self.pageNo)" + "&limit=15"
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                if success == "true"
                {
                    if self.pageNo == 1 {
                        self.currentOrdersArr.removeAll()
                    }
                    
                    for i in 0..<json["orderList"].count {
                        
                        let totalSize = json["totalCount"].intValue
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
                        
                        self.currentOrdersArr.append(SellerOrdersStruct.init(firstImg: firstImg, orderId: orderId, name: name, currency: currency, totalPrice: totalPrice, quantity: quantity, createdOn: createdOn, phoneCode: phoneCode, firstName: firstName, lastName: lastName, country: country, state: state, city: city, zipcode: zipcode, landmark: landmark, streetAddress: streetAddress, addressType: addressType, phone: phone, orderBy:orderBy, orderState:orderState, userImage: userImage,discountedPrice:discountedPrice,totalSize: totalSize))
                        
                    }
                    print(self.currentOrdersArr)
                    
                    DispatchQueue.main.async {
                        self.ordersReceivedTableView.reloadData()
                    }
                    
                    if self.currentOrdersArr.count > 0 {
                        self.ordersReceivedTableView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.ordersReceivedTableView.isHidden = true
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
                    self.getCurrentOrders()
                    //                    if self.orderTitleStatus == "Delivered" {
                    //                        self.getDeliveredOrders()
                    //                    } else if self.orderTitleStatus == "Current" {
                    //                        self.getCurrentOrders()
                    //                    } else if self.orderTitleStatus == "InProgress" {
                    //                        self.getInProcessOrders()
                    //                    }
                    
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
        let info = self.currentOrdersArr[index]
        self.changeOrderStateApi("Confirmed", orderID: info.orderId)
    }
    
    @objc func onClickRejectBtn(sender: UIButton)
    {
        let index = sender.tag
        let info = self.currentOrdersArr[index]
        self.changeOrderStateApi("Reject", orderID: info.orderId)
    }
    
    @objc func onClickDetailButton(sender: UIButton)
    {
        let sellerOrderDetailVC = DIConfigurator.shared.getSellerReceivedDetailVC()
        sellerOrderDetailVC.orderDetailArr = currentOrdersArr[sender.tag]
        sellerOrderDetailVC.isFrom = "ReceivedOrder"
        self.navigationController?.pushViewController(sellerOrderDetailVC, animated: true)
    }
}

extension SellerReceivedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentOrdersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerOrdersCell", for: indexPath) as! SellerOrdersCell
        cell.selectionStyle = .none
        cell.threeDotsButton.isHidden = true
        cell.detailButton.isHidden = false
        cell.acceptBtn.isHidden = false
        cell.rejectBtn.isHidden = false
        cell.orderStatusLbl.isHidden = true
        
        let info = self.currentOrdersArr[indexPath.row]
        
        cell.itemImage.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.firstImg)"), placeholderImage: UIImage(named: "loading"))
        
        cell.orderIdLbl.text = info.orderId
        cell.itemNameLbl.text = info.name
        var currency = ""
        if info.currency.lowercased() == "usd"
        {
            currency = "$"
        }
        else if info.currency.lowercased() == "ngn"{
            currency = "₦"
        }
        cell.itemCurrencyPriceQquantityLbl.text = "\(currency) \(info.discountedPrice) | \(info.quantity) Item"

//        cell.itemCurrencyPriceQquantityLbl.text = "\(info.currency) \(info.totalPrice) | \(info.quantity) Item"
        let createdDate = getFormattedDateString(dateStr: info.createdOn, dateFormat: "MMM dd , yyyy h:mm a")
        cell.itemCreatedOnDateLbl.text = createdDate
        cell.itemOrderByNameLbl.text = "Order By: \(info.orderBy)"
        cell.itemOrderByProfileImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.userImage)"), placeholderImage: UIImage(named: "avatar"))
        cell.acceptBtn.tag = indexPath.row
        cell.rejectBtn.tag = indexPath.row
        cell.detailButton.tag = indexPath.row
        cell.acceptBtn.addTarget(self, action: #selector(onClickAcceptBtn(sender:)), for: .touchUpInside)
        cell.rejectBtn.addTarget(self, action: #selector(onClickRejectBtn(sender:)), for: .touchUpInside)
        cell.detailButton.addTarget(self, action: #selector(onClickDetailButton(sender:)), for: .touchUpInside)
        
        if indexPath.row == self.currentOrdersArr.count - 1 { // last cell
            if info.totalSize > self.currentOrdersArr.count { // more items to fetch
                self.pageNo += 1
                self.getCurrentOrders()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerOrderDetailVC = DIConfigurator.shared.getSellerReceivedDetailVC()
        sellerOrderDetailVC.orderDetailArr = currentOrdersArr[indexPath.row]
        sellerOrderDetailVC.isFrom = "ReceivedOrder"
        self.navigationController?.pushViewController(sellerOrderDetailVC, animated: true)
    }
}







































//
//
//                                                                   if success == "true"
//                                                                   {
//                                                                       self.currentOrdersArr.removeAll()
//
//                                                                       for i in 0..<json["orderList"].count {
//
//
//
//                                                                           let firstImg = json["orderList"][i]["cartMetaData"]["items"][0]["metaData"]["images"][0].stringValue
//                                                                           let orderId = json["orderList"][i]["orderId"].stringValue
//                                                                           let name = json["orderList"][i]["cartMetaData"]["items"][0]["name"].stringValue
//                                                                           let currency = json["orderList"][i]["cartMetaData"]["items"][0]["currency"].stringValue
//                                                                           let totalPrice = json["orderList"][i]["cartMetaData"]["items"][0]["totalPrice"].stringValue
//                                                                           let quantity = json["orderList"][i]["cartMetaData"]["items"][0]["quantity"].stringValue
//                                                                           let createdOn = json["orderList"][i]["createdOn"].stringValue
//                                                                           let firstName = json["orderList"][i]["addressMetaData"]["firstName"].stringValue
//                                                                           let lastName = json["orderList"][i]["addressMetaData"]["lastName"].stringValue
//                                                                           let phoneCode = json["orderList"][i]["addressMetaData"]["phoneCode"].stringValue
//                                                                           let phone = json["orderList"][i]["addressMetaData"]["phone"].stringValue
//                                                                           let streetAddress = json["orderList"][i]["addressMetaData"]["streetAddress"].stringValue
//                                                                           let city = json["orderList"][i]["addressMetaData"]["city"].stringValue
//                                                                           let state = json["orderList"][i]["addressMetaData"]["state"].stringValue
//                                                                           let country = json["orderList"][i]["addressMetaData"]["country"].stringValue
//                                                                           let zipcode = json["orderList"][i]["addressMetaData"]["zipcode"].stringValue
//                                                                           let landmark = json["orderList"][i]["addressMetaData"]["landmark"].stringValue
//
//
//                                                                           self.cartDataArr.append(CurrentOrderStruct.init(firstImg: firstImg, orderId: orderId, name: name, currency: currency, totalPrice: totalPrice, quantity: quantity, createdOn: createdOn, phoneCode: phoneCode, firstName: firstName, lastName: <#T##String#>, country: <#T##String#>, state: <#T##String#>, city: <#T##String#>, zipcode: <#T##String#>, landmark: <#T##String#>, streetAddress: <#T##String#>, addressType: <#T##String#>, phone: <#T##String#>)




//
//
//
//                                                                   for j in 0..<json["orderList"][i]["cartMetaData"]["items"].count {
//
//                let productId = json["orderList"][i]["cartMetaData"]["items"][j]["productId"].stringValue
//                let discountPercent = json["orderList"][i]["cartMetaData"]["items"][j]["discountPercent"].stringValue
//                let totalPrice = json["orderList"][i]["cartMetaData"]["items"][j]["totalPrice"].stringValue
//                let quantity = json["orderList"][i]["cartMetaData"]["items"][j]["quantity"].stringValue
//                let discountedPrice = json["orderList"][i]["cartMetaData"]["items"][j]["discountedPrice"].stringValue
//                let itemId = json["orderList"][i]["cartMetaData"]["items"][j]["itemId"].stringValue
//                let price = json["orderList"][i]["cartMetaData"]["items"][j]["price"].stringValue
//                let stock = json["orderList"][i]["cartMetaData"]["items"][j]["stock"].stringValue
//                let currency = json["orderList"][i]["cartMetaData"]["items"][j]["currency"].stringValue
//                let name = json["orderList"][i]["cartMetaData"]["items"][j]["name"].stringValue
//
//                let images = json["orderList"][i]["cartMetaData"]["items"][j]["metaData"]["images"].arrayObject
//                let description = json["orderList"][i]["cartMetaData"]["items"][j]["metaData"]["description"].stringValue
//
//                self.cartDataArr.append(current_order_cartData_struct.init(itemId: itemId, productId: productId, price: price, discountedPrice: discountedPrice, name: name, currency: currency, quantity: quantity, discountPercent: discountPercent, stock: stock, totalPrice: totalPrice, metaData: current_order_metaData_struct.init(images: images!, description: description)))
//                print(self.cartDataArr)
//
//            }
//
//                                                                   let totalPrice = json["orderList"][i]["totalPrice"].stringValue
//                                                                   let orderId = json["orderList"][i]["orderId"].stringValue
//                                                                   let orderState = json["orderList"][i]["orderState"].stringValue
//
//                                                                   print(self.currentOrderArr)
//                                                                   self.currentOrderArr.append(current_order_Address_main_struct.init(orderState: orderState, totalPrice: totalPrice, orderId: orderId, country: country, state: state, lastName: lastName, firstName: firstName, city: city, phone: phone, zipcode: zipcode, streetAddress: streetAddress, landmark: landmark, cartMetaData: self.cartDataArr))
//
//                                                                   // self.currentOrderArr.append(current_order_Address_main_struct.init(orderState: orderState, totalPrice: totalPrice, orderId: orderId, addressMetaData: current_order_Address_struct.init(country: country, state: state, lastName: lastName, firstName: firstName, city: city, phone: phone, zipcode: zipcode, streetAddress: streetAddress, landmark: landmark), cartMetaData: cartDataArr))
//
//                                                                   print(self.currentOrderArr)
//
//                                                                   }
//
//                                                                   DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//
//                                                                   if self.currentOrderArr.count > 0 {
//                self.tableView.isHidden = false
//                self.emptyView.isHidden = true
//            } else {
//                self.tableView.isHidden = true
//                self.emptyView.isHidden = false
//            }
//
//
//                                                                   }
//                                                                   else {
//                UIAlertController.showInfoAlertWithTitle("Message", message: json["message"].stringValue, buttonTitle: "Okay")
//            }
