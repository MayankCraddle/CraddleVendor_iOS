//
//  UIViewController+Extensions.swift
//  SaharaGo
//
//  Created by ChawTech Solutions on 20/07/22.
//

import UIKit

//MARK:- Extension UIViewController
extension UIViewController {
    
    func showOkAlert(_ msg: String) {
        let alert = UIAlertController(title:
                                        "", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        okAction.setValue(AppColor.AppColor2, forKey: "titleTextColor")
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showOkAlertWithHandler(_ msg: String,handler: @escaping ()->Void){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (type) -> Void in
            handler()
        }
//        okAction.setValue(AppColor.AppColor2, forKey: "titleTextColor")
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithActions(_ msg: String,titles:[String], handler:@escaping (_ clickedIndex: Int) -> Void) {
        let alert = UIAlertController(title: "Craddle", message: msg, preferredStyle: .alert)
        
        for title in titles {
            let action  = UIAlertAction(title: title, style: .default, handler: { (alertAction) in
                //Call back fall when user clicked
                
                let index = titles.firstIndex(of: alertAction.title!)
                if index != nil {
                    handler(index!+1)
                }
                else {
                    handler(0)
                }
            })
//            action.setValue(AppColor.AppColor2, forKey: "titleTextColor")

            alert.addAction(action)
            
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showOkCancelAlertWithAction(_ msg: String, handler:@escaping (_ isOkAction: Bool) -> Void) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            return handler(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            return handler(false)
        }
//        cancelAction.setValue(AppColor.AppColor2, forKey: "titleTextColor")
//        okAction.setValue(AppColor.AppColor2, forKey: "titleTextColor")

        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }

        var topController = rootViewController

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }
}

enum AppStoryboard : String {
    case Main, Buyer, Seller
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass: T.Type) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
}

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiateViewController(_ storyboardName: AppStoryboard = .Main) -> Self{
        return storyboardName.viewController(viewControllerClass: self)
    }
}

extension UIViewController{
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
}

extension UIAlertController {
    class func showInfoAlertWithTitle(_ title: String?, message: String?, buttonTitle: String, viewController: UIViewController? = nil){
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction.init(title: buttonTitle, style: .default, handler: { (okayAction) in
                if viewController != nil {
                    // viewController?.dismiss(animated: true, completion: nil)
                    viewController?.navigationController?.popViewController(animated: true)
                }
                else {
                    UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
                }
            })
            alertController.addAction(okayAction)
            if viewController != nil {
                viewController?.present(alertController, animated: true, completion: nil)
            }
            else {
                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        })
    }
}
