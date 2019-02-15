//
//  RestaurantFeedbackModal.swift
//  Monkey
//
//  Created by apple on 17/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper

class RestaurantFeedbackModal: Mappable
{
    var Code : String?
    var Message : String?
    var Resturant_Feedback_List : [Resturant_Feedback_List]?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Code <- map["Code"]
        Message <- map["Message"]
        Resturant_Feedback_List <- map["Resturant_Feedback_List"]
        
    }
}

class Resturant_Feedback_List: Mappable
{
    var Rating_Id : Int?
    var Number_Of_Stars : String?
    var Comments : String?
    var Rating_Date : String?
    var Customer_Name : String?
    
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Rating_Id <- map["Rating_Id"]
        Number_Of_Stars <- map["Number_Of_Stars"]
        Comments <- map["Comments"]
        Rating_Date <- map["Rating_Date"]
        Customer_Name <- map["Customer_Name"]
        
    }
}
