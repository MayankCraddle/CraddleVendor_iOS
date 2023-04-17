////
////  ChatVC.swift
////  SaharaGo_Vendor
////
////  Created by ChawTech Solutions on 18/10/22.
////
//
import UIKit
import FirebaseAuth
import MobileCoreServices
import SwiftyJSON
import FirebaseDatabase

struct NotificationKeys {
    //    static let CLICKED_OK_IN_POP_UP = "ClickedOkInPopUpView"
    //    static let SLOT_BOOKED = "SlotBooked"
    //    static let PROFILE_UPDATE = "ProfileUpdate"
    static let MESSAGE = "Message"
}

class ChatVC: UIViewController {
    
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userProfilePicImgView: UIImageView!
    @IBOutlet weak var userProfilePicBtn: UIButton!
    
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    
    var user: FirebaseUser?
    var messages = [Message]()
    private let chatViewModel = ChatViewModel()
    var conversationId: String?
    let TYPE_A_MESSAGE = "Type a message..."
    var fcmKeys = [JSON]()
    var toId = ""
    var userFcmKey = ""
    private let fdbRef = Database.database().reference()
    var userName = ""
    var userProfilePicUrl = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addNotificationObserver()
        messageTxtView.delegate = self
        self.userNameLbl.text = self.userName
        if userProfilePicUrl != ""
        {
            self.userProfilePicImgView.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(userProfilePicUrl)"), placeholderImage: UIImage(named: "avatar"))
            
            self.userProfilePicBtn.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(userProfilePicUrl)"), for: .normal, placeholderImage: UIImage(named: "avatar"))
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            self.chatTableView.reloadData()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            //Reload with delay
//            self.chatTableView.reloadData()
//            //Again reload with delay
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self.chatTableView.reloadData()
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getConversationId()
        self.getUserFCmKey()
    }
    
    func getUserFCmKey() {
        fdbRef.child("users").child(self.toId).observeSingleEvent(of: .value) { (snapshot) in
            
            if snapshot.exists(){
                print(snapshot)
                
                var email = ""
                if let dict = snapshot.value as? NSDictionary, let postContent = dict["fcmKey"] as? String {
                    self.userFcmKey = postContent
                } else {
                    
                }
                if let dict = snapshot.value as? NSDictionary, let postContent = dict["email"] as? String {
                    email = postContent
                } else {
                    
                }
                
            }else{
                
            }
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func sendNotification(message : String, image: String) {
        let sender = PushNotificationSender()
        let name = UserDefaults.standard.string( forKey: USER_DEFAULTS_KEYS.LOGIN_NAME)
        // let val = self.Totlegallry_Arr[0]["deviceTokens"].arrayValue
        //        for i in 0..<fcmKeys.count {
        //            let token  = fcmKeys[i].stringValue
        //            if token != "" {
        ////                sender.sendPushNotification(to: token , title: "New Message from \(name ?? "")", body: message,email : self.patientEmail, queryID : queryID, image: image)
        //                sender.sendPushNotification(to: token , title: "New Message from \(name ?? "")", body: message,email : "", queryID : "", image: image)
        //            }
        //        }
        sender.sendPushNotification(to: self.userFcmKey , title: "New Message from \(name ?? "")", body: message,email : "", queryID : "", image: image)
    }
    
    @objc func handleKeyboard(_ notification: Notification){
        
        if notification.name == UIResponder.keyboardWillShowNotification{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                let bottomSafeArea = view.safeAreaInsets.bottom
                self.messageViewBottomConstraint.constant = keyboardHeight - bottomSafeArea
                if messages.count != 0{
                    DispatchQueue.main.async {
                        self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                    }
                }
                
            }
        }else if notification.name == UIResponder.keyboardWillHideNotification{
            self.messageViewBottomConstraint.constant = 0
        }
    }
    
    func getConversationId(){
        
        //        guard let fromId = Auth.auth().currentUser?.uid else { return }
        //        guard let toId = self.user?.uid else { return }
        
        let fromId = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID) as! String
        let toId = self.toId
        
        let request = Message(fromID: fromId, toID: toId)
        
        chatViewModel.getConversationId(request: request) { (conversationId) in
            self.conversationId = conversationId
            self.getMessages()
        } onError: { (errorMesage) in
            DispatchQueue.main.async {
                
                showMessageAlert(message: errorMesage)
            }
        }
    }
    
    func getMessages(){
        
        chatViewModel.getMessages(conversationId: self.conversationId) { (messages) in
            self.messages = messages
            NotificationCenter.default.post(name: NSNotification.Name(NotificationKeys.MESSAGE), object: nil)
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                print("Scroll to bottom in chat vc")
                self.chatTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: false)
                DispatchQueue.main.async {
                    self.chatTableView.beginUpdates()
                    //self.chatTableView.layoutIfNeeded()
                    self.chatTableView.endUpdates()
                }
                
            }
        }
    }
    
    @IBAction func onClickSend(){
        
        let message = messageTxtView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard message != TYPE_A_MESSAGE else { return }
        
        guard !message.isEmpty else { return }
        
        //        guard let fromId = Auth.auth().currentUser?.uid else { return }
        //        guard let toId = self.user?.uid else { return }
        
        let fromId = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID) as! String
        let toId = self.toId
        
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        let isRead = false
        let type = "text"
        self.sendNotification(message: messageTxtView.text!, image: "")
        let request = Message(content: message, fromID: fromId, timestamp: "\(timestamp)", isRead: isRead, toID: toId, type: type, queryId: "")
        
        chatViewModel.sendMessage(request: request) { (conversationId) in
            if self.conversationId == nil{
                self.conversationId = conversationId
                
                self.getMessages()
            }
            self.messageTxtView.text = ""
        }
    }
    
    func sendmessages (message : String,type : String) {
        let message = message
        
        guard message != TYPE_A_MESSAGE else { return }
        
        guard !message.isEmpty else { return }
        
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = self.user?.uid else { return }
        let timestamp = Int(Date().timeIntervalSince1970*1000)
        let isRead = false
        let type = type
        
        let request = Message(content: message, fromID: fromId, timestamp: "\(timestamp)", isRead: isRead, toID: toId, type: type,queryId: "")
        self.sendNotification(message: message, image: message)
        chatViewModel.sendMessage(request: request) { (conversationId) in
            if self.conversationId == nil{
                self.conversationId = conversationId
                self.getMessages()
            }
            self.messageTxtView.text = ""
        }
    }
    
}

extension ChatVC: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == TYPE_A_MESSAGE{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.textColor = .lightGray
            textView.text = TYPE_A_MESSAGE
        }
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let senderId = Auth.auth().currentUser?.uid
        let senderId = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.ENCRYPTED_ID) as! String
        let message = messages[indexPath.row]
        //        let queryI = messages[indexPath.row].queryId
        if message.fromID == senderId{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            cell.layoutIfNeeded()
            cell.message = message
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.layoutIfNeeded()
            cell.message = message
            return cell
        }
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let message = messages[indexPath.row]
    //        if message.type == "image" || message.type == "file"{
    //            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "webVC") as? webVC{
    //                VC.urls = message.content ?? ""
    //                VC.modalPresentationStyle = .fullScreen
    //                self.navigationController?.pushViewController(VC, animated: true)
    //            }
    //
    //        }
    //
    //    }
}
