//
//  Splash3_VC.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class Splash3_VC: UIViewController {

    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (time) in
            self.timer?.invalidate()
            self.timer = nil
            if let parent = self.parent?.view{
                if let vc1 = parent.superview?.next as? UIViewController{
                    var homeVC : HomeVC?
                    if let controlers = vc1.navigationController?.viewControllers{
                        for vc1 in controlers{
                            if let c = vc1 as? HomeVC
                            {
                                homeVC = c
                                break
                            }
                        }
                    }
                    if homeVC != nil{
                       
                    }else{
                        let vc = StoryboardScene.Main.instantiateHome_ViewController()
                        vc1.navigationController?.pushViewController(vc, animated: true)
                    }

                }
            }
          
        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
