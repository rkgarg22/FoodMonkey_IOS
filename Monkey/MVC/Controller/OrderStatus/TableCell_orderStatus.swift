//
//  TableCell_orderStatus.swift
//  Monkey
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class TableCell_orderStatus: UITableViewCell {

    @IBOutlet weak var constrant_bottom: NSLayoutConstraint!
    @IBOutlet weak var minCountheight: NSLayoutConstraint!
    @IBOutlet weak var vw_graph: CircleGraphView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_minLeft: UIButton!
    @IBOutlet weak var lbl_MinCount: UIButton!
    @IBOutlet weak var vw_circle: UIView!
    @IBOutlet weak var vw_line: UIView!
    @IBOutlet weak var imgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
