//
//  LoginVC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import SwiftyJSON
import LocalAuthentication
import GoogleSignIn

class LoginVC: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {
    
    @IBOutlet weak var txtField_email: UITextField!
    @IBOutlet weak var txtField_passowrd: UITextField!
    
    @IBOutlet weak var btn_thumb: UIButton!
    
    @IBOutlet weak var btn_facial: UIButton!
    
    var fbDict = [String:String]()
    var iconClick : Bool = false
    var fromPwd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if fromPwd == true{
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.hidesBackButton = true
        }
        setupUI()
    }
    
    func setupUI(){
        iconClick = true
        txtField_passowrd.layer.borderColor = UIColor.lightGray.cgColor
        txtField_email.layer.borderColor = UIColor.lightGray.cgColor
        let button = txtField_passowrd.addRightIcons(#imageLiteral(resourceName: "show-password"), selectedImage:#imageLiteral(resourceName: "unselect-password"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 22, height: 16), imageSize: CGSize.init(width: 22, height: 16))
        button.addTarget(self, action: #selector(self.btnAction_togglePwd), for: .touchUpInside)
        DispatchQueue.main.async {
            self.btn_thumb.addBorderTop(size: 0.5, color: UIColor.lightGray)
            self.btn_thumb.addBorderBottom(size: 0.5, color: UIColor.lightGray)
            self.btn_facial.addBorderBottom(size: 0.5, color: UIColor.lightGray)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(signIn: txtField_email.text, password: txtField_passowrd.text)
        return value
    }
    
    //MARK:-Button Action Methods
    @objc func btnAction_togglePwd(_ sender: UIButton){
        if(iconClick == true) {
            txtField_passowrd.isSecureTextEntry = false
            sender.isSelected = true
            iconClick = false
        } else {
            txtField_passowrd.isSecureTextEntry = true
            iconClick = true
            sender.isSelected = false
        }
    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        view.endEditing(true)
        let value = Validate()
        switch value {
        case .success:
            if let s = Int(txtField_email.text!)
            {
                if s == 0{
                     CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Enter valid mobile number", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                }else{
                    self.callLoginApi()
                }
                
            }
            else{
                if !(/txtField_email.text).isEmail{
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Enter valid email", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                }else{
                    self.callLoginApi()
                }
            }
            
        case .failure(_, let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            
        }
        
    }

    @IBAction func btnAction_thumb(_ sender: UIButton) {
        self.authenticate("TouchID") { (success) in
            print(success)
        }
    }
    
    @IBAction func btnAction_facial(_ sender: UIButton) {
        self.authenticate("FaceID") { (success) in
            print(success)
        }
    }
    
    @IBAction func btnAction_signup(_ sender: UIButton) {
        let vc = StoryboardScene.Main.instantiateSIgnupController()
        var isInStack : Bool = false
        if let controllers = self.navigationController?.viewControllers{
            for aViewController in controllers {
                if aViewController.isKind(of: SIgnup_VC.self) {
                    isInStack = true
                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
            if isInStack == false{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_FBLogin(_ sender: UIButton) {
        SocialNetworkClass.sharedInstance.facebookLogin(vC:self){[weak self] result in
            
            if let dict = result as? Dictionary<String, AnyObject>{
                
                let response = JSON(dict)
                
                print(response)
                
                if  let id = dict["id"] as? String ,  let name = dict["name"] as? String
                {
                    let imageStr = response["picture"]["data"]["url"].stringValue
                    let coverImg = response["cover"]["source"].stringValue
                    var firstName = ""
                    var lastName : String?
                    var Email : String?
                    if let first_name = dict["first_name"] as? String{
                        firstName = first_name
                    }
                    
                    if let last_name = dict["last_name"] as? String{
                        lastName = last_name
                    }
                    
                    if let email = dict["email"] as? String
                    {
                        Email = email
                        self?.fbDict = ["email" : email  ?? "", "fullname" : name , "social_id" : id , "profile_pic" : imageStr ,"cover_pic" :  coverImg,"first_name":firstName,"last_name":lastName ?? ""]
                    }
                    else
                    {
                        self?.fbDict = ["email" : "" , "fullname" : name , "social_id" : id , "profile_pic" : imageStr ,"cover_pic" :  coverImg,"first_name":firstName,"last_name":lastName ?? ""]
                    }
                    
                    //                    self?.callFacebookRegistrationAPI()
//                    APIManager.shared.request(with: LoginEndpoint.signup(TokenKey:CommonMethodsClass.getDeviceToken(), First_Name: firstName, Middle_Intial: nil, Sur_Name: lastName, Gender: nil, Email: nil, Mobile: nil, DOB: nil, Password: nil,ProfilePic: CommonMethodsClass.convertImageToBase64(image:UIImage(urlString:imageStr)!) , CallingChannel: ApiParmConstant.CallingChannel.rawValue,LoginType:"Facebook",GoogleorFbId:id))
//                    { (response) in
//                        self?.handleSignUpResponse(response : response)
//                    }
                    
                    APIManager.shared.request(with: LoginEndpoint.login(TokenKey: CommonMethodsClass.getDeviceToken(), Email: Email, Password: nil, CallingChannel: ApiParmConstant.CallingChannel.rawValue, LoginType: "Facebook", GoogleorFbId: id, First_Name: name, Sur_Name: lastName, Gender: nil))
                    { (response) in
                        self?.handleLoginApiResponse(response : response)
                    }
                }
                
            }else
            {
                if let str = result as? String
                {
                    if str == "email"
                    {
                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Please verify your email address on Facebook or make it public", vc: self!, isDelegateRequired: false, imgName: Images.error.rawValue)
                    }
                    else if str == "cancel"
                    {
                        CommonMethodsClass.showAlertWithSingleButton(title:  Keys.Error.rawValue, msg: "You have cancelled the process.", vc: self!, isDelegateRequired: false, imgName: Images.error.rawValue)
                    }
                }
                else
                {
                    CommonMethodsClass.showAlertWithSingleButton(title:  Keys.Error.rawValue , msg: "Some error occured.please try again.", vc: self!, isDelegateRequired: false, imgName: Images.error.rawValue)
                }
            }
        }
    }
    
    func handleSignUpResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let _ = dict.object(forKey: Keys.message.rawValue) as? String
                {
                    // AppDelegate.sharedDelegate().tempPwd = self.txtField_pwd.text!
                    let message = "Thanks for signing up with Food Monkey. Please sign in to continue ordering."
                    
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /message , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    @IBAction func click_GoogleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK:- Google SignIn Delegate
    // Present a view that prompts the user to sign in with Google
    
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Google Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            var profileImage : URL?
            if user.profile.hasImage{
                profileImage = user.profile.imageURL(withDimension: 50)
            }
//            APIManager.shared.request(with: LoginEndpoint.signup(TokenKey:CommonMethodsClass.getDeviceToken(), First_Name: givenName, Middle_Intial: nil, Sur_Name: familyName, Gender: nil, Email: nil, Mobile: nil, DOB: nil, Password: nil,ProfilePic: (user.profile.hasImage ? CommonMethodsClass.convertImageToBase64(image:UIImage(urlString:(profileImage?.absoluteString)!)!) : nil) , CallingChannel: ApiParmConstant.CallingChannel.rawValue,LoginType:"Google",GoogleorFbId:idToken))
//            { (response) in
//                self.handleSignUpResponse(response : response)
//            }
//
            APIManager.shared.request(with: LoginEndpoint.login(TokenKey: CommonMethodsClass.getDeviceToken(), Email: email, Password: nil, CallingChannel: ApiParmConstant.CallingChannel.rawValue, LoginType: "Google", GoogleorFbId: userId, First_Name: givenName, Sur_Name: familyName, Gender: nil))
            { (response) in
                self.handleLoginApiResponse(response : response)
            }
            
            
            // ...
        } else {
            print("\(error)")
            CommonMethodsClass.showAlertWithSingleButton(title:  Keys.Error.rawValue, msg: (error?.localizedDescription)!, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
    }
    
    //MARK:- Call Login API
    
    func callAddToken()
    {
        APIManager.shared.request(with: LoginEndpoint.addToken(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_Type: ApiParmConstant.Customer_Type.rawValue, CallingChannel: ApiParmConstant.CallingChannel.rawValue)){[weak self] (response) in
            // self?.handleAddTokenResponse(response: response)
        }
    }
    
    func handleAddTokenResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let msg = dict.object(forKey: Keys.message.rawValue) as? String
                {
                    // AppDelegate.sharedDelegate().tempPwd = self.txtField_pwd.text!
                    
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                    
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    func callLoginApi()
    {
        let formatter = DateFormatter.init()
        formatter.dateFormat  = "yyyy-MM-dd"
        APIManager.shared.request(with: LoginEndpoint.login(TokenKey: CommonMethodsClass.getDeviceToken(), Email: txtField_email.text, Password: txtField_passowrd.text, CallingChannel: ApiParmConstant.CallingChannel.rawValue, LoginType: "Direct", GoogleorFbId: nil, First_Name: nil, Sur_Name: nil, Gender: nil), completion: { (response) in
            self.handleLoginApiResponse(response : response)
        })
    }
    
    func handleLoginApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? LoginModal
            {
                if dict.Code == "200"{
                    // AppDelegate.sharedDelegate().tempPwd = self.txtField_pwd.text!
                  //  callAddToken()
                    
                    DBManager.setValueInUserDefaults(value: self.txtField_passowrd.text ?? "", forKey: ParamKeys.password.rawValue)
                    self.txtField_email.text = ""
                    self.txtField_passowrd.text = ""
                    if let customerDetails = dict.Customer_details{
                        if (customerDetails.count) > 0{
                            if let id = customerDetails[0].Customer_id{
                                DBManager.setValueInUserDefaults(value: id, forKey: ParamKeys.Customer_id.rawValue)
                            }
                        }
                    }
                    
                    if let details = dict.Customer_details{
                        if details.count > 0{
                            if let Stripe_Customer_Id = details[0].Stripe_Customer_Id{
                                DBManager.setValueInUserDefaults(value: Stripe_Customer_Id, forKey: ParamKeys.Stripe_Customer_Id.rawValue)
                            }
                            if let Refer_Code = details[0].Refer_Code{
                                DBManager.setValueInUserDefaults(value: Refer_Code, forKey: ParamKeys.Refer_Code.rawValue)
                            }
                            
                            if let profilePic = details[0].Image_Link{
                                DBManager.setValueInUserDefaults(value: profilePic, forKey: ParamKeys.profilePicURL.rawValue)
                            }
                            if let email = details[0].Email{
                                DBManager.setValueInUserDefaults(value: email, forKey: ParamKeys.email.rawValue)
                            }
                            if let firstName = details[0].First_Name, let middleName = details[0].Middle_Intial, let surName = details[0].Sur_Name{
                                let fullName = "\(firstName) \(middleName) \(surName)"
                                DBManager.setValueInUserDefaults(value: firstName, forKey: ParamKeys.firstName.rawValue)
                                DBManager.setValueInUserDefaults(value: surName, forKey: ParamKeys.lastName.rawValue)
                                DBManager.setValueInUserDefaults(value: fullName, forKey: ParamKeys.fullName.rawValue)
                            }
                        }
                    }

                    if (DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.cartAdded.rawValue) as? Bool) == true{
                        if let vc1 = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? CheckOut_VC{
                            let vc = StoryboardScene.Main.instantiateCheckOutAddress_VC()
                            vc.addOnList = vc1.addOnList
                            vc.selectedDeliveryOption = vc1.selectedOption
                            vc.restaurantModel = vc1.restaurantModel
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        let message = "You are successfully signed in. Continue ordering."
                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /message , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                        var homeVC : HomeVC?
                        if let controlers = self.navigationController?.viewControllers{
                            for vc1 in controlers{
                                if let c = vc1 as? HomeVC
                                {
                                    homeVC = c
                                    break
                                }
                            }
                        }
                        if homeVC != nil{
                            self.navigationController?.popToViewController(homeVC!, animated: true)
                        }else{
                            let vc = StoryboardScene.Main.instantiateHome_ViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    //MARK:- Local Authentication
    func authenticate(_ id:String,completion: @escaping ((Bool) -> ())){
        
        //Create a context
        let authenticationContext = LAContext()
        var error:NSError?

        //Check if device have Biometric sensor
        let isValidSensor : Bool = authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if #available(iOS 11.0, *) {
            switch authenticationContext.biometryType{
            case .faceID:
                if id != "FaceID"{
                    self.showAlertWithTitle(title: "Error", message: "\(id) Not Available")
                    return
                }
            case .touchID:
                if id != "TouchID"{
                    self.showAlertWithTitle(title: "Error", message: "\(id) Not Available")
                    return
                }
            }
        }else {
            // Fallback on earlier versions
        }
        if isValidSensor {
            //Device have BiometricSensor
            //It Supports TouchID
            
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "\(id) authentication",
                reply: { [unowned self] (success, error) -> Void in
                    
                    if(success) {
                        // Touch / Face ID recognized success here
                        completion(true)
                    } else {
                        //If not recognized then
                        if let error = error {
                            let strMessage = self.errorMessage(id,errorCode: error._code)
                            if strMessage != ""{
                                self.showAlertWithTitle(title: "Error", message: strMessage)
                            }
                        }
                        completion(false)
                    }
            })
        } else {
            let strMessage = self.errorMessage(id,errorCode: (error?._code)!)
            if strMessage != ""{
                self.showAlertWithTitle(title: "Error", message: strMessage)
            }
        }
    }
    
    //MARK: TouchID error
    
    func errorMessage(_ id:String,errorCode:Int) -> String{
        
        var strMessage = ""
        
        switch errorCode {
            
        case LAError.Code.authenticationFailed.rawValue:
            strMessage = "Authentication Failed"
            
        case LAError.Code.userCancel.rawValue:
            strMessage = "User Cancelled"
            
        case LAError.Code.userFallback.rawValue:
            strMessage = "User Fallback"
            
        case LAError.Code.systemCancel.rawValue:
            strMessage = "System Cancel"
            
        case LAError.Code.passcodeNotSet.rawValue:
            strMessage = "Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.touchIDNotAvailable.rawValue:
            strMessage = "\(id) Not Available"
            
        case LAError.Code.touchIDNotEnrolled.rawValue:
            strMessage = "\(id) Not Enrolled"
            
        case LAError.Code.touchIDLockout.rawValue:
            strMessage = "\(id) Lockout Please goto the Settings & Turn On Passcode"
            
        case LAError.Code.appCancel.rawValue:
            strMessage = "App Cancel"
            
        case LAError.Code.invalidContext.rawValue:
            strMessage = "Invalid Context"
            
        default:
            strMessage = ""
            
        }
        return strMessage
    }
    
    //MARK: Show Alert
    
    func showAlertWithTitle( title:String, message:String ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOk)
        self.present(alert, animated: true, completion: nil)
    }
 
}
