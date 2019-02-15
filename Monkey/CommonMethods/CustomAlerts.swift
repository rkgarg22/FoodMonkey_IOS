
//
//  CustomAlerts.swift
//  Wavelength
//
//  Created by Priya on 27/12/17.
//  Copyright © 2017 Priya. All rights reserved.
//

import UIKit

class CohostRemovalAlert: UIViewController
{
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var lblHeading : UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CommonMethodsClass.animatePresentView(yourView: self.view)
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        btnCancel.roundedButton()
        btnOther.roundedButton()

    }
  
}
class EventActionAlert: UIViewController
{
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnGoing: UIButton!
    @IBOutlet weak var btnInterested: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        CommonMethodsClass.animatePresentView(yourView: self.view)
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        btnCancel.roundedButton()
        btnGoing.roundedButton()

    }
}


class AttendeLeaveGropuAlert: UIViewController
{
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnInterested: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        CommonMethodsClass.animatePresentView(yourView: self.view)
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        btnCancel.roundedButton()
        btnInterested.roundedButton()
        
    }
}

