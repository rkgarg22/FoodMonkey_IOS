//
//  TableCell_Home.swift
//  Monkey
//
//  Created by Apple on 23/09/18.
//  Copyright © 2018 Igniva-iphone-Rupinder. All rights reserved.
//

import UIKit

class TableCell_Home: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var btn_seeMore: UIButton!
    
    var objRestaurantList : HomeRestaurantModal?
    var parentNavController : UINavigationController?
    var arrHome = [RestaurantHome]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    // collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrHome[collectionView.tag].array?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell_Home", for: indexPath) as! CollectionCell_Home
        if let item = arrHome[collectionView.tag].array?[indexPath.item]{
            if let imageData = item.Image_Link{
                if let index = imageData.range(of: "api/")?.upperBound {
                    let substring = imageData[index...]
                    let string = String(substring)
                    let urlString = APIConstants.basePath + string
                    cell.imgVW?.sd_setImage(with: URL(string: urlString), placeholderImage: #imageLiteral(resourceName: "rest-alvi"), options: .refreshCached, completed: nil)
                }else{
                    cell.imgVW.image = #imageLiteral(resourceName: "rest-alvi")
                }
            }else{
                cell.imgVW.image = #imageLiteral(resourceName: "rest-alvi")
            }
            if let restname = item.Rest_Name{
                cell.lbl_title.text = restname.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            if let numberOfReview = item.NumberOfReviews{
                if numberOfReview > 1{
                    cell.lbl_reviews.text = "\(numberOfReview) reviews"
                }else{
                    cell.lbl_reviews.text = "\(numberOfReview) review"
                }
            }
            cell.lbl_category.text = item.Cousine_List
            if let value = item.AggregateFeedback{
                cell.vw_reviews.value = CGFloat(Float(value)!)
            }
            cell.vw_reviews.isEnabled = false
            cell.btn_seeMore.tag = indexPath.item
            cell.btn_seeMore.addTarget(self, action: #selector(btnAction_seeMore), for: .touchUpInside)
        }
        cell.contentView.backgroundColor  = .clear
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    @objc func btnAction_seeMore(_ sender:UIButton){
            let vc = StoryboardScene.Main.instantiateRestaurantMenuMXVC()
            AppDelegate.sharedDelegate().preOrder = false
            self.parentNavController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let numberOfCellInRow = 3
        let cellWidth =  (UIScreen.main.bounds.size.width - 60)/CGFloat(numberOfCellInRow)
        print(cellWidth)
        return CGSize(width: cellWidth,height: 140)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = StoryboardScene.Main.instantiateRestaurantMenuMXVC()
        AppDelegate.sharedDelegate().preOrder = false
        vc.Resturant_id = arrHome[collectionView.tag].array?[indexPath.item].Rest_Id ?? 0
        vc.restName = arrHome[collectionView.tag].array?[indexPath.item].Rest_Name ?? ""
        if let home = self.parentNavController?.topViewController as? HomeVC{
            home.navigationItem.title = arrHome[collectionView.tag].array?[indexPath.item].Rest_Name ?? ""
        }
        self.parentNavController?.pushViewController(vc, animated: true)
    }
    
}
