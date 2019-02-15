//
//  Login.swift
//  APISampleClass
//
//  Created by cbl20 on 2/23/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import UIKit
import Alamofire
import EZSwiftExtensions
import Stripe

protocol Router {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
    func handle(data : Any) -> AnyObject?
    var header : [String: String] {get}
}

extension Sequence where Iterator.Element == Keys {
    
    func map(values: [Any?]) -> OptionalDictionary {
        
        var params = [String : Any]()
        
        for (index,element) in zip(self,values) {
            if element != nil{
                params[index.rawValue] = element
            }
        }
        return params
        
    }
    
    func mapQueryParams(values: [Any?]) -> String {
        
        var output: String = ""
        for (index,element) in zip(self,values) {
            if element != nil{
                output +=  "\(index)=\(element!)&"
            }
        }
        output = String(output.dropLast())
        return output
    }
}


enum LoginEndpoint {
    
    case signup(TokenKey : String? , First_Name : String?, Middle_Intial : String?,Sur_Name : String? , Gender : String?, Email : String?,Mobile : String? , DOB : String?, Password : String?,ProfilePic: String?, CallingChannel:String?,LoginType:String?,GoogleorFbId:String?)
 
    case login(TokenKey : String? , Email : String?, Password : String?,CallingChannel : String?,LoginType:String?,GoogleorFbId:String?,First_Name:String?,Sur_Name:String?,Gender:String?)
    
    case sendOtp(TokenKey : String? ,Mobile_number:String?)
    
    case verifyOtp(TokenKey : String? ,OTP:String?, Request_Id:String?)
    
    case verifyNumber(TokenKey : String? ,Mobile_Number:String?)
    
    case addToken(TokenKey : String? , Customer_Type : String?, CallingChannel : String?)
    
    case restaurantlist(TokenKey : String? , SearchBy : String? , PostCode : String?,DeliveryOptions:String?,ListBy:String?,Cuisines:String?,PageNumber:Int?, CallingChannel : String?)
   
    case homeRestaurant(TokenKey : String? ,Customer_id:String?)
    
    case cuisinesList(TokenKey : String?)
    
    case restaurantDetails(TokenKey : String? , Resturant_id:Int? , Customer_id:String?)
    
    case restaurantFeedback(TokenKey: String?, Resturant_id:Int?)
    
    case addOn(TokenKey: String?, Item_Id:Int?)
    
    case addAddress(TokenKey : String? , Customer_id:Int? , Address_type:String?,Mobile_Number : Int? , House_No:Int? , Address_Note:String?,Street_Line1 : String? , Street_Line2:String? , Post_Code:String?, City:String?)
    
    case getAddress(TokenKey : String? , Customer_id:Int?)
    
    case addCard(TokenKey : String? , Stripe_Customer_Id:String?,Stripe_Token : String?)
    
    case addCardToStripe(source : String? , object:String?,number : String? , exp_month:Int?,exp_year : Int? , cvc:String?)
    
    case getCardList(TokenKey : String? , Customer_id:String?)
    
    case getCardListFromStripe(customer : String? , ending_before:Int?, limit:Int?, starting_after:Int?)
    
    case checkout(TokenKey : String? , Customer_Id:Int?,Resturant_id : Int? , Address_id:Int?,Order_Amount : Float? , DeliveryOption:String?,Item_Id : String? , Quantity:String?,Addon_Id:String?,Preorder_DateTime:String?,Preorder_Comments:String?)
    
    case payment(TokenKey : String? , Order_id:Int?,Stripe_Cardid : String? , Payment_Method:String?)
    
    case getCustomerDetails(TokenKey : String? , Customer_id:Int?)
    
    case editAddress(TokenKey : String? , Address_id:Int? , Address_type:String?,Mobile_Number : Int? , House_No:Int? , Address_Note:String?,Street_Line1 : String? , Street_Line2:String? , Post_Code:String?, City:String?)
    
    case deleteAddress(TokenKey : String? , Address_id:Int?)
    
    case customerOrderList(TokenKey : String? , Customer_id:Int?)
    
    case customerOrderStatus(TokenKey : String? , Order_Id:Int?)
    
