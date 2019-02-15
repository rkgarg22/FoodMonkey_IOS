//
//  Constants.swift
//  HutchDecor
//
//  Created by Aseem 13 on 14/09/16.
//  Copyright © 2016 Taran. All rights reserved.
//

import UIKit
import SwiftyJSON
import EZSwiftExtensions
import RMMapper
import ObjectMapper

enum Defaults : String{
    
    case login
    case accessToken
    case isLoggedIn
    case isWalkThroughOver
    case latitude
    case longitude
//    case userId

    
    func get() -> Any?{
        switch self {
        case .login:
            guard let data = UserDefaults.standard.rm_customObject(forKey: self.rawValue) else {return nil}
            return Mapper<LoginModal>().map(JSONObject: data as! [String : Any])
            
        case .accessToken:
            return DBManager.accessUserDefaultsForKey(keyStr: self.rawValue)
            
        case .isLoggedIn:
            return DBManager.accessUserDefaultsForKey(keyStr: self.rawValue)
            
        case .isWalkThroughOver:
            return DBManager.accessUserDefaultsForKey(keyStr: self.rawValue)
            
        case .latitude:
            return DBManager.accessUserDefaultsForKey(keyStr: self.rawValue)
            
        case .longitude:
            return DBManager.accessUserDefaultsForKey(keyStr: self.rawValue)
            
//        case .userId:
//            return (Defaults.login.get() as? LoginModal)?.id

        }
    }
}

struct Screen {
    static let HEIGHT = UIScreen.main.bounds.size.height
    static let WIDTH = UIScreen.main.bounds.size.width
    static let HEIGHTRATIO = WIDTH * 0.5625
    
  
}

enum DemoArrays : Int{
    
    case DemoImages = 0
    case DemoDesc = 1
    case DemoTitle = 2
    
    func get() -> [String] {
        
        switch self {
        case .DemoImages:
            
            return ["walk_one","walk_two","walk_three"]
            
        case .DemoDesc:
            
            return ["Get updates when others win an award Congratulate them OR maybe you just want to keep track of how your competition is doing!\nIt's your prerogative!","Heading to a tournament?\nWant to know about your\ncompetition? Excelling in your field, you want to get noticed by scouts?\nOr, maybe you just want to see how you rank in your sport?\nThis page uses filters to give you the stats you're looking for.","Actually, you can add any kind of award whether it's a trophy, medal, ribbon, or \n plaque!\nLook for the QR Code on your trophy for a free, verified trophy!\nWant to add an award that didn't come with our code? Go ahead, you get 12 free uploads!"]
            
        case .DemoTitle:
            
            return ["CREATE EVENT","TEXT YOUR FRIENDS","SEARCH EVENT"]
        }
    }
}

enum TitleArrays : Int{
    case helpVC_str = 0
    case settingVC_str = 1
    case sideMenu_str = 2
    case sideMenu_str_loggedIn = 3
    
    func get() -> [String] {
        switch self {
        case .helpVC_str:
            return ["Online support","Cookies Policy","Acknowledgements","EULA","Delete app data"]
        case .settingVC_str:
            return ["Autostart","Service SMS","App permissions","Notifications","Show on Lock  Screen","Start in background","Display pop-up window"]
        case .sideMenu_str:
            //return ["Log in","Refer a friend","Sign up","Help","Terms","Settings"]
            return ["Log in","Sign up","Terms"]
        case .sideMenu_str_loggedIn:
           // return ["My Account","Refer a friend","My Orders","Help","Terms","Settings","Log out"]
            return ["My Account","Refer a friend","My Orders","Terms","Log out"]
        }
    }
}


enum Images : String
{
    case succes = "success_icon"
    case error = "error"
    case warning = "warning"
}

enum SucessTitle : String
{
    case passwordChanged = "Thank you. Your password has been\nsuccessfully changed. Please log into again\nusing your new password."
    
    case referFriend = "Share this code with your friends.\nWhen they order delivery or pick up for the first time they'll get 15% off.\n Then you will too!"
    
}


enum colorUsed : String
{
    case textField_border = "7f7f7f"
    
    
}

enum FontName : String
{
    case RawlineExtraBold   = "RawlineSemibold-Regular"
    case RawlineLight   = "RawlineLight-Regular"
    case UniSansRegular   = "Uni-Sans-Regular"
    case CatamaranExtraLight  = "Catamaran-ExtraLight"
    case CatamaranLight = "Catamaran-Light"
    case CatamaranMedium = "Catamaran-Medium"
    case LatoRegular = "Lato-Regular"
    case CatamaranSemiBold = "Catamaran-SemiBold"
    case CatamaranThin = "Catamaran-Thin"
}

enum FontSize : CGFloat {
    case PlaceholderSize   = 16.0
    case ChatHeaderSize = 13.0
}
