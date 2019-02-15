//
//  HomeRestaurantModal.swift
//  Monkey
//
//  Created by apple on 10/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import Foundation
import ObjectMapper

class HomeRestaurantModal: Mappable
{
    var Code : String?
    var Message : String?
    var Restutant_list : RestaurantTypeModal?
    
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

class RestaurantTypeModal:Mappable{
    var Popular_Restaurants : [SpecificRestaurantListModal?]?
    var Viewed_Restaurants : [SpecificRestaurantListModal?]?
    var Ordered_Restaurants : [SpecificRestaurantListModal?]?
    
    
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        Popular_Restaurants = MapHelper<SpecificRestaurantListModal>(map: map).flatMapArrayOfOptionals(field: "Popular_Restaurants")
        Viewed_Restaurants = MapHelper<SpecificRestaurantListModal>(map: map).flatMapArrayOfOptionals(field: "Viewed_Restaurants")
        Ordered_Restaurants = MapHelper<SpecificRestaurantListModal>(map: map).flatMapArrayOfOptionals(field: "Ordered_Restaurants")
        
    }
}
