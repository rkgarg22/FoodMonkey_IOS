//
//  Splash2_VC.swift
//  Monkey
//
//  Created by Apple on 21/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class Splash2_VC: UIViewController {

    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (time) in
            self.timer?.invalidate()
            self.timer = nil
            if let parent = self.parent as? UIPageViewController{
                if let vw = parent.view{
                    if let vc1 = vw.superview?.next as? WalkthroughViewController{
                        vc1.pageControl.currentPage = 2
                        vc1.currentIndex = 2
                        vc1.pageContainer.setViewControllers([vc1.pages[2]], direction:UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
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
