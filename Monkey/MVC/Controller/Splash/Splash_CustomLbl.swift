//
//  Splash_CustomLbl.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class Splash_CustomLbl: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let str = CommonMethodsClass.addBoldText(fullString: SplashString.descStr_splash0.rawValue as NSString, boldPartOfString: [SplashString.boldStr1_splash0.rawValue as NSString,SplashString.boldStr2_splash0.rawValue as NSString,SplashString.boldStr3_splash0.rawValue as NSString,SplashString.boldStr4_splash0.rawValue as NSString], font:UIFont.init(name: FontName.RawlineLight.rawValue, size: 22.0) , boldFont: UIFont.init(name: FontName.RawlineExtraBold.rawValue, size: 22.0))
        self.attributedText = str
    }

}
