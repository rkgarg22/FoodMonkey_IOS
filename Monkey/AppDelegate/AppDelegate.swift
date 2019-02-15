//
//  AppDelegate.swift
//  Social Galaxy
//
//  Created by Priya on 20/03/18.
//  Copyright © 2018 Priya. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import UserNotifications
import GoogleSignIn
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Stripe
import Firebase
import Braintree
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,GIDSignInDelegate, MessagingDelegate{
    
    var preOrder = false
    var userLocation : CLLocation?
    var fromNotification = false
    var orderId :Int?
    var window: UIWindow?
    
    var emailOTP = ""
    var customerId = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BTAppSwitch.setReturnURLScheme("com.app.foodMonkey.payments")
        GMSServices.provideAPIKey("AIzaSyB7q4LFcHAwd0HPcB_Bhgh48AVTnWoyY5I")
        GMSPlacesClient.provideAPIKey("AIzaSyB7q4LFcHAwd0HPcB_Bhgh48AVTnWoyY5I")
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        // Initialize sign-in
        //   GIDSignIn.sharedInstance().clientID = "125009307036-t0nhunua6g6ipoicshu6720eceej2232.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().clientID = "720920604609-q7bkvjb2ooei47fn4b2dsjce4hlrdm9o.apps.googleusercontent.com"
        
        GIDSignIn.sharedInstance().delegate = self
        IQKeyboardManager.shared.enable = true
        Stripe.setDefaultPublishableKey("pk_test_6Y79q9xXnWtKnV0JQJa087Yl")
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        requestNotificationAuthorization(application: application)
        return true
    }
    
    func requestNotificationAuthorization(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    static func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        print(url)
        let sourceApplication =  options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
        
        let googleHandler = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application (
            app,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        if url.scheme?.localizedCaseInsensitiveCompare("com.app.foodMonkey.payments") == .orderedSame {
             return googleHandler || facebookHandler || BTAppSwitch.handleOpen(url, options: options)
        }
        else
        {
            return googleHandler || facebookHandler
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void)
    {
        var userInfo = NSDictionary()
        
        userInfo = notification.request.content.userInfo as NSDictionary
        if let aps = userInfo["aps"] as? NSDictionary{
            if let alert = aps["alert"] as? NSDictionary{
                if let body = alert["body"] as? String{
                    fromNotification = true
                }
                
                if let title = alert["title"] as? String{
                    let s = title.components(separatedBy:":")
                    if s.count > 1{
                        let t = s[1]
                        orderId = Int(t) ?? 0
                    }
                }
            }
        }
        print(userInfo)
        completionHandler(.alert)
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        var userInfo = NSDictionary()
        userInfo = response.notification.request.content.userInfo as NSDictionary
        print(userInfo)
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        let dict:NSDictionary = (userInfo) as NSDictionary
        print(dict)
        
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let dict:NSDictionary = (userInfo as AnyObject) as! NSDictionary
        print(dict)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //   NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
       
        DBManager.setValueInUserDefaults(value: fcmToken , forKey: Keys.deviceNotificationToken.rawValue)
        if let token = DBManager.accessUserDefaultsForKey(keyStr: Keys.token.rawValue) as? Bool
        {
            if token == false
            {
                 callAddToken()
            }
        }
        else{
             callAddToken()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        if let token = Messaging.messaging().fcmToken {
             DBManager.setValueInUserDefaults(value: token , forKey: Keys.deviceNotificationToken.rawValue)
            if let token1 = DBManager.accessUserDefaultsForKey(keyStr: Keys.token.rawValue) as? Bool
            {
                if token1 == false
                {
                    callAddToken()
                }
            }
            else{
                callAddToken()
            }
        }
        
//        var token = ""
//        for i in 0..<deviceToken.count {
//            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
//        }
//        Messaging.messaging().apnsToken = deviceToken
//        DBManager.setValueInUserDefaults(value: token , forKey: Keys.deviceNotificationToken.rawValue)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error)
    }
    
    
    //MARK:- Call add token API -
    func callAddToken()
    {
        APIManager.shared.request(with: LoginEndpoint.addToken(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_Type: ApiParmConstant.Customer_Type.rawValue, CallingChannel: ApiParmConstant.CallingChannel.rawValue)){[weak self] (response) in
             self?.handleAddTokenResponse(response: response)
        }
    }
    
    func handleAddTokenResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let code = dict.object(forKey: Keys.statusCode.rawValue) as? String
                {
                    if code == "200"
                    {
                        DBManager.setValueInUserDefaults(value: true , forKey: Keys.token.rawValue)
                    }
                    // AppDelegate.sharedDelegate().tempPwd = self.txtField_pwd.text!
                    
                   // CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                    
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
}

