//
//  RestaurantMenuMXVC.swift
//  dem
//
//  Created by apple on 02/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import MXSegmentedPager
import HCSStarRatingView
import CoreLocation

class RestaurantMenuMXVC: MXSegmentedPagerController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var imgVw_rest: UIImageView!
    @IBOutlet weak var lbl_restName: UILabel!
    @IBOutlet weak var lbl_isSponsored: UILabel!
    @IBOutlet weak var vw_starRating: HCSStarRatingView!
    @IBOutlet weak var lbl_reviewCount: UILabel!
    @IBOutlet weak var lbl_menuDesc: UILabel!
    @IBOutlet weak var imgVw_foodDelivery: UIImageView!
    @IBOutlet weak var lbl_deliveryOption: UILabel!
    @IBOutlet weak var lbl_deliveryPrice: UILabel!
    @IBOutlet weak var lbl_minSpendPrice: UILabel!
    @IBOutlet weak var btnOutlet_distance: UIButton!
    
    var Resturant_id = 0
    var model_restaurant : SpecificRestaurantListModal?
    var totalPrice = "0"
    var preorderRest = false
    var preOrderView = false
    var distance = ""
    var restName = ""
    var fromSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMXVC()
      //  Resturant_id = 154
//        headerView.isHidden = true
        let defaults :UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: ParamKeys.cartPrice.rawValue)
        defaults.removeObject(forKey: ParamKeys.cartItems.rawValue)
        defaults.removeObject(forKey: ParamKeys.cartArray.rawValue)
        setupNavigationItems(checkout: false)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupMXVC(){
        segmentedPager.backgroundColor = .white
        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.minimumHeight = 0
        segmentedPager.parallaxHeader.height = 140
        // Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = .white
        segmentedPager.segmentedControl.titleTextAttributes = [kCTForegroundColorAttributeName : UIColor.AppColorGray, kCTFontAttributeName : UIFont(name:FontName.LatoRegular.rawValue, size: 16)!]
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [kCTForegroundColorAttributeName : UIColor.AppColorPink, kCTFontAttributeName : UIFont(name: FontName.LatoRegular.rawValue, size: 16)!]
        segmentedPager.segmentedControl.selectionStyle = .textWidthStripe
        segmentedPager.segmentedControl.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
        segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.AppColorPink
        segmentedPager.segmentedControl.segmentWidthStyle = .fixed
        segmentedPager.segmentedControl.selectionIndicatorHeight = 2
        segmentedPager.bounces = false
        segmentedPager.segmentedControl.isHidden = true
        headerView.isHidden = true
        segmentedPager.delegate = self
    }
    
    func setupNavigationItems(checkout:Bool,items:Int = 0,price:String = "0.00"){
        let button = UIButton(type: .system)
        totalPrice = price
        button.setImage(UIImage(named:"cart"), for: .normal)
        checkout ? (button.setTitle("\(items)   |   £\(price)", for: .normal)) : (button.setTitle("0", for: .normal))
        button.titleLabel?.font =  UIFont(name: FontName.LatoRegular.rawValue, size: 18)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.sizeToFit()
        button.layer.cornerRadius = button.frame.height/2
        button.backgroundColor = UIColor.AppColorRed
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(self.cartClicked), for: .touchUpInside)
 
        
        let rightBarButton2 = UIBarButtonItem(customView: button)
      //  let rightBarButton1 = UIBarButtonItem(customView: button1)
        
     //   navigationItem.leftBarButtonItems = [rightBarButton1]
        navigationItem.rightBarButtonItems = [rightBarButton2]
        
