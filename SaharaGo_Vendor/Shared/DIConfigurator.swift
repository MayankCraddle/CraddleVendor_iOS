//
//  DIConfigurator.swift
//  HomeFudd
//
//  Created by Ashish Chauhan on 29/03/19.
//

import Foundation
import UIKit

class DIConfigurator {
    static let shared = DIConfigurator()
    private init() {
        
    }
    
    func getViewControler(storyBoard: StoryboardType, indentifire: String) -> UIViewController {
        let storyB = UIStoryboard(name: storyBoard.rawValue, bundle: nil)
        return storyB.instantiateViewController(withIdentifier: indentifire)
    }
    
    func getSellerForgetPswrdVC() -> SellerForgetPswrdVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "SellerForgetPswrdVC") as? SellerForgetPswrdVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerForgetPasswordVC")
        }
    }
    
    func getDeactivateVC() -> DeactivateVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "DeactivateVC") as? DeactivateVC {
            return viewC
        } else {
            fatalError("Not able to initialize DeactivateVC")
        }
    }
    
    func getDeleteVC() -> DeleteVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "DeleteVC") as? DeleteVC {
            return viewC
        } else {
            fatalError("Not able to initialize DeleteVC")
        }
    }
    
    func getEditProfileVC() -> EditProfileVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "EditProfileVC") as? EditProfileVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerForgetPasswordVC")
        }
    }
    
    func getNotificationVC() -> NotificationsVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "NotificationsVC") as? NotificationsVC {
            return viewC
        } else {
            fatalError("Not able to initialize NotificationsVC")
        }
    }
    
    func getForgetPasswordVC() -> ForgetPasswordVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "ForgetPasswordVC") as? ForgetPasswordVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerForgetPasswordVC")
        }
    }
    
    func getChatVC() -> ChatVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "ChatVC") as? ChatVC {
            return viewC
        } else {
            fatalError("Not able to initialize ChatVC")
        }
    }
    
    func getUsersListVC() -> UsersListVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "UsersListVC") as? UsersListVC {
            return viewC
        } else {
            fatalError("Not able to initialize UsersListVC")
        }
    }
    
    func getSellerForgetPswrdOtpVC() -> SellerForgetPswrdOtpVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "SellerForgetPswrdOtpVC") as? SellerForgetPswrdOtpVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerForgetPswrdOtpVC")
        }
    }
    
    func getSellerSignUpVC() -> SellerSignUpVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "SellerSignUpVC") as? SellerSignUpVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerSignUpVC")
        }
    }
    
    func getUploadDocumentsVC() -> UploadDocumentsVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "UploadDocumentsVC") as? UploadDocumentsVC {
            return viewC
        } else {
            fatalError("Not able to initialize UploadDocumentsVC")
        }
    }
    
    func getChooseListVC() -> ChooseListVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "ChooseListVC") as? ChooseListVC {
            return viewC
        } else {
            fatalError("Not able to initialize ChooseListVC")
        }
    }
    
    func getBankAccountVC() -> BankAccountVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "BankAccountVC") as? BankAccountVC {
            return viewC
        } else {
            fatalError("Not able to initialize BankAccountVC")
        }
    }
    
    func getSignUpOtpVC() -> SignUpOtpVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "SignUpOtpVC") as? SignUpOtpVC {
            return viewC
        } else {
            fatalError("Not able to initialize SignUpOtpVC")
        }
    }
    
    func getSellerReceivedDetailVC() -> SellerReceivedDetailVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "SellerReceivedDetailVC") as? SellerReceivedDetailVC {
            return viewC
        } else {
            fatalError("Not able to initialize SellerForgetPswrdOtpVC")
        }
    }
    
    
    func getProfileAccountsVC() -> ProfileAccountsVC {
        if let viewC = self.getViewControler(storyBoard: .Main, indentifire: "ProfileAccountsVC") as? ProfileAccountsVC {
            return viewC
        } else {
            fatalError("Not able to initialize ProfileAccountsVC")
        }
    }
    
    
}

enum StoryboardType: String {
    
    case LaunchScreen
    case Main
    case Buyer
    case Seller
    
    var storyboardName: String {
        return rawValue
    }
}
