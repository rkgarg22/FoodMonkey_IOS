//
//  RestaurantMenuVC.swift
//  dem
//
//  Created by apple on 29/09/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

struct Section {
    var name: String
    var items: [Menu]
    var subItems : [Menu_Sub_Category]
    var collapsed: Bool
    
    init(name: String, items: [Menu], subItems : [Menu_Sub_Category], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.subItems = subItems
        self.collapsed = collapsed
    }
}

class RestaurantMenuVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var lbl_noData: UILabel!
    @IBOutlet weak var cons_tblView_bottom: NSLayoutConstraint!
    @IBOutlet weak var btnOutlet_checkout: UIButton!
    
    
    
    var items = [Section]()
    var Resturant_id = 0
    var model_restaurant : SpecificRestaurantListModal?
    var arrSelected = [AddOnItem]()
    var itemCount : Int?
    var itemPrice : Double?
    var subItems : [String]?
    var selectedItems = [Menu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.contentInset = UIEdgeInsets.init(top: 0
            , left: 0, bottom: 0, right: 0)
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.sectionHeaderHeight = 70
        tableView?.separatorStyle = .none
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.register(MenuItemsCell.nib, forCellReuseIdentifier: MenuItemsCell.identifier)
        tableView?.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.identifier)
        self.Resturant_id = (self.parent as? RestaurantMenuMXVC)?.Resturant_id ?? 0
        self.model_restaurant = (self.parent as? RestaurantMenuMXVC)?.model_restaurant
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var customerId : String?
        if let customer_id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            customerId = "\(customer_id)"
        }
        APIManager.shared.request(with: LoginEndpoint.restaurantDetails(TokenKey: CommonMethodsClass.getDeviceToken(), Resturant_id: self.Resturant_id,Customer_id: customerId)){[weak self] (response) in
            self?.handleRestaurantDetailsResponse(response: response)
        }
    }
    
    func handleRestaurantDetailsResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? RestaurantDetailsModal
            {
                if let code = dict.Code{
                    
                    if let msg = dict.Message{
                        if code == "200"{
                            self.model_restaurant = dict.Resturants?.Restaurant_Details![0]
                            if let arr = (self.parent as? RestaurantMenuMXVC)?.childViewControllers{
                                if arr.count > 1{
                                    if let vc = (self.parent as? RestaurantMenuMXVC)?.childViewControllers[1] as? RestaurantReviewsVC{
                                        
                                        if model_restaurant != nil{
                                            if let rating = model_restaurant?.AggregateFeedback{
                                                if let value =  Float(rating)
                                                {
                                                    vc.vwStarRating.value = CGFloat(value)
                                                    vc.lbl_StarRating.text = "\(value) / 5"
                                                }
                                            }
                                            if let reviews = model_restaurant?.NumberOfReviews{
                                                vc.lbl_numberReviews.text = "Based on the \(reviews) most recent reviews"
                                            }
                                        }
                                    }
                                }
                            }
                            if let arrMenuCategory = dict.Resturants?.Menu_Category{
                                self.items = []
                                for menuCategory in arrMenuCategory{
                                    var menus = [Menu]()
                                    if let menuCategoryName = menuCategory.Menu_Category_Name,let menusMain =  menuCategory.Menus{
                                        if let subMenu = menuCategory.Menu_Sub_Category{
                                            for i in subMenu{
                                                let menu = Menu()
                                                menu.SubCate_Info = i.SubCate_Info
                                                menu.Menu_Cate_Id = i.Menu_Cate_Id
                                                menu.Menu_Sub_Cate_Name = i.Menu_Sub_Cate_Name
                                                menu.Menu_Sub_Cate_Id = i.Menu_Sub_Cate_Id
                                                menu.Menus = i.Menus
                                                menus.append(menu)
                                            }
                                        }
                                        self.items.append(Section(name: menuCategoryName, items: menus + menusMain, subItems: menuCategory.Menu_Sub_Category ?? []))
                                    }
                                }
                                if arrMenuCategory.isEmpty{
                                    self.lbl_noData.isHidden = false
                                    self.tableView?.isHidden = true
                                    self.lbl_noData.text = "No menu found."
                                }else{
                                    self.lbl_noData.isHidden = true
                                    self.tableView?.isHidden = false
                                    self.tableView?.reloadData()
                                }
                              
                            }
                        }else{
                            
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                        }
                    }
                }
            }
            
        case .failure(let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    @IBAction func btnAction_checkout(_ sender: UIButton) {
        if let _ = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? String{
            let vc = StoryboardScene.Main.instantiateCheckOutAddress_VC()
            vc.addOnList = self.arrSelected ?? [AddOnItem]()
            vc.itemPrice = "\(self.itemPrice)"
            vc.itemCount = self.itemCount
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = StoryboardScene.Main.instantiateCheckOut_VC()
            vc.addOnList = self.arrSelected ?? [AddOnItem]()
            vc.itemPrice = self.itemPrice
            vc.itemCount = self.itemCount
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RestaurantMenuVC: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        if let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemsCell.identifier, for: indexPath) as? MenuItemsCell {
            let menu = item.items[indexPath.row]
            if let _ = item.items[indexPath.row].Menu_Sub_Cate_Id{
                if let subCatInfo = menu.SubCate_Info, subCatInfo != ""{
                    cell.cons_name_centerY.constant = -10
                }else{
                    cell.cons_name_centerY.constant = 0
                }
                cell.nameLabel?.text = menu.Menu_Sub_Cate_Name?.removeWhiteSpaces()
                cell.descLabel?.text = menu.SubCate_Info?.removeWhiteSpaces()
                cell.cons_imgVw_width.constant = 0
                cell.cons_imgVw_leading.constant = 0
                cell.priceLabel?.isHidden = true
                cell.pictureImageView?.isHidden = true
            }else{
                if let _ = menu.Menu_SubCategory_Id{
                    cell.cons_imgVw_leading.constant = 40
                }else{
                    cell.cons_imgVw_leading.constant = 20
                }
                cell.cons_imgVw_width.constant = 20
                cell.priceLabel?.isHidden = false
                cell.pictureImageView?.isHidden = false
                if let itemDesc = menu.Item_Desc, itemDesc != ""{
                    cell.cons_name_centerY.constant = -10
                }else{
                    cell.cons_name_centerY.constant = 0
                }
                cell.nameLabel?.text = menu.Item_Name?.removeWhiteSpaces()
                cell.descLabel?.text = menu.Item_Desc?.removeWhiteSpaces()
                if menu.AddOn != nil{
                    if menu.AddOn!.count > 0{
                        cell.priceLabel?.isHidden = true
                    }else{
                        cell.priceLabel?.isHidden = false
                        cell.priceLabel?.text = "£\(String(describing: menu.Item_Price))"
                    }
                }
                else{
                    cell.priceLabel?.isHidden = false
                    cell.priceLabel?.text = "£\(String(describing: menu.Item_Price))"
                }
                menu.IsItemNonVeg == 1 ? (cell.pictureImageView?.image = #imageLiteral(resourceName: "nonveg-icon")) : (cell.pictureImageView?.image = #imageLiteral(resourceName: "veg-icon"))
            }
            
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
        return UITableViewCell()
    }
}

extension RestaurantMenuVC: UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addOns = self.items[indexPath.section].items[indexPath.row].AddOn ?? []
        
        var items = [Sections]()
        if addOns != []{
            items = [Sections(name: "Add Extras", items: addOns)]
        }else{
            items = []
        }
        let item = self.items[indexPath.section]
        let menu = item.items[indexPath.row]
        if let _ = menu.Menu_Sub_Cate_Id{
            var isAlreadyInserted = false
            let subItemMenus = self.items[indexPath.section].items[indexPath.row].Menus!
            for dInner in subItemMenus{
                let index = (self.items[indexPath.section].items.index{$0 === dInner})
                isAlreadyInserted = (index ?? 0) > 0 && index != Int(NSIntegerMax)
                if isAlreadyInserted {
                    break
                }
            }
            if isAlreadyInserted {
                miniMizeThisRows(subItemMenus, indexPath: indexPath)
            } else {
                var count: Int = indexPath.row + 1
                var arCells: [Any] = []
                for dInner in subItemMenus{
                    arCells.append(IndexPath(row: count, section: indexPath.section))
                    self.items[indexPath.section].items.insert(dInner, at: count)
                    count += 1
                }
                if let aCells = arCells as? [IndexPath] {
                    tableView.insertRows(at: aCells, with: .none)
                }
            }
        }else{
            var item = ""
            if  self.items[indexPath.section].subItems.count > indexPath.row{
                if let t  = self.items[indexPath.section].subItems[indexPath.row].Menu_Sub_Cate_Name{
                    if t != ""{
                        item = t
                    }
                }
            }
            if let test = self.items[indexPath.section].items[indexPath.row].Item_Name{
                if item != "" && item != test{
                    item = item + "\n" + test
                }else{
                    item =  test
                }
            }
            
            
            CommonMethodsClass.showAddToCartWithTwoCompletionhandlers(addOns: addOns, vc: self,itemId:self.items[indexPath.section].items[indexPath.row].Item_id ?? 0, itemName: item,itemPrice : self.items[indexPath.section].items[indexPath.row].Item_Price , items: items, completionSuccess: { (arrSelected,itemCount) in
                self.cons_tblView_bottom.constant = 20
                self.btnOutlet_checkout.isHidden = true
                self.selectedItems.append(self.items[indexPath.section].items[indexPath.row])
                if let arrSel = arrSelected{
                    self.arrSelected.append(contentsOf: arrSel)
                }
                var itmcount = 0
                var pricee = 0.00
                var priceAddOn = 0.00
                var totalprice = 0.00
                for addOn in self.arrSelected{
                    if addOn.isItem == false{
                        itmcount += addOn.Addon_quantity
                        priceAddOn += Double(addOn.Addon_price)!.rounded(toPlaces: 2)
                        totalprice += (Double(addOn.Addon_price)!.rounded(toPlaces: 2) * Double(addOn.Addon_quantity).rounded(toPlaces: 2))
                    }else{
                        itmcount += addOn.Addon_quantity
                        pricee += Double(addOn.Addon_price)!.rounded(toPlaces: 2)
                        totalprice += (Double(addOn.Addon_price)!.rounded(toPlaces: 2) * Double(addOn.Addon_quantity).rounded(toPlaces: 2))
                    }
                }
                self.itemPrice = pricee
                self.itemCount = itmcount
//                if let discount = self.model_restaurant?.DiscountOffer{
//                    var value = Double(discount) * 0.01
//                    totalprice = totalprice - value
//                }
                (self.parent as? RestaurantMenuMXVC)?.setupNavigationItems(checkout: true,items: itmcount ,price: String(format: "%.2f", totalprice))
                
            }) { (success) in
                
            }
            
        }
        
    }
    
    func miniMizeThisRows(_ ar: [Menu], indexPath:IndexPath) {
        for dInner in ar {
            let indexToRemove = (self.items[indexPath.section].items.index{$0 === dInner})
            if (self.items[indexPath.section].items.index{$0 === dInner}) != NSNotFound {
                self.items[indexPath.section].items = self.items[indexPath.section].items.filter({ ($0) !== (dInner) })
                self.tableView?.deleteRows(at: [IndexPath(row: indexToRemove ?? 0, section: indexPath.section)], with: .none)
            }
        }
    }
}

extension RestaurantMenuVC: HeaderViewDelegate {
    func toggleSection(header: HeaderView, section: Int) {
        // Toggle collapse
        let collapsed = !items[section].collapsed
        items[section].collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        // Adjust the number of the rows inside the section
        self.tableView?.beginUpdates()
        self.tableView?.reloadSections([section], with: .fade)
        self.tableView?.endUpdates()
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
