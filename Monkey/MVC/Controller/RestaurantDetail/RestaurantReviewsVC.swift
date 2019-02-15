//
//  RestaurantReviewsVC.swift
//  dem
//
//  Created by apple on 02/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import HCSStarRatingView



class RestaurantReviewsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var vwStarRating: HCSStarRatingView!
    @IBOutlet weak var lbl_StarRating: UILabel!
    @IBOutlet weak var lbl_numberReviews: UILabel!
    @IBOutlet weak var lbl_noData: UILabel!
    
    var Resturant_id = 0
    var arrFeedback = [Resturant_Feedback_List]()
    var model_restaurant : SpecificRestaurantListModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.tableFooterView = UIView()
        tblView.estimatedRowHeight = 120
        tblView.rowHeight = UITableViewAutomaticDimension
        self.Resturant_id = (self.parent as? RestaurantMenuMXVC)?.Resturant_id ?? 0
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIManager.shared.request(with: LoginEndpoint.restaurantFeedback(TokenKey: CommonMethodsClass.getDeviceToken(), Resturant_id: self.Resturant_id)){[weak self] (response) in
            self?.handleRestaurantFeedbackResponse(response: response)
        }
    }
    
    func handleRestaurantFeedbackResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? RestaurantFeedbackModal
            {
                if let code = dict.Code{
                    
                    if let msg = dict.Message{
                        if code == "200"{
                            self.arrFeedback = []
                            if let arrFeedbackList = dict.Resturant_Feedback_List{
                                self.arrFeedback = arrFeedbackList
                            }
//                            if let reviews = dict.Resturant_Feedback_List{
//                                lbl_numberReviews.text = "Based on the \(reviews.count) most recent reviews"
//                            }
                            if arrFeedback.isEmpty{
                                self.lbl_noData.isHidden = false
                                self.tblView.isHidden = true
                                self.lbl_noData.text = "No reviews found."
                            }else{
                                self.lbl_noData.isHidden = true
                                self.tblView.isHidden = false
                                self.tblView.reloadData()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrFeedback.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewCell
        let modal = self.arrFeedback[indexPath.row]
        cell.lbl_name.text = modal.Customer_Name
        if let dateStr = modal.Rating_Date{
            cell.lbl_date.text = CommonMethodsClass.removeTime(dateString: dateStr)
        }
        cell.lbl_review.text = modal.Comments
        if let numberOfStars = modal.Number_Of_Stars{
            cell.vw_starRating.value = CGFloat(Float(numberOfStars)!)
        }
        cell.vw_starRating.isEnabled = false
        cell.selectionStyle = .none
        return cell
    }
}



import HCSStarRatingView
class ReviewCell:UITableViewCell{
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var vw_starRating: HCSStarRatingView!
    @IBOutlet weak var lbl_review: UILabel!
    
}
