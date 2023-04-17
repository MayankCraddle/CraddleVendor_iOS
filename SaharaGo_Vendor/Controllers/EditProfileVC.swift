//
//  EditProfileVC.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 17/10/22.
//

import UIKit
import CropViewController

class EditProfileVC: UIViewController, CropViewControllerDelegate {

    @IBOutlet weak var vendorNameLbl: UILabel!
    @IBOutlet weak var vendorCountryLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var companyNameTxt: UITextField!
    @IBOutlet weak var countryTxt: UITextField!
    
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var metaDataDic: NSMutableDictionary = NSMutableDictionary()
    var vendorProfileInfo = vendorProfile_Struct()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setMetadata() {
        
        metaDataDic.setValue(vendorProfileInfo.firstName, forKey: "firstName")
        metaDataDic.setValue(vendorProfileInfo.lastName, forKey: "lastName")
        metaDataDic.setValue(vendorProfileInfo.country, forKey: "country")
        metaDataDic.setValue(vendorProfileInfo.state, forKey: "state")
        metaDataDic.setValue(vendorProfileInfo.city, forKey: "city")
        metaDataDic.setValue(vendorProfileInfo.zipcode, forKey: "zipcode")
        metaDataDic.setValue(vendorProfileInfo.landmark, forKey: "landmark")
        metaDataDic.setValue(vendorProfileInfo.streetAddress, forKey: "streetAddress")
        metaDataDic.setValue(vendorProfileInfo.emailMobile, forKey: "emailMobile")
        metaDataDic.setValue(vendorProfileInfo.userImage, forKey: "image")
        metaDataDic.setValue(vendorProfileInfo.coverImage, forKey: "coverImage")
        metaDataDic.setValue(vendorProfileInfo.companyName, forKey: "companyName")
        metaDataDic.setValue(vendorProfileInfo.about, forKey: "about")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setMetadata()
        self.setDetails()
    }
    
    func setDetails() {
        self.vendorNameLbl.text = "\(self.vendorProfileInfo.firstName) \(vendorProfileInfo.lastName)"
        self.vendorCountryLbl.text = self.vendorProfileInfo.country
        self.firstNameTxt.text = self.vendorProfileInfo.firstName
        self.lastNameTxt.text = self.vendorProfileInfo.lastName
        self.countryTxt.text = self.vendorProfileInfo.country
        self.companyNameTxt.text = self.vendorProfileInfo.streetAddress
        self.profileImg.sd_setImage(with: URL(string: FILE_BASE_URL + "/\(self.vendorProfileInfo.userImage)"), placeholderImage: UIImage(named: "avatar"))
        self.companyNameTxt.text = self.vendorProfileInfo.companyName
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickCamera(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)

    }
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            self.croppingStyle = .default
            
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .popover
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func requestNativeImageUpload(image: UIImage) {
        showProgressOnView(appDelegateInstance.window!)
        guard let url = NSURL(string: "https://craddle.com:8443/api/v1/saharaGo/uploadSingleFile") else { return }
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
//                    self.imagesArr.removeAllObjects()
//                    self.imagesArr.add(jsonDic.value(forKey: "file") as! String)
                    self.metaDataDic.setValue(jsonDic.value(forKey: "file") as! String, forKey: "image")
                    
                    DispatchQueue.main.async {
                        self.profileImg.contentMode = .scaleToFill
                        self.profileImg.image = image
                        self.view.makeToast("Image Uploaded Successfully.")
                    }
                    
                } catch {
                    //hideAllProgressOnView(self.view)
                    print(error)
                }
            }
            }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        
//        DispatchQueue.main.async {
//            self.profileImg.contentMode = .scaleToFill
//            self.profileImg.image = image
//        }
//
        //        self.userProfileImg.image = image
        self.requestNativeImageUpload(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
        
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
    
    
    @IBAction func updateProfileAction(_ sender: Any) {
        if self.firstNameTxt.text!.isEmpty {
            self.view.makeToast("Please Enter First Name.")
            return
        } else if self.lastNameTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Last Name.")
            return
        } else if self.countryTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Country.")
            return
        } else if self.companyNameTxt.text!.isEmpty {
            self.view.makeToast("Please Enter Company Name.")
            return
        }
        
        self.metaDataDic.setValue(self.firstNameTxt.text!, forKey: "firstName")
        self.metaDataDic.setValue(self.lastNameTxt.text!, forKey: "lastName")
        self.metaDataDic.setValue(self.countryTxt.text!, forKey: "country")
        self.metaDataDic.setValue(self.companyNameTxt.text!, forKey: "companyName")

        self.updateProfileApi()
    }
    
    func updateProfileApi() {
        if Reachability.isConnectedToNetwork() {
            showProgressOnView(appDelegateInstance.window!)
            
            let param:[String:Any] = ["metaData": self.metaDataDic]
            print(self.metaDataDic)
            ServerClass.sharedInstance.putRequestWithUrlParameters(param, path: BASE_URL + PROJECT_URL.VENDOR_UPDATE_PROFILE, successBlock: { (json) in
                print(json)
                hideAllProgressOnView(appDelegateInstance.window!)
                let success = json["success"].stringValue
                
                if success == "true"
                {
                    self.view.makeToast(json["message"].stringValue)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
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

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        //cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        
        self.image = image
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
}
