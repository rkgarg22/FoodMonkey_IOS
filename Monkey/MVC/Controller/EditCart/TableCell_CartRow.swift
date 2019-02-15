//
//  TableCell_CartRow.swift
//  Monkey
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class TableCell_CartRow: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    @IBOutlet weak var btn_minus: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var btn_count: UIButton!
    @IBOutlet weak var vw_outer: UIView!
   
    @IBOutlet weak var lbl_quantity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
