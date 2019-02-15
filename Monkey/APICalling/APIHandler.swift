//
//  APIHandler.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

enum ResponseKeys : String {
    case data
    
}

extension LoginEndpoint {
    
    func handle(data : Any) -> AnyObject? {
        
       // let parameters = JSON(data)
        
        switch self {
        
        case .forgetPwd(_):
            return data as AnyObject
            
        case .changePwd(_):
            return data as AnyObject
            
        case .emailPhoneExits(_):
            
            return data as AnyObject
            
        case .signup(_):
            
            return data as AnyObject
            
        case .login(_):
            let object = Mapper<LoginModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .sendOtp(_):
            let object = Mapper<OTPModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .verifyOtp(_):
            let object = Mapper<OTPModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .verifyNumber(_):
            return data as AnyObject
            
        case .addToken(_):
            
            return data as AnyObject
            
        case .restaurantlist(_):
            let object = Mapper<RestaurantListMainModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .homeRestaurant(_):
            let object = Mapper<HomeRestaurantModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .cuisinesList(_):
            let object = Mapper<CuisinesModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .restaurantDetails(_):
            let object = Mapper<RestaurantDetailsModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .restaurantFeedback(_):
            let object = Mapper<RestaurantFeedbackModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .addOn(_):
            let object = Mapper<AddOnItemModal>().map(JSONObject: data)
            return object as AnyObject?
        
        case .addAddress(_):
              return data as AnyObject
            
        case .getAddress(_):
            let object = Mapper<AdressModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .addCard(_):
            let object = Mapper<CardDetailModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .addCardToStripe(_):
            let object = Mapper<CardDetailModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .getCardList(_):
            let object = Mapper<CardListModel>().map(JSONObject: data)
            return object as AnyObject?
            
        case .getCardListFromStripe(_):
            let object = Mapper<CardListModel>().map(JSONObject: data)
            return object as AnyObject?
            
        case .checkout(_):
            return data as AnyObject
            
        case .payment(_):
            return data as AnyObject
            
        case .getCustomerDetails(_):
            let object = Mapper<LoginModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .editAddress(_):
            return data as AnyObject

        case .deleteAddress(_):
            return data as AnyObject
            
        case .customerOrderList(_):
            let object = Mapper<OrderModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .customerOrderStatus(_):
            return data as AnyObject
            
        case .createBrainToken(_):
            return data as AnyObject
            
        case .brainTreePayment(_):
            return data as AnyObject
            
        case .editCustomerProfile(_):
            return data as AnyObject
            
        case .stripePayment(_):
            return data as AnyObject
            
        case .sendOTPToEmail(_):
            let object = Mapper<OTPModal>().map(JSONObject: data)
            return object as AnyObject?
            
        case .referFriendByMobile(_):
             return data as AnyObject
            
        case .feedback(_):
            return data as AnyObject
            
        case .signout(_):
            return data as AnyObject
        }
    }
}



