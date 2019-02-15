//
//  Filter_VC.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import CoreLocation

enum FilterRestaurants{
    case open
    case preorder
    case closed
}

struct Restaurant{
    var title : String?
    var array : [SpecificRestaurantListModal]?
    var type: FilterRestaurants?
}

enum DeliveryOptions: String{
    case All
    case Delivery
    case Collection
    case Takeaway_Collection
}

enum ListBy: String{
    case BestMatch = "Best match"
    case Distance
    case New
    case AvgRating = "Avg. rating"
    case A_Z = "A-Z"
}

class Filter_VC: UIViewController,UIPopoverPresentationControllerDelegate, FilterResult {
    @IBOutlet weak var ht_view_constrnt: NSLayoutConstraint!
    
    @IBOutlet weak var lbl_central: UILabel!
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var button_cuisinesFilter: UIButton!
    @IBOutlet weak var button_listBy: UIButton!
    @IBOutlet weak var button_deliveryOptions: UIButton!
    @IBOutlet weak var button_search: UIButton!
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var button_back: UIButton!
    @IBOutlet weak var lbl_noData: UILabel!
    @IBOutlet weak var lbl_cuisine: UILabel!
    @IBOutlet weak var lbl_list: UILabel!
    @IBOutlet weak var lbl_restCount: UILabel!
    
