//
//  FilterTableVC.swift
//  Monkey
//
//  Created by apple on 07/10/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

enum FilterData{
    case cuisines
    case list
    case deliveryOption
}

class FilterModal {
    var array = [String]()
    var filterType : FilterData?
    var selectedCuisine : IndexPath = IndexPath(row: 0, section: 0)
    var selectedDeliveryOption : IndexPath = IndexPath(row: 0, section: 0)
    var selectedListBy : IndexPath = IndexPath(row: 0, section: 0)

}

protocol FilterResult : class{
    func popoverDidEnd()
}

class FilterTableVC: UITableViewController {

    var array = [String]()
    var restCountArray = [Int]()
    var filterType : FilterData?
    var selectedIndex : IndexPath?
    var totalCount = 0
    
    weak var delegate : FilterResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = 44
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell_Filter", for: indexPath) as! TableCell_Filter
        if filterType! == .cuisines{
            if indexPath.row == 0{
                cell.lbl_restCount.isHidden = true
            }else{
                if totalCount < 300 {
                    cell.lbl_restCount.isHidden = true
                }else{
                    cell.lbl_restCount.isHidden = false
                }
            }
            cell.lbl_restCount.text = "(\(restCountArray[indexPath.row]))"
        }else{
            cell.lbl_restCount.isHidden = true
        }
        cell.lbl_title.text = array[indexPath.row]
        if (selectedIndex == indexPath) {
            cell.imgvw_radio.image = UIImage.init(named: "Radio_filter2")
        } else {
            cell.imgvw_radio.image = UIImage.init(named: "Radio1_filter")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath
        tableView.reloadData()
        self.delegate?.popoverDidEnd()
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
