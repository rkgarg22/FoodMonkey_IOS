//
//  HomeVC.swift
//  Monkey
//
//  Created by Apple on 23/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation

enum HomeSections: String{
    case restaurant = "Featured Restaurants"
    case recentlyViewed = "Recently Viewed"
    case yourOrders = "Your Orders"
}

struct RestaurantHome{
    var title : String?
    var array : [SpecificRestaurantListModal]?
    var type : HomeSections?
}

class HomeVC: UIViewController, CLLocationManagerDelegate, DelegateFromTwoActionAlert {
    
    @IBOutlet weak var navItem: UINavigationItem!
    var locationBtnPressed = false
    @IBOutlet weak var tblVw: UITableView!
    var locationEnabled = true
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var btn_search: UIButton!
    @IBOutlet weak var vw_outer: UIView!
    
    @IBOutlet weak var lbl_noData: UILabel!
    @IBOutlet weak var txtField_Search: UITextField!
    @IBOutlet weak var btn_location: UIButton!
    
    var arrHome = [RestaurantHome]()
    let locationManager = CLLocationManager()
    var postalCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        tblVw.separatorStyle = .none
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        if !self.isLocationServiceEnabled(){
            if CLLocationManager.authorizationStatus() != .notDetermined{
                CommonMethodsClass.showAlertWithTwoButton(msg: "Please enable location services for this app.", vc: self, btnOtherTitle: "Settings", btnCancelTitle: "Cancel")
            }
        }else{
            self.locationManager.startUpdatingLocation()
            Utility.shared.loader()
        }
        
