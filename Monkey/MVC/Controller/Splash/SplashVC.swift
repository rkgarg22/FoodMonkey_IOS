//
//  ViewController.swift
//  Social Galaxy
//
//  Created by Priya on 20/03/18.
//  Copyright © 2018 Priya. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {
    
    @IBOutlet weak var lbl_desc: UILabel!
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        let str = CommonMethodsClass.addBoldText(fullString: SplashString.descStr_splash0.rawValue as NSString, boldPartOfString: [SplashString.boldStr1_splash0.rawValue as NSString,SplashString.boldStr2_splash0.rawValue as NSString,SplashString.boldStr3_splash0.rawValue as NSString,SplashString.boldStr4_splash0.rawValue as NSString], font:UIFont.init(name: FontName.RawlineLight.rawValue, size: 22.0) , boldFont: UIFont.init(name: FontName.RawlineExtraBold.rawValue, size: 22.0))
        lbl_desc.attributedText = str
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (time) in
            self.timer?.invalidate()
            self.timer = nil
            if let parent = self.parent as? UIPageViewController{
                if let vw = parent.view{
                    if let vc1 = vw.superview?.next as? WalkthroughViewController{
//                        vc1.pageControl.currentPage = 1
//                        vc1.currentIndex = 1
//                        vc1.pageContainer.setViewControllers([vc1.pages[1]], direction:UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
                        
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
            }
            
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

