//
//  ReferFriend_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import FBSDKShareKit

class ReferFriend_VC: UIViewController {
    
    @IBOutlet weak var lbl_referCode: UILabel!
    @IBOutlet weak var lbl_desc: UILabel!
    @IBOutlet weak var txtField_mobile: UITextField!
    
    @IBOutlet weak var btn_fb: UIButton!
    @IBOutlet weak var btn_twitter: UIButton!
    @IBOutlet weak var btn_email: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_mobile.layer.borderColor = UIColor.lightGray.cgColor
        lbl_desc.text = SucessTitle.referFriend.rawValue
        DispatchQueue.main.async {
            self.btn_fb.addBorderBottom(size: 0.5, color: UIColor.lightGray)
            self.btn_twitter.addBorderBottom(size: 0.5, color: UIColor.lightGray)
            self.btn_email.addBorderBottom(size: 0.5, color: UIColor.lightGray)
        }
        
        if let code = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.Refer_Code.rawValue) as? String{
            lbl_referCode.text = code
        }else{
            lbl_referCode.text = ""
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clikck_fb(_ sender: UIButton) {
         if  lbl_referCode.text?.isEmpty == false{
             referOnFB()
        }
         else{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Please login first to proceed further", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
    }
    
    @IBAction func click_emailOrMore(_ sender: UIButton) {
        let url = URL(string: "https://food-monkey.com/refer_a_friend")
        
        // open in safari
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func click_twitter(_ sender: UIButton) {
        if  lbl_referCode.text?.isEmpty == false{
            let tweetText = lbl_referCode.text ?? ""
            let tweetUrl = "https://food-monkey.com/"
            
            let shareString = "https://twitter.com/intent/tweet?text= Refer code \(tweetText)&url=\(tweetUrl)"
            
            // encode a space to %20 for example
            let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            // cast to an url
            let url = URL(string: escapedShareString)
            
            // open in safari
            UIApplication.shared.openURL(url!)
        }else{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Please login first to proceed further", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
       
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_referFriend(_ sender: UIButton) {
        if txtField_mobile.text?.isEmpty == false && lbl_referCode.text?.isEmpty == false{
            var name = ""
            if let n = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.fullName.rawValue) as? String{
                name = n
            }
            APIManager.shared.request(with: LoginEndpoint.referFriendByMobile(TokenKey:  CommonMethodsClass.getDeviceToken(), Customer_Name: name, Refer_Code: lbl_referCode.text, Mobile_Number: Int(txtField_mobile.text ?? "0"))) { (response) in
                self.handleReferApiResponse(response: response)
            }
        }else{
            var msg = "Please put valid mobile number"
            if lbl_referCode.text?.isEmpty == true{
                msg = "Please login first to proceed further"
            }
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }
    }
    
    func handleReferApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let msg = dict.object(forKey: Keys.message.rawValue) as? String
                {
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    
    // share on fb
    func referOnFB(){
       
        let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = URL.init(string: "https://food-monkey.com/")
        let shareDialog = FBSDKShareDialog()
        shareDialog.shareContent = content
        shareDialog.mode = .automatic
     
        
        do {
            try shareDialog.show()
        } catch {
            //error displaying facebook dialog
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
