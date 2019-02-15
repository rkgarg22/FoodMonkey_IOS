//
//  SettingsVC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    var titleArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        titleArr = TitleArrays(rawValue: 1)?.get() != nil ? (TitleArrays(rawValue: 1)?.get())! : [String]()
        tblVw.reloadData()
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

    @IBAction func click_back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- table view methods

extension SettingsVC : UITableViewDataSource, UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Settings") as! TableCell_Settings
        cell.selectionStyle = .none
        cell.lbl_title.text = titleArr[indexPath.row]
       
        cell.backgroundColor = .clear
        if indexPath.row == 2{
             cell.lbl_subTitle.text = "Contacts, Location, Phone, SMS"
        }else{
             cell.lbl_subTitle.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

