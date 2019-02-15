//
//  Order_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class Order_VC: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var lbl_noData: UILabel!
    
    var arrOrder = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callCustomerOrderListApi()
    }
    
    
    func callCustomerOrderListApi(){
        let customerId = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int
        APIManager.shared.request(with: LoginEndpoint.customerOrderList(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: customerId)){[weak self] (response) in
            self?.handleCustomerOrderListResponse(response: response)
        }
    }
    
    func handleCustomerOrderListResponse(response : Response){
        switch response {
        case .success(let responseValue):
            print(responseValue as? NSDictionary ?? [:])
            if let dict = responseValue as? OrderModal
            {
                if let code = dict.Code{

                    if let msg = dict.Message{
                        if code == "200"{
                            if let orderList = dict.Customer_orders{
                                arrOrder = []
                                if let Pre_Orders = orderList.Pre_Orders{
                                    if Pre_Orders.count > 0{
                                        arrOrder.append(contentsOf: Pre_Orders)
                                    }
                                }
                                if let Order_Detail = orderList.Order_Detail{
                                    if Order_Detail.count > 0{
                                        arrOrder.append(contentsOf: Order_Detail)
                                    }
                                }
                                if let Rejected_Orders = orderList.Rejected_Orders{
                                    if Rejected_Orders.count > 0{
                                        arrOrder.append(contentsOf: Rejected_Orders)
                                    }
                                }
                                if (orderList.Pre_Orders?.count == 0) && (orderList.Order_Detail?.count == 0) && (orderList.Rejected_Orders?.count == 0){
                                    self.lbl_noData.isHidden = false
                                    self.tblVw.isHidden = true
                                    self.lbl_noData.text = "No restaurant found."
                                }else{
                                    self.lbl_noData.isHidden = true
                                    self.tblVw.isHidden = false
                                    self.tblVw.reloadData()
                                }
                            }else{
                                self.lbl_noData.isHidden = false
                                self.tblVw.isHidden = true
                                self.lbl_noData.text = "No restaurant found."
                            }
                        }else{
                            self.lbl_noData.isHidden = false
                            self.tblVw.isHidden = true
                            self.lbl_noData.text = msg
                        }
                    }
                }
            }
            
        case .failure(let msg):
            self.lbl_noData.isHidden = false
            self.tblVw.isHidden = true
            self.lbl_noData.text = msg
        case .Warning(let msg):
            self.lbl_noData.isHidden = false
            self.tblVw.isHidden = true
            self.lbl_noData.text = msg
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- table view methods

extension Order_VC : UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Order") as! TableCell_Order
        let modal = arrOrder[indexPath.row]
        cell.lbl_title.text = modal.Rest_Name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.lbl_priceDesc.text = modal.Order_Amount ?? ""
        if let imageData = modal.Rest_Image_Link{
            if let index = imageData.range(of: "api/")?.upperBound {
                let substring = imageData[index...]
                let string = String(substring)
                let urlString = APIConstants.basePath + string
                cell.imgVw_pic.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "rest-alvi"), options: .refreshCached, completed: nil)
            }else{
                cell.imgVw_pic.image = #imageLiteral(resourceName: "rest-alvi")
            }
        }else{
            cell.imgVw_pic.image = #imageLiteral(resourceName: "rest-alvi")
        }
        if let numberOfReview = modal.NumberOfReviews{
            cell.lbl_review.text = "(\(numberOfReview))"
        }
        if let value = modal.AggregateFeedback{
            cell.vwRating.value = CGFloat(Float(value)!)
        }
        cell.vwRating.isEnabled = false
        var cuisineList = ""
        if let cuisine1 = modal.Cousine1, cuisine1 != ""{
            cuisineList = cuisine1
            if let cuisine2 = modal.Cousine2, cuisine2 != ""{
                cuisineList += ", " + cuisine2
            }
        }else if let cuisine2 = modal.Cousine2, cuisine2 != ""{
            cuisineList = cuisine2
        }
        cell.lbl_cuisines.text = cuisineList
        cell.btnOutlet_ViewDetail.tag = indexPath.row
        cell.btnOutlet_ViewDetail.addTarget(self, action: #selector(btnViewDetail), for: .touchUpInside)
        cell.lbl_orderId.text = "\(modal.Order_Id ?? 0)"
        cell.lbl_Delivered.text = modal.Order_Status
        if let dateStr = modal.Order_Date_Time{
            cell.lbl_date.text = CommonMethodsClass.removeTime(dateString: dateStr)
        }
        cell.contentView.backgroundColor  = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func btnViewDetail(sender:UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        vc.addOnList = arrOrder[sender.tag].Menu_Order ?? []
        vc.restaurantModel = arrOrder[sender.tag]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderStatus_VC") as! OrderStatus_VC
        vc.orderId = arrOrder[indexPath.row].Order_Id ?? 0
        vc.restId = arrOrder[indexPath.row].Rest_Id ?? 0
        AppDelegate.sharedDelegate().orderId = nil
        AppDelegate.sharedDelegate().fromNotification = false
        vc.restaurantNumber = arrOrder[indexPath.row].Rest_Telephone ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
