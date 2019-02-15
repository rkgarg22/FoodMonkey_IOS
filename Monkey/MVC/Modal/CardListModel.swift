//
//  CardDetailsModel.swift
//  Monkey
//
//  Created by Apple on 26/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import ObjectMapper

//class CardListModel: Mappable
//{
//    var Card_list : [CardDetailModal]?
//
//    required init?(map: Map)
//    {
//    }
//
//    func mapping(map: Map)
//    {
//        Card_list <- map["Card_list"]
//    }
//}
//
//class CardDetailModal: NSObject ,Mappable
//{
//    var Cardid = 0
//    var Customer_id  = 0
//    var NameOnCard = ""
//    var CardNumber  = 0
//    var Exp_Date = ""
//    var CVV = 0
//
//    required init?(map: Map)
//    {
//
//    }
//
//    func mapping(map: Map)
//    {
//        Cardid <- map["Cardid"]
//        Customer_id <- map["Customer_id"]
//        NameOnCard <- map["NameOnCard"]
//        CardNumber <- map["CardNumber"]
//        Exp_Date <- map["Exp_Date"]
//        CVV <- map["CVV"]
//    }
//}

class CardListModel:Mappable{
    var object: String?
    var url: String?
    var has_more: Bool?
    var data: [CardDetailModal]?

    required init?(map: Map) {
        
    }
     func mapping(map: Map) {
        data <- map["Message.data"]
    }
}

class CardDetailModal: NSObject ,Mappable
{
        var id: String?
        var object: String?
        var address_city: String?
        var address_country: String?
        var address_line1: String?
        var address_line1_check: String?
        var address_line2: String?
        var address_state: String?
        var address_zip: String?
        var address_zip_check: String?
        var brand: String?
        var country: String?
        var customer: String?
        var cvc_check: String?
        var dynamic_last4: String?
        var exp_month: Int?
        var exp_year: Int?
        var fingerprint: String?
        var funding: String?
        var last4: String?
        var metadata: [String:String]?
        var name: String?
        var tokenization_method: String?

    required init?(map: Map)
    {

    }

    func mapping(map: Map)
    {
        id <- map["id"]
        object <- map["object"]
        address_city <- map["address_city"]
        address_country <- map["address_country"]
        address_line1 <- map["address_line1"]
        address_line1_check <- map["address_line1_check"]
        address_line2 <- map["address_line2"]
        address_state <- map["address_state"]
        address_zip <- map["address_zip"]
        address_zip_check <- map["address_zip_check"]
        brand <- map["brand"]
        country <- map["country"]
        customer <- map["customer"]
        cvc_check <- map["cvc_check"]
        dynamic_last4 <- map["dynamic_last4"]
        exp_month <- map["exp_month"]
        exp_year <- map["exp_year"]
        fingerprint <- map["fingerprint"]
        funding <- map["funding"]
        last4 <- map["last4"]
        metadata <- map["metadata"]
        name <- map["name"]
        tokenization_method <- map["tokenization_method"]
    }
}
