//
//  MyAccount_MainVC.swift
//  Monkey
//
//  Created by Apple on 02/12/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class MyAccount_MainVC: UIViewController {

    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var tbleVw: UITableView!
    
    var titleArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let password = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.password.rawValue) as? String{
            if password.isEmpty == false{
                  titleArr = ["Personal Account Detail","Fingerprint","Facial Recognition","Change Password"]
            }
            else{
                  titleArr = ["Personal Account Detail","Fingerprint","Facial Recognition"]
            }
        }else{
            titleArr = ["Personal Account Detail","Fingerprint","Facial Recognition"]
        }
        tbleVw.backgroundColor = .clear
        tbleVw.tableFooterView = UIView()
        self.lbl_userName.text = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.fullName.rawValue) as? String
        imgVw.layoutIfNeeded()
        imgVw.layer.cornerRadius = imgVw.frame.size.height/2
        let image_Link = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.profilePicURL.rawValue) as? String
        if let imageData = image_Link{
            if let index = imageData.range(of: "api/")?.upperBound {
                let substring = imageData[index...]
                let string = String(substring)
                let urlString = APIConstants.basePath + string
                self.imgVw.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "profile-icon"), options: .refreshCached, completed: nil)
            }else{
                self.imgVw.image = #imageLiteral(resourceName: "profile-icon")
            }
        }else{
            self.imgVw.image = #imageLiteral(resourceName: "profile-icon")
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

}

//MARK:- table view methods

extension MyAccount_MainVC : UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Settings") as! TableCell_Settings
        cell.selectionStyle = .none
        cell.lbl_title.text = titleArr[indexPath.row]
        if indexPath.row == 1 || indexPath.row == 2{
            cell.imgVw_back.isHidden = true
            cell.onSwitch.isHidden = false
        }else{
           cell.imgVw_back.isHidden = false
            cell.onSwitch.isHidden = true
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = StoryboardScene.Main.instantiateMyAccountController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePwdVC") as! ChangePwdVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}


