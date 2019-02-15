//
//  AddCard_VC.swift
//  Monkey
//
//  Created by Apple on 26/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import Stripe

class AddCard_VC: UIViewController {

    @IBOutlet weak var txtField_cardNumber: CustomTextField!
    @IBOutlet weak var txtField_cardName: CustomTextField!
    
    
    @IBOutlet weak var txtField_cvv: UITextField!
    @IBOutlet weak var txtField_date: UITextField!
    @IBOutlet weak var txtField_year: UITextField!
    
    let monthPicker = UIPickerView()
    let yearPicker = UIPickerView()
    var arrYear = [String]()
    var arrMonth = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from:Date())
        var year = 0
        if let y = Int(dateString.components(separatedBy: "/").last ?? "0")
        {
            year = y
        }
        for value in 1...15{
            
            arrYear.append("\(year+value)")
        }
        
        for value in 1...12
        {
            arrMonth.append("\(value)")
        }
        txtField_year.addRightIcon(#imageLiteral(resourceName: "arrow-down"), frame: CGRect.init(x: 0, y: 0, w: 15, h: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_date.addRightIcon(#imageLiteral(resourceName: "arrow-down"), frame: CGRect.init(x: 0, y: 0, w: 15, h: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_date.inputView = monthPicker
        txtField_year.inputView = yearPicker
        monthPicker.delegate = self
        yearPicker.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_addCard(_ sender: UIButton) {
        let value = Validate()
        switch value {
        case .success:
            let value = STPCardValidator.validationState(forNumber: txtField_cardNumber.text, validatingCardBrand: true)
            if  value == STPCardValidationState.invalid || value == STPCardValidationState.incomplete
            {
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Card number is invalid", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            }else{
                self.callAddCardApi()
            }
            
            
        case .failure(_, let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            
        }
    }
    
    
    //MARK: Validate
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(addCard: txtField_cardName.text, CardNumber: txtField_cardNumber.text, ExpDate: txtField_date.text, ExpYear: txtField_year.text, CVV: txtField_cvv.text)
        
        return value
    }
    
    
    //MARK:- Call Add card api
    func callAddCardApi()
    {
        
        let cardParams = STPCardParams()
        cardParams.number = txtField_cardNumber.text!
        cardParams.expMonth = UInt(Int(txtField_date.text!)!)
        cardParams.expYear = UInt(Int(txtField_year.text!)!)
        cardParams.cvc = txtField_cvv.text!
        
        Utility.shared.loader()
        STPAPIClient.shared().createToken(withCard: cardParams) { (token, error) in
            if let error = error {
                // show the error to the user
                Utility.shared.removeLoader()
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: error.localizedDescription, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            } else if let token = token {
                Utility.shared.removeLoader()
                let stripeToken = token.tokenId
                let customerId = APIConstants.getStripeCustomerId()
                    
                APIManager.shared.request(with: LoginEndpoint.addCard(TokenKey: CommonMethodsClass.getDeviceToken(), Stripe_Customer_Id: customerId, Stripe_Token: stripeToken), completion: { (response) in
                     self.handleAddCardApiResponse(response : response)
                })
//                APIManager.shared.request(with: LoginEndpoint.addCardToStripe(source: stripeToken, object: nil, number: nil, exp_month: nil, exp_year: nil, cvc: nil), completion: { (response) in
//                    self.handleAddCardApiResponse(response : response)
//                })
            }
        }
        
//        var customerId : Int?
//        if let customer_id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
//            customerId = customer_id
//        }
//        APIManager.shared.request(with: LoginEndpoint.addCard(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: customerId, NameOnCard: txtField_cardName.text ?? "", CardNumber: Int(txtField_cardNumber.text ?? "0"), ExpDate: Int(txtField_date.text ?? "0"), ExpYear: Int(txtField_year.text ?? "0"), CVV: Int(txtField_cvv.text ?? "0")), completion: { (response) in
//            self.handleAddCardApiResponse(response : response)
//        })
    }
    
    func handleAddCardApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
           
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "Card Added" , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
            
//            if let dict = responseValue as? NSDictionary
//            {
//                if let msg = dict.object(forKey: Keys.message.rawValue) as? String
//                {
//                    // AppDelegate.sharedDelegate().tempPwd = self.txtField_pwd.text!
//
//                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
//
//                }
//            }
            
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


extension AddCard_VC : UIPickerViewDelegate,UIPickerViewDataSource, DelegateFromSingleAlert{
    
    
    func donePressed(obj: AlertVC) {
        CommonMethodsClass.okBtnForSingleAlertHandlerWithCompletionHandler { (success) in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker{
            return arrMonth.count
        }else{
            return arrYear.count
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPicker{
            return arrMonth[row]
        }else{
            return arrYear[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthPicker{
            self.txtField_date.text = arrMonth[row]
        }else{
            self.txtField_year.text = arrYear[row]
        }
    }
    
}

