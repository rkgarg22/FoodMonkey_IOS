//
//  LoginModal.swift
//  RedVault
//
//  Created by Aseem 13 on 17/08/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//

import Foundation
import ObjectMapper

class LoginModal: Mappable
{
    var Code : String?
    var Message : String?
    var Customer_details : [Customer_details]?
    
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Code <- map["Code"]
        Message <- map["Message"]
        Customer_details <- map["Customer_details"]
    }
}


class Customer_details: Mappable
{
    
    var Middle_Intial: String?
    var DOB: String?
    var Password: String?
    var Mobile: String?
    var First_Name: String?
    var Customer_id: Int?
    var Stripe_Customer_Id: String?
    var Email : String?
    var Sur_Name : String?
    var Image_Link : String?
    var Gender : String?
    var Registration_date : String?
    var Status : Int?
    var Addresses: [AddressModal]?
    var Refer_Code: String?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Middle_Intial <- map["Middle_Intial"]
        DOB <- map["DOB"]
        Password <- map["Password"]
        Mobile <- map["Mobile"]
        First_Name <- map["First_Name"]
        Customer_id <- map["Customer_id"]
        Stripe_Customer_Id <- map["Stripe_Customer_Id"]
        Email <- map["Email"]
        Sur_Name <- map["Sur_Name"]
        Image_Link <- map["Image_Link"]
        Gender <- map["Gender"]
        Registration_date <- map["Registration_date"]
        Status <- map["Status"]
        Addresses <- map["Addresses"]
        Refer_Code <- map["Refer_Code"]
    }
}
