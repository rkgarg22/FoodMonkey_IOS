//
//  SideMenuVC.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var lbl_fullName: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    var titleArr = [String]()
    var loggedIntitleArr = [String]()
    var isLoggedIn : Bool = false
    var clicked = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        
        statusBar.backgroundColor = #colorLiteral(red: 0.8431372549, green: 0.05882352941, blue: 0.3921568627, alpha: 1)
        if let _ = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            isLoggedIn = true
        }else{
            isLoggedIn = false
        }
        if isLoggedIn{
            tblVw.tableHeaderView = header
            self.lbl_fullName.text = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.fullName.rawValue) as? String
            self.lbl_email.text = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.email.rawValue) as? String
            let image_Link = DBManager.accessUserDefaultsForKey(keyStr: ParamKeys.profilePicURL.rawValue) as? String
            if let imageData = image_Link{
                if let index = imageData.range(of: "api/")?.upperBound {
                    let substring = imageData[index...]
                    let string = String(substring)
                    let urlString = APIConstants.basePath + string
                    self.profilePic.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "profile-icon"), options: .refreshCached, completed: nil)
                }else{
                    self.profilePic.image = #imageLiteral(resourceName: "profile-icon")
                }
            }else{
                self.profilePic.image = #imageLiteral(resourceName: "profile-icon")
            }
        }else{
            tblVw.tableHeaderView = nil
        }
        tblVw.backgroundColor = .clear
        self.profilePic.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        titleArr = TitleArrays(rawValue: 2)?.get() != nil ? (TitleArrays(rawValue: 2)?.get())! : [String]()
        loggedIntitleArr = TitleArrays(rawValue: 3)?.get() != nil ? (TitleArrays(rawValue: 3)?.get())! : [String]()
        tblVw.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callApi()
    {
        APIManager.shared.request(with: LoginEndpoint.signout(TokenKey:CommonMethodsClass.getDeviceToken() ), completion: { (response) in
            self.handleSignoutApiResponse(response : response)
        })
    }
    
    func handleSignoutApiResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? NSDictionary
            {
                if let code = dict.value(forKey: "Code") as? String{
                    if code == "200"
                    {
                        UserDefaults.standard.removeObject(forKey: Keys.Customer_id.rawValue)
                         UserDefaults.standard.removeObject(forKey: ParamKeys.password.rawValue)
                        var homeVC : HomeVC?
                        if let controlers = self.navigationController?.viewControllers{
                            for vc1 in controlers{
                                if let c = vc1 as? HomeVC
                                {
                                    homeVC = c
                                    break
                                }
                            }
                        }
                        if homeVC != nil{
                            self.navigationController?.popToViewController(homeVC!, animated: true)
                        }else{
                            let vc = StoryboardScene.Main.instantiateHome_ViewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        if let msg = dict.value(forKey: "Message") as? String{
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg:msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
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
}

//MARK:- table view methods

extension SideMenuVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoggedIn ? loggedIntitleArr.count : titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_sideMenu") as! TableCell_sideMenu
        cell.selectionStyle = .none
        if isLoggedIn{
            cell.lbl_title.text = loggedIntitleArr[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "myaccount")
                break
            case 1:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "referfrnd")
                break
            case 2:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "myorders")
                break
                //            case 3:
                //                cell.imgeVw_icon.image = #imageLiteral(resourceName: "help")
            //                break
            case 3:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "terms")
                break
//            case 4:
//                cell.imgeVw_icon.image = #imageLiteral(resourceName: "setting")
//                break
            default:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "signout")
                break
            }
        }else{
            cell.lbl_title.text = titleArr[indexPath.row]
            switch indexPath.row {
            case 0:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "myaccount")
                break
            case 1:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "signout")
                break
//            case 2:
//                cell.imgeVw_icon.image = #imageLiteral(resourceName: "signout")
//                break
//            case 3:
//                cell.imgeVw_icon.image = #imageLiteral(resourceName: "referfrnd")
                break
//            case 4:
//                cell.imgeVw_icon.image = #imageLiteral(resourceName: "myorders")
//                break
                //            case 5:
                //                cell.imgeVw_icon.image = #imageLiteral(resourceName: "help")
            //                break
            case 2:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "terms")
                break
//            case 6:
//                cell.imgeVw_icon.image = #imageLiteral(resourceName: "setting")
//                break
            default:
                cell.imgeVw_icon.image = #imageLiteral(resourceName: "signout.png")
                break
            }
        }
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if clicked == false{
            if isLoggedIn {
                switch indexPath.row {
                case 0:
                    let vc = StoryboardScene.Main.instantiateMyAccountMainController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case 1:
                    let vc = StoryboardScene.Main.instantiateReferFriendController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case 2:
                    let vc = StoryboardScene.Main.instantiateOrderController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    //            case 3:
                    //                let vc = StoryboardScene.Main.instantiateHelpController()
                    //                self.navigationController?.pushViewController(vc, animated: true)
                //                break
                case 3:
                    let vc = StoryboardScene.Main.instantiateTermsController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
//                case 4:
//                    let vc = StoryboardScene.Main.instantiateSettingsController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    break
                case 4:
                    //Logout
                    callApi()
                    break
                default:
                    break
                }
            }else{
                switch indexPath.row {
                    //            case 0:
                    //                let vc = StoryboardScene.Main.instantiateMyAccountController()
                    //                self.navigationController?.pushViewController(vc, animated: true)
                //                break
                case 0:
                    let vc = StoryboardScene.Main.instantiateLoginController()
                    DBManager.setValueInUserDefaults(value: false, forKey: ParamKeys.cartAdded.rawValue)
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
//                case 1:
//                    let vc = StoryboardScene.Main.instantiateReferFriendController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    break
                    
                case 1:
                    let vc = StoryboardScene.Main.instantiateSIgnupController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                    //            case 4:
                    //                let vc = StoryboardScene.Main.instantiateOrderController()
                    //                self.navigationController?.pushViewController(vc, animated: true)
                    //                break
                    //            case 3:
                    //                let vc = StoryboardScene.Main.instantiateHelpController()
                    //                self.navigationController?.pushViewController(vc, animated: true)
                //                break
                case 2:
                    let vc = StoryboardScene.Main.instantiateTermsController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
//                case 4:
//                    let vc = StoryboardScene.Main.instantiateSettingsController()
//                    self.navigationController?.pushViewController(vc, animated: true)
//                    break
                default:
                    break
                }
            }
            clicked = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}
