//
//  TableCell_RecentlyViewed_Closed.swift
//  Monkey
//
//  Created by apple on 10/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import HCSStarRatingView

class TableCell_RecentlyViewed_Closed: UITableViewCell {

    @IBOutlet weak var imgVw_pic: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_rating: UILabel!
    @IBOutlet weak var btn_distance: UIButton!
    @IBOutlet weak var lbl_minSpend: UILabel!
    @IBOutlet weak var lbl_delivery: UILabel!
    @IBOutlet weak var lbl_spnonser: UILabel!
    @IBOutlet weak var vw_rating: HCSStarRatingView!
    @IBOutlet weak var outerVw_discount: UIView!
    @IBOutlet weak var innerVw_discount: UILabel!
    @IBOutlet weak var imgVw_foodDelivery: UIImageView!
    @IBOutlet weak var lbl_cuisineList: UILabel!
    @IBOutlet weak var lbl_deliveryOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.outerVw_discount.layer.borderWidth = 2
        self.outerVw_discount.layer.borderColor = UIColor.AppColorPink.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
