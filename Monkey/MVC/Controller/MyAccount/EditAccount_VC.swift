//
//  EditAccount_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class EditAccount_VC: UIViewController {

    @IBOutlet weak var imgVw_profile: UIImageView!
    @IBOutlet weak var txtField_name: UITextField!
    @IBOutlet weak var txtField_gender: UITextField!
    @IBOutlet weak var txtField_email: UITextField!
    @IBOutlet weak var txtField_phone: UITextField!
    @IBOutlet weak var txtField_dob: UITextField!
    @IBOutlet weak var txtField_middleName: UITextField!
    @IBOutlet weak var txtField_surName: UITextField!
    
    var customer_details : [Customer_details]?
    var selectedImage : UIImage?
    var imgSelected = false
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    var arrayGender = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        showDatePicker()
        showGenderPicker()
        getCustomerDetails()
    }

    func setupTextFields(){
        txtField_name.layer.borderColor = UIColor.lightGray.cgColor
        txtField_gender.layer.borderColor = UIColor.lightGray.cgColor
        txtField_email.layer.borderColor = UIColor.lightGray.cgColor
        txtField_phone.layer.borderColor = UIColor.lightGray.cgColor
        txtField_dob.layer.borderColor = UIColor.lightGray.cgColor
        txtField_middleName.layer.borderColor = UIColor.lightGray.cgColor
        txtField_surName.layer.borderColor = UIColor.lightGray.cgColor
        
        txtField_name.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_gender.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
     //   txtField_email.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
    //    txtField_phone.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_dob.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_middleName.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_surName.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
    }

    
    func getCustomerDetails(){
        if let customer_details = self.customer_details{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let DOB = customer_details[0].DOB{
                if let date = dateFormatter.date(from: DOB){
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateFormat = "dd-MM-yyyy"
                    let dateString = newDateFormatter.string(from: date)
                    self.txtField_dob.text = dateString
                }
            }
            self.txtField_email.text = customer_details[0].Email
            if let firstName = customer_details[0].First_Name, let middleName = customer_details[0].Middle_Intial, let surName = customer_details[0].Sur_Name{
                //let fullName = "\(firstName) \(middleName) \(surName)"
                self.txtField_name.text = firstName
                self.txtField_middleName.text = middleName
                self.txtField_surName.text = surName
            }
            self.txtField_phone.text = customer_details[0].Mobile
            self.txtField_gender.text = customer_details[0].Gender
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
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

       
    }
    
    @IBAction func btnAction_editAccount(_ sender: UIButton) {
        Utility.shared.openCameraAndPhotos(isEditImage: false, cropStyle: .circurlar, getImage: { (image, info) in
            self.imgVw_profile.image = image
            self.selectedImage = image
            self.imgSelected = true
        }) { (error) in
            self.imgSelected = false
        }
    }
    @IBAction func btnAction_done(_ sender: UIButton) {
        let customerId = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.Customer_id.rawValue) as? Int ?? 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var dobString = ""
        if let DOB = self.txtField_dob.text{
            if let date = dateFormatter.date(from: DOB){
                let newDateFormatter = DateFormatter()
                newDateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = newDateFormatter.string(from: date)
                dobString = dateString
            }
        }
        APIManager.shared.postRequest(with: LoginEndpoint.editCustomerProfile(TokenKey: CommonMethodsClass.getDeviceToken(), Customer_Id: customerId, First_Name: self.txtField_name.text ?? "", Middle_Intial: self.txtField_middleName.text ?? "", Sur_Name: self.txtField_surName.text ?? "", Gender: self.txtField_gender.text ?? "", DOB: dobString, ProfilePic: (imgSelected ? CommonMethodsClass.convertImageToBase64(image: self.selectedImage!) : nil))) { (response) in
            self.handleEditCustomerProfileResponse(response : response)
        }
    }
    
    func handleEditCustomerProfileResponse(response:Response){
        switch response{
        case .success(let responseValue):
        if let dict = responseValue as? NSDictionary
        {
            if let _ = dict.object(forKey: Keys.message.rawValue) as? String
            {
                let message = "Your profile has been updated successfully."
                
                CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /message , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                    self.navigationController?.popViewController(animated: true)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Date Picker
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        
        let loc = Locale(identifier: "en_GB")
        self.datePicker.locale = loc
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton: UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donedatePicker(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton: UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.cancelDatePicker))
        
        //        doneButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.AppColorGreen], for: .normal)
        //        cancelButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.AppColorGreen], for: .normal)
        
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        txtField_dob.inputAccessoryView = toolbar
        
        // add datepicker to textField
        txtField_dob.inputView = datePicker
    }
    
    @objc func donedatePicker(sender :UIDatePicker){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        txtField_dob.backgroundColor = .white
        txtField_dob.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
}


extension EditAccount_VC:UIPickerViewDataSource,UIPickerViewDelegate{
    //MARK:- Gender Picker
    func showGenderPicker(){
        arrayGender = ["MALE","FEMALE"]
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton: UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneGenderPicker(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton: UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action:#selector(self.cancelGenderPicker))
        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        // add toolbar to textField
        txtField_gender.inputAccessoryView = toolbar
        
        // add picker to textField
        txtField_gender.inputView = pickerView
    }
    
    @objc func doneGenderPicker(sender :UIPickerView){
        //dismiss picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelGenderPicker(){
        //cancel button dismiss picker dialog
        self.view.endEditing(true)
    }
    
    //MARK: - Pickerview method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayGender.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayGender[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtField_gender.text = arrayGender[row]
    }
}
