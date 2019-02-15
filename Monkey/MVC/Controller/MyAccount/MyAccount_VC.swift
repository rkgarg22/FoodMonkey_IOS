//
//  MyAccount_VC.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class MyAccount_VC: UIViewController {

    @IBOutlet weak var imgVw_profile: UIImageView!
    @IBOutlet weak var btnOutlet_name: UIButton!
    @IBOutlet weak var lbl_gender: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_mobile: UILabel!
    @IBOutlet weak var lbl_dob: UILabel!
    @IBOutlet weak var lbl_homeAdd: UILabel!
    @IBOutlet weak var lbl_businessAdd: UILabel!
    
    var customer_details : [Customer_details]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgVw_profile.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callApiToGetCustomerDetails()
    }

    func callApiToGetCustomerDetails(){
        let customerId = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int
        APIManager.shared.request(with: LoginEndpoint.getCustomerDetails(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_id: customerId)){[weak self] (response) in
            self?.handleCustomerDetailsResponse(response: response)
        }
    }
    
    func handleCustomerDetailsResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? LoginModal
            {
                if let code = dict.Code{
                    
                    if let msg = dict.Message{
                        if code == "200"{
                            if let customer_details = dict.Customer_details{
                                self.customer_details = customer_details
                                if let firstName = customer_details[0].First_Name, let middleName = dict.Customer_details?[0].Middle_Intial, let surName = dict.Customer_details?[0].Sur_Name{
                                    let fullName = "\(firstName) \(middleName) \(surName)"
                                    self.btnOutlet_name.setTitle(fullName, for: .normal)
                                }
                                if let profilePic = customer_details[0].Image_Link{
                                        if let index = profilePic.range(of: "api/")?.upperBound {
                                            let substring = profilePic[index...]
                                            let string = String(substring)
                                            let urlString = APIConstants.basePath + string 
                                            self.imgVw_profile.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "profile-icon"), options: .refreshCached, completed: nil)
                                        }else{
                                            self.imgVw_profile.image = #imageLiteral(resourceName: "profile-icon")
                                        }
                                    }else{
                                        self.imgVw_profile.image = #imageLiteral(resourceName: "profile-icon")
                                    }
                                if let email = customer_details[0].Email{
                                    self.lbl_email.text = email
                                }
                                if let mobile = customer_details[0].Mobile{
                                    self.lbl_mobile.text = mobile
                                }
                                if let gender = customer_details[0].Gender{
                                    self.lbl_gender.text = gender
                                }
                                if let dob = customer_details[0].DOB{
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-MM-dd"       
                                   
                                        if let date = dateFormatter.date(from: dob){
                                            let newDateFormatter = DateFormatter()
                                            newDateFormatter.dateFormat = "dd-MM-yyyy"
                                            let dateString = newDateFormatter.string(from: date)
                                            self.lbl_dob.text = dateString
                                        }
                                }
                                if let houseAddresses = customer_details[0].Addresses?.filter({$0.Address_Name == "House"}){
                                    if houseAddresses.count > 0{
                                        let modal = houseAddresses[0]
                                        let t1 = modal.Address_Note + "\n\(modal.House_No)" + " " + modal.Street_Line1 + "\n"
                                        let t2 = modal.Street_Line2  + " " + modal.Post_Code +  " " + modal.City
                                        self.lbl_homeAdd.text = t1 + t2
                                    }else{
                                       self.lbl_homeAdd.text = ""
                                    }
                                }
                                if let officeAddresses = customer_details[0].Addresses?.filter({$0.Address_Name != "House"}){
                                     if officeAddresses.count > 0{
                                    let modal = officeAddresses[0]
                                    let t1 = modal.Address_Note + "\n\(modal.House_No)" + " " + modal.Street_Line1 + "\n"
                                    let t2 = modal.Street_Line2  + " " + modal.Post_Code +  " " + modal.City
                                    self.lbl_businessAdd.text = t1 + t2
                                }else{
                                    self.lbl_businessAdd.text = ""
                                }
                            }
                            }else{
                                
                                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: "No customer details found." , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                                
                            }
                        }else{
                            
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                        }
                    }
                }
            }
            
        case .failure(let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.isNavigationBarHidden = false
        imgVw_profile.layer.cornerRadius = imgVw_profile.frame.size.height/2
        imgVw_profile.layoutIfNeeded()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnAction_editAccount(_ sender: UIButton) {
        let vc = StoryboardScene.Main.instantiateEditAccount_VC()
        vc.customer_details = self.customer_details
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


