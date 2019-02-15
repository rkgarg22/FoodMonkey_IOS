//
//  PreOrder_checkoutVC.swift
//  Monkey
//
//  Created by Apple on 16/01/19.
//  Copyright © 2019 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class PreOrder_checkoutVC: UIViewController {
    
    @IBOutlet weak var txtVw_note: UITextView!
    @IBOutlet weak var txtField_time: CustomTextField!
    @IBOutlet weak var txtfield_date: CustomTextField!
    var addOnList = [AddOnItem]()
    var restaurantModel:SpecificRestaurantListModal?
    var selectedIndex = IndexPath.init(row: 0, section: 0)
    var totalSum = 0.0
    var selectedDeliveryOption = "Delivery"
    var addresssModalArr = [AddressModal]()
    var orderId = 0
    var restaurantNumber = ""
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_time.layer.borderColor = UIColor.lightGray.cgColor
        txtfield_date.layer.borderColor = UIColor.lightGray.cgColor
        txtVw_note.layer.borderColor = UIColor.lightGray.cgColor
        txtVw_note.layer.cornerRadius = 5
        txtVw_note.clipsToBounds = true
        txtVw_note.layer.masksToBounds = true
        txtVw_note.layer.borderWidth = 0.5
        
        
        showDatePicker()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func click_confirm(_ sender: UIButton) {
        if txtfield_date.text?.isEmpty == true{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: "Please select appropriate date" , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }else  if txtField_time.text?.isEmpty == true{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: "Please select appropriate time" , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }else{
            checkoutApi()
        }
    }
    
    
    func showDatePicker(){
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        
        timePicker.datePickerMode = .time
        timePicker.minimumDate = Date()
        
        let loc = Locale(identifier: "en_GB")
        self.datePicker.locale = loc
        self.timePicker.locale = loc
        
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
        
        
        // //ToolBar
        let toolbar1 = UIToolbar();
        toolbar1.sizeToFit()
        
        //done button & cancel button
        let doneButton1: UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneTimePicker(sender:)))
      
         let cancelButton1: UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.cancelDatePicker))
        toolbar1.setItems([cancelButton1,spaceButton,doneButton1], animated: false)
        
        // add toolbar to textField
        txtfield_date.inputAccessoryView = toolbar
        
        // add datepicker to textField
        txtfield_date.inputView = datePicker
        
        // add toolbar to textField
        txtField_time.inputAccessoryView = toolbar1
        
        // add datepicker to textField
        txtField_time.inputView = timePicker
        
    }
    
    @objc func doneTimePicker(sender :UIDatePicker){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        txtField_time.backgroundColor = .white
        txtField_time.text = formatter.string(from: timePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func donedatePicker(sender :UIDatePicker){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy EEEE"
        txtfield_date.backgroundColor = .white
        txtfield_date.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    ///api call
    
    func checkoutApi(){
        var customerId : Int?
        if let customer_id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            customerId = customer_id
        }
        var itemId = ""
        var quantity = ""
        var addOnId = ""
        for i in 0..<self.addOnList.count
        {
            let value = self.addOnList[i].Item_id ?? 0
            let value1 = self.addOnList[i].Addon_quantity
            let value2 = self.addOnList[i].Addon_Id ?? 0
            if i != 0{
                itemId.append(",")
                quantity.append(",")
                addOnId.append(",")
            }
            
            itemId.append("\(value)")
            quantity.append("\(value1)")
            addOnId.append("\(value2)")
        }
        let test = (txtfield_date.text ?? "") + " " + (txtField_time.text ?? "")
        var t1 :String?
        if txtVw_note.text.isEmpty == false{
            t1 = txtVw_note.text
        }
        APIManager.shared.request(with: LoginEndpoint.checkout(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_Id: customerId, Resturant_id: self.restaurantModel?.Rest_Id, Address_id: self.addresssModalArr[selectedIndex.row].Address_Id, Order_Amount: Float(totalSum), DeliveryOption: selectedDeliveryOption, Item_Id: itemId, Quantity: quantity, Addon_Id: nil, Preorder_DateTime: test, Preorder_Comments : t1)){[weak self] (response) in
            self?.handleCheckoutResponse(response: response)
        }
    }
    
    func handleCheckoutResponse(response : Response){
        switch response {
        case .success(let responseValue):
            
            if let dict = responseValue as? NSDictionary
            {
                if let msg = dict.object(forKey: Keys.message.rawValue) as? String
                {
                    // AppDelegate.sharedDelegate().tempPwd = self.txtField_pwd.text!
                    if let id = dict.object(forKey: "Order_id") as? String
                    {
                        self.orderId = Int(id) ?? 0
                        let vc = StoryboardScene.Main.instantiateCompleteYourPaymentVC()
                        vc.orderId = self.orderId
                        vc.restaturantNumber = self.restaurantNumber
                        vc.amount = self.totalSum
                        vc.restId = self.restaurantModel?.Rest_Id ?? 0
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        CommonMethodsClass.showAlertWithSingleButton(title:"", msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                    }
                    
                    // CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                    
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

extension PreOrder_checkoutVC : DelegateFromSingleAlert{
    
    func donePressed(obj: AlertVC) {
        CommonMethodsClass.okBtnForSingleAlertHandlerWithCompletionHandler { (success) in
            //            let vc = StoryboardScene.Main.instantiateCompleteYourPaymentVC()
            //            vc.orderId = self.orderId
            //            vc.restaturantNumber = self.restaurantNumber
            //            vc.amount = self.totalSum
            //            vc.restId = self.restaurantModel?.Rest_Id ?? 0
            //            self.navigationController?.pushViewController(vc, animated: true)
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
