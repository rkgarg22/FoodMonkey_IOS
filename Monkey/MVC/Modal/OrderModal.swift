//
//  OrderModal.swift
//  Monkey
//
//  Created by apple on 22/11/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper
class OrderModal:Mappable{
    
    var Message: String?
    var Code: String?
    var Customer_orders: CustomerOrders?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Message <- map["Message"]
        Code <- map["Code"]
        Customer_orders <- map["Customer_orders"]
    }
}

class CustomerOrders:Mappable{
    
    var Pre_Orders: [Order]?
    var Order_Detail: [Order]?
    var Rejected_Orders: [Order]?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Pre_Orders <- map["Pre_Orders"]
        Order_Detail <- map["Order_Detail"]
        Rejected_Orders <- map["Rejected_Orders"]
        
    }
}

class Order:Mappable{
    
    var Delivery_Post_Code: String?
    var Rest_Name: String?
    var Menu_Order: [MenuOrder]?
    var Rest_Street_Line2: String?
    var Coupon_Code: String?
    var IsSponsoredRest: Bool?
    var Rest_Post_Code: String?
    var DeliveryCharges: String?
    var DiscountOffer: Int?
    var Rest_Image_Link: String?
    var IsPreOrder: Bool?
    var Cousine2: String?
    var Order_Amount: String?
    var PreOrderComments: String?
    var Order_Date_Time: String?
    var Order_Id: Int?
    var Rest_Street_Line1: String?
    var Cousine1: String?
    var DeliveryOption: String?
    var PercentageDiscount: String?
    var PreOrderDeliveryDayTime: String?
    var Delivery_Address_Name: String?
    var Rest_Email: String?
    var Delivery_House_No: String?
    var AggregateFeedback: String?
    var NumberOfReviews: Int?
    var Delivery_Street_Line2: String?
    var Delivery_Street_Line1: String?
    var Delivery_City: String?
    var Order_Status: String?
    var Rest_City: String?
    var IsCurrentlyOnline: Bool?
    var Rest_Telephone : String?
    var Rest_Id : Int?
    var Mobile_Number : Int?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Mobile_Number <- map["Mobile_Number"]
        Rest_Id <- map["Rest_Id"]
        Delivery_Post_Code <- map["Delivery_Post_Code"]
        Rest_Name <- map["Rest_Name"]
        Menu_Order <- map["Menu_Order"]
        Rest_Street_Line2 <- map["Rest_Street_Line2"]
        Coupon_Code <- map["Coupon_Code"]
        IsSponsoredRest <- map["IsSponsoredRest"]
        Rest_Post_Code <- map["Rest_Post_Code"]
        DeliveryCharges <- map["DeliveryCharges"]
        DiscountOffer <- map["DiscountOffer"]
        Rest_Image_Link <- map["Rest_Image_Link"]
        IsPreOrder <- map["IsPreOrder"]
        Cousine2 <- map["Cousine2"]
        Order_Amount <- map["Order_Amount"]
        PreOrderComments <- map["PreOrderComments"]
        Order_Date_Time <- map["Order_Date_Time"]
        Order_Id <- map["Order_Id"]
        Rest_Street_Line1 <- map["Rest_Street_Line1"]
        Cousine1 <- map["Cousine1"]
        DeliveryOption <- map["DeliveryOption"]
        PercentageDiscount <- map["PercentageDiscount"]
        PreOrderDeliveryDayTime <- map["PreOrderDeliveryDayTime"]
        Delivery_Address_Name <- map["Delivery_Address_Name"]
        Rest_Email <- map["Rest_Email"]
        Delivery_House_No <- map["Delivery_House_No"]
        AggregateFeedback <- map["AggregateFeedback"]
        NumberOfReviews <- map["NumberOfReviews"]
        Delivery_Street_Line2 <- map["Delivery_Street_Line2"]
        Delivery_Street_Line1 <- map["Delivery_Street_Line1"]
        Delivery_City <- map["Delivery_City"]
        Order_Status <- map["Order_Status"]
        Rest_City <- map["Rest_City"]
        IsCurrentlyOnline <- map["IsCurrentlyOnline"]
        Rest_Telephone <- map["Rest_Telephone"]
    }
    
}

class MenuOrder:Mappable{
    var Order_Id: Int?
    var Quantity: Int?
    var Addon_Order: [Int]?
    var Item_Price: String?
    var Item_id: Int?
    var Item_Name: String?
    
    required init?(map: Map) {
        
    }
    
     func mapping(map: Map) {
        Order_Id <- map["Order_Id"]
        Quantity <- map["Quantity"]
        Addon_Order <- map["Addon_Order"]
        Item_Price <- map["Item_Price"]
        Item_id <- map["Item_id"]
        Item_Name <- map["Item_Name"]
    }

}

