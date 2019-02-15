//
//  VerifyOTPVC.swift
//  Monkey
//
//  Created by apple on 26/11/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class VerifyOTPVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var txtOTP4: UITextField!
    @IBOutlet weak var txtOTP3: UITextField!
    @IBOutlet weak var txtOTP2: UITextField!
    @IBOutlet weak var txtOTP1: UITextField!
    
    var mobileNumber: String?
    var fromMobileNmbr = true
    var emailOTP = ""
    var fromSignUp = false
    var email = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if fromMobileNmbr == false{
            lbl_desc.text = "OTP has been sent to you on your email. Please enter it below."
        }
        txtOTP1.backgroundColor = UIColor.clear
        txtOTP2.backgroundColor = UIColor.clear
        txtOTP3.backgroundColor = UIColor.clear
        txtOTP4.backgroundColor = UIColor.clear
        
        addBottomBorderTo(textField: txtOTP1)
        addBottomBorderTo(textField: txtOTP2)
        addBottomBorderTo(textField: txtOTP3)
        addBottomBorderTo(textField: txtOTP4)
        
        txtOTP1.delegate = self
        txtOTP2.delegate = self
        txtOTP3.delegate = self
        txtOTP4.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.txtOTP1.becomeFirstResponder()
    }
    
    func addBottomBorderTo(textField:UITextField) {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0.0, y: textField.frame.size.height - 2.0, width: textField.frame.size.width, height: 2.0)
        textField.layer.addSublayer(layer)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            if textField == txtOTP1 {
                txtOTP2.becomeFirstResponder()
            }
            
            if textField == txtOTP2 {
                txtOTP3.becomeFirstResponder()
            }
            
            if textField == txtOTP3 {
                txtOTP4.becomeFirstResponder()
            }
            
            if textField == txtOTP4 {
                txtOTP4.resignFirstResponder()
            }
            
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == txtOTP2 {
                txtOTP1.becomeFirstResponder()
            }
            if textField == txtOTP3 {
                txtOTP2.becomeFirstResponder()
            }
            if textField == txtOTP4 {
                txtOTP3.becomeFirstResponder()
            }
            if textField == txtOTP1 {
                txtOTP1.resignFirstResponder()
            }
            
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAction_submit(_ sender: UIButton) {
        view.endEditing(true)
        let value = Validate()
        switch value {
        case .success:
            if fromMobileNmbr == true{
                callVerifyOtpApi()
            }else{
                let otp = txtOTP1.text! + txtOTP2.text! + txtOTP3.text! + txtOTP4.text!
                if AppDelegate.sharedDelegate().emailOTP == otp{
                    AppDelegate.sharedDelegate().emailOTP = ""
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePwd_VC") as! CreatePwd_VC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg:"Please enter valid OTP", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                }
            }
            
            
        case .failure(_, let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
    }
    
    //MARK- verify otp
    
    func callVerifyOtpApi(){
        if let request_id = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.request_id.rawValue) as? String{
            APIManager.shared.request(with: LoginEndpoint.verifyOtp(TokenKey: CommonMethodsClass.getDeviceToken(),OTP:txtOTP1.text! + txtOTP2.text! + txtOTP3.text! + txtOTP4.text!, Request_Id:request_id)){[weak self] (response) in
                self?.handleVerifyOtpApiResponse(response: response)
            }
        }
    }
    
    func handleVerifyOtpApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? OTPModal
            {
                if dict.Code == "200"{
                    if fromSignUp == false{
                        if let request_id = dict.Result?.request_id{
                            DBManager.setValueInUserDefaults(value: request_id, forKey: ParamKeys.request_id.rawValue)
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePwd_VC") as! CreatePwd_VC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        var vc : SIgnup_VC?
                        if let controllers =  self.navigationController?.viewControllers{
                            for vc1 in controllers{
                                if let c = vc1 as? SIgnup_VC{
                                    vc = c
                                    break
                                }
                            }
                        }
                        
                        if vc != nil{
                            vc?.mobileNumberVerify = true
                            self.navigationController?.popToViewController(vc!, animated: true)
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
    
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(verifyOtp: txtOTP1.text! + txtOTP2.text! + txtOTP3.text! + txtOTP4.text!)
        return value
    }
    
    @IBAction func btnAction_resendOTP(_ sender: UIButton) {
        view.endEditing(true)
        let value = ValidateSendOtp()
        switch value {
        case .success:
            if fromMobileNmbr == true{
                callSendOtpApi()
            }
            else{
                callSendOtpApiEmail()
            }
            
        case .failure(_, let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
    }
    
    func ValidateSendOtp() -> Valid{
        var value : Valid = Validation.shared.validate(sendOtp: self.mobileNumber?.removeWhiteSpaces())
        if fromMobileNmbr == false{
            value  = Validation.shared.validate(forgotPassword: self.email)
        }
        return value
    }
    
    func callSendOtpApi(){
        APIManager.shared.request(with: LoginEndpoint.sendOtp(TokenKey: CommonMethodsClass.getDeviceToken(), Mobile_number: self.mobileNumber?.removeWhiteSpaces())){[weak self] (response) in
            self?.handleSendOtpApiResponse(response: response)
        }
    }
    
    func handleSendOtpApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? OTPModal
            {
                if dict.Code == "200"{
                    if let request_id = dict.Result?.request_id{
                        DBManager.setValueInUserDefaults(value: request_id, forKey: ParamKeys.request_id.rawValue)
                    }
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    
    func callSendOtpApiEmail(){
        APIManager.shared.request(with: LoginEndpoint.sendOTPToEmail(TokenKey: CommonMethodsClass.getDeviceToken(), Email: email.removeWhiteSpaces())){[weak self] (response) in
            self?.handleSendOtpEmailApiResponse(response: response)
        }
    }
    
    func handleSendOtpEmailApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? OTPModal
            {
                if dict.Code == "200"{
                    if let emailOTP = dict.emailOTP{
                        AppDelegate.sharedDelegate().emailOTP = "\(emailOTP)"
                    }
                    if let msg = dict.Message{
                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                    }
                    
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
}


