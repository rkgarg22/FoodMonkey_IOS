//
//  AddAdress_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import GooglePlaces

class AddAdress_VC: UIViewController {

    var comingFromEdit = false
    
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var height_places: NSLayoutConstraint!
    @IBOutlet weak var vw_googlePlaces: GooglePlaces_VC!
    @IBOutlet weak var txtField_name: UITextField!
    @IBOutlet weak var txtField_houseNmbr: UITextField!
    @IBOutlet weak var txtField_addNote: UITextField!
    @IBOutlet weak var txtField_line1: UITextField!
    @IBOutlet weak var txtField_line2: UITextField!
    @IBOutlet weak var txtField_postCode: UITextField!
    @IBOutlet weak var txtField_city: UITextField!
    
    @IBOutlet weak var txtField_mobileNumber: CustomTextField!
    
    var placesClient = GMSPlacesClient()
    var myLocation = locationInfo()
    var addressModel : AddressModal?
    
    struct locationInfo {
        var city = ""
        var lat = ""
        var long = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        height_places.constant = 0
        txtField_name.layer.borderColor = UIColor.lightGray.cgColor
        txtField_houseNmbr.layer.borderColor = UIColor.lightGray.cgColor
        txtField_addNote.layer.borderColor = UIColor.lightGray.cgColor
        txtField_line1.layer.borderColor = UIColor.lightGray.cgColor
        txtField_line2.layer.borderColor = UIColor.lightGray.cgColor
        txtField_postCode.layer.borderColor = UIColor.lightGray.cgColor
        txtField_city.layer.borderColor = UIColor.lightGray.cgColor
        txtField_mobileNumber.layer.borderColor = UIColor.lightGray.cgColor
        self.vw_googlePlaces.delegateFromGooglePlaces = self
        self.vw_googlePlaces.isHidden = true
        txtField_addNote.addTarget(self, action: #selector(self.searchHandler(sender:)), for: .editingChanged)
        
        if comingFromEdit == true{
           // txtField_mobileNumber.isUserInteractionEnabled = false
            btn_add.setTitle("Done", for: .normal)
            self.navigationItem.title = "Edit address"
            txtField_name.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            txtField_houseNmbr.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            txtField_addNote.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            txtField_line1.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            txtField_line2.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            txtField_postCode.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            txtField_city.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            txtField_mobileNumber.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
            if addressModel != nil{
                txtField_name.text = addressModel?.Address_Name.capitalizedFirst()
                let mobileNumber = addressModel?.Mobile_Number ?? 0
                txtField_houseNmbr.text = addressModel?.House_No.capitalizedFirst()
                txtField_addNote.text = addressModel?.Address_Note.capitalizedFirst()
                txtField_line1.text = addressModel?.Street_Line1.capitalizedFirst()
                txtField_line2.text = addressModel?.Street_Line2.capitalizedFirst()
                txtField_postCode.text = addressModel?.Post_Code.capitalizedFirst()
                txtField_city.text = addressModel?.City.capitalizedFirst()
                txtField_mobileNumber.text = "\(mobileNumber)".capitalizedFirst()
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @objc func searchHandler(sender : UITextField)
    {
        if !(/sender.text).trimmed().isBlank
        {
            
//            self.vw_googlePlaces.isHidden = false
//            height_places.constant = 200
//            self.vw_googlePlaces.delegateFromGooglePlaces = self
//            self.vw_googlePlaces.placeAutocomplete(searchStr: txtField_addNote.text ?? "", textfield: txtField_addNote , placesClient: self.placesClient)
            
        }
        
    }
    
    @IBAction func click_addAddress(_ sender: UIButton) {
        let value = Validate()
        switch value {
        case .success:
            
            if (txtField_mobileNumber.text?.characters.count)! < 7{
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: "Mobile number should be more than 7 characters", vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            }else{
                if txtField_name.text!.lowercased() != "home" &&  txtField_name.text!.lowercased() != "business"{
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg:"Please enter valid address type" , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                }
                else{
                    if comingFromEdit == false{
                        self.callAddAddressApi()
                    }
                    else{
                        self.callEditAddressApi()
                    }
                }
                
            }
           
            
        case .failure(_, let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
            
        }
    }
    
    
    //MARK: Validate
    func Validate() -> Valid{
        let value : Valid = Validation.shared.validate(addAddress: txtField_name.text ?? "", mobileNumber: txtField_mobileNumber.text ?? "", houseNumber: txtField_houseNmbr.text ?? "", line1: txtField_line1.text ?? "", postCode: txtField_postCode.text ?? "", city: txtField_city.text ?? "")
        
        return value
    }
    
    //MARK:- Call Add adres api
    
    func callEditAddressApi()
    {
        var addresNote: String?
        if txtField_addNote.text?.trimmed().isEmpty == false{
            addresNote = txtField_addNote.text
        }
        var line2: String?
        if txtField_line2.text?.trimmed().isEmpty == false{
            line2 = txtField_line2.text
        }
        APIManager.shared.request(with: LoginEndpoint.editAddress(TokenKey:  CommonMethodsClass.getDeviceToken(), Address_id: addressModel?.Address_Id ?? 0, Address_type: txtField_name.text, Mobile_Number: Int(txtField_mobileNumber.text!), House_No: Int(txtField_houseNmbr.text!), Address_Note: addresNote, Street_Line1: txtField_line1.text, Street_Line2: line2, Post_Code: txtField_postCode.text, City: txtField_city.text), completion: { (response) in
            self.handleAddAddressApiResponse(response : response)
        })
    }
    
    func callAddAddressApi()
    {
        var customerId : Int?
        if let customer_id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            customerId = customer_id
        }
        var addresNote: String?
        if txtField_addNote.text?.trimmed().isEmpty == false{
            addresNote = txtField_addNote.text
        }
        var line2: String?
        if txtField_line2.text?.trimmed().isEmpty == false{
            line2 = txtField_line2.text
        }
        APIManager.shared.request(with: LoginEndpoint.addAddress(TokenKey:  CommonMethodsClass.getDeviceToken(), Customer_id: customerId, Address_type: txtField_name.text, Mobile_Number: Int(txtField_mobileNumber.text!), House_No: Int(txtField_houseNmbr.text!), Address_Note: addresNote, Street_Line1: txtField_line1.text, Street_Line2: line2, Post_Code: txtField_postCode.text, City: txtField_city.text), completion: { (response) in
            self.handleAddAddressApiResponse(response : response)
        })
    }
    
    func handleAddAddressApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
//                if let msg = dict.object(forKey: Keys.message.rawValue) as? String
//                {
                    // AppDelegate.sharedDelegate().tempPwd = self.txtField_pwd.text!
                    
                    CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg:"Address added successfully" , vc: self, isDelegateRequired: true, imgName: Images.succes.rawValue)
                    
//                }
            }
            
        case .failure(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }
    
}

//text field delegate and google places delegate

extension AddAdress_VC : UITextFieldDelegate,DelegateFromGooglePlacesVIew{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.myLocation = locationInfo.init(city: "", lat: "", long: "")
        if textField == txtField_mobileNumber{
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= 12
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        self.vw_googlePlaces.isHidden = true
//        height_places.constant = 0
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    //MARK:- DelegateFromAutoComplete -
    
    func onPlacesPressed(selectedPlaces: NSAttributedString, autoCompleteData: GMSAutocompletePrediction)
    {
        Utility.shared.loader()
        self.vw_googlePlaces.isHidden = true
        txtField_addNote.resignFirstResponder()
        height_places.constant = 0
        txtField_addNote.attributedText = selectedPlaces
        
        GMSPlacesClient.shared().lookUpPlaceID(autoCompleteData.placeID!, callback: { (place, error) -> Void in
            
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                Utility.shared.calculateAddress(lat: place.coordinate.latitude, long: place.coordinate.longitude, responseBlock: { (coordinates, fullAddress,address,city,state,sublocality,postalCode) in
                    if let city = city{
                        Utility.shared.removeLoader()
                        self.myLocation.city = city
                        self.txtField_city.text = city
                        self.txtField_line1.text = sublocality
                        self.txtField_postCode.text = postalCode
                        //  self.txtField_location.text = ""
                        self.myLocation.lat = "\(place.coordinate.latitude)"
                        self.myLocation.long = "\(place.coordinate.longitude)"
                        if self.comingFromEdit == true{
                            self.txtField_line2.text = ""
                        }
                        
                    }
                })
            }
        })
    }
}

//alert action
extension AddAdress_VC : DelegateFromSingleAlert{
    func donePressed(obj: AlertVC) {
        CommonMethodsClass.okBtnForSingleAlertHandlerWithCompletionHandler { (success) in
            self.navigationController?.popViewController(animated: true)
        }
    }

}

