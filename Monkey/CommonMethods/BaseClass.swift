//
//  BaseClass.swift
//  TrophyCaseApp
//
//  Created by Khushboo on 7/20/17.
//  Copyright © 2017 Khushboo. All rights reserved.
//
import UIKit
import CoreLocation
import Photos
import AVFoundation
import CoreImage
import MobileCoreServices

class BaseClass: UIViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //storyboard instance
    func storyBoadName(name:String) ->UIStoryboard {
        return UIStoryboard(name:name,bundle:nil)
    }
    
    //return vc by name
    
    func isValidEmail(testStr:String) -> Bool {
        // ////print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func passwordValidationAlphaNumeric(testStr:String) -> Bool {
        let emailRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!#$%&'()*+,-./:;<=>?@^_`{|}~\"])[A-Za-z\\d!#$%&'()*+,-./:;<=>?@^_`{|}~\"]{6,15}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    //MARK: Validation Check For Phone Number
    func validatePhonNo(phoneNo: String)-> Bool
    {
        
        var hasChar: Bool
        
        if (phoneNo.characters.count >= 5 && phoneNo.characters.count <= 15 )
        {
            hasChar = true
        }
        else
        {
            hasChar = false
        }
        var hasNumb: Bool
        
        let badCharacters = CharacterSet.decimalDigits.inverted
        if phoneNo.rangeOfCharacter(from: badCharacters) == nil
        {
            
            hasNumb = true
        }
        else {
            
            hasNumb = false
        }
        
        
        if (!hasChar || !hasNumb )
        {
            return false
        }
        else
        {
            return true
        }
        
        
    }
    
   
    
    func timeSince(from: Date, numericDates: Bool) -> String {
        
        let calendar = Calendar.current
        let now = NSDate()
        let earliest = now.earlierDate(from as Date)
        let latest = earliest == now as Date ? from : now as Date
        let components = calendar.dateComponents([.year, .weekOfYear, .month, .day, .hour, .minute, .second], from: earliest, to: latest as Date)
        
        var result = ""
        
        if components.year! >= 2 {
            result = "\(components.year!) years ago"
        } else if components.year! >= 1 {
            if numericDates == true {
                result = "1 year ago"
            } else {
                result = "Last year"
            }
        } else if components.month! >= 2 {
            result = "\(components.month!) months ago"
        } else if components.month! >= 1 {
            if numericDates == true {
                result = "1 month ago"
            } else {
                result = "Last month"
            }
        } else if components.weekOfYear! >= 2 {
            result = "\(components.weekOfYear!) weeks ago"
        } else if components.weekOfYear! >= 1 {
            if numericDates == true {
                result = "1 week ago"
            } else {
                result = "Last week"
            }
        } else if components.day! >= 2 {
            result = "\(components.day!) days ago"
        } else if components.day! >= 1 {
            if numericDates == true {
                result = "1 day ago"
            } else {
                result = "Yesterday"
            }
        } else if components.hour! >= 2 {
            result = "\(components.hour!) hours ago"
        } else if components.hour! >= 1 {
            if numericDates == true {
                result = "1 hour ago"
            } else {
                result = "An hour ago"
            }
        } else if components.minute! >= 2 {
            result = "\(components.minute!) min ago"
        } else if components.minute! >= 1 {
            if numericDates == true {
                result = "1 min ago"
            } else {
                result = "A min ago"
            }
        } else if components.second! >= 3 {
            //            result = "\(components.second!) sec ago"
            result = "Just now"
        } else {
            result = "Just now"
        }
        
        return result
    }
    
    func passwordChek(testStr:String) -> Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        if testStr.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        else
        {
            return false
        }
    }
    
    
}

