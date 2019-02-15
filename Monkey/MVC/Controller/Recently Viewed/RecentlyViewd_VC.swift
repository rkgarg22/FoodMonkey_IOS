//
//  RecentlyViewd_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class RecentlyViewd_VC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblVw: UITableView!
    var arr = [SpecificRestaurantListModal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        tblVw.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        tblVw.separatorStyle = .none
        tblVw.separatorColor = .clear
        tblVw.allowsSelection = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
         self.navigationItem.title = "Recently Viewed"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_RecentlyViewed") as! TableCell_RecentlyViewed
        cell.contentView.backgroundColor  = .clear
        cell.selectionStyle = .none
    
        let item = arr[indexPath.row]
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
        //        if let distance = item.Distance{
        //            cell.btn_distance.setTitle(" \(String(describing: distance)) miles", for: .normal)
        //        }else{
        //            cell.btn_distance.setTitle( " 0.0 miles", for: .normal)
        //        }
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

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StoryboardScene.Main.instantiateRestaurantMenuMXVC()
        vc.Resturant_id = arr[indexPath.row].Rest_Id ?? 0
        vc.restName = arr[indexPath.row].Rest_Name ?? ""
        vc.preorderRest = false
        AppDelegate.sharedDelegate().preOrder = false
        self.navigationItem.title = arr[indexPath.row].Rest_Name ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
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

