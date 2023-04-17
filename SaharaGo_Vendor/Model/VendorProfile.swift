//
//  VendorProfile.swift
//  SaharaGo_Vendor
//
//  Created by ChawTech Solutions on 17/10/22.
//

import Foundation

struct vendorProfile_Struct {
    
    var firstName:String = ""
    var lastName:String = ""
    var country:String = ""
    var state:String = ""
    var city :String = ""
    var zipcode :String = ""
    var landmark:String = ""
    var streetAddress:String = ""
    var sourcing:String = ""
    var emailMobile:String = ""
    var userImage:String = ""
    var coverImage:String = ""
    var companyName:String = ""
    var about:String = ""
}

struct docsType_Struct {
    var id:String = ""
    var name:String = ""
    var isUploaded:Bool = false
}

struct account_Struct {
    var id:Int = 0
    var bankSortCode:String = ""
    var accountName:String = ""
    var accountNumber:String = ""
    var isDefault:Bool = false
}

struct notification_Struct {
    var body:String = ""
    var date:String = ""
    var title:String = ""
    var totalSize:Int = 0
    
}
