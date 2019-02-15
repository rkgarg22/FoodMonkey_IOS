//
//  TableCell_Settings.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class TableCell_Settings: UITableViewCell {

    @IBOutlet weak var lbl_serviceTax: UILabel!
    @IBOutlet weak var lbl_discount: UILabel!
    @IBOutlet weak var lbl_TotalTitle: UILabel!
    @IBOutlet weak var lbl_deliveryFee: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var lbl_totalAmount: UILabel!
    @IBOutlet weak var lbl_orderStatus: UILabel!
    @IBOutlet weak var lbl_DeliveryCharges: UILabel!
    
    @IBOutlet weak var imgVw_back: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
