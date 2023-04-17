//
//  UploadDocumentsVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 20/12/22.
//

import UIKit

class UploadDocumentsVC: UIViewController, UIDocumentPickerDelegate {
    
    
    @IBOutlet weak var docsTableView: UITableView!
    
    var docsArr = [docsType_Struct]()
    var imagePicker = UIImagePickerController()
    var uplaodedFile = ""
    var selectedType = ""
    var selectedIndex = 0
    var documentDic: NSMutableDictionary = NSMutableDictionary()
    var uploadedDocsArr: NSMutableArray = NSMutableArray()
    var metaDataDic: NSMutableDictionary = NSMutableDictionary()
    
    var email = ""
    var mobile = ""
    var password = ""
    var country = ""
    var fcmKey = ""
    var firstName = ""
    var lastName = ""
    var addressCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getDocsApi()
    }
    
    func getDocsApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:String] = [:]
            ServerClass.sharedInstance.getRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.GET_DOC_TYPE, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                //success == "true"
                if success == "true"
                {
                    self.docsArr.removeAll()
                    for i in 0..<json["list"].count {
                        
                        let id = json["list"][i]["id"].stringValue
                        let name = json["list"][i]["name"].stringValue
                        
                        self.docsArr.append(docsType_Struct.init(id: id, name: name, isUploaded: false))
                        
                    }

                    DispatchQueue.main.async {
                        self.docsTableView.reloadData()
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
    
    @IBAction func onTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onTapSignup(_ sender: UIButton) {
        
        let sellerSignupVC = DIConfigurator.shared.getBankAccountVC()
        sellerSignupVC.metaDataDic = self.metaDataDic
        sellerSignupVC.email = self.email
        sellerSignupVC.mobile = self.mobile
        sellerSignupVC.password = self.password
        sellerSignupVC.country = self.country
        sellerSignupVC.metaDataDic = self.metaDataDic
        sellerSignupVC.uploadedDocsArr = self.uploadedDocsArr
        sellerSignupVC.addressCode = self.addressCode
        
        self.navigationController?.pushViewController(sellerSignupVC, animated: true)
    }
    
    func checkAndUpdateDocsArr(_ docDic: NSMutableDictionary) -> (Bool, Int) {
        var isAvailable = false
        var index = -1
        print(self.uploadedDocsArr)
        for i in self.uploadedDocsArr {
            index += 1
            let item = i as! NSMutableDictionary
            if item.value(forKey: "type") as! String == docDic.value(forKey: "type") as! String {
                isAvailable = true
                break
            }
        }
        return (isAvailable, index)
    }
    
}

extension UploadDocumentsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.docsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadDocsCell", for: indexPath) as! UploadDocsCell
        
        let info = self.docsArr[indexPath.row]
        cell.cellDocLbl.text = info.name
        
        if info.isUploaded {
            cell.cellSubLbl.text = "Uploaded"
        } else {
            cell.cellSubLbl.text = "Click to Upload"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.docsArr[indexPath.row]
        self.selectedType = info.id
        self.selectedIndex = indexPath.row
        
        let alertController = UIAlertController(title: "Please select what would you like to upload?", message: "", preferredStyle: .actionSheet)
        alertController.view.tintColor = UIColor(displayP3Red: 49/255.0, green: 128/255.0, blue: 152/255.0, alpha: 1.0)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(UIAlertAction(title: "Image", style: .default , handler:{ (UIAlertAction)in
            self.chooseType()
        }))
        alertController.addAction(UIAlertAction(title: "Document", style: .default , handler:{ (UIAlertAction)in
            self.clickFunction()
        }))
        
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)

    }
    
    
}

