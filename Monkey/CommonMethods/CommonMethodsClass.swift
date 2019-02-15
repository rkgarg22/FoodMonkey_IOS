//
//  CommonMethodsClass.swift
//  SpiceMint_Merchant
//
//  Created by Igniva-ios-12 on 11/15/16.
//  Copyright © 2016 Igniva-ios-12. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Foundation

typealias CompletionHandler = (_ success:Bool) -> Void

var alertSingle : AlertVC?
var alertWithTwoOption : AlertWithTwoOptionVC?
var addToCart : AddToCartVC?

class CommonMethodsClass : NSObject {

    override init() // since it is overriding the NSObject init
    {
        
    }
    
    class func animatePresentView(yourView :UIView)
    {
        yourView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        yourView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            
            yourView.transform = CGAffineTransform.identity
        })
        { (true) in
            yourView.backgroundColor = UIColor.ColorAlertBackGround
        }
    }
    
   
    class func okBtnForSingleAlertHandlerWithCompletionHandler( completion: @escaping CompletionHandler)
    {
        DispatchQueue.main.async {
            alertSingle?.view.backgroundColor = UIColor.clear
            alertSingle?.view.superview?.transform = CGAffineTransform.identity
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                alertSingle?.view.transform =  CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            { (true) in
                alertSingle?.view.backgroundColor = UIColor.clear
                alertSingle?.view.removeFromSuperview()
                alertSingle = nil
                completion(true)
            }
        }
    }
    
    class func showAlertWithSingleButton(title : String , msg : String , vc : AnyObject ,isDelegateRequired : Bool , imgName : String)
    {
        DispatchQueue.main.async {
            
            if alertSingle == nil
            {
                alertSingle = StoryboardScene.Alert.instantiateAlertController()
                AppDelegate.sharedDelegate().window?.addSubview((alertSingle?.view)!)
                alertSingle?.lblTitle.text = title
                alertSingle?.lblMsg.text = msg
                alertSingle?.imgAlert.image = UIImage.init(named: imgName)
                alertSingle?.isDelegateReqiured = isDelegateRequired
                if isDelegateRequired
                {
                    alertSingle?.delegateFrmSigleAlert = vc as? DelegateFromSingleAlert
                }
            }
        }
    }
    
    class func okBtnForSingleAlertHandler()
    {
         DispatchQueue.main.async {
            
            alertSingle?.view.backgroundColor = UIColor.clear
            alertSingle?.view.superview?.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                
                alertSingle?.view.transform =  CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            { (true) in
                alertSingle?.view.backgroundColor = UIColor.clear
                alertSingle?.view.removeFromSuperview()
                alertSingle = nil
            }

        }
        
        }
    
    class func showAddToCartWithTwoCompletionhandlers(addOns : [AddOnItem] , vc : AnyObject ,itemId:Int, itemName:String?, itemPrice : String? , items : [Sections], completionSuccess: @escaping (_ success:[AddOnItem]?,_ itemCount:Int?) -> Void, completionCancel: @escaping CompletionHandler)
    {
        DispatchQueue.main.async {
            addToCart = nil
            if addToCart == nil
            {
                addToCart = StoryboardScene.Main.instantiateAddToCartVC()
                addToCart?.addOns = addOns
                addToCart?.itemName = itemName
                addToCart?.items = items
                addToCart?.itemPrice = itemPrice
                addToCart?.ItemId = itemId
                AppDelegate.sharedDelegate().window?.addSubview((addToCart?.view)!)
                addToCart?.completionHandleraddToCart = {
                    completionSuccess(addToCart?.arrSelected,addToCart?.count)
                    let vc1 = StoryboardScene.Main.instantiateCheckOut_VC()
                    vc1.addOnList = addToCart?.arrSelected ?? [AddOnItem]()
                    if let nav = AppDelegate.sharedDelegate().window?.rootViewController as? UINavigationController
                    {
                        if let parennt = nav.topViewController as? RestaurantMenuMXVC
                        {
                            vc1.restaurantModel =  parennt.model_restaurant
                        }
                        //nav.pushViewController(vc1, animated: true)
                    }
                }
                addToCart?.completionHandlerAlertCancel = {
                    completionCancel(true)
                }
            }
        }
    }
    
    class func okBtnForAddToCartCancelHandler()
    {
        DispatchQueue.main.async {
            
            addToCart?.view.backgroundColor = UIColor.clear
            addToCart?.view.superview?.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                
                addToCart?.view.transform =  CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            { (true) in
                addToCart?.view.backgroundColor = UIColor.clear
                addToCart?.view.removeFromSuperview()
                addToCart = nil
            }
        }
    }
    class func showAlertWithTwoButton(msg : String , vc : AnyObject , btnOtherTitle : String , btnCancelTitle : String)
    {
        DispatchQueue.main.async {
            
            if alertWithTwoOption == nil
            {
                alertWithTwoOption = StoryboardScene.Alert.instantiateAlertWithTwoOptionController()
                AppDelegate.sharedDelegate().window?.addSubview((alertWithTwoOption?.view)!)
                alertWithTwoOption?.lblMsg.text = msg
                alertWithTwoOption?.btnOther.setTitle(btnOtherTitle, for: .normal)
                alertWithTwoOption?.btnCancel.setTitle(btnCancelTitle, for: .normal)
                alertWithTwoOption?.delegateFrmTwoActionAlert = vc as? DelegateFromTwoActionAlert
            }
        }
    }
    
    class func okBtnForTwoAlertHandler()
    {
        DispatchQueue.main.async
        {
            
            alertWithTwoOption?.view.backgroundColor = UIColor.clear
            alertWithTwoOption?.view.superview?.transform = CGAffineTransform.identity
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                
                alertWithTwoOption?.view.transform =  CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
            { (true) in
                alertWithTwoOption?.view.backgroundColor = UIColor.clear
                alertWithTwoOption?.view.removeFromSuperview()
                alertWithTwoOption = nil
            }
        }
    }
    
    class func getDeviceToken() -> String
    {
        if let devicetoken = DBManager.accessUserDefaultsForKey(keyStr: Keys.deviceNotificationToken.rawValue) as? String
        {
            return devicetoken
        }
        else
        {
            return "1213214345565"
        }
    }
    
    class func showAlertViewWithActionOnWindow(titleStr: String, messageStr: String, okBtnTitleStr:String, cncelBtnTitleStr: String, completion: @escaping CompletionHandler)
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        
        let alertAction = UIAlertAction.init(title: okBtnTitleStr, style: .default) { (UIAlertAction) in
            
            completion(true)
        }
        
        alert.addAction(alertAction)
        alert.addAction(UIAlertAction(title: cncelBtnTitleStr, style: UIAlertActionStyle.default, handler: nil))
        alert.view.tintColor =  UIColor.AppColorGreen
        AppDelegate.sharedDelegate().window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    class func showAlertViewOnWindow(titleStr: String, messageStr: String, okBtnTitleStr:String)
    {
        let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: okBtnTitleStr, style: UIAlertActionStyle.default, handler: nil))
        alert.view.tintColor = UIColor.AppColorGreen
        AppDelegate.sharedDelegate().window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    class func addBoldText(fullString: NSString, boldPartOfString: [NSString], font: UIFont!, boldFont: UIFont!) -> NSAttributedString
    {
        let nonBoldFontAttribute = [NSFontAttributeName:font!]
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified
        let boldFontAttribute = [NSFontAttributeName:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String , attributes:nonBoldFontAttribute)
        for i in 0..<boldPartOfString.count - 1{
            boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartOfString[i] as String))
        }
        return boldString
    }
    
    class func passwordChek(testStr:String) -> Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 ")
        if testStr.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        else
        {
            return false
        }
    }
    
    class func converToDateStrFrom(timestamp : Double,format:String) -> String{
        let startDate = NSDate(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let startDateStr = dateFormatter.string(from: startDate as Date)
        return startDateStr
    }
    
    //
    // Convert String to base64
    //
    class func convertImageToBase64(image: UIImage) -> String {
        let imageData = UIImageJPEGRepresentation(image, 0.5)!
        return "data:image/png;base64," + imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    //
    // Convert base64 to String
    //
    class func convertBase64ToImage(imageString: String) -> UIImage {
        let imageData = Data(base64Encoded: imageString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
        return UIImage(data: imageData)!
    }
    
    class func removeTime(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString : Date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let datenewString = dateFormatter.string(from: dateFromString)
        print(datenewString)
        return datenewString
    }
    
    class func getDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFromString : Date = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss a"
        let datenewString = dateFormatter.string(from: dateFromString)
        print(datenewString)
        return datenewString
    }
    
}

extension UITextField{
    
    /// EZSE: Add a image icon on the left side of the textfield
    public func addRightIcon(_ image: UIImage?, frame: CGRect, imageSize: CGSize) {
        let leftView = UIView()
        leftView.frame = frame
        let imgView = UIImageView()
        imgView.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, w: imageSize.width, h: imageSize.height)
        imgView.image = image
        leftView.addSubview(imgView)
        self.rightView = leftView
        self.rightViewMode = UITextFieldViewMode.always
    }
    public func addRightIcons(_ image: UIImage?, selectedImage:UIImage?, frame: CGRect, imageSize: CGSize)-> UIButton {
        let leftView = UIView()
        leftView.frame = frame
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: frame.width - 8 - imageSize.width, y: (frame.height - imageSize.height) / 2, w: imageSize.width, h: imageSize.height)
        button.setImage(image, for: .normal)
        button.setImage(selectedImage, for: .selected)
        leftView.addSubview(button)
        self.rightView = leftView
        self.rightViewMode = UITextFieldViewMode.always
        return button
    }
}
