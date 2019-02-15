//
//  CheckOut_VC.swift
//  Monkey
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class CheckOut_VC: UIViewController {
    
    @IBOutlet weak var cnstrnt_heightTable: NSLayoutConstraint!
    @IBOutlet weak var lbl_totalTitle: UILabel!
    @IBOutlet var btnDelivery : [UIButton]!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet var view1 : UIView!
    @IBOutlet var view2 : UIView!
    
    @IBOutlet weak var lbl_totalPrice: UILabel!
    var addOnList = [AddOnItem]()
    var restaurantModel:SpecificRestaurantListModal?
    var itemCount : Int?
    var itemPrice : Double?
    var selectedOption = "Delivery"
    
    @IBOutlet weak var lbl_deliveryTime: UILabel!
    @IBOutlet weak var lbl_collectionTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.tableFooterView = UIView()
        tblVw.backgroundColor = .clear
        tblVw.separatorStyle = .none
        tblVw.separatorColor = .clear
        btnDelivery[0].isSelected = true
        tblVw.estimatedRowHeight = 40
        
        tblVw.rowHeight = UITableViewAutomaticDimension
        if restaurantModel?.DeliveryOption?.lowercased() == "takeaway" || restaurantModel?.DeliveryOption?.lowercased() == "collection"{
            view1.isHidden = true
            selectedOption = "Collection"
            if btnDelivery[0].tag == 1{
                btnDelivery[0].isSelected = true
                btnDelivery[1].isSelected = false
            }else{
                btnDelivery[1].isSelected = true
                btnDelivery[0].isSelected = false
            }
            if let c = restaurantModel?.Collection_Time{
                lbl_collectionTime.text = "\(c) mins"
            }
        }else if restaurantModel?.DeliveryOption?.lowercased() == "delivery"{
            view2.isHidden = true
            selectedOption = "Delivery"
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
            if btnDelivery[0].tag == 0{
                btnDelivery[0].isSelected = true
                btnDelivery[1].isSelected = false
            }else{
                btnDelivery[1].isSelected = true
                btnDelivery[0].isSelected = false
            }
            selectedOption = "Delivery"
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cnstrnt_heightTable?.constant = self.tblVw.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let _ = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            btn_login.isHidden = true
        }else{
            btn_login.isHidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAction_editOrder(_ sender: UIButton) {
        let vc = StoryboardScene.Main.instantiateEditCart_VC()
        vc.addOnList = self.addOnList
        vc.restaurantModel = self.restaurantModel
        vc.quantityDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func barBtnAction_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_login(_ sender: UIButton) {
        let vc = StoryboardScene.Main.instantiateLoginController()
        DBManager.setValueInUserDefaults(value: true, forKey: ParamKeys.cartAdded.rawValue)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func click_deliveryOption(_ sender: UIButton) {
        for aButton in btnDelivery{
            aButton.isSelected = false
        }
        sender.isSelected = true
        
        selectedOption = sender.tag == 0 ? "Delivery" : "Collection"
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


//MARK:- table view methods

extension CheckOut_VC : UITableViewDataSource, UITableViewDelegate,quantityChangedDelegate{
    
    
    func valueChanged(values:[AddOnItem]){
        self.addOnList = values
        self.tblVw.reloadData()
    }
    
    
    //tble view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
            if selectedOption == "Delivery" || selectedOption == "Collection"{
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
                if selectedOption == "Delivery"{
                    
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
                                sum = sum - (sum * value)
                            }
                            
                            let newTotalSum = String(format: "%.2f", sum)
                            lbl_totalPrice.text = "£" + "\(newTotalSum)"
                        }
                        else{
                            cell.lbl_DeliveryCharges.isHidden = false
                            cell.lbl_deliveryFee.isHidden = false
                            cell.lbl_DeliveryCharges.text = "£0.00"
                            
                            if let discount = self.restaurantModel?.DiscountOffer{
                                let value = Double(discount) * 0.01
                                sum = sum + 0.25
                                sum = sum - (sum * value)
                            }
                            
                            let newTotalSum = String(format: "%.2f", sum)
                            lbl_totalPrice.text = "£" + "\(newTotalSum)"
                        }
                    }
                    
                }else{
                    cell.lbl_deliveryFee.isHidden = true
                    cell.lbl_DeliveryCharges.isHidden = true
                    
                    if let discount = self.restaurantModel?.DiscountOffer{
                        let value = Double(discount) * 0.01
                        sum = sum + 0.25
                        sum = sum - (sum * value)
                    }
                    
                    let newTotalSum = String(format: "%.2f", sum)
                    lbl_totalPrice.text = "£" + "\(newTotalSum)"
                }
                self.viewWillLayoutSubviews()
                return cell
            }else{
                
                return UITableViewCell()
            }
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_help1") as! TableCell_help
            self.viewWillLayoutSubviews()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
        if selectedOption == "Delivery"{
            return 125
        }else if selectedOption == "Collection"{
            return 95
        }
        return 125
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addOnList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_CartRow") as! TableCell_CartRow
        cell.selectionStyle = .none
        cell.lbl_title.text = addOnList[indexPath.row].Addon_name.capitalizedFirst()
        cell.lbl_subTitle.text = "£" + (addOnList[indexPath.row].Addon_price )
        cell.lbl_quantity.text =  "\((addOnList[indexPath.row].Addon_quantity ))" + "     x" 
        self.viewWillLayoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
