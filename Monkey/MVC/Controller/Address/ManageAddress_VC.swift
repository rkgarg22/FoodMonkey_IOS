//
//  ManageAddress_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class ManageAddress_VC: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    var addresses =  [AddressModal]()
    var selectedIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.tableFooterView = UIView()
        tblVw?.contentInset = UIEdgeInsets.init(top: -10, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        callApiToGetCustomerDetails()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
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
                                if let address = customer_details[0].Addresses{
                                    addresses = address
                                    tblVw.reloadData()
                                }else{
                                    
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    @objc func editClick(sender: UIButton){
        let vc = StoryboardScene.Main.instantiate_AddAdress_VC()
        vc.addressModel = self.addresses[sender.tag]
        vc.comingFromEdit = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func deleteClick(sender: UIButton){
        let modal = self.addresses[sender.tag]
        selectedIndex  = sender.tag
        APIManager.shared.request(with: LoginEndpoint.deleteAddress(TokenKey:  CommonMethodsClass.getDeviceToken(), Address_id: modal.Address_Id), completion: { (response) in
             self.handleDeleteAddressApiResponse(response : response)
        })
    }
    
    func handleDeleteAddressApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let code = dict.object(forKey: Keys.statusCode.rawValue) as? String
                {
                    if code == "200"{
                        if let msg = dict.object(forKey: Keys.message.rawValue) as? String{
                             CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg:msg , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                        }
                    }else{
                        if let msg = dict.object(forKey: Keys.message.rawValue) as? String{
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue , msg:msg , vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
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
    
    
    
}

//MARK:- table view methods

extension ManageAddress_VC : UITableViewDataSource, UITableViewDelegate,DelegateFromSingleAlert{
    
    func donePressed(obj: AlertVC) {
        CommonMethodsClass.okBtnForSingleAlertHandlerWithCompletionHandler { (success) in
            if self.selectedIndex != nil{
                self.addresses.remove(at: self.selectedIndex!)
                self.selectedIndex = nil
                self.tblVw.reloadData()
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, w: tblVw.frame.size.width, h: 60))
        let lbl = UILabel.init(x: 0, y: 0, w: tblVw.frame.size.width, h: 60)
        lbl.font = UIFont.init(name: FontName.RawlineExtraBold.rawValue, size: 18.0)
        lbl.textColor = .black
        view.backgroundColor = .white
        let modal = self.addresses[section]
        if modal.Address_Name.lowercased() == "office"
        {
            lbl.text = "Business"
        }else{
            lbl.text = modal.Address_Name.capitalizedFirst()
        }
        view.addSubview(lbl)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_ManageAdd") as! TableCell_ManageAdd
        cell.selectionStyle = .none
        cell.btn_edit.tag = indexPath.section
        cell.btn_delete.tag = indexPath.section
        let modal = self.addresses[indexPath.section]
        cell.lbl_name.text = ""
        let t1 = modal.Address_Note.capitalizedFirst() + "\n\(modal.House_No)" + " " + modal.Street_Line1 + "\n"
        let t2 = modal.Street_Line2  + " " + modal.Post_Code +  " " + modal.City
        cell.lbl_address.text = t1 + t2
        cell.btn_edit.addTarget(self, action: #selector(editClick(sender:)), for: .touchUpInside)
        cell.btn_delete.addTarget(self, action: #selector(deleteClick(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
