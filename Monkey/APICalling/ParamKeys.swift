//
//  ParamKeys.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 28/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import UIKit

enum ParamKeys : String {
    
    case Refer_Code
    case accessToken
    case phoneNo
    case countryCode
    case OTPCode
    case signUpStep
    case Customer_id
    case request_id
    case Stripe_Customer_Id
    case cartAdded
    case fullName
    case firstName
    case lastName
    case profilePicURL
    case original
    case thumbnail
    case _id
    case name
    case image
    case level
    case loyalityPoint
    case registrationDate
    case email
    case cartItems
    case cartPrice
    case cartArray
    case password
}

enum Keys : String{
    
    case Preorder_DateTime
    case Preorder_Comments
    
    case statusCode = "Code"
    case message = "Message"
    case Restutant_list = "Restutant_list"
    case Success
    case Warning
    case Error
    
    case ErrorTitle = "MonkeyApp"
    case Settings
    case Cancel
    
    //payment
    case Payment_Method_Nonce
    case Amount
    case orderId
    case Customer_First_Name
    case Customer_Last_Name
    case Customer_Email
    case brainTreeToken = "Braintree_token"
    
    //App keys
    case deviceNotificationToken = "deviceNotificationToken"
    case deviceTypeIOS = "ios"
    
    
    //token
    case token
    
    //Signup  and login
    case TokenKey
    case First_Name
    case Middle_Intial
    case Sur_Name
    case Gender
    case Email
    case Mobile_number
    case OTP
    case Request_Id
    case Mobile                                           
    case DOB //(Y-M-D)
    case Password
    case ProfilePic
    case CallingChannel
    case LoginType
    case GoogleorFbId
    
     //add token
    
    case Customer_Type
    
    //Restaurant List
    case SearchBy
    case PostCode
    case DeliveryOptions
    case ListBy
    case Cuisines
    case PageNumber

    //Home Restaurant
    case Customer_id
    case Resturant_id
    case Item_Id
    
    //feedback
    case Number_of_Stars
    case Comment
    
    //address
    case Address_type
    case House_No
    case Mobile_Number
    case Address_Note
    case Street_Line1
    case Street_Line2
    case Post_Code
    case City
    
    
    //card
    case NameOnCard
    case CardNumber
    case ExpDate
    case ExpYear
    case CVV
    
    //checkout
    case Address_id
    case Order_Amount
    case DeliveryOption
    case Quantity
    case Addon_Id
    case Customer_Id
    
    //payment
    case Order_id
    case Order_Id
    case Stripe_Cardid
    case Payment_Method
    case Stripe_Token
    case Stripe_Customer_Id
    case Price
    case Stripe_Card_Id
    
    //Stripe
    case source
    case object
    case number
    case exp_month
    case exp_year
    case cvc
    
    case customer
    case ending_before
    case limit
    case starting_after
    
    //forgot pwd
    case EmailorMobile
    case New_Password
    case Old_Password
    
    //refer
    case Customer_Name
    case Refer_Code
}
