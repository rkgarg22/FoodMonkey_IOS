//
//  OrderStatus_VC.swift
//  Monkey
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class OrderStatus_VC: UIViewController {
    var restaurantNumber = ""
    var fromPayment = false
    @IBOutlet weak var tblVw: UITableView!
    var restId: Int?
    var selectedIndex = 1
    var orderId = 0
    var isRejected = false
    var time = 0.0
    var originalTime = 0.0
    var status = ""
    var preOrder = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.isHidden = true
        tblVw.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        tblVw.separatorStyle = .none
        if AppDelegate.sharedDelegate().orderId != nil{
            self.orderId = AppDelegate.sharedDelegate().orderId ?? 0
            AppDelegate.sharedDelegate().orderId = nil
            AppDelegate.sharedDelegate().fromNotification = false
        }
        //  self.lbl_thanks.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callCustomerOrderStatusApi()
    }
    
    @objc func click_callRestaurant(sender: UIButton) {
        if sender.tag == 0{
            if self.restaurantNumber.isEmpty == false{
                if let number = Int(self.restaurantNumber.replacingOccurrences(of: " ", with: ""))
                {
                    if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
                else{
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg: "Contact number seems not valid" , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
                }
            }else{
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg: "Contact number seems not valid" , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
            }
        }else{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "feedback_VC") as? feedback_VC{
                vc.restId = self.restId ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        if AppDelegate.sharedDelegate().fromNotification == false
        {
            if fromPayment == true{
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
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }else{
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
    
    func callCustomerOrderStatusApi(){
        APIManager.shared.request(with: LoginEndpoint.customerOrderStatus(TokenKey: CommonMethodsClass.getDeviceToken(), Order_Id: orderId)){[weak self] (response) in
            self?.handleCustomerOrderStatusResponse(response: response)
        }
    }
    
    func handleCustomerOrderStatusResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary{
                if let _ = dict.object(forKey: Keys.message.rawValue) as? String{
                    if let Order_Status = dict.object(forKey: "Order_Status") as? NSDictionary{
                        if let preStatus = Order_Status.object(forKey: "IsPreOrder") as? Bool{
                            preOrder = preStatus
                        }
                         tblVw.isHidden = false
                        if let orderStatus = Order_Status.object(forKey: "Order_Status") as? String{
                            print(orderStatus)
                            status = orderStatus
                            switch orderStatus{
                            case "Open":
                                self.selectedIndex = 0
                            case "Dispatch":
                                self.selectedIndex = 1
                            case "Delivered":
                                self.selectedIndex = 2
                            case "Reject":
                                self.selectedIndex = 0
                                self.isRejected = true
                            case "Pickup":
                                self.selectedIndex = 3
                            case "In-Kitchen":
                                self.selectedIndex = 4
                            default:
                                self.selectedIndex = 0
                            }
                            
                        }
                        if let timeLeft = Order_Status.object(forKey: "Delivery_Time_Left") as? String{
                            let s = timeLeft.components(separatedBy: ":")
                            
                            if  s.count > 0{
                                let t = s[0]
                                if let temp = Int(t){
                                    
                                    if temp == 0 {
                                        time = 1.0
                                        originalTime = 0
                                    }else{
                                        // let test =  Double(15/86400)
                                        originalTime = Double(t) ?? 0
                                        if originalTime > 0{
                                            let r = 1 - (Double(originalTime)/Double(60))
                                            if  r > 0{
                                                originalTime = Double(r)
                                            }else{
                                                originalTime = 0
                                            }
                                        }else{
                                            
                                            time = Double(originalTime)
                                        }
                                    }
                                }
                            }
                        }
                        self.tblVw.reloadData()
                    }
                }
            }
            
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
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
    
}

//MARK:- table view methods

extension OrderStatus_VC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == 2{
            if indexPath.row == 2{
                return 150
            }
            return 75
            
        }else  if selectedIndex == 1{
            if indexPath.row == 1{
                return 150
            }
            return 75
            
        }else  if selectedIndex == 4{
            if indexPath.row == 0{
                return 150
            }
            return 75
            
        }
        return 150
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedIndex == 0 {
            if isRejected == false{
                return 2
            }
            return 1
        }else if selectedIndex == 2 || selectedIndex == 1 || selectedIndex == 4{
            return 3
        }
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_orderStatus") as! TableCell_orderStatus
        cell.selectionStyle = .none
        
        cell.vw_line.isHidden = false
        cell.lbl_title.numberOfLines = 0
        cell.imgVw.isHidden = true
        cell.vw_graph.isHidden = false
        cell.vw_graph.arcBackgroundColor = .lightGray
        cell.vw_graph.arcColor = #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
        cell.vw_graph.arcWidth = 5.0
        cell.vw_graph.backgroundColor = .clear
        cell.lbl_minLeft.isHidden = false
        cell.lbl_MinCount.isHidden = false
        // self.lbl_thanks.isHidden = true
        cell.lbl_minLeft.setTitle("Minutes\nLeft", for: .normal)
        cell.lbl_minLeft.titleLabel?.textAlignment = .center
        cell.minCountheight.constant = 25
        if indexPath.row <= selectedIndex{
            cell.vw_circle.backgroundColor =  #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
            cell.lbl_title.textColor =  #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
        }else{
            cell.vw_circle.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.lbl_title.textColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if self.selectedIndex == 0 {
            cell.lbl_title.text = isRejected ? "Your Order is Rejected":"Your order has been sent to the restaurant."
            if isRejected == false{
                cell.vw_line.isHidden = true
                if indexPath.row == 1{
                    if time == 0{
                        cell.lbl_title.text =  "Your Order is ready for pickup"
                    }else{
                        cell.lbl_title.text = "You will get your order soon"
                    }
                }
                else if indexPath.row == 0{
                    cell.vw_line.isHidden = false
                }
                
                if status.lowercased() != "open"{
                    cell.vw_graph.endArc = CGFloat(time)
                    if originalTime > 0{
                        cell.lbl_MinCount.setTitle("\(Int(originalTime/86400))", for: .normal)
                    }else{
                        cell.lbl_MinCount.isHidden  = true
                        cell.vw_graph.endArc = 0
                        cell.minCountheight.constant = 0
                        cell.lbl_MinCount.setTitle(nil, for: .normal)
                        cell.lbl_minLeft.setTitle("Order is\n Ready!", for: .normal)
                    }
                }else{
                    cell.lbl_MinCount.isHidden  = true
                    cell.vw_graph.endArc = 0
                    cell.minCountheight.constant = 0
                    cell.lbl_MinCount.setTitle(nil, for: .normal)
                    cell.lbl_minLeft.setTitle("Request\nsent!", for: .normal)
                }
                if indexPath.row == 1{
                    cell.lbl_MinCount.isHidden = true
                    cell.lbl_minLeft.isHidden = true
                    cell.vw_graph.isHidden = true
                }else{
                    cell.vw_graph.isHidden = false
                    cell.lbl_MinCount.isHidden = false
                    cell.lbl_minLeft.isHidden = false
                }
            }else{
                cell.imgVw.isHidden = true
                cell.lbl_minLeft.isHidden = false
                cell.lbl_MinCount.isHidden = true
                  cell.vw_line.isHidden = true
                // self.lbl_thanks.isHidden = true
                cell.vw_graph.endArc = 0
                cell.lbl_MinCount.isHidden  = true
                cell.minCountheight.constant = 0
                cell.lbl_MinCount.setTitle(nil, for: .normal)
                cell.lbl_minLeft.setTitle("Order\nrejected!", for: .normal)
            }
            
        }else if self.selectedIndex == 1{
            cell.imgVw.isHidden = true
            cell.vw_circle.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
            cell.lbl_title.textColor = #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
            cell.vw_graph.endArc = CGFloat(time)
            cell.lbl_minLeft.isHidden = true
            cell.vw_graph.isHidden = true
            cell.vw_line.isHidden = false
            if originalTime > 0{
                cell.lbl_MinCount.setTitle("\(originalTime)", for: .normal)
            }else{
                cell.lbl_MinCount.isHidden  = true
                cell.minCountheight.constant = 0
                cell.lbl_MinCount.setTitle(nil, for: .normal)
                cell.lbl_minLeft.setTitle("Order is\n Ready!", for: .normal)
            }
            if indexPath.row == 0{
                cell.lbl_title.text = "Your order is confirmed and currently preparing"
                cell.vw_line.isHidden = false
                
            }else  if indexPath.row == 1{
                cell.vw_graph.isHidden = false
                cell.lbl_minLeft.isHidden = false
                cell.lbl_title.text = "Your order is on the way"
                cell.vw_line.isHidden = false
            } else{
                cell.vw_circle.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_title.text = "Your order is delivered"
                cell.vw_line.isHidden = true
            }
           // cell.lbl_title.text = "Your Order is on the way"
        }else if self.selectedIndex == 2{
            cell.imgVw.isHidden = true
            cell.lbl_minLeft.isHidden = true
            cell.lbl_MinCount.isHidden = true
            // self.lbl_thanks.isHidden = false
            cell.vw_graph.isHidden = true
            cell.vw_line.isHidden = true
            if indexPath.row == 0{
                 cell.lbl_title.text = "Your order is confirmed and currently preparing"
                 cell.vw_line.isHidden = false
            }else  if indexPath.row == 1{
               
                cell.lbl_title.text = "Your order is on the way"
                cell.vw_line.isHidden = false
            } else{
                cell.lbl_title.text = "Your order is delivered"
                cell.imgVw.isHidden = false
            }
           
        }else if self.selectedIndex == 3{
            cell.imgVw.isHidden = true
            cell.lbl_title.text = "Order is ready.Please collect it."
            cell.vw_graph.endArc = CGFloat(time)
            if originalTime > 0{
                cell.lbl_MinCount.setTitle("\(originalTime)", for: .normal)
            }else{
                cell.lbl_MinCount.isHidden  = true
                cell.minCountheight.constant = 0
                cell.lbl_MinCount.setTitle(nil, for: .normal)
                cell.lbl_minLeft.setTitle("Order is\n Ready!", for: .normal)
            }
        }
        else if self.selectedIndex == 4{
            cell.imgVw.isHidden = true
            cell.vw_graph.isHidden = true
            cell.vw_line.isHidden = false
            cell.vw_circle.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
            cell.lbl_title.textColor = #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
            cell.lbl_minLeft.isHidden = false
            cell.lbl_title.text = preOrder ? "Order is confirmed And will be delivered on scheduled time." : "Your Order is confirmed and currently preparing"
            cell.vw_graph.endArc = CGFloat(time)
            cell.vw_graph.isHidden = true
            if originalTime > 0{
                cell.lbl_MinCount.setTitle("\(originalTime)", for: .normal)
            }else{
                cell.lbl_MinCount.isHidden  = true
                cell.minCountheight.constant = 0
                cell.lbl_MinCount.setTitle(nil, for: .normal)
                cell.lbl_minLeft.setTitle("Order is\n Ready!", for: .normal)
            }
            if indexPath.row == 0{
                
                cell.vw_graph.isHidden = false
                cell.lbl_title.text = preOrder ? "Order is confirmed And will be delivered on scheduled time." : "Your Order is confirmed and currently preparing"
               
            }else  if indexPath.row == 1{
                cell.lbl_title.text = "Your order is on the way"
                cell.vw_circle.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                 cell.lbl_minLeft.isHidden = true
                
            } else{
                cell.lbl_title.text = "Your order is delivered"
                cell.vw_line.isHidden = true
                cell.vw_circle.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                cell.lbl_title.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                 cell.lbl_minLeft.isHidden = true
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.frame.size.height/2
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderStatus_headerCell") as! OrderStatus_headerCell
        if self.selectedIndex == 2{
            cell.lbl_thanks.isHidden = false
            cell.btn_call.setTitle("Give Feedback", for: .normal)
            cell.btn_call.tag = 1
        }else{
            cell.lbl_thanks.isHidden = true
            cell.btn_call.setTitle("Call Restaurant", for: .normal)
            cell.btn_call.tag = 0
        }
        cell.btn_call.addTarget(self, action: #selector(click_callRestaurant(sender:)), for: .touchUpInside)
        return cell
    }
}



