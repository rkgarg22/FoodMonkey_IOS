//
//  CuisinesModal.swift
//  Monkey
//
//  Created by apple on 12/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper

class CuisinesModal: Mappable
{
    var Code : String?
    var Message : String?
    var Cuisines_List : [Cuisine]?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Code <- map["Code"]
        Message <- map["Message"]
        Cuisines_List <- map["Cuisines_List"]
        
    }
}

class Cuisine: Mappable{
    var Cuisine_Id : Int?
    var Cuisine_Name : String?
    var Resturant_Count : Int?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Cuisine_Id <- map["Cuisine_Id"]
        Cuisine_Name <- map["Cuisine_Name"]
        Resturant_Count <- map["Resturant_Count"]
    }
}
