//
//  SIgnup_VC.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleSignIn

class SIgnup_VC: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate {
    
    @IBOutlet var btnGender : [UIButton]!
    @IBOutlet weak var imgVw_profilPic: UIImageView!
    @IBOutlet weak var txtField_firstNAme: UITextField!
    @IBOutlet weak var txtField_middleName: UITextField!
    @IBOutlet weak var txtField_surName: UITextField!
    @IBOutlet weak var txtField_password: UITextField!
    @IBOutlet weak var txtField_email: UITextField!
    @IBOutlet weak var txtField_mobile: UITextField!
    @IBOutlet weak var txtField_dob: UITextField!
    @IBOutlet weak var btn_Terms: UIButton!
    
    @IBOutlet weak var vw_dob: UIView!
    @IBOutlet weak var btn_year: UIButton!
    @IBOutlet weak var btn_date: UIButton!
    @IBOutlet weak var btn_month: UIButton!
    
    var fbDict = [String:String]()
    var iconClick : Bool = false
    var selectedImage : UIImage?
    var imgSelected = false
    let datePicker = UIDatePicker()
    var selectedGender = ""
    var termsAgreed = false
    var mobileNumberVerify = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        iconClick = true
        txtField_firstNAme.layer.borderColor = UIColor.lightGray.cgColor
        txtField_middleName.layer.borderColor = UIColor.lightGray.cgColor
        txtField_surName.layer.borderColor = UIColor.lightGray.cgColor
        txtField_password.layer.borderColor = UIColor.lightGray.cgColor
        txtField_email.layer.borderColor = UIColor.lightGray.cgColor
        txtField_mobile.layer.borderColor = UIColor.lightGray.cgColor
        
        vw_dob.layer.borderColor = UIColor.lightGray.cgColor
        
