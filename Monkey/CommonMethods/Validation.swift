//
//  ValidationClass.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import UIKit

enum Valid{
    case success
    case failure(Alerts,String)
}

class Validation: NSObject {
    
    static let shared = Validation()
    
    func validate(signUp firstName : String?, lastName : String?,gender: String?,mobile : String?,dob : String?, password : String?,terms:Bool?) -> Valid {
        if terms == false{
            return errorMsg(str: .ValidateTerms)
        }else if (/firstName).isEmpty{
            return errorMsg(str: .ValidateFirstName)
        }
        else if (/lastName).isEmpty{
            
            return errorMsg(str: .ValidateLastName)
        }
//        else if (/gender).isEmpty{
//            
//            return errorMsg(str: .ValidateGender)
//        }
//        else if (/email).isEmpty{
//
//            return errorMsg(str: .ValidateEmail)
//        }
//        else if !(/email).isEmail{
//            return errorMsg(str: .ValidateValidEmail)
//        }
        else if (/mobile).isEmpty{
            
            return errorMsg(str: .ValidateMobile)
        }
        else if (/password).isEmpty
        {
            return errorMsg(str: .ValidatePassword)
        }
        else if (/password).length < 4 {
            return errorMsg(str: .ValidateValidPassword)
        }
       
        return .success
    }
    
    func validate(signIn email : String?, password : String?) -> Valid {
        
        if (/email).isEmpty{
            return errorMsg(str: .ValidateEmail)
        }
//        else if !(/email).isEmail{
//            return errorMsg(str: .ValidateValidEmail)
//        }
        else if (/password).isEmpty
        {
            return errorMsg(str: .ValidatePassword)
        }
        else if (/password).length < 4 {
            return errorMsg(str: .ValidateValidPassword)
        }
        
        return .success
    }
    
    
    func validate(createPassword : String?) -> Valid {
        
        if (/createPassword).isEmpty
        {
            return errorMsg(str: .ValidatePassword)
        }
        if (/createPassword).length < 4 {
            return errorMsg(str: .ValidateValidPassword)
        }
        
        return .success
    }
    
    func validate(sendOtp mobile_number : String?) -> Valid {
        
        if (/mobile_number).isEmpty{
            return errorMsg(str: .ValidateMobile)
        }
        return .success
    }
    
    func validate(verifyOtp otp : String?) -> Valid {
        
        if (/otp).isEmpty{
            return errorMsg(str: .ValidateOtp)
        }else if (/otp).count < 4{
            return errorMsg(str: .ValidateOtp)
        }
        return .success
    }
    
    func validate(addCard  NameOnCard : String?,CardNumber : String?, ExpDate : String?,ExpYear : String?, CVV : String?) -> Valid {
        
        if (/NameOnCard).isEmpty{
            return errorMsg(str: .ValidateValidNameOnCard)
        }
        else if (/CardNumber).isEmpty
        {
            return errorMsg(str: .ValidateValidCardNumber)
        }
        else if (/ExpDate).isEmpty {
            return errorMsg(str: .ValidateValidExpDate)
        }
        else if (/ExpYear).isEmpty
        {
            return errorMsg(str: .ValidateValidExpYear)
        }
        else if (/CVV).isEmpty {
            return errorMsg(str: .ValidateValidCVV)
        }
        
        return .success
    }
    
    func validate(searchText:String) -> Valid {
        
        if (/searchText).isEmpty{
            return errorMsg(str: .ValidateSearch)
        }
        
        return .success
    }
    
    func validate(forgotPassword email : String?) -> Valid {
        
        if (/email).isEmpty{
            
            return errorMsg(str: .ValidateEmail)
            
        }
        else if !(/email).isEmail{
            return errorMsg(str: .ValidateValidEmail)
        }
        
        return .success
    }
    
    
    
    func validate(addAddress name : String?,mobileNumber :String,houseNumber:String,line1:String,postCode:String,city:String) -> Valid {
        
        if (/name).isEmpty
        {
            return errorMsg(str: .validateName)
        }
        else if (/mobileNumber).isEmpty
        {
            return errorMsg(str: .ValidateMobile)
        }
        else if (/houseNumber).isEmpty
        {
            return errorMsg(str: .validateHouse)
        }
//        else if (/addressNote).isEmpty
//        {
//            return errorMsg(str: .validateAddressNote)
//        }
        else if (/line1).isEmpty
        {
            return errorMsg(str: .validateLine1)
        }
//        else if (/line2).isEmpty
//        {
//            return errorMsg(str: .validateLine2)
//        }
        else if (/postCode).isEmpty
        {
            return errorMsg(str: .validatePostcode)
        }
        else if (/city).isEmpty
        {
            return errorMsg(str: .validateCity)
        }
    
        return .success
    }
    
    func errorMsg(str : Alerts) -> Valid{
        return .failure(.Error,str.get())
    }
    
}
