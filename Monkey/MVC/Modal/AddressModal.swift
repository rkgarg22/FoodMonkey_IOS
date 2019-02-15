//
//  AddressModal.swift
//  Monkey
//
//  Created by Apple on 25/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import ObjectMapper


class AdressModal: Mappable
{

    var Customer_addresses : [AddressModal]?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Customer_addresses <- map["Customer_addresses"]
    
    }
}

class AddressModal: NSObject ,Mappable
{
    var Mobile_Number = 0
    var Address_Id  = 0
    var City = ""
    var Address_Name  = ""
    var House_No = ""
    var Address_Note = ""
    var Post_Code = ""
    var Street_Line2 = ""
    var Street_Line1 = ""
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Mobile_Number <- map["Mobile_Number"]
        Address_Id <- map["Address_Id"]
        City <- map["City"]
        Address_Name <- map["Address_Name"]
        House_No <- map["House_No"]
        Address_Note <- map["Address_Note"]
        Post_Code <- map["Post_Code"]
        Street_Line2 <- map["Street_Line2"]
        Street_Line1 <- map["Street_Line1"]
    }
}