    case createBrainToken(TokenKey : String?)
    case brainTreePayment(TokenKey : String? , Payment_Method_Nonce:String? , Amount:Double?,orderId : Int? , Customer_First_Name:String? , Customer_Last_Name:String?,Customer_Email : String?,CallingChannel:String?)
    case editCustomerProfile(TokenKey : String?, Customer_Id:Int?, First_Name : String?, Middle_Intial : String?,Sur_Name : String? , Gender : String?, DOB : String?,ProfilePic: String?)
    case emailPhoneExits(TokenKey : String?, EmailorMobile:String?)
    case forgetPwd(TokenKey : String?, Customer_id:Int?,New_Password:String?)
    case changePwd(TokenKey : String?, Customer_id:Int?,Old_Password:String?,New_Password:String?)
    case stripePayment(TokenKey:String?,Price:Int?,Stripe_Customer_Id:String?,Stripe_Card_Id:String?,Order_Id:Int?,CallingChannel:String?)
    case sendOTPToEmail(TokenKey:String?,Email:String?)
    case referFriendByMobile(TokenKey:String?,Customer_Name:String?,Refer_Code:String?,Mobile_Number : Int?)
    case feedback(TokenKey:String?,Resturant_id:Int?,Customer_id:Int?,Number_of_Stars : Int?,Comment:String?)
    case signout(TokenKey:String?)
}


extension LoginEndpoint : Router{
    
    var route : String  {
        
        switch self {
        case .forgetPwd(_):
            return APIConstants.forgotPwd
        
        case .changePwd(_):
            return APIConstants.changePwd
            
        case .emailPhoneExits(_):
            return APIConstants.email_phone_exist
            
        case .signup(_): return APIConstants.signUp
            
        case .addToken(_): return APIConstants.addToken
          
        case .login(_): return APIConstants.login
            
        case .sendOtp(_): return APIConstants.sendOtp
            
        case .verifyOtp(_): return APIConstants.verifyOtp
            
        case .verifyNumber(_): return APIConstants.verifyNumber
            
        case .restaurantlist(_): return APIConstants.restaurantList
        
        case .homeRestaurant(_): return APIConstants.homeRestaurant
            
        case .cuisinesList(_): return APIConstants.cuisinesList
            
        case .restaurantDetails(_): return APIConstants.restaurantDetails
            
        case .restaurantFeedback(_): return APIConstants.restaurantFeedback
            
        case .addOn(_): return APIConstants.addOn
        
        case .addAddress(_) : return APIConstants.addNewAddress
            
        case .getAddress(_) : return APIConstants.getDeliveryAddress
       
        case .addCard(_) : return APIConstants.addCard
            
        case .addCardToStripe(let source,let object,let number,let exp_month,let exp_year,let cvc):
            return APIConstants.addCardToStripe + "?" + Parameters.addCardToStripe.mapQueryParams(values: [source])
            
        case .getCardList(_) : return APIConstants.getCardList
            
        case .getCardListFromStripe(_) : return APIConstants.getCardListFromStripe
            
        case .checkout(_) : return APIConstants.checkout
            
        case .payment(_) : return APIConstants.payment
            
        case .getCustomerDetails(_): return APIConstants.getCustomerDetails
         
        case .editAddress(_) : return APIConstants.editAddress
        
        case .deleteAddress(_) : return APIConstants.deleteAddress
            
        case .customerOrderList(_): return APIConstants.customerOrderList
            
        case .customerOrderStatus(_): return APIConstants.customerOrderStatus
            
        case .createBrainToken(_) : return APIConstants.createBrainToken
            
        case .brainTreePayment(_) : return APIConstants.brainTreePayment
            
        case .editCustomerProfile(_): return APIConstants.editCustomerProfile
            
        case .stripePayment(_): return APIConstants.stripePayment
        
        case .sendOTPToEmail(_): return APIConstants.sendOtpToEmail
        
        case .referFriendByMobile(_) : return APIConstants.referFriendByMobile
            
        case .feedback(_) : return APIConstants.feedback
        
        case .signout(_) : return APIConstants.signout
        }
    }
    