extension UploadDocumentsVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIDocumentMenuDelegate {
    
    
    func chooseType() {
        let alert = UIAlertController(title: "", message: "Select Mode", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = UIColor(displayP3Red: 49/255.0, green: 128/255.0, blue: 152/255.0, alpha: 1.0)
        
        let deletbutton =  UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: {(action) in
            // self.Profileimage.image = #imageLiteral(resourceName: "customer.png")
            
        })
        // add the actions (buttons)
        let takephoto =  UIAlertAction(title: "Take Photo", style: UIAlertAction.Style.default, handler: {(action) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
              //  UIApplication.topViewController()?.present(self.imagePicker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
            
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        let uploadphoto = UIAlertAction(title: "Upload Photo", style: UIAlertAction.Style.default, handler: {(action) in
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
          //  UIApplication.topViewController()?.present(self.imagePicker, animated: true, completion: nil)
            
            
        })
        
        alert.addAction(takephoto)
        alert.addAction(uploadphoto)
        //  alert.addAction(deletbutton)
        // show the alert
        self.present(alert, animated: true, completion: nil)
      //  UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func clickFunction() {
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
       // UIApplication.topViewController()?.present(importMenu, animated: true, completion: nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        self.present(
            alertVC,
            animated: true,
            completion: nil)
//        UIApplication.topViewController()?.present(
//            alertVC,
//            animated: true,
//            completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        let fileUrlkk = Foundation.URL(string: myURL.absoluteString)
        do {
            let data = try Data(contentsOf: fileUrlkk!)
            let imageSize: Int = data.count
            if Double(imageSize) / 1000000.0 < 25.0 {
                self.uploadFileAPI(data, fileNamee: myURL.lastPathComponent)
            }
        } catch {
            
        }
        
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .fullScreen
        self.present(documentPicker, animated: true, completion: nil)
       // UIApplication.topViewController()?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        //UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let imageData = chosenImage.jpegData(compressionQuality: 0.5)
        self.dismiss(animated: true, completion: nil)
     //   UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        
        self.requestNativeImageUpload(image: chosenImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       // UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadFileAPI(_ imageData: Data, fileNamee: String) {
        let params = ["file": ""] as Dictionary<String, AnyObject>
//        showProgressOnView(self.view)
        showProgressOnView(appDelegateInstance.window!)
        ImageUploadServerClass.sharedInstance.multipartPostRequestHandler(BASE_URL + PROJECT_URL.UPLOAD_SIGNLE_FILE, mimeType: "", fileName: fileNamee, params: params, fileData: imageData) { ( response: AnyObject?, error:NSError?, httpStatusCode:Int?) in
            //hideAllProgressOnView(self.view)
            hideProgressOnView(appDelegateInstance.window!)
            DispatchQueue.main.async(execute: {
                if error == nil && response != nil && response is NSDictionary && httpStatusCode == 200 {
                    let respDic = response as! NSDictionary
                    print(respDic)
                    self.uplaodedFile = respDic.value(forKey: "file") as! String
                    let docDic: NSMutableDictionary = NSMutableDictionary()
                    docDic.setValue(self.selectedType, forKey: "type")
                    docDic.setValue(self.uplaodedFile, forKey: "document")
                    
                    if self.uploadedDocsArr.count > 0 {
                        let checkAndUpdateDocsArr = self.checkAndUpdateDocsArr(docDic)
                        if checkAndUpdateDocsArr.0 {
                            self.uploadedDocsArr.removeObject(at: checkAndUpdateDocsArr.1)
                            self.uploadedDocsArr.insert(self.documentDic, at: checkAndUpdateDocsArr.1)
                        } else {
                            self.uploadedDocsArr.add(docDic)
                        }
                    } else {
                        self.uploadedDocsArr.add(docDic)
                    }
                    self.docsArr[self.selectedIndex].isUploaded = true
                    DispatchQueue.main.async {
                        self.docsTableView.reloadData()
                    }
                    
                }
            })
        }
    }
    
}

extension UploadDocumentsVC {
    func requestNativeImageUpload(image: UIImage) {
        showProgressOnView(appDelegateInstance.window!)
        guard let url = NSURL(string: BASE_URL + PROJECT_URL.VENDOR_UPLOAD_SINGLE_FILE) else { return }
        let boundary = generateBoundary()
        var request = URLRequest(url: url as URL)
        
        let parameters = ["file": ""]
        
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = [
            "X-User-Agent": "ios",
            "Accept-Language": "en",
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "ApiKey": ""
        ]
        
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
                DispatchQueue.main.async {
                    hideAllProgressOnView(appDelegateInstance.window!)
                }
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let jsonDic = json as! NSDictionary
                    print(jsonDic)
//                    let data = jsonDic.value(forKey: "data") as! NSDictionary
//                    self.uplaodedFile = data.value(forKey: "filename") as! String
                    self.uplaodedFile = jsonDic.value(forKey: "file") as! String
                    let docDic: NSMutableDictionary = NSMutableDictionary()
                    docDic.setValue(self.selectedType, forKey: "type")
                    docDic.setValue(self.uplaodedFile, forKey: "document")
                    
                    if self.uploadedDocsArr.count > 0 {
                        let checkAndUpdateDocsArr = self.checkAndUpdateDocsArr(docDic)
                        if checkAndUpdateDocsArr.0 {
                            self.uploadedDocsArr.removeObject(at: checkAndUpdateDocsArr.1)
                            self.uploadedDocsArr.insert(self.documentDic, at: checkAndUpdateDocsArr.1)
                        } else {
                            self.uploadedDocsArr.add(docDic)
                        }
                    } else {
                        self.uploadedDocsArr.add(docDic)
                    }

                    self.docsArr[self.selectedIndex].isUploaded = true
                    DispatchQueue.main.async {
                        self.docsTableView.reloadData()
                    }
                    
                } catch {
                    DispatchQueue.main.async {
                        hideAllProgressOnView(appDelegateInstance.window!)
                    }
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
    
    struct Media {
        let key: String
        let fileName: String
        let data: Data
        let mimeType: String
        
        init?(withImage image: UIImage, forKey key: String) {
            self.key = key
            self.mimeType = "image/jpg"
            self.fileName = "\(arc4random()).jpeg"
            
            guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
            self.data = data
        }
    }
}
