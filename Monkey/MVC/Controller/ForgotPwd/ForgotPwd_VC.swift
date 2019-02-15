//
//  ForgotPwd_VC.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class ForgotPwd_VC: UIViewController {

    @IBOutlet var btn_email: [UIButton]!

    var selected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func click_action(_ sender: UIButton) {
        for aButton in btn_email{
            aButton.isSelected = false
        }
        sender.isSelected = true
        selected = sender.tag
    }
    
    @IBAction func click_next(_ sender: UIButton) {
        
//      
        
        if selected == 0{
            let vc = StoryboardScene.Main.instantiateForgotPwd_emailController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = StoryboardScene.Main.instantiateSendOTPController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
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
