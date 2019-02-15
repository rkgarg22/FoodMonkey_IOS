//
//  EditCart_VC.swift
//  Monkey
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit


protocol quantityChangedDelegate
{
    func valueChanged(values:[AddOnItem])
}

protocol quantity1ChangedDelegate
{
    func valueChanged1(values:[AddOnItem])
}

class EditCart_VC: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    var addOnList = [AddOnItem]()
    var restaurantModel:SpecificRestaurantListModal?
    var lbl_Total :UILabel?
    var newSum = ""
    var quantityDelegate: quantityChangedDelegate?
    var quantity1Delegate: quantity1ChangedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.tableFooterView = UIView()
        tblVw.backgroundColor = .clear
        tblVw.separatorStyle = .none
        tblVw.separatorColor = .clear
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func barBtnAction_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAction_addItems(_ sender: UIButton) {
       let sum = self.addOnList.map({$0.Addon_quantity}).reduce(0, +)
        DBManager.setValueInUserDefaults(value: sum , forKey: ParamKeys.cartItems.rawValue)
        DBManager.setValueInUserDefaults(value: newSum , forKey: ParamKeys.cartPrice.rawValue)
        DBManager.setValueInUserDefaults(value: addOnList , forKey: ParamKeys.cartArray.rawValue)
        for controller in (self.navigationController?.viewControllers)!{
            if let controller = controller as? RestaurantMenuMXVC{
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func btnAction_done(_ sender: UIButton) {
        self.quantityDelegate?.valueChanged(values: self.addOnList)
        self.quantity1Delegate?.valueChanged1(values: self.addOnList)
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

extension EditCart_VC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_help") as! TableCell_help
        if let restaurantDetail = self.restaurantModel{
            cell.lbl_title.text  = restaurantDetail.Rest_Name?.capitalizedFirst()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Settings") as! TableCell_Settings
        var sum = 0.0
        for value in self.addOnList
        {
            let temp  = Double(value.Addon_price) ?? 0
            sum += Double(value.Addon_quantity) * temp
        }
        lbl_Total =  cell.lbl_subTitle
        let newSum = String(format: "%.2f", sum)
        self.newSum = newSum
        cell.lbl_subTitle.text = "£" + "\(newSum)"
        return cell
    }
    
    func tableView(_ tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addOnList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_CartRow") as! TableCell_CartRow
        cell.selectionStyle = .none
        cell.btn_add.tag = indexPath.row
        cell.btn_minus.tag = indexPath.row
        cell.vw_outer.layer.borderColor = UIColor.darkGray.cgColor
        cell.btn_minus.addBorderRight(size: 0.5, color: .darkGray)
        cell.btn_add.addBorderLeft(size: 0.5, color: .darkGray)
        cell.lbl_title.text = self.addOnList[indexPath.row].Addon_name.capitalizedFirst()
        cell.btn_count.setTitle("\(Int(self.addOnList[indexPath.row].Addon_quantity))", for: .normal)
        cell.lbl_subTitle.text = "£" + self.addOnList[indexPath.row].Addon_price
        cell.btn_minus.addTarget(self, action: #selector(clickMinus(_ :)), for: .touchUpInside)
        cell.btn_add.addTarget(self, action: #selector(clickAdd(_ :)), for: .touchUpInside)
        return cell
    }
    
    
    func clickMinus(_ sender: UIButton) {
        var count = self.addOnList[sender.tag].Addon_quantity
        
        if count != 0{
            count -= 1
            self.addOnList[sender.tag].Addon_quantity = count
            if let cell = tblVw.cellForRow(at: NSIndexPath.init(row: sender.tag, section: 0) as IndexPath) as? TableCell_CartRow{
                cell.btn_count.setTitle("\(count)", for: .normal)
            }
            
            var sum = 0.0
            for value in self.addOnList
            {
                let temp  = Double(value.Addon_price) ?? 0
                sum += Double(value.Addon_quantity) * temp
            }
            let newSum = String(format: "%.2f", sum)
            lbl_Total?.text = "£" + "\(newSum)"
            
            if count == 0{
                self.addOnList.remove(at: sender.tag)
                self.tblVw.reloadData()
            }
            
        }
    }
    
    func clickAdd(_ sender: UIButton) {
        var count = self.addOnList[sender.tag].Addon_quantity
        if count != 99{
            count += 1
            if let cell = tblVw.cellForRow(at: NSIndexPath.init(row: sender.tag, section: 0) as IndexPath) as? TableCell_CartRow{
                cell.btn_count.setTitle("\(count)", for: .normal)
            }
            self.addOnList[sender.tag].Addon_quantity = count
            var sum = 0.0
            for value in self.addOnList
            {
                let temp  = Double(value.Addon_price) ?? 0
                sum += Double(value.Addon_quantity) * temp
            }
            let newSum = String(format: "%.2f", sum)
            lbl_Total?.text = "£" + "\(newSum)"
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
