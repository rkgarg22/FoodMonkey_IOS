//
//  OrderDetailsVC.swift
//  Monkey
//
//  Created by apple on 24/11/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
protocol quantityChangedDelegateMenu
{
    func valueChanged(values:[MenuOrder])
}
class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    
    @IBOutlet weak var lbl_RestTitle: UILabel!
    @IBOutlet weak var lbl_RestAddress: UILabel!
    @IBOutlet weak var lbl_customerName: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_orderId: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_phoneNo: UILabel!
    @IBOutlet weak var lbl_customerAddress: UILabel!
    
    var addOnList = [MenuOrder]()
    var restaurantModel:Order?
    var itemCount : Int?
    var itemPrice : Double?
    var selectedOption = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.tableFooterView = UIView()
        tblVw.backgroundColor = .clear
        tblVw.separatorStyle = .none
        tblVw.separatorColor = .clear
        tblVw.estimatedRowHeight = 40
        tblVw.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let restaurantDetail = self.restaurantModel{
            self.lbl_RestTitle.text  = restaurantDetail.Rest_Name?.capitalizedFirst()
            let r1 = (restaurantDetail.Rest_Street_Line1 ?? "") + " " + (restaurantDetail.Rest_Street_Line2 ?? "") + ", "
            let r2 = (restaurantDetail.Rest_City ?? "") + ", " + (restaurantDetail.Rest_Post_Code ?? "")
            self.lbl_RestAddress.text =  r1 + r2
            self.lbl_orderId.text = "\(restaurantDetail.Order_Id ?? 0)"
            self.lbl_price.text = "£" + (restaurantDetail.Order_Amount ?? "")
            self.lbl_customerName.text = restaurantDetail.Delivery_Address_Name ?? ""
            self.lbl_phoneNo.text = "\(restaurantDetail.Mobile_Number ?? 0)"
            let t1 = (restaurantDetail.Delivery_House_No ?? "") + " " + (restaurantDetail.Delivery_Street_Line1 ?? "") + "\n"
            let t2 = (restaurantDetail.Delivery_Street_Line2 ?? "")  + ", " + (restaurantDetail.Delivery_City ?? "")
            let t3 =   ", " + (restaurantDetail.Delivery_Post_Code ?? "")
            self.lbl_customerAddress.text = t1 + t2 + t3
            if let dateStr = restaurantDetail.Order_Date_Time{
                self.lbl_date.text = CommonMethodsClass.getDate(dateString: dateStr)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func barBtnAction_back(_ sender: UIBarButtonItem) {
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


//MARK:- table view methods

extension OrderDetailsVC : UITableViewDataSource, UITableViewDelegate,quantityChangedDelegateMenu{
    
    func valueChanged(values:[MenuOrder]){
        self.addOnList = values
        self.tblVw.reloadData()
    }
    
    
    //tble view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_help") as! TableCell_help
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tblVw{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Settings") as! TableCell_Settings
            var sum = 0.0
            for value in self.addOnList
            {
                let temp  = Double(value.Item_Price ?? "") ?? Double(0)
                sum += Double(value.Quantity ?? 0) * temp
            }
            let newSum = String(format: "%.2f", sum)
            cell.lbl_subTitle.text = "£" + "\(newSum)"
            if let discount = restaurantModel?.DiscountOffer{
                if discount > 0{
                    cell.lbl_discount.text = "\(discount)%"
                }else{
                    cell.lbl_discount.text = "0%"
                }
            }
            let DeliveryCharges = Double(restaurantModel?.DeliveryCharges ?? "")
            cell.lbl_DeliveryCharges.text = "£" + (restaurantModel?.DeliveryCharges ?? "")
            if let discount = self.restaurantModel?.DiscountOffer{
               
                let value = Double(discount) * 0.01
                if let deliverCharge  = restaurantModel?.DeliveryCharges {
                     sum  = sum + 1.0
                }
                sum = sum + 0.25
                sum  = sum - (sum * value)
            }
            let newTotalSum = String(format: "%.2f", sum)
            cell.lbl_totalAmount.text = "£" + "\(newTotalSum)"
            cell.lbl_orderStatus.text = (restaurantModel?.Order_Status ?? "")
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_help1") as! TableCell_help
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addOnList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_CartRow") as! TableCell_CartRow
        cell.selectionStyle = .none
        cell.lbl_title.text = addOnList[indexPath.row].Item_Name?.capitalizedFirst()
        cell.lbl_subTitle.text = "£" + (addOnList[indexPath.row].Item_Price ?? "" )
        cell.lbl_quantity.text = "\((addOnList[indexPath.row].Quantity ?? 0))" + "     x"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
