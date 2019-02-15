//
//  HelpVC.swift
//  Monkey
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

    @IBOutlet weak var tblVw: UITableView!
    var titleArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVw.backgroundColor = .clear
        tblVw.tableFooterView = UIView()
        titleArr = TitleArrays(rawValue: 0)?.get() != nil ? (TitleArrays(rawValue: 0)?.get())! : [String]()
        tblVw.reloadData()
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

extension HelpVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_help") as! TableCell_help
        cell.selectionStyle = .none
        cell.lbl_title.text = titleArr[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }

}
