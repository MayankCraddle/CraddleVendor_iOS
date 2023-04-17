//
//  UsersListVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 20/10/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UsersListVC: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var usersTableView: UITableView!
    
    let chatViewModel = ChatViewModel()
    var users = [FirebaseUser]()
    private let fdbRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        NotificationCenter.default.addObserver(self, selector: #selector(getUsersList), name: NSNotification.Name(NotificationKeys.MESSAGE), object: nil)
        self.mainView.roundCorners(corners: [.topLeft, .topRight], cornerRadius: 15)
        self.getUsersList()
    }
    
        @objc private func getUsersList(){
            print("Get users list")
            chatViewModel.getUsersList { (usersList) in
                self.users = usersList
                print(self.users)
                DispatchQueue.main.async {
                    if self.users.count > 0 {
                        self.emptyView.isHidden = true
                        self.usersTableView.isHidden = false
                        self.usersTableView.reloadData()
                    } else {
                        self.emptyView.isHidden = false
                        self.usersTableView.isHidden = true
                    }
                    
                    //                self.hideLoading()
                }
    
            } onError: { (errorMessage) in
                print(errorMessage)
            }
        }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension UsersListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableCell", for: indexPath) as! UsersTableCell
        let info = self.users[indexPath.row]
        cell.cellLbl.text = info.name
        if info.profilePic != ""
        {
        cell.userProfilePicImgView.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(info.profilePic)"), placeholderImage: UIImage(named: "avatar"))
        }

        cell.cellMsgLbl.text = info.lastMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.users[indexPath.row]
        let vc = DIConfigurator.shared.getChatVC()
        guard let uidd = info.uid else {return}
        guard let fcmKeyy = info.fcm_key else {return}
        guard let userNamee = info.name else {return}
        vc.toId = uidd
        vc.userName = userNamee
        vc.userProfilePicUrl = info.profilePic ?? ""
        UserDefaults.standard.set(userNamee, forKey: USER_DEFAULTS_KEYS.TO_LOGIN_NAME)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