        vw_outer.layer.borderColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.isHidden = false
        self.txtField_Search.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(done))
        
        if AppDelegate.sharedDelegate().fromNotification == true{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderStatus_VC") as? OrderStatus_VC{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func done(){
        self.txtField_Search.resignFirstResponder()
        let vc = StoryboardScene.Main.instantiateFilterController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         navigationItem.title = "Food Monkey"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController?.isNavigationBarHidden = false
        callHomeRestaurantApi()
        //        arrHome = [RestaurantHome(type: .restaurant),RestaurantHome(type: .recentlyViewed),RestaurantHome(type: .yourOrders)]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_sidemenu(_ sender: UIBarButtonItem) {
        let vc = StoryboardScene.Main.instantiateSlideNavigationController()
        SideMenuManager.default.menuLeftNavigationController = vc
        SideMenuManager.default.menuRightNavigationController = vc
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func btnAction_cross(_ sender: UIButton) {
        self.txtField_Search.text = ""
    }
    @IBAction func btnAction_search(_ sender: UIButton) {
        view.endEditing(true)
        let value = Validate()
        switch value {
        case .success:
            self.txtField_Search.resignFirstResponder()
            let vc = StoryboardScene.Main.instantiateFilterController()
            vc.postalCode = self.postalCode
            vc.locationEnabled = self.locationEnabled
            if let searchText = self.txtField_Search.text, searchText != ""{
                vc.searchText = searchText
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .failure(_, let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            
        }
    }
    
    //MARK: Validate
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(searchText:self.txtField_Search.text ?? "")
        
        return value
    }
    

    
    @IBAction func btnAction_location(_ sender: UIButton) {
        locationBtnPressed  = true
        locationManager.delegate = self
        if !self.isLocationServiceEnabled(){
            if CLLocationManager.authorizationStatus() != .notDetermined{
                CommonMethodsClass.showAlertWithTwoButton(msg: "Please enable location services for this app.", vc: self, btnOtherTitle: "Settings", btnCancelTitle: "Cancel")
            }
        }else{
            self.locationManager.startUpdatingLocation()
            Utility.shared.loader()
        }
    }
    
    func otherBtnPressed() {
        CommonMethodsClass.okBtnForTwoAlertHandler()
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            // If general location settings are enabled then open location settings for the app
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func cancelBtnPressed(){
        CommonMethodsClass.okBtnForTwoAlertHandler()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            break
        case .restricted:
            break
        case .denied:
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
        }
    }
    
    func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let latitude = locations.last?.coordinate.latitude, let longitude = locations.last?.coordinate.longitude{
            AppDelegate.sharedDelegate().userLocation = locations.last!
            Utility.shared.calculateAddress(lat: latitude, long: longitude, responseBlock: { (location, fullAddress, address, city, state, subLocality, postalCode) in
            if let postalCode = postalCode{
                if self.locationBtnPressed == true{
                    self.postalCode = postalCode
                    self.txtField_Search.text = postalCode
                    self.locationBtnPressed = false
                }
                self.locationManager.stopUpdatingLocation()
                Utility.shared.removeLoader()
            }else{
                Utility.shared.removeLoader()
            }
        })
        }
    }
    
    //MARK:- Call Restaurant List API -
    func callHomeRestaurantApi()
    {
         if let customerId = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int
         {
            APIManager.shared.request(with: LoginEndpoint.homeRestaurant(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: "\(customerId)")){[weak self] (response) in
                self?.handleHomeRestaurantResponse(response: response)
            }
         }else{
            
            APIManager.shared.request(with: LoginEndpoint.homeRestaurant(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: nil)){[weak self] (response) in
                self?.handleHomeRestaurantResponse(response: response)
            }
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
                                arrHome = []
                                if let Popular_Restaurants = restList.Popular_Restaurants as? [SpecificRestaurantListModal]{
                                    if Popular_Restaurants.count > 0{
                                        arrHome.append(RestaurantHome(title: "Popular Restaurants", array: Popular_Restaurants, type: .restaurant))
                                    }
                                }
                                if let Viewed_Restaurants = restList.Viewed_Restaurants as? [SpecificRestaurantListModal]{
                                    if Viewed_Restaurants.count > 0{
                                        arrHome.append(RestaurantHome(title: "\(String(describing: Viewed_Restaurants.count)) restaurants taking pre-orders for later", array: Viewed_Restaurants, type: .recentlyViewed))
                                    }
                                }
                                if let Ordered_Restaurants = restList.Ordered_Restaurants as? [SpecificRestaurantListModal]{
                                    if Ordered_Restaurants.count > 0{
                                        arrHome.append(RestaurantHome(title: "Ordered Restaurants", array: Ordered_Restaurants, type: .yourOrders))
                                    }
                                }
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
                                //                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "No restaurant found." , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                                
                            }
                        }else{
                            self.lbl_noData.isHidden = false
                            self.tblVw.isHidden = true
                            self.lbl_noData.text = msg
                            //                        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: /Users/apple/Desktop/Agam/MyProjects/FoodMonkey/FoodMonkey_IOS/Monkey/AppDelegatefalse, imgName: Images.succes.rawValue)
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

extension HomeVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrHome.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Home") as! TableCell_Home
        cell.parentNavController = self.navigationController
        cell.collectionView.tag = indexPath.row
        cell.arrHome = self.arrHome
        cell.lbl_title.text = arrHome[indexPath.row].type?.rawValue
        cell.btn_seeMore.isHidden = false
//        if self.arrHome.count > 2{
//            
//        }else{
//            cell.btn_seeMore.isHidden = true
//        }
        cell.btn_seeMore.tag = indexPath.row
        cell.btn_seeMore.addTarget(self, action: #selector(btnAction_seeMore), for: .touchUpInside)
        cell.setData()
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func btnAction_seeMore(_ sender:UIButton){
        if self.arrHome[sender.tag].type == .recentlyViewed{
            let vc = StoryboardScene.Main.instantiateRecentlyViewdController()
            vc.arr = self.arrHome[sender.tag].array ?? [SpecificRestaurantListModal]()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
            if self.arrHome[sender.tag].type == .yourOrders{
            let vc = StoryboardScene.Main.instantiateOrderController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.txtField_Search.resignFirstResponder()
            let vc = StoryboardScene.Main.instantiateFilterController()
            vc.postalCode = ""
         //   vc.searchText = "BD8 7SZ"
            vc.searchText =  ""
            vc.fromSeeMore = true
            if sender.tag == 1{
                vc.fromRecentReview = true
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension HomeVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        locationEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        let vc = StoryboardScene.Main.instantiateFilterController()
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = StoryboardScene.Main.instantiateFilterController()
        vc.postalCode = self.postalCode
        vc.locationEnabled = self.locationEnabled
        if let searchText = self.txtField_Search.text, searchText != ""{
            vc.searchText = searchText
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return true
    }
}
