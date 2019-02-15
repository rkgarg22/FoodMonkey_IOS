//
//  TableCell_Order.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import HCSStarRatingView

class TableCell_Order: UITableViewCell {

    @IBOutlet weak var imgVw_pic: UIImageView!
    @IBOutlet weak var vwRating: HCSStarRatingView!
    @IBOutlet weak var lbl_review: UILabel!
    @IBOutlet weak var lbl_orderId: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_cuisines: UILabel!
    @IBOutlet weak var lbl_priceDesc: UILabel!
    @IBOutlet weak var lbl_Delivered: UILabel!
    @IBOutlet weak var btnOutlet_ViewDetail: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
