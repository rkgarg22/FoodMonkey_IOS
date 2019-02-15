//
//  ChangePwdVC.swift
//  Monkey
//
//  Created by Apple on 11/01/19.
//  Copyright © 2019 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class ChangePwdVC: UIViewController {

    @IBOutlet weak var txtField_confirm: CustomTextField!
    @IBOutlet weak var txtField_new: CustomTextField!
    @IBOutlet weak var txtField_old: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = txtField_confirm.addRightIcons(#imageLiteral(resourceName: "show-password"), selectedImage:#imageLiteral(resourceName: "unselect-password"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 22, height: 16), imageSize: CGSize.init(width: 22, height: 16))
        button.tag = 0
        button.addTarget(self, action: #selector(self.btnAction_togglePwd), for: .touchUpInside)
        
        let button1 = txtField_new.addRightIcons(#imageLiteral(resourceName: "show-password"), selectedImage:#imageLiteral(resourceName: "unselect-password"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 22, height: 16), imageSize: CGSize.init(width: 22, height: 16))
        button1.tag = 1
        button1.addTarget(self, action: #selector(self.btnAction_togglePwd), for: .touchUpInside)
        
        let button2 = txtField_old.addRightIcons(#imageLiteral(resourceName: "show-password"), selectedImage:#imageLiteral(resourceName: "unselect-password"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 22, height: 16), imageSize: CGSize.init(width: 22, height: 16))
        button2.tag = 2
        button2.addTarget(self, action: #selector(self.btnAction_togglePwd), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:-Button Action Methods
    @objc func btnAction_togglePwd(_ sender: UIButton){
        if(sender.isSelected == false) {
            if sender.tag == 0{
                  txtField_confirm.isSecureTextEntry = false
            }
            else  if sender.tag == 1{
                txtField_new.isSecureTextEntry = false
            }else  {
                txtField_old.isSecureTextEntry = false
            }
            sender.isSelected = true
        } else {
            if sender.tag == 0{
                txtField_confirm.isSecureTextEntry = true
            }
            else  if sender.tag == 1{
                txtField_new.isSecureTextEntry = true
            }else  {
                txtField_old.isSecureTextEntry = true
            }
            sender.isSelected = false
        }
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_changePwd(_ sender: UIButton) {
        if txtField_old.text?.isEmpty == false{
            var pwd = ""
            if let password = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.password.rawValue) as? String{
                pwd = password
            }
            if txtField_old.text == pwd{
                let value =   Validation.shared.validate(createPassword: txtField_new.text)
                switch value {
                case .success:
                    let value1 =   Validation.shared.validate(createPassword: txtField_confirm.text)
                    switch value1 {
                    case .success:
                        if txtField_confirm.text == txtField_new.text{
                            var customerId = 0
                            
                            if let id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
                                customerId = id
                            }else{
                                customerId = AppDelegate.sharedDelegate().customerId
                            }
                            APIManager.shared.request(with: LoginEndpoint.changePwd(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: customerId,Old_Password:txtField_old.text, New_Password: txtField_new.text)) { (response) in
                                 self.handleChangePwdResponse(response:response)
                            }
                        }else{
                            
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Password did not match", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                        }
                        
                    case .failure(_, let msg):
                        
                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                        
                    }
                    
                case .failure(_, let msg):
                    
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                    
                }
            }else{
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Please enter correct old password", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            }
        }else{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Please enter valid old password", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
        
    }
    
    //MARK:- handle response
    func handleChangePwdResponse(response:Response){
        switch response{
        case .success(let responseValue):
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChanged_VC") as! PasswordChanged_VC
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
