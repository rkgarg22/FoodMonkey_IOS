//
//  AddToCartVC.swift
//  Monkey
//
//  Created by apple on 19/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
 struct Sections {
    var name: String
    var items: [AddOnItem]
    var collapsed: Bool
    
     init(name: String, items: [AddOnItem], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

class AddToCartVC: UIViewController {

    @IBOutlet weak var cons_animatableVwHt: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblHeader: UIView!
    @IBOutlet weak var tblFooter: UIView!
    @IBOutlet weak var vw_outer: UIView!
    @IBOutlet weak var btn_minus: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var btnCount: UIButton!
    @IBOutlet weak var lbl_itemName: UILabel!
    
    var selectedItem = ""
    var items = [Sections]()
    var arrAddOn = [AddOnItem]()
    var arrSelected = [AddOnItem]()
    var completionHandlerAlertCancel: (()->Void)?
    var completionHandleraddToCart: (()->Void)?
    var count = 0
    var addOns = [AddOnItem]()
    var itemName: String?
    var itemPrice: String?
    var ItemId = 0
    var model_restaurant : SpecificRestaurantListModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vw_outer.layer.borderColor = UIColor.darkGray.cgColor
        self.btn_minus.addBorderRight(size: 0.5, color: .darkGray)
        self.btn_add.addBorderLeft(size: 0.5, color: .darkGray)
        self.tblView.register(AddOnItemCell.nib, forCellReuseIdentifier: AddOnItemCell.identifier)
        self.tblView.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        self.tblView.sectionHeaderHeight = 70
        self.tblView.tableHeaderView = tblHeader
        self.tblView.tableFooterView = tblFooter
        count = Int(btnCount.titleLabel?.text! ?? "") ?? 0
        self.arrAddOn = addOns
        self.lbl_itemName.text = self.itemName
        if self.arrAddOn.isEmpty{
            self.cons_animatableVwHt.constant = CGFloat(172 + (self.arrAddOn.count * 40))
        }else{
            self.cons_animatableVwHt.constant = CGFloat(172 + (70 + (self.arrAddOn.count * 40)))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @IBAction func btnAction_cancel(_ sender: UIButton) {
        CommonMethodsClass.okBtnForAddToCartCancelHandler()
    }
    @IBAction func btnAction_addToCart(_ sender: UIButton) {
        self.arrSelected.removeAll()
        for i in self.arrAddOn{
            if i.isSelected == true{
                i.Addon_quantity = count
               
                arrSelected.append(i)
            }
        }
        if self.arrAddOn.count == 0{
            let addOn = AddOnItem()
            addOn.Addon_name = self.lbl_itemName.text ?? ""
            addOn.Addon_quantity = self.count
            addOn.Item_id = self.ItemId
            addOn.Addon_Id = self.ItemId
            addOn.isItem = true
            addOn.Addon_price = self.itemPrice ?? "0"
            self.arrSelected.append(addOn)
        }
    
        completionHandleraddToCart!()
        CommonMethodsClass.okBtnForAddToCartCancelHandler()
    }
    @IBAction func btnAction_increment(_ sender: UIButton) {
        if count != 99{
            count += 1
            self.btnCount.setTitle("\(count)", for: .normal)
        }
    }
    @IBAction func btnAction_decrement(_ sender: UIButton) {
        if count != 1{
            count -= 1
            self.btnCount.setTitle("\(count)", for: .normal)
        }
    }
    
}

extension AddToCartVC : UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = items[section]
        guard item.collapsed else {
            return item.items.count
        }
        
        if item.collapsed {
            return 0
        } else {
            return item.items.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        if let cell = tableView.dequeueReusableCell(withIdentifier: AddOnItemCell.identifier, for: indexPath) as? AddOnItemCell {
            let menu = item.items[indexPath.row]
            cell.nameLabel?.text = menu.Addon_name
            cell.lbl_price.text = "£\(menu.Addon_price)"
            if arrSelected.contains(where: {$0.Addon_Id == menu.Addon_Id}){
                menu.isSelected = true
                cell.pictureImageView?.image = #imageLiteral(resourceName: "Radio-button1")
            }else{
                menu.isSelected = false
                cell.pictureImageView?.image = #imageLiteral(resourceName: "Radio-button2")
            }
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as? HeaderView {
            let item = items[section]
            headerView.titleLabel?.text = item.name
            headerView.setCollapsed(collapsed: item.collapsed)
            headerView.section = section
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: footerView.frame.height, width: tableView.frame.width - 2 * tableView.separatorInset.left, height: 1))
        separatorView.backgroundColor = UIColor.separatorColor
        footerView.addSubview(separatorView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AddOnItemCell{
            if cell.pictureImageView?.image == #imageLiteral(resourceName: "Radio-button2"){
                self.arrAddOn[indexPath.row].isSelected = true
                cell.pictureImageView?.image = #imageLiteral(resourceName: "Radio-button1")
            }else{
                self.arrAddOn[indexPath.row].isSelected = false
                cell.pictureImageView?.image = #imageLiteral(resourceName: "Radio-button2")
            }
        }
    }
}

extension AddToCartVC : HeaderViewDelegate{
    func toggleSection(header: HeaderView, section: Int) {
        // Toggle collapse
        let collapsed = !items[section].collapsed
        items[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the number of the rows inside the section
        UIView.performWithoutAnimation {
        self.tblView.beginUpdates()
        if collapsed == false{
            self.cons_animatableVwHt.constant = CGFloat(172 + (70 + (self.arrAddOn.count * 40)))
        }else{
            self.cons_animatableVwHt.constant = CGFloat(172 + 70)
        }
        self.tblView.reloadSections([section], with: .none)
        self.tblView.endUpdates()
        }
    }
}
