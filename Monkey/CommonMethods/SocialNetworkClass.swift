//
//  SocialNetworkClass.swift
//  TrophyCaseApp
//
//  Created by Khushboo on 7/26/17.
//  Copyright © 2017 Khushboo. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


typealias SuccessBlock = (_ success: AnyObject? ) -> ()

class SocialNetworkClass :NSObject
{
    var responseBack : SuccessBlock?
    static let sharedInstance = SocialNetworkClass()
    
    //MARK: - Facebook
    
    func facebookLogin(vC:UIViewController ,responseBlock : @escaping SuccessBlock) {
        
        responseBack = responseBlock
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"],from: vC, handler: {[weak self] (result, error) -> Void in
            if (error == nil)
            {
                
                if UIApplication.shared.canOpenURL(URL(string: "fb://")!) {
                    fbLoginManager.loginBehavior = .native
                }
                else {
                    fbLoginManager.loginBehavior = .web
                }
                if let fbloginresult : FBSDKLoginManagerLoginResult = result{
                    
                    if(fbloginresult.isCancelled) {
                        self?.responseBack?("cancel" as AnyObject)
                    }
                    else 
                    {
                        self?.handleFbResult()

                    }
                }
            }
            else{
                
                self?.responseBack?(error?.localizedDescription as AnyObject)
            }
        })
        
    }
    
    func handleFbResult()  {
        
        
        if (FBSDKAccessToken.current() != nil){
            FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "id,name,email,picture.width(300).height(300),cover"]).start(completionHandler: {[weak self] (connection, result, error) in
            
             
                
                self?.responseBack?(result as AnyObject?)
                
            })
        }else{
            
            responseBack?(nil)
        }
        
    }

    
}
