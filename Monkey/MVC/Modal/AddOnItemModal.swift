//
//  AddOnItemModal.swift
//  Monkey
//
//  Created by apple on 19/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper

class AddOnItemModal: Mappable
{
    var Code : String?
    var Message : String?
    var Menu_AddOn_list : [Menu_AddOn]?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Code <- map["Code"]
        Message <- map["Message"]
        Menu_AddOn_list <- map["Menu_AddOn_list"]
        
    }
}

class Menu_AddOn: NSObject,Mappable
{
    var AddOn_Id : Int?
    var AddOn_Name : String?
    var AddOn_Price : String?
    var isSelected = false
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        AddOn_Id <- map["AddOn_Id"]
        AddOn_Name <- map["AddOn_Name"]
        AddOn_Price <- map["AddOn_Price"]
        
    }
}

