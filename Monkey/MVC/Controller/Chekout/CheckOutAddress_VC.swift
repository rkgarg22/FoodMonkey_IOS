//
//  CheckOutAddress_VC.swift
//  Monkey
//
//  Created by apple on 13/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class CheckOutAddress_VC: UIViewController {
    @IBOutlet var btnDelivery : [UIButton]!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var tblVw_address: UITableView!
    var addOnList = [AddOnItem]()
    var restaurantModel:SpecificRestaurantListModal?
    var itemCount : Int?
    var itemPrice : String?
    var addresssModalArr = [AddressModal]()
    var selectedIndex = IndexPath.init(row: 0, section: 0)
    var totalSum = 0.0
    var selectedDeliveryOption = "Delivery"
    var orderId = 0
    @IBOutlet weak var lbl_totalSum: UILabel!
    var restaurantNumber = ""
    @IBOutlet var view1 : UIView!
    @IBOutlet var view2 : UIView!
    
    @IBOutlet weak var lbl_deliveryTime: UILabel!
    
    @IBOutlet weak var lbl_collectionTime: UILabel!
    @IBOutlet weak var lbl_totaltitle: UILabel!
    
    @IBOutlet weak var cnstrnt_itemsTable: NSLayoutConstraint!
    @IBOutlet weak var cnstrnt_adressTable: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tblVw.tableFooterView = UIView()
        tblVw.backgroundColor = .clear
        tblVw.separatorStyle = .none
        tblVw.separatorColor = .clear
        tblVw_address.tableFooterView = UIView()         
        tblVw_address.backgroundColor = .clear
        tblVw_address.separatorStyle = .none
        tblVw_address.separatorColor = .white
        tblVw_address.estimatedRowHeight = 80
        tblVw_address.rowHeight = UITableViewAutomaticDimension
        tblVw.estimatedRowHeight = 40
        tblVw.rowHeight = UITableViewAutomaticDimension
       
        if restaurantModel?.DeliveryOption?.lowercased() == "takeaway" || restaurantModel?.DeliveryOption?.lowercased() == "collection"{
            view1.isHidden = true
            if btnDelivery[0].tag == 1{
                btnDelivery[0].isSelected = true
                btnDelivery[1].isSelected = false
            }else{
                btnDelivery[1].isSelected = true
                btnDelivery[0].isSelected = false
            }
            selectedDeliveryOption = "Collection"
            if let c = restaurantModel?.Collection_Time{
                lbl_collectionTime.text = "\(c) mins"
            }
        }else if restaurantModel?.DeliveryOption?.lowercased() == "delivery"{
            view2.isHidden = true
            selectedDeliveryOption = "Delivery"
            if btnDelivery[0].tag == 0{
                 btnDelivery[0].isSelected = true
                 btnDelivery[1].isSelected = false
            }else{
                 btnDelivery[1].isSelected = true
                 btnDelivery[0].isSelected = false
            }
            
            if let c = restaurantModel?.Delivery_Time{
                lbl_deliveryTime.text = "\(c) mins"
            }
        }else{
            if let c = restaurantModel?.Collection_Time{
                lbl_collectionTime.text = "\(c) mins"
            }
            if let c = restaurantModel?.Delivery_Time{
                lbl_deliveryTime.text = "\(c) mins"
            }
            if selectedDeliveryOption.isEmpty{
                if btnDelivery[0].tag == 0{
                    btnDelivery[0].isSelected = true
                    btnDelivery[1].isSelected = false
                }else{
                    btnDelivery[1].isSelected = true
                    btnDelivery[0].isSelected = false
                }
                selectedDeliveryOption = "Delivery"
            }else{
                if selectedDeliveryOption == "Delivery"{
                    if btnDelivery[0].tag == 0{
                        btnDelivery[0].isSelected = true
                        btnDelivery[1].isSelected = false
                    }else{
                        btnDelivery[1].isSelected = true
                        btnDelivery[0].isSelected = false
                    }
                }else{
                    if btnDelivery[0].tag == 1{
                        btnDelivery[0].isSelected = true
                        btnDelivery[1].isSelected = false
                    }else{
                        btnDelivery[1].isSelected = true
                        btnDelivery[0].isSelected = false
                    }
                }
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.restaurantNumber = self.restaurantModel?.Rest_Telephone ?? ""
        getAddressList()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cnstrnt_itemsTable?.constant = self.tblVw.contentSize.height
        self.cnstrnt_adressTable?.constant = self.tblVw_address.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_deliveryOption(_ sender: UIButton) {
        for aButton in btnDelivery{
            aButton.isSelected = false
        }
        sender.isSelected = true
        
        selectedDeliveryOption = sender.tag == 0 ? "Delivery" : "Collection"
        self.tblVw.reloadData()
    }
    
    @IBAction func btnAction_editOrder(_ sender: UIButton) {
        let vc = StoryboardScene.Main.instantiateEditCart_VC()
        vc.addOnList = self.addOnList
        vc.restaurantModel = self.restaurantModel
        vc.quantity1Delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func barBtnAction_back(_ sender: UIBarButtonItem) {
        if (DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.cartAdded.rawValue) as? Bool) == true{
            var vc1 : RestaurantMenuMXVC?
            if let controllers = self.navigationController?.viewControllers{
                for values in controllers{
                    if let vc = values as? RestaurantMenuMXVC{
                        vc1 = vc
                        break
                    }
                }
            }
            if vc1 != nil{
                self.navigationController?.popToViewController(vc1!, animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else{
             self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnAction_pay(_ sender: UIButton) {
        
        if self.addresssModalArr.count > 0{
            if  AppDelegate.sharedDelegate().preOrder == true{
                if let vc = self.storyboard?.instantiateViewController(withIdentifier:"PreOrder_checkoutVC" ) as? PreOrder_checkoutVC{
                    vc.addOnList = self.addOnList
                    vc.selectedIndex = self.selectedIndex
                    vc.totalSum = self.totalSum
                    vc.restaurantModel = self.restaurantModel
                    vc.selectedDeliveryOption = self.selectedDeliveryOption
                    vc.addresssModalArr = self.addresssModalArr
                    vc.restaurantNumber = self.restaurantNumber
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }else{
                checkoutApi()
            }
            
        }
        else{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg:"Please add address to proceed further" , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
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

        APIManager.shared.request(with: LoginEndpoint.checkout(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_Id: customerId, Resturant_id: self.restaurantModel?.Rest_Id, Address_id: self.addresssModalArr[selectedIndex.row].Address_Id, Order_Amount: Float(totalSum), DeliveryOption: selectedDeliveryOption, Item_Id: itemId, Quantity: quantity, Addon_Id: nil, Preorder_DateTime: nil, Preorder_Comments : nil)){[weak self] (response) in
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
    
    
    func getAddressList(){
        var customerId : Int?
        if let customer_id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            customerId = customer_id
        }
        APIManager.shared.request(with: LoginEndpoint.getAddress(TokenKey:  CommonMethodsClass.getDeviceToken(), Customer_id: customerId)){[weak self] (response) in
            self?.handleGetAddressResponse(response: response)
        }
    }
    
    func handleGetAddressResponse(response : Response){
        switch response {
        case .success(let responseValue):
            
            if let dict = responseValue as? AdressModal
            {
                if let add = dict.Customer_addresses
                {
                        addresssModalArr = add
                }
                self.tblVw_address.reloadData()
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
}


//MARK:- table view methods

extension CheckOutAddress_VC : UITableViewDataSource, UITableViewDelegate,quantity1ChangedDelegate,DelegateFromSingleAlert{
    
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let subviews = cell.subviews
        guard subviews.count >= 3 else {
            return
        }
        
        for subview in subviews where NSStringFromClass(subview.classForCoder) == "_UITableViewCellSeparatorView" {
            subview.removeFromSuperview()
        }
    }
    
    func valueChanged1(values:[AddOnItem]){
        self.addOnList = values
        self.tblVw.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView == tblVw{
//            return 40
//        }else{
            return UITableViewAutomaticDimension
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_help") as! TableCell_help
        if let restaurantDetail = self.restaurantModel{
            cell.lbl_title.text  = restaurantDetail.Rest_Name?.capitalizedFirst()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tblVw{
             if selectedDeliveryOption == "Delivery" || selectedDeliveryOption == "Collection"{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Settings") as! TableCell_Settings
                var sum = 0.0
                for value in self.addOnList
                {
                    let temp  = Double(value.Addon_price) ?? 0
                    sum += Double(value.Addon_quantity) * temp
                }
                let newSum = String(format: "%.2f", sum)
                cell.lbl_subTitle.text = "£" + "\(newSum)"
                if let discount = restaurantModel?.DiscountOffer{
                    if discount > 0{
                        cell.lbl_discount.text =  "\(discount)%"
                    }
                }
                if selectedDeliveryOption == "Delivery"{
                   
                    if restaurantModel?.Delivery != nil{
                        let d = Float(restaurantModel?.Delivery ?? "0.00")
                        if  d ?? 0.0 > Float(0.00){
                             cell.lbl_DeliveryCharges.isHidden = false
                            cell.lbl_deliveryFee.isHidden = false
                            if let deliveryCharges = restaurantModel?.Delivery{
                                 cell.lbl_DeliveryCharges.text = "£" + "\(deliveryCharges)"
                            }else{
                                 cell.lbl_DeliveryCharges.text = "£0.00"
                            }
                            if let discount = self.restaurantModel?.DiscountOffer{
                                let value = Double(discount) * 0.01
                                if let deliveryCharges = restaurantModel?.Delivery{
                                    if let t = Double(deliveryCharges){
                                        sum  = sum + t
                                    }
                                }
                                sum = sum + 0.25
                                sum  = sum - (sum * value)
                            }
                            
                            let newTotalSum = String(format: "%.2f", sum)
                            lbl_totalSum.text = "£" + "\(newTotalSum)"
                            totalSum = sum 
                        }
                        else{
                            cell.lbl_DeliveryCharges.isHidden = false
                            cell.lbl_deliveryFee.isHidden = false
                            cell.lbl_DeliveryCharges.text = "£0.00"
                            if let discount = self.restaurantModel?.DiscountOffer{
                                let value = Double(discount) * 0.01
                                sum = sum + 0.25
                                sum  = sum - (sum * value)
                            }
                            
                            let newTotalSum = String(format: "%.2f", sum)
                            lbl_totalSum.text = "£" + "\(newTotalSum)"
                            totalSum = sum
                        }
                    }
                   
                }else{
                    cell.lbl_DeliveryCharges.isHidden = true
                    cell.lbl_deliveryFee.isHidden = true
                    if let discount = self.restaurantModel?.DiscountOffer{
                        let value = Double(discount) * 0.01
                        sum = sum + 0.25
                        sum = sum - (sum * value)
                    }
                    
                    let newTotalSum = String(format: "%.2f", sum)
                    lbl_totalSum.text = "£" + "\(newTotalSum)"
                    totalSum = sum
                }
                 self.viewWillLayoutSubviews()
                return cell
             }else{
                return UITableViewCell()
            }
           
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_help1") as! TableCell_help
            cell.btn_address.addTarget(self, action: #selector(addAddress(_ :)), for: .touchUpInside)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tblVw{
            if selectedDeliveryOption == "Delivery"{
                return 125
            }else if selectedDeliveryOption == "Collection"{
                return 95
            }
            return 0
        }
        return 50
       
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblVw{
            return self.addOnList.count
            
        }
        else{
            return self.addresssModalArr.count
        }
    }
    
    
    func addAddress(_ sender:UIButton){
        let vc = StoryboardScene.Main.instantiate_AddAdress_VC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblVw{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_CartRow") as! TableCell_CartRow
            cell.selectionStyle = .none
            cell.lbl_title.text = addOnList[indexPath.row].Addon_name.capitalizedFirst()
            cell.lbl_subTitle.text = "£" + (addOnList[indexPath.row].Addon_price )
            cell.lbl_quantity.text =  "\(addOnList[indexPath.row].Addon_quantity)" + "     x"
             self.viewWillLayoutSubviews()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_address") as! TableCell_address
            let modal = self.addresssModalArr[indexPath.row]
            cell.lbl_Heading.text = modal.Address_Name.capitalizedFirst()
            let t1 = modal.Address_Note + "\n\(modal.House_No)" + " " + modal.Street_Line1 + "\n"
            let t2 = modal.Street_Line2  + " " + modal.Post_Code +  " " + modal.City
            cell.lbl_title.text = t1 + t2
             self.viewWillLayoutSubviews()
            if (selectedIndex == indexPath) {
                cell.imgVw.image = #imageLiteral(resourceName: "Radio-button1")
            }else{
                cell.imgVw.image = #imageLiteral(resourceName: "Radio-button2")
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView != tblVw{
            selectedIndex = indexPath
            tableView.reloadData()
        }
    }
}
