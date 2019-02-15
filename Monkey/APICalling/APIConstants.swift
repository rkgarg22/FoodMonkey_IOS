//
//  APIConstants.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//


import Foundation

internal class APIConstants {
    
    class func getStripeCustomerId() -> String{
        return DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.Stripe_Customer_Id.rawValue) as? String ?? ""
    }
   
    static let basePath = "https://food-monkey.com/api/"
    
    let stripeBasePath = "https://api.stripe.com/v1/customers/\(APIConstants.getStripeCustomerId())/"

    static let termsLink = "https://food-monkey.com/terms-and-conditions.php"
    
    //Registration
    static let signUp = "customer/customer_signup.php"
    static let addToken = "customer/add_token.php"
    static let login = "customer/customer_login.php"
    static let forgotPassword = "user/forgot-password"
    static let resendVerificationLink = "user/account-re-verification"
    static let logout = "customer/user/logout"
    static let sendOtp = "customer/send_mobile_otp.php"
    static let verifyOtp = "customer/verify_mobile_otp.php"
    static let verifyNumber = "customer/verify_number.php"
    //Restaurant
    static let restaurantList = "resturant/resturant_list.php"
    static let homeRestaurant = "resturant/home_restaurant.php"
    static let cuisinesList = "resturant/list_cuisines.php"
    static let restaurantDetails = "resturant/restaurant_details.php"
    static let restaurantFeedback = "resturant/rest_feedback_list.php"
    static let addOn = "resturant/list_menu_addon.php"
    
    static let getDeliveryAddress = "customer/customer_address.php"
    static let addNewAddress = "customer/customer_new_address.php"
    static let editAddress = "customer/customer_edit_address.php"
    static let deleteAddress = "customer/customer_address_delete.php"
    
    //payment
    static let addCard = "customer/add_card.php"
    static let addCardToStripe = "sources"
    static let getCardList = "customer/card_list.php"
    static let getCardListFromStripe = "sources?object=card"
    static let checkout = "customer/order_checkout.php"
    static let payment = "customer/add_paymentmethod.php"
    static let getCustomerDetails = "customer/customer_details.php"
    static let editCustomerProfile = "customer/customer_profile_edit.php"
    
    static let customerOrderList = "resturant/Customer_Order_list.php"
    static let customerOrderStatus = "customer/customer_order_status.php"
    
    //braintree
    static let createBrainToken = "braintree/braintree_token.php"
    static let brainTreePayment = "braintree/braintree_payment.php"
    static let stripePayment = "customer/pay_with_card.php"
    
    //forgot pwd
    static let email_phone_exist = "customer/forget_password.php"
    static let forgotPwd = "customer/forget_change_password.php"
    static let sendOtpToEmail = "customer/send_email_otp.php"
    static let changePwd = "customer/direct_forget_password.php"
    
    //refer
    static let referFriendByMobile = "customer/refer_by_mobile.php"
    
    //feedback
    static let feedback = "customer/customer_feedback.php"
    
    //signout
    static let signout = "customer/appsignout.php"
}



enum SplashString : String{
    case descStr_splash0 = "Let The Chimp Tingle Your Taste Buds.."
    case boldStr1_splash0 = "Let"
    case boldStr2_splash0 = "Chimp"
    case boldStr3_splash0 = "Your"
    case boldStr4_splash0 = "Buds.."
}

enum Alerts : String {
    
    case ValidateEmail = "Enter Email."
    case Error = "Trophy Case"
    case ValidateTerms = "Please accept the terms and conditions."
    case ValidateFirstName = "Enter First Name."
    case ValidateMiddleName = "Enter Middle Name."
    case ValidateLastName = "Enter Last Name."
    case ValidateGender = "Please select Gender."
    case ValidatePassword = "Enter password."
    case ValidateValidEmail = "Enter a valid Email."
    case ValidateMobile = "Enter Mobile Number."
    case ValidateOtp = "Enter OTP."
    case ValidateDOB = "Please select your date of birth."
    case ValidateValidPassword = "Password should be minimum 4 characters."
    case ValidateValidUsername = "Enter a valid Full Name.Full Name length should be 6-20 characters."
    case ValidateConfirmPassword = "Confirm password does not match the password."
    case ValidateEnterConfirmPassword = "Please enter confirm password."
    case SettingsApp  = "Application needs Location. Please allow Location Permissions from settings."
    
    case validateOldPassword = "Your old password seems invalid"
    case validateNewPassword = "Enter a valid new password. Password length should be 8-12 characters."
    case validateNewPasswordConfirm = "Enter a valid confirm password. Password length should be 8-12 characters."
    case noRecepent = "Please enter the mail id of the recipient."
    case subject = "Please Enter the Subject."
    case message = "Message cannot be blank."
   
    case validateName = "Please enter address type."
    case validateStartDate = "Please enter start date of event."
    case validateHouse = "Please enter house number"
    case validateAddressNote = "Please enter address note"
    case validateLine1 = "Please enter street line1"
    case validateLine2 = "Please enter street line2"
    case validatePostcode = "Please enter postcode"
    case validateCity = "Please enter city"
    
    case ValidateSearch = "Enter a location or enable your current location."
    case internetOff = "Internet connection appears to be offline."
    
    
    case ValidateValidNameOnCard = "Enter a valid NameOnCard."
    case ValidateValidCardNumber = "Enter a valid CardNumber."
    case ValidateValidExpDate = "Enter a valid ExpDate"
    case ValidateValidExpYear = "Enter a valid ExpYear."
    case ValidateValidCVV = "Enter a valid CVV."
    
    
    func get() -> String{
        switch self {
        default:
            return self.rawValue
        }
    }
}