    var objRestaurantList : RestaurantListModal?
    var cuisineList : [Cuisine]?
    let objModal = FilterModal()
    var filterVC:FilterTableVC = FilterTableVC()
    var arr = [Restaurant]()
    var postalCode = ""
    var searchText = ""
    var Cuisine_Name = ""
    var List_By = ""
    var Delivery_option = ""
    var totalCount = 0
    var fromSeeMore = false
    var pageNumber = 0
    var locationEnabled = false
    var fromRecentReview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        let imgVw = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 15))
        imgVw.contentMode = .scaleAspectFit
        imgVw.image = UIImage(named:"search")
        self.tf_search.rightView = imgVw
        self.tf_search.rightViewMode = .always
        tf_search.attributedPlaceholder = NSAttributedString(string: "Enter postcode", attributes: [NSForegroundColorAttributeName : UIColor.white])
        lbl_Title.text = self.searchText
        
        if fromSeeMore == true{
            if fromRecentReview == false{
                lbl_central.text = "Featured Restaurants"
            }else{
                lbl_central.text = "Recently Viewed"
            }
            tf_search.isHidden = true
            lbl_central.isHidden = false
            button_listBy.isHidden = true
            button_cuisinesFilter.isHidden = true
            button_deliveryOptions.isHidden = true
            button_search.isHidden = true
            ht_view_constrnt.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if fromSeeMore == false{
            callRestaurantList()
        }else{
            callHomeRestaurantApi()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- call home restaurant api
    
    func callHomeRestaurantApi()
    {
        var customerId : String?
        if let id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            customerId = "\(id)"
        }
        APIManager.shared.request(with: LoginEndpoint.homeRestaurant(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: customerId)){[weak self] (response) in
            self?.handleHomeRestaurantResponse(response: response)
        }
        
    }
    
    func handleHomeRestaurantResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? HomeRestaurantModal
            {
                if let code = dict.Code{
                    
                    if let msg = dict.Message{
                        if code == "200"{
                            if let restList = dict.Restutant_list{
                                //    self.objRestaurantList = restList
                                self.arr = []
                                if let Popular_Restaurants = restList.Popular_Restaurants as? [SpecificRestaurantListModal]{
                                    if Popular_Restaurants.count > 0{
                                        //  arr.append(RestaurantHome(title: "Popular Restaurants", array: Popular_Restaurants, type: .restaurant))
                                        arr.append(Restaurant(title: "Popular Restaurants", array: Popular_Restaurants, type: .open))
                                    }
                                }
                                //                                if let Viewed_Restaurants = restList.Viewed_Restaurants as? [SpecificRestaurantListModal]{
                                //                                    if Viewed_Restaurants.count > 0{
                                //                                        arr.append(RestaurantHome(title: "\(String(describing: Viewed_Restaurants.count)) restaurants taking pre-orders for later", array: Viewed_Restaurants, type: .recentlyViewed))
                                //                                    }
                                //                                }
                                //                                if let Ordered_Restaurants = restList.Ordered_Restaurants as? [SpecificRestaurantListModal]{
                                //                                    if Ordered_Restaurants.count > 0{
                                //                                        arr.append(RestaurantHome(title: "Ordered Restaurants", array: Ordered_Restaurants, type: .yourOrders))
                                //                                    }
                                //                                }
                                if (restList.Popular_Restaurants?.count == 0) && (restList.Viewed_Restaurants?.count == 0) && (restList.Ordered_Restaurants?.count == 0){
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
        //            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            self.lbl_noData.isHidden = false
            self.tblVw.isHidden = true
            self.lbl_noData.text = msg
            //            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    //MARK:- Call Restaurant List API -
    func callRestaurantList()
    {
        var searchBy = ""
        var postCode = ""
        if locationEnabled == false{
            searchBy = "Postcode"
            postCode = postalCode
        }else{
            searchBy = "Loction"
            postCode = searchText
        }
        
        if List_By.lowercased() == "avg. rating"{
            List_By =  "Avg_Rating"
        }else if List_By.lowercased() == "a-z"{
            List_By =  "A_Z"
        }
        if Delivery_option.isEmpty == false{
            if Delivery_option.lowercased() == "all"
            {
                Delivery_option = ""
            }
            else if Delivery_option.lowercased() == "collection"
            {
                Delivery_option = "Takeaway"
            }
            else if  Delivery_option.lowercased() == "delivery"
            {
                Delivery_option = "Delivery"
            }
            else{
                Delivery_option = "Takeaway_Delivery"
            }
        }
        
        
        APIManager.shared.request(with: LoginEndpoint.restaurantlist(TokenKey: CommonMethodsClass.getDeviceToken(), SearchBy: searchBy, PostCode: searchText, DeliveryOptions: Delivery_option, ListBy: List_By, Cuisines: Cuisine_Name, PageNumber: pageNumber, CallingChannel: ApiParmConstant.CallingChannel.rawValue)){[weak self] (response) in
            self?.handleRestaurantListResponse(response: response)
        }
    }
    
    func handleRestaurantListResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? RestaurantListMainModal
            {
                if let code = dict.Code{
                    
                    if let msg = dict.Message{
                        if code == "200"{
                            if let restList = dict.Restutant_list{
                                self.objRestaurantList = restList
                                if self.pageNumber == 0{
                                    self.arr = []
                                }
                                
                                if let open_resturant = restList.open_resturant as? [SpecificRestaurantListModal]{
                                    if open_resturant.count > 0{
                                        
                                        if pageNumber == 0{
                                            arr.append(Restaurant(title: "Open Restaurants", array: open_resturant, type: .open))
                                        }else{
                                            if let test = arr.index(where: {$0.type == .open}){
                                                var a = arr[test]
                                                for values in open_resturant{
                                                    a.array?.append(values)
                                                }
                                                self.arr[test] = a
                                            }else{
                                                arr.append(Restaurant(title: "Open Restaurants", array: open_resturant, type: .open))
                                            }
                                        }
                                        
                                    }
                                }
                                if let preorder_resturant = restList.preorder_resturant as? [SpecificRestaurantListModal]{
                                    if preorder_resturant.count > 0{
                                        if let n1 = restList.Preorder_resturants_number
                                        {
                                            if pageNumber == 0{
                                                arr.append(Restaurant(title: "\(String(describing: n1)) restaurants taking pre-orders for later", array: preorder_resturant, type: .preorder))
                                            }else{
                                                if let test = arr.index(where: {$0.type == .preorder}){
                                                    var a = arr[test]
                                                    for values in preorder_resturant{
                                                        a.array?.append(values)
                                                    }
                                                    self.arr[test] = a
                                                }else{
                                                    arr.append(Restaurant(title: "\(String(describing: n1)) restaurants taking pre-orders for later", array: preorder_resturant, type: .preorder))
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                if let close_resturant = restList.close_resturant as? [SpecificRestaurantListModal]{
                                    if close_resturant.count > 0{
                                        if pageNumber == 0{
                                            arr.append(Restaurant(title: "Closed Restaurants", array: close_resturant, type: .closed))
                                        }else{
                                            if let test = arr.index(where: {$0.type == .closed}){
                                                var a = arr[test]
                                                for values in close_resturant{
                                                    a.array?.append(values)
                                                }
                                                self.arr[test] = a
                                            }else{
                                                arr.append(Restaurant(title: "Closed Restaurants", array: close_resturant, type: .closed))
                                            }
                                        }
                                        
                                    }
                                }
                                
                                if (restList.Open_resturants_number == 0) && (restList.Preorder_resturants_number == 0) && (restList.Closed_resturants_number == 0){
                                    self.lbl_restCount.text = "0 restaurant"
                                    self.lbl_noData.isHidden = false
                                    self.tblVw.isHidden = true
                                    self.lbl_noData.text = "No restaurant found."
                                }else{
                                    totalCount = (restList.open_resturant?.count ?? 0) + (restList.preorder_resturant?.count ?? 0) + (restList.close_resturant?.count ?? 0)
                                    if totalCount < 300 {
                                        self.lbl_restCount.text = "All restaurants"
                                    }else{
                                        self.lbl_restCount.text = "\(totalCount) restaurants"
                                    }
                                    
                                    self.lbl_noData.isHidden = true
                                    self.tblVw.isHidden = false
                                    self.tblVw.reloadData()
                                    
                                }
                            }else{
                                self.lbl_noData.isHidden = false
                                self.tblVw.isHidden = true
                                self.lbl_noData.text = "No restaurant found."
                                //                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "No restaurant found." , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                                
                            }
                        }else{
                            self.lbl_noData.isHidden = false
                            self.tblVw.isHidden = true
                            self.lbl_noData.text = msg
                            //                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                        }
                    }
                }
            }
            
        case .failure(let msg):
            self.lbl_noData.isHidden = false
            self.tblVw.isHidden = true
            self.lbl_noData.text = msg
        //            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            self.lbl_noData.isHidden = false
            self.tblVw.isHidden = true
            self.lbl_noData.text = msg
            //            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    
    func openFilter(_ sender:UIButton,_ array:[String],_ filterType : FilterData,_ selectedIndex:IndexPath,_ restCountArray:[Int]? = nil){
        sender.backgroundColor = UIColor.AppColorRed
        self.filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterTableVC") as! FilterTableVC
        self.filterVC.delegate = self
        self.filterVC.filterType = filterType
        if let restCountArray = restCountArray{
            self.filterVC.restCountArray = restCountArray
        }
        objModal.filterType = filterType
        objModal.array = array
        self.filterVC.array = objModal.array
        self.filterVC.totalCount = self.totalCount
        switch objModal.filterType!{
        case .cuisines:
            self.filterVC.selectedIndex = objModal.selectedCuisine
        case .list:
            self.filterVC.selectedIndex = objModal.selectedListBy
        case .deliveryOption:
            self.filterVC.selectedIndex = objModal.selectedDeliveryOption
        }
        self.filterVC.modalPresentationStyle = .popover
        let height = array.count * Int(filterVC.tableView.rowHeight)
        filterVC.preferredContentSize = CGSize(width: 210, height: height)
        let popover: UIPopoverPresentationController = self.filterVC.popoverPresentationController!
        popover.permittedArrowDirections = .up
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        popover.delegate = self
        self.present(self.filterVC, animated: true, completion:nil)
    }
    
    //MARK:- Call Cuisines List API -
    func callCuisinesListApi(_ sender:UIButton){
        APIManager.shared.request(with: LoginEndpoint.cuisinesList(TokenKey: CommonMethodsClass.getDeviceToken())){[weak self] (response) in
            self?.handleCuisinesListResponse(response: response, sender)
        }
    }
    
    func handleCuisinesListResponse(response : Response, _ sender:UIButton){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? CuisinesModal{
                if let code = dict.Code{
                    if let msg = dict.Message{
                        if code == "200"{
                            if let cuisineList = dict.Cuisines_List{
                                self.cuisineList = []
                                if cuisineList.count > 0{
                                    self.cuisineList = cuisineList
                                    let cuisineAll = Cuisine(JSON: ["Cuisine_Id":0,"Cuisine_Name":"All Cuisines","Resturant_Count":0])
                                    self.cuisineList?.insertFirst(cuisineAll!)//append(cuisineAll!)
                                    let array = self.cuisineList?.compactMap{$0.Cuisine_Name}
                                    let restCountArray = self.cuisineList?.compactMap{$0.Resturant_Count}
                                    openFilter(sender,array ?? [],.cuisines,objModal.selectedCuisine,restCountArray)
                                }
                            }
                        }else{
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
                        }
                    }
                }
            }
            
        case .failure(let msg):
            //                self.lbl_noData.isHidden = false
            //                self.tblVw.isHidden = true
            //                self.lbl_noData.text = msg
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            //                self.lbl_noData.isHidden = false
            //                self.tblVw.isHidden = true
            //                self.lbl_noData.text = msg
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    
    // MARK: - ButtonActions
    @IBAction func buttonAction_cuisinesFilter(_ sender: UIButton) {
        callCuisinesListApi(sender)
    }
    @IBAction func buttonAction_ListBy(_ sender: UIButton) {
        let array = ["Best match","Distance","New","Avg. rating","A-Z"]
        openFilter(sender,array,.list,objModal.selectedListBy)
    }
    @IBAction func buttonAction_deliveyOptions(_ sender: UIButton) {
        let array = ["All","Delivery","Collection","Delivery + Collection"]
        openFilter(sender,array,.deliveryOption,objModal.selectedDeliveryOption)
    }
    
    @IBAction func buttonAction_search(_ sender: UIButton) {
        self.tf_search.isHidden = false
        self.tf_search.becomeFirstResponder()
    }
    @IBAction func buttonAction_back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle{
        return UIModalPresentationStyle.none
    }
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool{
        self.button_cuisinesFilter.backgroundColor = UIColor.AppColorPink
        self.button_listBy.backgroundColor = UIColor.AppColorPink
        self.button_search.backgroundColor = UIColor.AppColorPink
        self.button_deliveryOptions.backgroundColor = UIColor.AppColorPink
        return true
    }
    
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
    }
    
    func popoverDidEnd() {
        self.pageNumber = 0
        self.button_cuisinesFilter.backgroundColor = UIColor.AppColorPink
        self.button_listBy.backgroundColor = UIColor.AppColorPink
        self.button_search.backgroundColor = UIColor.AppColorPink
        self.button_deliveryOptions.backgroundColor = UIColor.AppColorPink
        switch objModal.filterType!{
        case .cuisines:
            if filterVC.selectedIndex != nil{
                objModal.selectedCuisine = filterVC.selectedIndex!
            }
            if let cuisineList = self.cuisineList{
                let newCuisineList = cuisineList.filter({$0.Cuisine_Name == filterVC.array[filterVC.selectedIndex?.row ?? 0]})
                if newCuisineList.count > 0{
                    if let name = newCuisineList[0].Cuisine_Name{
                        if name != "All Cuisines"{
                            self.Cuisine_Name = name
                        }else{
                            self.Cuisine_Name = ""
                        }
                        self.lbl_cuisine.text = name + " -"
                    }
                }
            }
        case .list:
            if filterVC.selectedIndex != nil{
                objModal.selectedListBy = filterVC.selectedIndex!
            }
            
            let value = filterVC.array[filterVC.selectedIndex?.row ?? 0]
            self.lbl_list.text = value
            self.List_By = value
            
        case .deliveryOption:
            
            objModal.selectedDeliveryOption = filterVC.selectedIndex ??  IndexPath.init(row: 0, section: 0)
            
            
            let value = filterVC.array[filterVC.selectedIndex?.row ?? 0]
            self.Delivery_option = DeliveryOptions(rawValue: value)?.rawValue ?? "Takeaway_Delivery"
            
        }
        self.callRestaurantList()
    }
    
}

//MARK:- table view methods

extension Filter_VC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // if arr[section].type != .open{
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        returnedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        label.font = UIFont(name: FontName.LatoRegular.rawValue, size: 17.0)
        label.textAlignment = .center
        label.text = arr[section].title
        label.textColor = .black
        returnedView.addSubview(label)
        return returnedView
        //  }
        // return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arr[section].type != .open{
            return 50.0
        }
        return 0.0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if self.arr.count == 0
        {
            return
        }
        let currentOffset: CGFloat = scrollView.contentOffset.y
        let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0
        {
            
            var total = 0
            if let restList = self.objRestaurantList
            {
                if let n = restList.Open_resturants_number
                {
                    total += n
                }
                if let n1 = restList.Preorder_resturants_number
                {
                    total += n1
                }
                if let n2 = restList.Closed_resturants_number
                {
                    total += n2
                }
                if (self.pageNumber / 10) <= total / 10{
                    self.pageNumber += 10
                    self.callRestaurantList()
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr[section].array?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arr[indexPath.section].type != .closed{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_RecentlyViewed") as! TableCell_RecentlyViewed
            if let item = arr[indexPath.section].array?[indexPath.row]{
                if let imageData = item.Image_Link{
                    if let index = imageData.range(of: "api/")?.upperBound {
                        let substring = imageData[index...]
                        let string = String(substring)
                        let urlString = APIConstants.basePath + string
                        cell.imgVw_pic?.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "rest-alvi"), options: .refreshCached, completed: nil)
                    }else{
                        cell.imgVw_pic.image = #imageLiteral(resourceName: "rest-alvi")
                    }
                }else{
                    cell.imgVw_pic.image = #imageLiteral(resourceName: "rest-alvi")
                }
                if let restname = item.Rest_Name{
                    cell.lbl_title.text = restname.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                if let numberOfReview = item.NumberOfReviews{
                    cell.lbl_rating.text = "(\(numberOfReview))"
                }
                if let cusineList = item.Cousine_List{
                    if item.IsHalal == 1{
                        cell.lbl_cuisineList.text = cusineList + ", Halal"
                    }
                    else{
                        cell.lbl_cuisineList.text = cusineList
                    }
                }
                
                if let delivery = item.Delivery{
                    cell.lbl_delivery.text = "£\(String(describing: delivery))"
                }
                if let deliveryOption = item.DeliveryOption{
                    if deliveryOption == "Takeaway"{
                        cell.imgVw_foodDelivery.image = #imageLiteral(resourceName: "bag")
                        cell.lbl_deliveryOption.text = "Collect Now"
                        cell.lbl_delivery.isHidden = true
                    }else{
                        cell.imgVw_foodDelivery.image = #imageLiteral(resourceName: "food-delivery")
                        if let delev = item.Delivery{
                            if let priceD = Float(delev)
                            {
                                if priceD > 0
                                {
                                    cell.lbl_deliveryOption.text = "Delivery:"
                                    cell.lbl_delivery.isHidden = false
                                }else{
                                    cell.lbl_deliveryOption.text = "Free Delivery"
                                    cell.lbl_delivery.isHidden = true
                                }
                            }else{
                                cell.lbl_deliveryOption.text = "Free Delivery"
                                cell.lbl_delivery.isHidden = true
                            }
                            
                        }else{
                            cell.lbl_deliveryOption.text = "Free Delivery"
                            cell.lbl_delivery.isHidden = true
                        }
                        
                    }
                }
                if let value = item.AggregateFeedback{
                    cell.vw_rating.value = CGFloat(Float(value)!)
                }
                cell.vw_rating.isEnabled = false
                
                if let minSpend = item.Min_Spend{
                    cell.lbl_minSpend.text = "£\(String(describing: minSpend))"
                }
                if let distance = item.Distance{
                    cell.btn_distance.setTitle(" \(String(describing: distance)) miles", for: .normal)
                }else{
                    cell.btn_distance.setTitle( " 0.0 miles", for: .normal)
                }
                if fromSeeMore == true{
                    cell.btn_distance.isHidden = true
                }else{
                    cell.btn_distance.isHidden = false
                }
//                if let latitude =  item.cordinate_latitude, let longitude =  item.cordinate_longitude{
//                    let location = CLLocation.init(latitude: latitude, longitude: longitude)
//                    if let loc1 = AppDelegate.sharedDelegate().userLocation{
//                        let distance = loc1.distance(from: location)
//                        let milesDistance : Float = Float(distance/1609.34)
//                        let d = String(format: "%.2f", milesDistance)
//                        cell.btn_distance.setTitle(" " + d + "miles", for: .normal)
//                    }
//
//                }
                if let discount = item.DiscountOffer{
                    if discount > 0{
                        cell.outerVw_discount.isHidden = false
                        cell.innerVw_discount.text = "\(String(describing: discount))% off"
                    }else{
                        cell.outerVw_discount.isHidden = true
                    }
                }else{
                    cell.outerVw_discount.isHidden = true
                }
                if item.IsSponsoredRest == 0{
                    cell.lbl_spnonser.isHidden = true
                }else{
                    cell.lbl_spnonser.isHidden = false
                }
            }
            cell.contentView.backgroundColor  = .clear
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_RecentlyViewed_Closed") as! TableCell_RecentlyViewed_Closed
            if let item = arr[indexPath.section].array?[indexPath.row]{
                if let imageData = item.Image_Link{
                    if let index = imageData.range(of: "api/")?.upperBound {
                        let substring = imageData[index...]
                        let string = String(substring)
                        let urlString = APIConstants.basePath + string
                        cell.imgVw_pic?.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "rest-alvi"), options: .refreshCached, completed: nil)
                    }else{
                        cell.imgVw_pic.image = #imageLiteral(resourceName: "rest-alvi")
                    }
                }else{
                    cell.imgVw_pic.image = #imageLiteral(resourceName: "rest-alvi")
                }
                if let restname = item.Rest_Name{
                    cell.lbl_title.text = restname.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                if let numberOfReview = item.NumberOfReviews{
                    cell.lbl_rating.text = "(\(numberOfReview))"
                }
                //cell.lbl_cuisineList.text = item.Cousine_List
                if let cusineList = item.Cousine_List{
                    if item.IsHalal == 1{
                        cell.lbl_cuisineList.text = cusineList + ",Halal"
                    }
                    else{
                        cell.lbl_cuisineList.text = cusineList
                    }
                }
                if let delivery = item.Delivery{
                    cell.lbl_delivery.text = "£\(String(describing: delivery))"
                }
                if let deliveryOption = item.DeliveryOption{
                   if deliveryOption == "Takeaway"{
                        (cell.imgVw_foodDelivery.image = #imageLiteral(resourceName: "bag"))
                        (cell.lbl_deliveryOption.text = "Collect Now")
                        cell.lbl_delivery.isHidden = true
                    }else{
                        (cell.imgVw_foodDelivery.image = #imageLiteral(resourceName: "food-delivery"))
                        (cell.lbl_deliveryOption.text = "Delivery:")
                        cell.lbl_delivery.isHidden = false
                    }
                    
                }
                if let value = item.AggregateFeedback{
                    cell.vw_rating.value = CGFloat(Float(value)!)
                }
                cell.vw_rating.isEnabled = false
                if let minSpend = item.Min_Spend{
                    cell.lbl_minSpend.text = "£\(String(describing: minSpend))"
                }
                if let distance = item.Distance{
                    let d = String(format: "%.2f", distance)
                    cell.btn_distance.setTitle( " " + d + "miles", for: .normal)
                }else{
                    cell.btn_distance.setTitle( " 0.0 miles", for: .normal)
                }
                if fromSeeMore == true{
                    cell.btn_distance.isHidden = true
                }else{
                    cell.btn_distance.isHidden = false
                }
                if let discount = item.DiscountOffer{
                    if discount > 0{
                        cell.outerVw_discount.isHidden = false
                        cell.innerVw_discount.text = "\(String(describing: discount))% off"
                    }else{
                        cell.outerVw_discount.isHidden = true
                    }
                }else{
                    cell.outerVw_discount.isHidden = true
                }
                if item.IsSponsoredRest == 0{
                    cell.lbl_spnonser.isHidden = true
                }else{
                    cell.lbl_spnonser.isHidden = false
                }
            }
            cell.imgVw_foodDelivery.setImageColor(color: .AppColorGray)
            cell.outerVw_discount.layer.borderColor = UIColor.lightGray.cgColor
            cell.btn_distance.imageView?.setImageColor(color: .lightGray)
            cell.btn_distance.isHidden = false
            cell.contentView.backgroundColor  = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if arr[indexPath.section].title?.lowercased() != "closed restaurants"{
            let vc = StoryboardScene.Main.instantiateRestaurantMenuMXVC()
            vc.fromSearch = true
            vc.Resturant_id = arr[indexPath.section].array?[indexPath.row].Rest_Id ?? 0
            vc.restName = arr[indexPath.section].array?[indexPath.row].Rest_Name ?? ""
            vc.distance = arr[indexPath.section].array?[indexPath.row].Distance ?? "0.0"
            self.navigationItem.title  = arr[indexPath.section].array?[indexPath.row].Rest_Name ?? ""
            if arr[indexPath.section].title?.lowercased().contains("restaurants taking pre-orders for later") == true{
                vc.preorderRest = true
            }else{
                AppDelegate.sharedDelegate().preOrder = false
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            AppDelegate.sharedDelegate().preOrder = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


extension Filter_VC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        locationEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tf_search.resignFirstResponder()
        // self.tf_search.isHidden = true
        postalCode = textField.text ?? ""
        searchText = textField.text ?? ""
        self.pageNumber = 0
        if postalCode.isEmpty == false{
            callRestaurantList()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tf_search.resignFirstResponder()
        // self.tf_search.isHidden = true
        return true
    }
}
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
