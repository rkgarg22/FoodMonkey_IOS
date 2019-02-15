//
//  OTPModal.swift
//  Monkey
//
//  Created by apple on 27/11/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper

class OTPModal:Mappable{
    var Code : String?
    var Message : String?
    var Result : Result?
    var emailOTP : Int?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Code <- map["Code"]
        Message <- map["Message"]
        Result <- map["Result"]
        emailOTP <- map["OTP_Code"]
    }
}

class Result:Mappable{
    var status : String?
    var request_id : String?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        status <- map["status"]
        request_id <- map["request_id"]
    }
}

