//
//  ChangePwd_VC.swift
//  Monkey
//
//  Created by Apple on 19/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class CreatePwd_VC: UIViewController {

    @IBOutlet weak var txtField_newPwd: UITextField!
    @IBOutlet weak var txtField_confirmPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_newPwd.layer.borderColor = UIColor.lightGray.cgColor
        txtField_confirmPwd.layer.borderColor = UIColor.lightGray.cgColor
        let button = txtField_newPwd.addRightIcons(#imageLiteral(resourceName: "show-password"), selectedImage:#imageLiteral(resourceName: "unselect-password"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 22, height: 16), imageSize: CGSize.init(width: 22, height: 16))
        button.tag = 0
        button.addTarget(self, action: #selector(self.btnAction_togglePwd), for: .touchUpInside)
        
        let button1 = txtField_confirmPwd.addRightIcons(#imageLiteral(resourceName: "show-password"), selectedImage:#imageLiteral(resourceName: "unselect-password"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 22, height: 16), imageSize: CGSize.init(width: 22, height: 16))
        button1.tag = 1
        button1.addTarget(self, action: #selector(self.btnAction_togglePwd), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:-Button Action Methods
    @objc func btnAction_togglePwd(_ sender: UIButton){
        if(sender.isSelected == false) {
            if sender.tag == 0{
                txtField_newPwd.isSecureTextEntry = false
            }
            else  {
                txtField_confirmPwd.isSecureTextEntry = false
            }
            sender.isSelected = true
        } else {
            if sender.tag == 0{
                txtField_newPwd.isSecureTextEntry = true
            }
            else  {
                txtField_confirmPwd.isSecureTextEntry = true
            }
            sender.isSelected = false
        }
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_createPwd(_ sender: UIButton) {
       
        
        let value =   Validation.shared.validate(createPassword: txtField_newPwd.text)
        switch value {
        case .success:
            
             let value1 =   Validation.shared.validate(createPassword: txtField_confirmPwd.text)
             switch value1 {
             case .success:
                if txtField_confirmPwd.text == txtField_newPwd.text{
                    var customerId = 0
                    
                    if let id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
                        customerId = id
                    }else{
                        customerId = AppDelegate.sharedDelegate().customerId
                    }
                    APIManager.shared.request(with: LoginEndpoint.forgetPwd(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: customerId, New_Password: txtField_newPwd.text)) { (response) in
                        self.handleforgetPwdResponse(response:response)
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
    }
    
    //MARK:- handle response
    func handleforgetPwdResponse(response:Response){
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