        let button = txtField_password.addRightIcons(#imageLiteral(resourceName: "show-password"), selectedImage:#imageLiteral(resourceName: "unselect-password"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 22, height: 16), imageSize: CGSize.init(width: 22, height: 16))
        button.addTarget(self, action: #selector(self.btnAction_togglePwd), for: .touchUpInside)
    
        showDatePicker()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imgVw_profilPic.layer.cornerRadius = imgVw_profilPic.frame.size.height/2
        imgVw_profilPic.layoutIfNeeded()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Button Action Methods
    @IBAction func btnAction_Gender(_ sender: UIButton) {
        for aButton in btnGender{
            aButton.isSelected = false
        }
        sender.isSelected = true
        
        selectedGender = sender.tag == 1 ? "MALE" : "FEMALE"
    }
    
    @IBAction func btnAction_terms(_ sender: UIButton) {
        sender.isSelected ? (sender.isSelected = false): (sender.isSelected = true)
        sender.isSelected ? (termsAgreed = true) : (termsAgreed = false)
    }
    @objc func btnAction_togglePwd(_ sender: UIButton){
        if(iconClick == true) {
            txtField_password.isSecureTextEntry = false
            sender.isSelected = true
            iconClick = false
        } else {
            txtField_password.isSecureTextEntry = true
            iconClick = true
            sender.isSelected = false
        }
    }
    @IBAction func btnAction_signup(_ sender: UIButton) {
        view.endEditing(true)
        let value = Validate()
        switch value {
        case .success:
            if mobileNumberVerify == false{
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Please verify your mobile number first", vc: self, isDelegateRequired: true, imgName: Images.error.rawValue)
            }else{
                 self.callSignUpApi()
            }
           
            
        case .failure(_, let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            
        }
    }

    //MARK: Validate
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(signUp: txtField_firstNAme.text,lastName: txtField_surName.text,gender: selectedGender,mobile: self.txtField_mobile.text,dob: txtField_dob.text, password: txtField_password.text,terms:termsAgreed)
        
        return value
    }
    
    @IBAction func btnAction_signin(_ sender: UIButton) {
        let vc = StoryboardScene.Main.instantiateLoginController()
        var isInStack : Bool = false
        if let controllers = self.navigationController?.viewControllers{
            for aViewController in controllers {
                if aViewController.isKind(of: LoginVC.self) {
                    isInStack = true
                    _ = self.navigationController?.popToViewController(aViewController, animated: true)
                }
            }
            if isInStack == false{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func btnAction_addImage(_ sender: UIButton) {
        Utility.shared.openCameraAndPhotos(isEditImage: true, cropStyle: .circurlar, getImage: { (image, info) in
            self.imgVw_profilPic.image = image
            self.selectedImage = image
            self.imgSelected = true
        }) { (error) in
            self.imgSelected = false
            //  CommonMethodsClass.showAlertViewOnWindow(titleStr: AppInfo.appName.rawValue, messageStr: /error, okBtnTitleStr: AppInfo.okButtonTitle.rawValue)
        }
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
                    var lastName = ""
                    if let first_name = dict["first_name"] as? String{
                        firstName = first_name
                    }
                    
                    if let last_name = dict["last_name"] as? String{
                        lastName = last_name
                    }
                    if firstName.isEmpty == true{
                        if name.isEmpty == false{
                            firstName = name
                        }
                    }
                    
                    
                    if let email = dict["email"] as? String
                    {
                        self?.fbDict = ["email" : email , "fullname" : name , "social_id" : id , "profile_pic" : imageStr ,"cover_pic" :  coverImg,"first_name":firstName,"last_name":lastName]
                    }
                    else
                    {
                        self?.fbDict = ["email" : "" , "fullname" : name , "social_id" : id , "profile_pic" : imageStr ,"cover_pic" :  coverImg,"first_name":firstName,"last_name":lastName]
                    }
                    
                    //                    self?.callFacebookRegistrationAPI()
                    APIManager.shared.request(with: LoginEndpoint.signup(TokenKey:CommonMethodsClass.getDeviceToken(), First_Name: firstName, Middle_Intial: nil, Sur_Name: lastName, Gender: nil, Email: nil, Mobile: nil, DOB: nil, Password: nil,ProfilePic: CommonMethodsClass.convertImageToBase64(image:UIImage(urlString:imageStr)!) , CallingChannel: ApiParmConstant.CallingChannel.rawValue,LoginType:"Facebook",GoogleorFbId:id))
                    { (response) in
                        self?.handleSignUpResponse(response : response)
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
    
    
    @IBAction func click_GoogleLogin(_ sender: UIButton) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    //MARK:Google SignIn Delegate
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
            // ...
            APIManager.shared.request(with: LoginEndpoint.signup(TokenKey:CommonMethodsClass.getDeviceToken(), First_Name: givenName, Middle_Intial: nil, Sur_Name: familyName, Gender: nil, Email: email, Mobile: nil, DOB: nil, Password: nil,ProfilePic: (user.profile.hasImage ? CommonMethodsClass.convertImageToBase64(image:UIImage(urlString:(profileImage?.absoluteString)!)!) : nil) , CallingChannel: ApiParmConstant.CallingChannel.rawValue,LoginType:"Google",GoogleorFbId:userId))
            { (response) in
                self.handleSignUpResponse(response : response)
            }
        } else {
            print("\(error)")
            CommonMethodsClass.showAlertWithSingleButton(title:  Keys.Error.rawValue, msg: (error?.localizedDescription)!, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
    }
    
    
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Call SignUp API
    func callSignUpApi()
    {
        let formatter = DateFormatter.init()
        formatter.dateFormat  = "yyyy-MM-dd"
        APIManager.shared.request(with: LoginEndpoint.signup(TokenKey:CommonMethodsClass.getDeviceToken(), First_Name: txtField_firstNAme.text?.removeWhiteSpaces(), Middle_Intial: txtField_middleName.text?.removeWhiteSpaces(), Sur_Name: txtField_surName.text?.removeWhiteSpaces(), Gender: selectedGender, Email: txtField_email.text, Mobile: txtField_mobile.text, DOB: formatter.string(from: datePicker.date), Password: txtField_password.text?.removeWhiteSpaces(),ProfilePic: (imgSelected ? CommonMethodsClass.convertImageToBase64(image: self.selectedImage!) : nil) , CallingChannel: ApiParmConstant.CallingChannel.rawValue,LoginType:"Direct", GoogleorFbId: nil))
        { (response) in
            self.handleSignUpResponse(response : response)
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
                    self.txtField_firstNAme.text = ""
                    self.txtField_middleName.text = ""
                    self.txtField_surName.text = ""
                    self.txtField_password.text = ""
                    self.txtField_email.text = ""
                    self.txtField_mobile.text = ""
                    self.txtField_dob.text = ""
                    self.selectedGender = ""
                    self.selectedImage = nil
                    self.termsAgreed = false
                    self.btnGender[0].isSelected = false
                    self.btnGender[1].isSelected = false
                    self.btn_Terms.isSelected = false
                    self.imgVw_profilPic.image = #imageLiteral(resourceName: "profile-icon")
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /message , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                    
                }
            }
            
        case .failure(let msg):
            self.mobileNumberVerify = false
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
             self.mobileNumberVerify = false
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }

    

    // MARK: - Date Picker

    func showDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let loc = Locale(identifier: "en_GB")
        self.datePicker.locale = loc
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton: UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donedatePicker(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton: UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.cancelDatePicker))
        
//        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.AppColorGreen], for: .normal)
//        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.AppColorGreen], for: .normal)
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        txtField_dob.inputAccessoryView = toolbar
        
        // add datepicker to textField
        txtField_dob.inputView = datePicker
    }
    
    @objc func donedatePicker(sender :UIDatePicker){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        txtField_dob.backgroundColor = .white
        txtField_dob.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
}

extension SIgnup_VC : UITextFieldDelegate,DelegateFromSingleAlert{
    
    func donePressed(obj: AlertVC) {
        CommonMethodsClass.okBtnForSingleAlertHandlerWithCompletionHandler { (success) in
            if self.txtField_mobile.text?.isEmpty == true{
                self.navigationController?.popViewController(animated: true)
            }else{
                let vc = StoryboardScene.Main.instantiateSendOTPController()
                vc.mobileNumber = self.txtField_mobile.text ?? ""
                vc.fromSignUp = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtField_mobile{
            if mobileNumberVerify == false{
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Please verify mobile number first", vc: self, isDelegateRequired: true, imgName: Images.error.rawValue)
            }
        }
    }
}
