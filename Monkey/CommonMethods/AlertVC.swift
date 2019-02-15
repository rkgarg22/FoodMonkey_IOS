
//
//  AlertVC.swift
//  TrophyCase
//
//  Created by Priya on 27/07/17.
//  Copyright © 2017 Priya. All rights reserved.
//

import UIKit
import IBAnimatable

protocol DelegateFromSingleAlert : class
{
    func donePressed(obj:AlertVC)
}


class AlertVC: UIViewController {

    @IBOutlet weak var imgAlert: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var vwAlert: AnimatableView!
    var delegateFrmSigleAlert :DelegateFromSingleAlert?
    var isDelegateReqiured : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        CommonMethodsClass.animatePresentView(yourView: self.view)
        
    }
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        btnOk.roundedButton()

    }
    
    //MARK - IBAction -
    
    @IBAction func btnCloseHandler(_ sender: Any) {
        
        if isDelegateReqiured
        {
            delegateFrmSigleAlert?.donePressed(obj: self)

        }
        else
        {
            CommonMethodsClass.okBtnForSingleAlertHandler()
        }
        
    }
    
}

protocol DelegateFromTwoActionAlert : class
{
    func otherBtnPressed()
}


class AlertWithTwoOptionVC: UIViewController {
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    @IBOutlet weak var lblMsg: UILabel!
   
    var delegateFrmTwoActionAlert :DelegateFromTwoActionAlert?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        CommonMethodsClass.animatePresentView(yourView: self.view)

    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        btnCancel.roundedButton()
        btnOther.roundedButton()

        
    }

    
    //MARK - IBAction -
    
    @IBAction func btnCloseHandler(_ sender: Any) {
        
     CommonMethodsClass.okBtnForTwoAlertHandler()
        
    }
    
    //MARK - IBAction -
    
    @IBAction func btnOtherHandler(_ sender: Any) {
        
        delegateFrmTwoActionAlert?.otherBtnPressed()
    }
    
}

protocol DelegateFromEmailAlert : class
{
    func okBtnPressed(email : String)
    func cancelBtnPressed()
}

class EmailAlert: UIViewController {
    
    @IBOutlet weak var txtfldEmail: UITextField!
    @IBOutlet weak var btnOk: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
    
    public var doneCompletion : ((String) -> Void)?
    var cancelCompletion : (() -> Void)?
    
    var delegateFrmTwoEmailAlrt :DelegateFromEmailAlert?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        CommonMethodsClass.animatePresentView(yourView: self.view)
        
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        btnOk.roundedButton()
        btnCancel.roundedButton()
        
        
    }
    
    
    //MARK - IBAction -
    
    @IBAction func btnCloseHandler(_ sender: Any) {
        cancelCompletion?()
    }
    
    //MARK - IBAction -
    
    @IBAction func btnOtherHandler(_ sender: Any) {
        if let valid = Validation.shared.validate(forgotPassword: txtfldEmail.text!) as? Valid{
            switch valid{
            case .success:
                doneCompletion?(txtfldEmail.text!)
            case .failure(_, let msg):
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            }
        }
    }
    
}

