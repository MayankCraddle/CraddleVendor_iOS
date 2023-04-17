//
//  ChooseListVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 20/03/23.
//

import UIKit


protocol ChooseListNamesDelegate {
    func onSelectListNames(country: String, isFrom: String)
}

class ChooseListVC: UIViewController {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var delegate: ChooseListNamesDelegate?
    var list = [String]()
    var isFrom = ""
    var state = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        if self.isFrom == "City" {
            self.headerLbl.text = "Select City"
        } else {
            self.headerLbl.text = "Select State"
        }
        self.getList()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.isHidden = true
    }
    
    func getList() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            var apiUrl = ""
            if self.isFrom == "City" {
                apiUrl = BASE_URL + PROJECT_URL.GET_CITY + "?state=\(self.state)"
            } else {
                apiUrl = BASE_URL + PROJECT_URL.GET_STATE
            }
            
            let url : NSString = apiUrl as NSString
            let urlStr : NSString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
            
            
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: urlStr as String, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.list.removeAll()
//                    self.list.append(<#T##Self.Output#>)
//                    var arr = [String]()
                    let arr = json["list"].arrayValue
                    for item in arr {
                        let strr = item.rawValue as! String
                        self.list.append(strr)
                    }
                    print(self.list)
                    
//                    for i in 0..<arr.count
//                    {
//                        arr = json["list"].arrayValue
//                        self.list.append(ListName_Struct.init(name: name))
//
//                    }
//                    self.list.sort { $0.active && !$1.active}
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    if self.list.count > 0 {
                        self.tableView.isHidden = false
                        self.emptyView.isHidden = true
                    } else {
                        self.tableView.isHidden = true
                        self.emptyView.isHidden = false
                    }
                    
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

extension ChooseListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseListCell", for: indexPath) as! ChooseListCell
//        let info = self.list[indexPath.row]
        cell.cellLbl.text = self.list[indexPath.row] as! String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let str = self.list[indexPath.row]
        
        delegate?.onSelectListNames(country: str as! String, isFrom: self.isFrom)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension ChooseListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.getList()
        } else {
            
            self.list = self.list.sorted(by: { (i1, i2) -> Bool in
                return i1.contains(searchText.capitalized)
            })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        print("searchText \(searchText)")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
    }
}
