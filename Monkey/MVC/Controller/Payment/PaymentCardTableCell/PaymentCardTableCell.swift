//
//  PaymentCardTableCell.swift
//  Monkey
//
//  Created by apple on 26/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class PaymentCardTableCell: UITableViewCell {

    @IBOutlet weak var imgVw_card: UIImageView!
    @IBOutlet weak var btnOutlet_selectCard: UIButton!
    @IBOutlet weak var lbl_visaNoExpiry: UILabel!
    @IBOutlet weak var btnOutlet_arrow: UIButton!
    @IBOutlet weak var tf_cvv: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
