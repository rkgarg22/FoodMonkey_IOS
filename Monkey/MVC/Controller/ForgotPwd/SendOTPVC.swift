//
//  SendOTPVC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class SendOTPVC: UIViewController {

    @IBOutlet weak var txtField_phone: UITextField!
    var fromSignUp = false
    var mobileNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_phone.layer.borderColor = UIColor.lightGray.cgColor
        if fromSignUp == true{
            txtField_phone.text = mobileNumber
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAction_sendOtp(_ sender: UIButton) {
        view.endEditing(true)
        let value = Validate()
        switch value {
        case .success:
            if fromSignUp == false{
                APIManager.shared.postRequest(with: LoginEndpoint.emailPhoneExits(TokenKey:  CommonMethodsClass.getDeviceToken(), EmailorMobile: txtField_phone.text ?? "")) { (response) in
                    self.handleEmailPhoneExitsResponse(response: response)
                }
            }else{
                 callSendOtpApi()
            }

        case .failure(_, let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
    }
    
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(sendOtp: txtField_phone.text?.removeWhiteSpaces())
        return value
    }
    
    //MARK:- handle api
    func handleEmailPhoneExitsResponse(response:Response){
        switch response{
        case .success(let responseValue):
            if let dic = responseValue as? NSDictionary{
                if let str = dic["Code"] as? String{
                    if str == "500"
                    {
                        if let msg = dic["Message"] as? String{
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg:msg , vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                        }
                        
                    }else{
                        if fromSignUp == false{
                            if let id = dic["Customer_id"] as? Int{
                                AppDelegate.sharedDelegate().customerId = id
                            }
                        }
                        callSendOtpApi()
                    }
                }
            }
            
           
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    func callSendOtpApi(){
        APIManager.shared.request(with: LoginEndpoint.sendOtp(TokenKey: CommonMethodsClass.getDeviceToken(), Mobile_number: self.txtField_phone.text?.removeWhiteSpaces())){[weak self] (response) in
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
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
                    vc.mobileNumber = self.txtField_phone.text
                    vc.fromSignUp = self.fromSignUp
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
