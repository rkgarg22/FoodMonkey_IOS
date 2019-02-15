//
//  feedback_VC.swift
//  Monkey
//
//  Created by Apple on 28/12/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import HCSStarRatingView

class feedback_VC: UIViewController {

    @IBOutlet weak var txt_comment: UITextView!
    @IBOutlet weak var vw_star: HCSStarRatingView!
    var restId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txt_comment.layer.borderColor = UIColor.lightGray.cgColor
        txt_comment.layer.cornerRadius = 5
        txt_comment.clipsToBounds = true
        txt_comment.layer.masksToBounds = true
        txt_comment.layer.borderWidth = 0.5
        // Do any additional setup after loading the view.
    }
    
    @IBAction func click_feedback(_ sender: UIButton) {
        if vw_star.value == 0{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:"Please select star" , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
        }else if txt_comment.text.isEmpty == true{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:"Please write comment" , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
        }else{
            callApi()
        }
        
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func callApi()
    {
        if let customerId = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int
        {
            APIManager.shared.request(with: LoginEndpoint.feedback(TokenKey: CommonMethodsClass.getDeviceToken(), Resturant_id: restId ?? 0, Customer_id: customerId, Number_of_Stars: Int(vw_star.value), Comment: txt_comment.text ?? ""), completion: { (response) in
                self.handleFeedbackApiResponse(response : response)
            })
        }
    }
    
    func handleFeedbackApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let msg = dict.value(forKey: "Message") as? String{
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg:msg , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                }
            }
            
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

extension feedback_VC :  DelegateFromSingleAlert{
    
    func donePressed(obj: AlertVC) {
        CommonMethodsClass.okBtnForSingleAlertHandlerWithCompletionHandler { (success) in
            self.navigationController?.popViewController(animated: true)
        }
    }
}