    var parameters: OptionalDictionary{
        return format()
    }
    
    
    func format() -> OptionalDictionary {
        
        switch self {
            
        case .signup(let TokenKey , let First_Name,let
            Middle_Intial,let Sur_Name,let Gender,let Email,let Mobile, let DOB, let Password,let ProfilePic,let CallingChannel,let LoginType,let GoogleorFbId):
            
            return Parameters.signUp.map(values: [TokenKey , First_Name,Middle_Intial,Sur_Name,Gender,Email,Mobile, DOB, Password,ProfilePic,CallingChannel,LoginType,GoogleorFbId])
        
        case .login(let TokenKey , let Email, let Password ,let CallingChannel,let LoginType,let GoogleorFbId,let First_Name,let Sur_Name,let Gender):
            return Parameters.login.map(values: [TokenKey , Email,  Password , CallingChannel,LoginType, GoogleorFbId, First_Name, Sur_Name, Gender])
            
        case .sendOtp(let TokenKey,let Mobile_number):
            return Parameters.sendOtp.map(values: [TokenKey,Mobile_number])
            
        case .verifyOtp(let TokenKey,let OTP,let Request_Id):
            return Parameters.verifyOtp.map(values: [TokenKey,OTP,Request_Id])
            
        case .verifyNumber(let TokenKey,let Mobile_Number):
            return Parameters.verifyNumber.map(values: [TokenKey,Mobile_Number])
            
        case .addToken(let TokenKey , let Customer_Type ,let CallingChannel):
            return Parameters.addToken.map(values: [TokenKey , Customer_Type , CallingChannel])

        case .restaurantlist(let TokenKey, let SearchBy, let PostCode, let DeliveryOptions, let ListBy, let Cuisines, let PageNumber, let CallingChannel):
            return Parameters.restaurantList.map(values: [TokenKey , SearchBy , PostCode , DeliveryOptions , ListBy , Cuisines , PageNumber, CallingChannel])
            
        case .homeRestaurant(let TokenKey,let Customer_id):
            return Parameters.homeRestaurant.map(values: [TokenKey,Customer_id])
            
        case .cuisinesList(let TokenKey):
            return Parameters.cuisinesList.map(values:[TokenKey])
            
        case .restaurantDetails(let TokenKey,let Resturant_id, let Customer_id):
            return Parameters.restaurantDetails.map(values: [TokenKey,Resturant_id,Customer_id])
        
        case .restaurantFeedback(let TokenKey,let Resturant_id):
            return Parameters.restaurantFeedback.map(values: [TokenKey,Resturant_id])
            
        case .addOn(let TokenKey,let Item_Id):
            return Parameters.addOn.map(values:[TokenKey,Item_Id])
            
        case .addAddress(let TokenKey, let Customer_id,let Address_type,let Mobile_Number,let House_No,let Address_Note,let Street_Line1, let Street_Line2, let Post_Code,let City):
            return Parameters.addAddress.map(values:[TokenKey,Customer_id,Address_type,Mobile_Number,House_No,Address_Note,Street_Line1,Street_Line2,Post_Code,City])
            
        case .getAddress(let TokenKey,let Customer_id) :
            return Parameters.getAddress.map(values: [TokenKey, Customer_id])
            
        case .addCard(let TokenKey,let Stripe_Customer_Id,let Stripe_Token):
            return Parameters.addCard.map(values: [TokenKey, Stripe_Customer_Id,Stripe_Token])
            
        case .addCardToStripe(_):
            return nil
            
        case .getCardList(let TokenKey,let Customer_id):
             return Parameters.getCardList.map(values: [TokenKey, Customer_id])
            
        case .getCardListFromStripe(let customer,let ending_before,let limit,let starting_after):
            return Parameters.getCardListFromStripe.map(values: [customer,ending_before,limit,starting_after])
            
        case .checkout(let TokenKey,let Customer_Id,let Resturant_id,let Address_id,let Order_Amount, let DeliveryOption,let Item_Id,let Quantity,let Addon_Id,let Preorder_DateTime,let Preorder_Comments):
            return Parameters.checkout.map(values: [TokenKey, Customer_Id,Resturant_id, Address_id, Order_Amount,DeliveryOption,Item_Id,Quantity,Addon_Id,Preorder_DateTime, Preorder_Comments])
        
        case .payment(let TokenKey, let Order_id,let Stripe_Cardid,let Payment_Method):
            return Parameters.payment.map(values: [TokenKey, Order_id,Stripe_Cardid,Payment_Method])
            
        case .getCustomerDetails(let TokenKey,let Customer_id):
            return Parameters.getCustomerDetails.map(values: [TokenKey,Customer_id])
        
        case .editAddress(let TokenKey, let Address_id,let Address_type,let Mobile_Number,let House_No,let Address_Note,let Street_Line1, let Street_Line2, let Post_Code,let City):
            return Parameters.editAddress.map(values:[TokenKey,Address_id,Address_type,Mobile_Number,House_No,Address_Note,Street_Line1,Street_Line2,Post_Code,City])
            
        case .deleteAddress(let TokenKey, let Address_id):
            return Parameters.editAddress.map(values:[TokenKey,Address_id])
            
        case .customerOrderList(let TokenKey,let Customer_id):
            return Parameters.customerOrderList.map(values: [TokenKey,Customer_id])
            
        case .customerOrderStatus(let TokenKey,let Order_Id):
            return Parameters.customerOrderStatus.map(values:[TokenKey,Order_Id])
            
        case .createBrainToken(let TokenKey):
            return Parameters.createBrainToken.map(values:[TokenKey])
        
        case .brainTreePayment(let TokenKey ,let Payment_Method_Nonce,let Amount, let orderId ,let Customer_First_Name , let Customer_Last_Name,let Customer_Email, let CallingChannel):
            return Parameters.brainTreePayment.map(values:[TokenKey ,Payment_Method_Nonce,Amount, orderId ,Customer_First_Name , Customer_Last_Name,Customer_Email,CallingChannel])
        
        case .editCustomerProfile(let TokenKey,let  Customer_Id,let  First_Name,let  Middle_Intial,let  Sur_Name,let  Gender,let  DOB,let  ProfilePic):
            return Parameters.editCustomerProfile.map(values:[TokenKey,Customer_Id,First_Name,Middle_Intial,Sur_Name,Gender,DOB,ProfilePic])
            
        case .emailPhoneExits(let TokenKey,let EmailorMobile):
            return Parameters.emailPhoneExits.map(values:[TokenKey,EmailorMobile])
        
        case .forgetPwd(let TokenKey,let Customer_id, let New_Password):
            return Parameters.forgetPwd.map(values: [TokenKey,Customer_id,New_Password])
            
        case .changePwd(let TokenKey, let Customer_id,let Old_Password, let New_Password):
            return Parameters.changePwd.map(values: [TokenKey,Customer_id,Old_Password,New_Password])
            
        case .stripePayment(let TokenKey,let Price,let Stripe_Customer_Id,let Stripe_Card_Id,let Order_Id, let CallingChannel):
            return Parameters.stripePayment.map(values: [TokenKey, Price, Stripe_Customer_Id, Stripe_Card_Id, Order_Id,CallingChannel])
            
        case .sendOTPToEmail(let TokenKey,let Email):
            return Parameters.sendOTPToEmail.map(values:[TokenKey,Email])
        
        case .referFriendByMobile(let TokenKey,let Customer_Name,let Refer_Code,let Mobile_Number):
            return Parameters.referFriendByMobile.map(values: [TokenKey,Customer_Name,Refer_Code,Mobile_Number])
            
        case .feedback(let TokenKey,let Resturant_id,let Customer_id,let Number_of_Stars,let Comment):
            return Parameters.feedback.map(values:[ TokenKey, Resturant_id, Customer_id, Number_of_Stars, Comment] )
            
        case .signout(let TokenKey) :
            return Parameters.feedback.map(values:[ TokenKey] )
        }
    }
    
    var method : Alamofire.HTTPMethod {
        switch self {
        case .getCardListFromStripe(_):
            return .get
        default:
            return .post
        }
    }
    
    var baseURL: String{
        let apiConstants = APIConstants()
        switch self{
        case .addCardToStripe(_):
            return apiConstants.stripeBasePath
        case .getCardListFromStripe(_):
            return apiConstants.stripeBasePath
        default:
            return APIConstants.basePath
        }
    }
   
    var header : [String: String]{
        
        switch self{
        case .addCardToStripe(_):
           
            return ["Authorization" : "Bearer " + "sk_test_eGA1vmXgPmvLErBrWCIifKyG","Content-Type" : "application/x-www-form-urlencoded"]
            
          
        case .getCardListFromStripe(_):
           
            
                return ["Authorization" : "Bearer " + "sk_test_eGA1vmXgPmvLErBrWCIifKyG","Content-Type" : "application/x-www-form-urlencoded"]
           
        default:
            if let accessToken = Defaults.accessToken.get() as? String{
                print("Authorization \(accessToken)")
                return ["xlogintoken" : "\(accessToken)"]
            }else{ return [:]}
        }
        
    }
    
}
