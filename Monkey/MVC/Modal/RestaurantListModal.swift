//
//  RestaurantListModal.swift
//  Monkey
//
//  Created by apple on 01/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper

class RestaurantListMainModal: Mappable
{
    var Code : String?
    var Message : String?
    var Restutant_list : RestaurantListModal?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Code <- map["Code"]
        Message <- map["Message"]
        Restutant_list <- map["Restutant_list"]
        
    }
}

class RestaurantListModal:Mappable{
    var preorder_resturant : [SpecificRestaurantListModal?]?
    var open_resturant : [SpecificRestaurantListModal?]?
    var close_resturant : [SpecificRestaurantListModal?]?
    var Preorder_Restaurant_Size : [Int]?
    var Open_Restaurant_Size : [Int]?
    var Close_Restaurant_Size : [Int]?
    
    var Preorder_resturants_number : Int?
    var Closed_resturants_number : Int?
    var Open_resturants_number :Int?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        close_resturant = MapHelper<SpecificRestaurantListModal>(map: map).flatMapArrayOfOptionals(field: "close_resturant")
        open_resturant = MapHelper<SpecificRestaurantListModal>(map: map).flatMapArrayOfOptionals(field: "open_resturant")
        preorder_resturant = MapHelper<SpecificRestaurantListModal>(map: map).flatMapArrayOfOptionals(field: "preorder_resturant")
        Preorder_Restaurant_Size <- map["Preorder_Restaurant_Size"]
        Open_Restaurant_Size <- map["Open_Restaurant_Size"]
        Close_Restaurant_Size <- map["Close_Restaurant_Size"]
        Open_resturants_number <- map["Open_resturants_number"]
        Preorder_resturants_number <- map["Preorder_resturants_number"]
        Closed_resturants_number <- map["Closed_resturants_number"]
    }
}


class SpecificRestaurantListModal: Mappable
{
    
