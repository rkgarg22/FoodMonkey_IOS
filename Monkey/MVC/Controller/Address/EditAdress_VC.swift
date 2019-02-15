//
//  EditAdress_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class EditAdress_VC: UIViewController {

    @IBOutlet weak var txtField_name: UITextField!
    @IBOutlet weak var txtField_houseNmbr: UITextField!
    @IBOutlet weak var txtField_addNote: UITextField!
    @IBOutlet weak var txtField_line1: UITextField!
    @IBOutlet weak var txtField_line2: UITextField!
    @IBOutlet weak var txtField_postCode: UITextField!
    @IBOutlet weak var txtField_city: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtField_name.layer.borderColor = UIColor.lightGray.cgColor
        txtField_houseNmbr.layer.borderColor = UIColor.lightGray.cgColor
        txtField_addNote.layer.borderColor = UIColor.lightGray.cgColor
        txtField_line1.layer.borderColor = UIColor.lightGray.cgColor
        txtField_line2.layer.borderColor = UIColor.lightGray.cgColor
        txtField_postCode.layer.borderColor = UIColor.lightGray.cgColor
        txtField_city.layer.borderColor = UIColor.lightGray.cgColor
        
        txtField_name.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_houseNmbr.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_addNote.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_line1.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_line2.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_postCode.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        txtField_city.addRightIcon(#imageLiteral(resourceName: "edit-icon"), frame: CGRect.init(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 15, height: 15), imageSize: CGSize.init(width: 15, height: 15))
        
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

}
