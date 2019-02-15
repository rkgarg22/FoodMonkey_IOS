//
//  TableCell_ManageAdd.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class TableCell_ManageAdd: UITableViewCell {

    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_address: UILabel!
    @IBOutlet weak var btn_edit: UIButton!
    @IBOutlet weak var btn_delete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
