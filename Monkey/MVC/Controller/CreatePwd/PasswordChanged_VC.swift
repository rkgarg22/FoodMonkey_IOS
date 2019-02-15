//
//  PasswordChanged_VC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class PasswordChanged_VC: UIViewController {

    @IBOutlet weak var lbl_success: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_success.text = SucessTitle.passwordChanged.rawValue
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func click_backToLogin(_ sender: UIButton) {
        if let arr  = self.navigationController?.viewControllers
        {
            var vc : LoginVC?
            for value in arr{
                if let v = value as? LoginVC{
                    vc = v
                    break
                }
            }
             UserDefaults.standard.removeObject(forKey: Keys.Customer_id.rawValue)
//            let vc = StoryboardScene.Main.instantiateHome_ViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
            if vc != nil{
                
                self.navigationController?.popToViewController(vc!, animated: true)
            }else{
               
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                vc.fromPwd = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
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