    var Rest_Telephone: String?
    var Rest_Id: Int?
    var Rest_Name: String?
    var Email: String?
    var Min_Spend: String?
    var Delivery: String?
    var Rest_Street_Line1: String?
    var Rest_Street_Line2 : String?
    var Rest_Post_Code : String?
    var Rest_City : String?
    var Owner_Name: String?
    var Owner_Mobile: String?
    var Owner_Landline: String?
    var Owner_Street_Line1: String?
    var Owner_Street_Line2: String?
    var Owner_Post_Code: String?
    var Owner_City : String?
    var Emerg_Contact_Name : String?
    var Emerg_Contact_Number : String?
    var Monday_Open : String?
    var Tuesday_open : String?
    var Wednesday_open : String?
    var Thursday_open : String?
    var Friday_open : String?
    var Saturday_open : String?
    var Sunday_open : String?
    var Monday_close : String?
    var Tuesday_close : String?
    var Wednesday_close : String?
    var Thursday_close : String?
    var Friday_close : String?
    var Saturday_close : String?
    var Sunday_close : String?
    var Password: String?
    var DeliveryOption: String?
    var IsSponsoredRest: Int?
    var Image_Link: String?
    var AggregateFeedback: String?
    var NumberOfReviews: Int?
    var IsCurrentlyOnline : Int?
    var DiscountOffer : Int?
    var Rest_Info: String?
    var DeliveryStartTime : String?
    var DeliveryEndTime : String?
    var IsHalal : Int?
    var DeliveryAreaCovered : Int?
    var IsPreorder : Int?
    var Cousine_List : String?
    var Cousine1 : String?
    var Cousine2 : String?
    var Registeration_Date : String?
    var Distance : String?
    var is_menuadded : Int?
    var cordinate_latitude : Double?
    var cordinate_longitude : Double?
    var Collection_Time : String?
    var Delivery_Time : String?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Collection_Time <- map["Collection_Time"]
        Delivery_Time <- map["Delivery_Time"]
        Rest_Id <- map["Rest_Id"]
        Rest_Name <- map["Rest_Name"]
        Email <- map["Email"]
        Min_Spend <- map["Min_Spend"]
        Delivery <- map["Delivery"]
        Rest_Street_Line1 <- map["Rest_Street_Line1"]
        Rest_Street_Line2 <- map["Rest_Street_Line2"]
        Rest_Post_Code <- map["Rest_Post_Code"]
        Rest_City <- map["Rest_City"]
        Owner_Name <- map["Owner_Name"]
        Owner_Mobile <- map["Owner_Mobile"]
        Owner_Landline <- map["Owner_Landline"]
        Owner_Street_Line1 <- map["Owner_Street_Line1"]
        Owner_Street_Line2 <- map["Owner_Street_Line2"]
        Owner_Post_Code <- map["Owner_Post_Code"]
        Owner_City <- map["Owner_City"]
        Emerg_Contact_Name <- map["Emerg_Contact_Name"]
        Emerg_Contact_Number <- map["Emerg_Contact_Number"]
        Monday_Open <- map["Monday_Open"]
        Tuesday_open <- map["Tuesday_open"]
        Wednesday_open <- map["Wednesday_open"]
        Thursday_open <- map["Thursday_open"]
        Friday_open <- map["Friday_open"]
        Saturday_open <- map["Saturday_open"]
        Sunday_open <- map["Sunday_open"]
        Monday_close <- map["Monday_close"]
        Tuesday_close <- map["Tuesday_close"]
        Wednesday_close <- map["Wednesday_close"]
        Thursday_close <- map["Thursday_close"]
        Friday_close <- map["Friday_close"]
        Saturday_close <- map["Saturday_close"]
        Sunday_close <- map["Sunday_close"]
        Password <- map["Password"]
        DeliveryOption <- map["DeliveryOption"]
        IsSponsoredRest <- map["IsSponsoredRest"]
        Image_Link <- map["Image_Link"]
        AggregateFeedback <- map["AggregateFeedback"]
        NumberOfReviews <- map["NumberOfReviews"]
        IsCurrentlyOnline <- map["IsCurrentlyOnline"]
        DiscountOffer <- map["DiscountOffer"]
        Rest_Info <- map["Rest_Info"]
        DeliveryStartTime <- map["DeliveryStartTime"]
        DeliveryEndTime <- map["DeliveryEndTime"]
        IsHalal <- map["IsHalal"]
        DeliveryAreaCovered <- map["DeliveryAreaCovered"]
        IsPreorder <- map["IsPreorder"]
        Cousine_List <- map["Cousine_List"]
        Cousine1 <- map["Cousine1"]
        Cousine2 <- map["Cousine2"]
        Registeration_Date <- map["Registeration_Date"]
        Distance <- map["Distance"]
        is_menuadded <- map["is_menuadded"]
        cordinate_latitude <- map["cordinate_latitude"]
        cordinate_longitude <- map["cordinate_longitude"]
        Rest_Telephone <- map["Rest_Telephone"]
    }
}

final class MapHelper<T:Mappable> {
    
    let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    func flatMapArrayOfOptionals(field: String) -> [T] {
        if let values = map[field].value() as [AnyObject]? {
            var resultValues = [T]()
            for value in values {
                if value is NSNull {
                    // do nothing
                } else {
                    if let mappableValue = Mapper<T>().map(JSONObject: value) {
                        resultValues.append(mappableValue)
                    } else if let nonMappableValue = value as? T {
                        resultValues.append(nonMappableValue)
                    }
                }
            }
            
            return resultValues
        }
        return []
    }
    
    func mapArrayOfOptionals(field: String) -> [T?] {
        if let values = map[field].value() as [AnyObject]? {
            var resultValues = [T?]()
            for value in values {
                if value is NSNull {
                    resultValues.append(nil)
                } else {
                    if let mappableValue = Mapper<T>().map(JSONObject: value) {
                        resultValues.append(mappableValue)
                    } else {
                        resultValues.append(value as? T)
                    }
                }
            }
            
            return resultValues
        }
        return []
    }
    
}
