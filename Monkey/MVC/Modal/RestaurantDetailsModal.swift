//
//  RestaurantDetailsModal.swift
//  Monkey
//
//  Created by apple on 14/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper

class RestaurantDetailsModal: Mappable
{
    var Code : String?
    var Message : String?
    var Resturants : RestaurantsModal?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Code <- map["Code"]
        Message <- map["Message"]
        Resturants <- map["Resturants"]
        
    }
}


class RestaurantsModal: Mappable
{
    var Restaurant_Details : [SpecificRestaurantListModal]?
    var Menu_Category : [Menu_Category]?
    var deliveryAreas : [String]?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Restaurant_Details <- map["Restaurant_Details"]
        Menu_Category <- map["Menu_Category"]
        deliveryAreas <- map["Delivery_Postcodes"]
    }
}

class Menu_Category: Mappable{
    
    var Menu_Category_Id : Int?
    var Menu_Category_Name : String?
    var Menus : [Menu]?
    var Menu_Cat_Info : String?
    var Menu_Sub_Category : [Menu_Sub_Category]?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Menu_Category_Id <- map["Menu_Category_Id"]
        Menu_Category_Name <- map["Menu_Category_Name"]
        Menus <- map["Menus"]
        Menu_Cat_Info <- map["Menu_Cat_Info"]
        Menu_Sub_Category <- map["Menu_Sub_Category"]
    }
}

class Menu_Sub_Category: Mappable{
    var Menu_Cate_Id : Int?
    var SubCate_Info : String?
    var Menus : [Menu]?
    var Menu_Sub_Cate_Id : Int?
    var Menu_Sub_Cate_Name : String?
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Menu_Cate_Id <- map["Menu_Cate_Id"]
        SubCate_Info <- map["SubCate_Info"]
        Menus <- map["Menus"]
        Menu_Sub_Cate_Id <- map["Menu_Sub_Cate_Id"]
        Menu_Sub_Cate_Name <- map["Menu_Sub_Cate_Name"]
    }
}

class Menu: NSObject,Mappable{
    
    var Item_id : Int?
    var Rest_id : Int?
    var Menu_category_Id : Int?
    var Item_Name : String?
    var Item_Price  = ""
    var Item_Desc : String?
    var Item_Status : Int?
    var IsItemNonVeg : Int?
    var AddOn : [AddOnItem]?
    var Menu_SubCategory_Id : Int?
    
    var ItemCount : Int?
    
    //SubCategoryModified
    var Menu_Cate_Id : Int?
    var SubCate_Info : String?
    var Menus : [Menu]?
    var Menu_Sub_Cate_Id : Int?
    var Menu_Sub_Cate_Name : String?
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Item_id <- map["Item_id"]
        Rest_id <- map["Rest_id"]
        Menu_category_Id <- map["Menu_category_Id"]
        Item_Name <- map["Item_Name"]
        Item_Price <- map["Item_Price"]
        Item_Desc <- map["Item_Desc"]
        Item_Status <- map["Item_Status"]
        IsItemNonVeg <- map["IsItemNonVeg"]
        AddOn <- map["AddOn"]
        Menu_SubCategory_Id <- map["Menu_SubCategory_Id"]
        
        //SubCategoryModified
        Menu_Cate_Id <- map["Menu_Cate_Id"]
        SubCate_Info <- map["SubCate_Info"]
        Menus <- map["Menus"]
        Menu_Sub_Cate_Id <- map["Menu_Sub_Cate_Id"]
        Menu_Sub_Cate_Name <- map["Menu_Sub_Cate_Name"]
        
    }
}

class AddOnItem: NSObject,Mappable{
    
    var Addon_quantity  = 0
    var Addon_Id : Int?
    var Item_id : Int?
    var Addon_name : String = ""
    var Addon_price : String = ""
    var isSelected = false
    var isItem = false
    var Addon_nameSecond : String = ""
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        Addon_Id <- map["Addon_Id"]
        Item_id <- map["Item_id"]
        Addon_name <- map["Addon_name"]
        Addon_price <- map["Addon_price"]
        
    }
}
