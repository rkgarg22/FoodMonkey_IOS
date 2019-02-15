//
//  CollectionCell_Home.swift
//  Monkey
//
//  Created by Apple on 24/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import HCSStarRatingView

class CollectionCell_Home: UICollectionViewCell {
    
   
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_seeMore: UIButton!
    @IBOutlet weak var vw_reviews: HCSStarRatingView!
    @IBOutlet weak var imgVW: UIImageView!
    @IBOutlet weak var lbl_reviews: UILabel!
    @IBOutlet weak var lbl_category: UILabel!
}
