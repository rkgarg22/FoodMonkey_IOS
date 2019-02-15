//
//  APIManager.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//


import Foundation
import SwiftyJSON
import EZSwiftExtensions

class APIManager : NSObject{
    
    typealias Completion = (Response) -> ()
    static let shared = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    var alertEmail : EmailAlert?
    
    func postRequest(with api : Router , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            Utility.shared.loader()
        }
        httpClient.postRequest(withApi: api, success: {[weak self] (data) in
            Utility.shared.removeLoader()
            
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            print(json)
            
           
            
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.invalidAccessToken.rawValue{
                self?.tokenExpired()
                return
            }
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.adminBlocked.rawValue{
                self?.adminBlocked(msg : json[Keys.message.rawValue].stringValue)
                return
            }
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.accountNotVerified.rawValue{
                self?.accountNotVerifiedHandler(msg : json[Keys.message.rawValue].stringValue)
                return
            }
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.emailRequired.rawValue{
                self?.emailRequiredForFbHandler(msg: json[Keys.message.rawValue].stringValue, paramsDict: api.parameters)
                return
            }
            if json[Keys.statusCode.rawValue].stringValue == Validate.verifyEmail.rawValue{
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:json[Keys.message.rawValue].stringValue , vc: ez.topMostVC!, isDelegateRequired: false, imgName: Images.error.rawValue)
                return
            }
            if json[Keys.statusCode.rawValue].stringValue == Validate.AccountDeactivated .rawValue{
                self?.accountActivationHandler(msg : json[Keys.message.rawValue].stringValue)
                return
            }
            
            
                let object : AnyObject?
                object = api.handle(data: response)
                completion(Response.success(object))
                
           
            
            }, failure: { (message) in
                
                Utility.shared.removeLoader()
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg: /message, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                
        })
    }
    
    func request(with api : Router , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            Utility.shared.loader()
        }
        
        if api.method == .get{
            httpClient.getRequest(withApi: api, success: {[weak self] (data) in
                Utility.shared.removeLoader()
                
                guard let response = data else {
                    completion(Response.failure(.none))
                    return
                }
                let json = JSON(response)
                
                print(json)
                
                if api.route.contains(APIConstants.addCard) == true ||  api.route.contains(APIConstants.getCardList) == true || api.route.contains(APIConstants.stripePayment) == true {
                    let object : AnyObject?
                    object = api.handle(data: data)
                    completion(Response.success(object))
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == Validate.invalidAccessToken.rawValue{
                    self?.tokenExpired()
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == Validate.adminBlocked.rawValue{
                    self?.adminBlocked(msg : json[Keys.message.rawValue].stringValue)
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == Validate.accountNotVerified.rawValue{
                    self?.accountNotVerifiedHandler(msg : json[Keys.message.rawValue].stringValue)
                    return
                }
                if json[Keys.statusCode.rawValue].stringValue == Validate.verifyEmail.rawValue{
                    if let msg = json[Keys.message.rawValue] as? String
                    {
                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:msg , vc: ez.topMostVC!, isDelegateRequired: false, imgName: Images.error.rawValue)
                    }
                    return
                }
                if json[Keys.statusCode.rawValue].stringValue == Validate.AccountDeactivated.rawValue{
                    if let msg = json[Keys.message.rawValue] as? String
                    {
                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:msg , vc: ez.topMostVC!, isDelegateRequired: false, imgName: Images.error.rawValue)
                    }
                    return
                }
                let responseType = Validate(rawValue: json[Keys.statusCode.rawValue].stringValue) ?? .failure
                switch responseType {
                case .success:
                    let object : AnyObject?
                    object = api.handle(data: response)
                    completion(Response.success(object))
                    
                case .failure:
                    completion(Response.failure(json[Keys.message.rawValue].stringValue))
                default : break
                }
                
                }, failure: { (message) in
                    
                    Utility.shared.removeLoader()
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg: /message, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            })
            
        }
        else{
            httpClient.postRequest(withApi: api, success: {[weak self] (data) in
                Utility.shared.removeLoader()
                
                
                
                guard let response = data else {
                    completion(Response.failure(.none))
                    return
                }
                let json = JSON(response)
                print(json)
                
                if api.route.contains(APIConstants.addCard) == true ||  api.route.contains(APIConstants.getCardList) == true || api.route.contains(APIConstants.stripePayment) == true {
                    let object : AnyObject?
                    object = api.handle(data: data)
                    completion(Response.success(object))
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == Validate.invalidAccessToken.rawValue{
                    self?.tokenExpired()
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == "402"{
                    var delegte = false
                    if let c = ez.topMostVC as? CheckOutAddress_VC{
                        delegte = true
                    }
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:json[Keys.message.rawValue].stringValue , vc: ez.topMostVC!, isDelegateRequired: delegte, imgName: Images.error.rawValue)
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == Validate.adminBlocked.rawValue{
                    self?.adminBlocked(msg : json[Keys.message.rawValue].stringValue)
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == Validate.accountNotVerified.rawValue{
                    self?.accountNotVerifiedHandler(msg : json[Keys.message.rawValue].stringValue)
                    return
                }
                
                if json[Keys.statusCode.rawValue].stringValue == Validate.emailRequired.rawValue{
                    self?.emailRequiredForFbHandler(msg: json[Keys.message.rawValue].stringValue, paramsDict: api.parameters)
                    return
                }
                if json[Keys.statusCode.rawValue].stringValue == Validate.verifyEmail.rawValue{
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:json[Keys.message.rawValue].stringValue , vc: ez.topMostVC!, isDelegateRequired: false, imgName: Images.error.rawValue)
                    return
                }
                if json[Keys.statusCode.rawValue].stringValue == Validate.AccountDeactivated .rawValue{
                    self?.accountActivationHandler(msg : json[Keys.message.rawValue].stringValue)
                    return
                }
                
                let responseType = Validate(rawValue: json[Keys.statusCode.rawValue].stringValue) ?? .failure
                switch responseType {
                case .success:
                    let object : AnyObject?
                    object = api.handle(data: response)
                    completion(Response.success(object))
                    
                case .failure:
                    completion(Response.failure(json[Keys.message.rawValue].stringValue))
                default : break
                }
                
                }, failure: { (message) in
                    
                    Utility.shared.removeLoader()
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg: /message, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                    
            })
            
        }
    }
    
    func requestMultipartFormData(with api : Router,imageData:[String:Data],videoData : [String:Data] , completion : @escaping Completion )  {
        
        if isLoaderNeeded(api: api) {
            Utility.shared.loader()
        }
        httpClient.uploadMediaToServer(api: api, imgMedia: imageData, videoMedia: videoData, success: { [weak self] (data) in
            Utility.shared.removeLoader()
            
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            print(json)
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.invalidAccessToken.rawValue{
                self?.tokenExpired()
                return
            }
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.adminBlocked.rawValue{
                self?.adminBlocked(msg : json[Keys.message.rawValue].stringValue)
                return
            }
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.accountNotVerified.rawValue{
                self?.accountNotVerifiedHandler(msg : json[Keys.message.rawValue].stringValue)
                return
            }
            
            if json[Keys.statusCode.rawValue].stringValue == Validate.emailRequired.rawValue{
                self?.emailRequiredForFbHandler(msg: json[Keys.message.rawValue].stringValue, paramsDict: api.parameters)
                return
            }
           
            
            let responseType = Validate(rawValue: json[Keys.statusCode.rawValue].stringValue) ?? .failure
            switch responseType {
            case .success:
                let object : AnyObject?
                object = api.handle(data: response)
                completion(Response.success(object))
                
            case .failure:
                completion(Response.failure(json[Keys.message.rawValue].stringValue))
            default : break
            }
        }) { (message) in
            Utility.shared.removeLoader()
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg: /message, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
        
    }
    
    
    func tokenExpired(){
        
        DispatchQueue.main.async {
            DBManager.cleanUpUserDefaults()
//            let vc = StoryboardScene.Main.instantiateLoginController()
//            let navVC  = UINavigationController.init(rootViewController:  vc )
//            navVC.navigationBar.isHidden = true
//            navVC.interactivePopGestureRecognizer?.isEnabled = false
//            AppDelegate.sharedDelegate().window?.rootViewController = navVC
        }
   
    }
    
    func adminBlocked(msg : String?){
        
        
    }
    
    func accountNotVerifiedHandler(msg : String?){
//        if let objLoginVc = UIApplication.topViewController() as? LoginVC{
//
//             let alert = UIAlertController(title: Keys.ErrorTitle.rawValue, message: "Your account is not verified yet.", preferredStyle: .actionSheet)
//
//            alert.addAction(UIAlertAction(title: "Resend Link", style: .default , handler:{ (UIAlertAction)in
//                if let emailToSend = objLoginVc.textFieldEmail.text{
//                    print(emailToSend)
//                    self.callResendVerificationLinkAPi(email: emailToSend)
//                }
//            }))
//
//
//            alert.addAction(UIAlertAction(title: "ok", style: .destructive , handler:{ (UIAlertAction)in
//
//            }))
//
//            alert.view.tintColor = UIColor.AppColorGreen
//
//            objLoginVc.present(alert, animated: true, completion: {
//                print("completion block")
//            })
//        }
        
    }
    
    func accountActivationHandler(msg : String?){
//        if let objLoginVc = UIApplication.topViewController() as? LoginVC{
//
//            let alert = UIAlertController(title: Keys.ErrorTitle.rawValue, message: /msg, preferredStyle: .actionSheet)
//
//            alert.addAction(UIAlertAction(title: "Activate", style: .default , handler:{ (UIAlertAction)in
//
//                objLoginVc.callSignInAPI(activation: true)
//
//            }))
//
//
//            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive , handler:{ (UIAlertAction)in
//
//            }))
//
//            alert.view.tintColor = UIColor.AppColorGreen
//
//            objLoginVc.present(alert, animated: true, completion: {
//                print("completion block")
//            })
//        }
        
    }
    
    
    func emailRequiredForFbHandler(msg : String?,paramsDict:OptionalDictionary){
       // showEmailAlert(paramsDict)
    }
    
    //MARK:- HelperMethods -
    
    func showEmailAlert(_ paramsDict:OptionalDictionary)
    {
//        DispatchQueue.main.async {
//            if self.alertEmail == nil
//            {
//                self.alertEmail = StoryboardScene.Alert.instantiateEmailAlertController()
//                self.alertEmail?.cancelCompletion = {
//                    self.alertEmail?.view.removeFromSuperview()
//                    self.alertEmail = nil
//                }
//                self.alertEmail?.doneCompletion = { email in
//                    self.alertEmail?.view.removeFromSuperview()
//                    self.alertEmail = nil
//                    if var params =  paramsDict{
//                        params.updateValue(email, forKey: Keys.email.rawValue)
//
//                        if let email = email as? String ,let name = params["full_name"] as? String,let pic = params["profile_pic"] as? String,let cover = params["cover_pic"] as? String, let id = params["social_id"] as? String
//                        {
//                            APIManager.shared.request(with: LoginEndpoint.fbRegistration(email:email, is_email: false , full_name:name , cover_pic:cover , social_id:id  , profile_pic:pic , device_id: UIDevice.idForVendor()!, device_notification_token: CommonMethodsClass.getDeviceToken(), device_type:  Keys.deviceTypeIOS.rawValue, activate_account: false)) {[weak self] (response) in
//                                self?.handleFacebookSignUpResponse(response: response)
//                            }
//
//                        }
//                    }
//                }
//                AppDelegate.sharedDelegate().window?.addSubview((self.alertEmail?.view)!)
//            }
//        }
    }
    
    func handleFacebookSignUpResponse(response : Response)
    {
        switch response{
            
        case .success(_):

           break


        case .failure(let msg):

            CommonMethodsClass.showAlertWithSingleButton(title: Keys.ErrorTitle.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)

        case .Warning(let msg):

            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    
    func isLoaderNeeded(api : Router) -> Bool{
        
        switch api.route {

            
        default: return true
        }
    }
    
    
    func callResendVerificationLinkAPi(email : String)
    {
//        APIManager.shared.request(with: LoginEndpoint.resendVerificationLink(email: email)) { [weak self](response) in
//
//            self?.handleResendVerificationLinkResponse(response: response)
//
//        }
    }
    
    func handleResendVerificationLinkResponse(response : Response)
    {
//        switch response{
//            
//        case .success(let responseValue):
//            
//            if let dict = responseValue as? NSDictionary
//            {
//                if let msg = dict.object(forKey: Keys.message.rawValue) as? String
//                {
//                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
//                   
//                }
//            }
//            
//        case .failure(let msg):
//            
//            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
//            
//        case .Warning(let msg):
//            
//            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
//        }
    }
    
    
}
