//
//  PreOrder_VC.swift
//  Monkey
//
//  Created by Apple on 16/01/19.
//  Copyright © 2019 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class PreOrder_VC: UIViewController {

    @IBOutlet weak var lbl_minimumSpend: UILabel!
    @IBOutlet weak var lbl_opening: UILabel!
    var model_restaurant : SpecificRestaurantListModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_minimumSpend.text = "Minimum spend for delivery £" + (model_restaurant?.Min_Spend ?? "0.00")
        lbl_opening.text = "Resturant opening at " + (model_restaurant?.Monday_Open ?? "10:00")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_preAction(_ sender: UIButton) {
        AppDelegate.sharedDelegate().preOrder = true
        self.willMove(toParentViewController: nil)
        self.beginAppearanceTransition(false, animated: true)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    @IBAction func btn_nearyByaction(_ sender: UIButton) {
      //  AppDelegate.sharedDelegate().preOrder = true
        self.willMove(toParentViewController: nil)
        self.beginAppearanceTransition(false, animated: true)
        let parent = self.parent
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
        if let parent1 = parent as? UINavigationController{
            parent1.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