//        if let item = self.navigationItem.leftBarButtonItem{
//            item.title = restName
//        }
        let desiredWidth = checkout ? 150.0 : 80.0
        let desiredHeight = 35.0
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(desiredWidth))
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat(desiredHeight))
        button.addConstraints([widthConstraint, heightConstraint])
    }
    
    @objc func searchClicked()
    {

    }
    
    @objc func cartClicked() {
        if let test = (self.childViewControllers[0] as? RestaurantMenuVC)?.arrSelected{
            if test.count > 0{
                let totalPrce = Float(totalPrice)
                let minSpent = Float((self.childViewControllers[0] as? RestaurantMenuVC)?.model_restaurant?.Min_Spend ?? "0")
                if totalPrce ?? 0.0 >= minSpent ?? 0.0{
                    if let _ = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
                        let vc = StoryboardScene.Main.instantiateCheckOutAddress_VC()
                        vc.addOnList = (self.childViewControllers[0] as? RestaurantMenuVC)?.arrSelected ?? [AddOnItem]()
                        vc.itemPrice = "\((self.childViewControllers[0] as? RestaurantMenuVC)?.itemPrice)"
                        vc.itemCount = (self.childViewControllers[0] as? RestaurantMenuVC)?.itemCount
                        vc.restaurantModel = (self.childViewControllers[0] as? RestaurantMenuVC)?.model_restaurant
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = StoryboardScene.Main.instantiateCheckOut_VC()
                        vc.addOnList = (self.childViewControllers[0] as? RestaurantMenuVC)?.arrSelected ?? [AddOnItem]()
                        vc.restaurantModel = self.model_restaurant
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "Total price must be greater or equal to minimum spend" , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                }
               
            }else{
                 CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "Please add items in cart first" , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
            }
        }else{
             CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "Please add items in cart first" , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
        }
        
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let items = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.cartItems.rawValue) as? Int , let price = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.cartPrice.rawValue) as? String, let array = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.cartArray.rawValue) as? [AddOnItem]{
            self.setupNavigationItems(checkout: true, items: items, price: price)
            (self.childViewControllers[0] as? RestaurantMenuVC)?.arrSelected = array
        }
        
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
                            if let arrRestaurant_Details = dict.Resturants?.Restaurant_Details{
                                let restDetail = arrRestaurant_Details[0]
                                model_restaurant = restDetail
                                self.lbl_restName.text = restDetail.Rest_Name?.trimmingCharacters(in: .whitespacesAndNewlines)
                                if let imageData = restDetail.Image_Link{
                                    if let index = imageData.range(of: "api/")?.upperBound {
                                        let substring = imageData[index...]
                                        let string = String(substring)
                                        let urlString = APIConstants.basePath + string
                                        self.imgVw_rest.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "rest-alvi"), options: .refreshCached, completed: nil)
                                    }else{
                                        self.imgVw_rest.image = #imageLiteral(resourceName: "rest-alvi")
                                    }
                                }else{
                                    self.imgVw_rest.image = #imageLiteral(resourceName: "rest-alvi")
                                }
                                restDetail.IsSponsoredRest == 1 ? (self.lbl_isSponsored.isHidden = false) : (self.lbl_isSponsored.isHidden = true)
                                if let value = restDetail.AggregateFeedback{
                                    self.vw_starRating.value = CGFloat(Float(value)!)
                                }
                                self.vw_starRating.isEnabled = false
                                if let minSpend = restDetail.Min_Spend{
                                    self.lbl_minSpendPrice.text = "£\(String(describing: minSpend))"
                                }
                               
                                if let numberOfReview = restDetail.NumberOfReviews{
                                    self.lbl_reviewCount.text = "(\(numberOfReview))"
                                }
                                var cuisineList = ""
                                if let cuisine1 = restDetail.Cousine1, cuisine1 != ""{
                                    cuisineList = cuisine1
                                    if let cuisine2 = restDetail.Cousine2, cuisine2 != ""{
                                        cuisineList += ", " + cuisine2
                                    }
                                }else if let cuisine2 = restDetail.Cousine2, cuisine2 != ""{
                                    cuisineList = cuisine2
                                }
                                self.lbl_menuDesc.text = cuisineList
                                if let delivery = restDetail.Delivery{
                                    self.lbl_deliveryPrice.text = "£\(String(describing: delivery))"
                                }
//                              //  if let distance = restDetail.Distance{
                                if fromSearch == true{
                                     self.btnOutlet_distance.isHidden = false
                                    self.btnOutlet_distance.setTitle(" \(String(describing: self.distance)) miles", for: .normal)
                                }else{
                                    self.btnOutlet_distance.isHidden = true
                                }
                                
//                                //}
//                                if let latitude = restDetail.cordinate_latitude, let longitude = restDetail.cordinate_longitude{
//                                    let location = CLLocation.init(latitude: latitude, longitude: longitude)
//                                    if let loc1 = AppDelegate.sharedDelegate().userLocation{
//                                        let distance = location.distance(from: loc1)
//                                        let milesDistance : Float = Float(distance/1609.34)
//                                        let d = String(format: "%.2f", milesDistance)
//                                        self.btnOutlet_distance.setTitle( " " + d + "miles", for: .normal)
//                                    }
//
//                                }
                                
                                if let deliveryOption = restDetail.DeliveryOption{
                                    if deliveryOption == "Takeaway"{
                                        self.imgVw_foodDelivery.image = #imageLiteral(resourceName: "bag")
                                        self.lbl_deliveryOption.text = "Collection"
                                        self.lbl_deliveryPrice.isHidden = true
                                        self.lbl_deliveryOption.text = "Collect Now"
                                    }else{
                                        (self.imgVw_foodDelivery.image = #imageLiteral(resourceName: "food-delivery"))
                                        if let delev = restDetail.Delivery{
                                            if let priceD = Float(delev)
                                            {
                                                if priceD > 0
                                                {
                                                    self.lbl_deliveryOption.text = "Delivery:"
                                                    self.lbl_deliveryPrice.isHidden = false
                                                }else{
                                                   self.lbl_deliveryOption.text = "Free Delivery"
                                                    self.lbl_deliveryPrice.isHidden = true
                                                }
                                            }else{
                                                self.lbl_deliveryOption.text = "Free Delivery"
                                                self.lbl_deliveryPrice.isHidden = true
                                            }
                                            
                                        }else{
                                            self.lbl_deliveryOption.text = "Free Delivery"
                                            self.lbl_deliveryPrice.isHidden = true
                                        }
                                    }
                                    
                                }
                                
                                if self.preOrderView == false{
                                    if self.preorderRest == true{
                                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PreOrder_VC") as? PreOrder_VC{
                                            vc.model_restaurant = self.model_restaurant
                                            self.preOrderView = true
                                            if let p = self.parent{
                                                p.addChildViewController(vc)
                                                self.beginAppearanceTransition(false, animated: true)
                                                p.view.addSubview(vc.view)
                                                vc.didMove(toParentViewController: p)
                                            }
                                            
                                        }
                                    }
                                }
                                self.headerView.isHidden = false
                                segmentedPager.segmentedControl.isHidden = false
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
}

    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        
        return ["Menu","Reviews","Info"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
        //print("progress \(parallaxHeader.progress)")
    }
    
}

extension RestaurantMenuMXVC : MXPagerViewDelegate{
    
    func pagerView(_ pagerView: MXPagerView, didMoveToPage page: UIView, at index: Int) {
        
    }
}