enum ApiParmConstant : String {

    case Customer_Type = "Customer"
    case CallingChannel = "App"
}


enum Validate : String {
    
    case none
    case success = "200"
    case failure = "400"
    case accountNotVerified = "404"
    case invalidAccessToken = "101"
    case adminBlocked = "403"
    case emailRequired = "402"
    case verifyEmail = "405"
    case AccountDeactivated = "406"

    func map(response message : String?) -> String? {
        
        switch self {
        case .success:
            return message
        case .failure :
            return message
        case .invalidAccessToken :
            return message
        case .adminBlocked:
            return message
        case .accountNotVerified:
            return message
        case .emailRequired:
            return message
        case .verifyEmail:
            return message
        default:
            return nil
        }
    }
}

enum Response {
    case success(AnyObject?)
    case Warning(String?)
    case failure(String?)
    
}

typealias OptionalDictionary = [String : Any]?

struct Parameters {
    
    static let signUp : [Keys] = [.TokenKey, .First_Name, .Middle_Intial,.Sur_Name,.Gender,.Email,.Mobile,.DOB,.Password,.ProfilePic,.CallingChannel,.LoginType,.GoogleorFbId]
    
    static let login : [Keys] = [.TokenKey, .Email, .Password, .CallingChannel,.LoginType,.GoogleorFbId,.First_Name,.Sur_Name,.Gender]
    static let sendOtp : [Keys] = [.TokenKey, .Mobile_number]
    static let verifyOtp : [Keys] = [.TokenKey, .OTP, .Request_Id]
    static let verifyNumber : [Keys] = [.TokenKey, .Mobile_Number]
    static let addToken : [Keys] = [.TokenKey,.Customer_Type,.CallingChannel]
    static let restaurantList : [Keys] = [.TokenKey,.SearchBy,.PostCode,.DeliveryOptions,.ListBy,.Cuisines,.PageNumber,.CallingChannel]
    static let homeRestaurant : [Keys] = [.TokenKey,.Customer_id]
    static let cuisinesList : [Keys] = [.TokenKey]
    static let restaurantDetails : [Keys] = [.TokenKey,.Resturant_id,.Customer_id]
    static let restaurantFeedback : [Keys] = [.TokenKey,.Resturant_id]
    static let addOn : [Keys] = [.TokenKey,.Item_Id]
    static let addAddress : [Keys] = [.TokenKey, .Customer_id,.Address_type,.Mobile_Number,.House_No,.Address_Note,.Street_Line1, .Street_Line2,.Post_Code,.City]
    static let getAddress : [Keys] = [.TokenKey, .Customer_id]
    static let addCard :[Keys] = [.TokenKey,.Stripe_Customer_Id,.Stripe_Token]
    static let addCardToStripe :[Keys] = [.source,.object,.number,.exp_month,.exp_year,.cvc]
    static let getCardList : [Keys] = [.TokenKey,.Stripe_Customer_Id]
    static let getCardListFromStripe : [Keys] = [.customer,.ending_before,.limit,.starting_after]
    static let checkout  : [Keys] = [.TokenKey,.Customer_Id,.Resturant_id,.Address_id,.Order_Amount, .DeliveryOption,.Item_Id,.Quantity,.Addon_Id,.Preorder_DateTime,.Preorder_Comments]
    static let payment : [Keys] = [.TokenKey,.Order_id,.Stripe_Cardid,.Payment_Method]
    static let getCustomerDetails : [Keys] = [.TokenKey,.Customer_id]
    static let editAddress : [Keys] = [.TokenKey, .Address_id,.Address_type,.Mobile_Number,.House_No,.Address_Note,.Street_Line1, .Street_Line2,.Post_Code,.City]
    static let deleteAddress : [Keys] = [.TokenKey, .Address_id]
    static let customerOrderList : [Keys] = [.TokenKey,.Customer_id]
    static let customerOrderStatus : [Keys] = [.TokenKey,.Order_Id]
    static let createBrainToken : [Keys] = [.TokenKey]
    static let brainTreePayment : [Keys] = [.TokenKey,.Payment_Method_Nonce,.Amount,.orderId,.Customer_First_Name,.Customer_Last_Name,.Customer_Email,.CallingChannel]
    static let editCustomerProfile : [Keys] = [.TokenKey,.Customer_id,.First_Name,.Middle_Intial,.Sur_Name,.Gender,.DOB,.ProfilePic]
    static let emailPhoneExits : [Keys] = [.TokenKey,.EmailorMobile]
    static let forgetPwd : [Keys] = [.TokenKey,.Customer_id,.New_Password]
    static let stripePayment : [Keys] = [.TokenKey,.Price,.Stripe_Customer_Id,.Stripe_Card_Id,.Order_Id,.CallingChannel]
    static let sendOTPToEmail : [Keys] = [.TokenKey,.Email]
    static let referFriendByMobile : [Keys] = [.TokenKey,.Customer_Name,.Refer_Code,.Mobile_Number]
    static let feedback : [Keys] = [.TokenKey,.Resturant_id,.Customer_id,.Number_of_Stars,.Comment]
    static let signout : [Keys] = [.TokenKey]
    static let changePwd : [Keys] = [.TokenKey,.Customer_id,.Old_Password,.New_Password]
}




