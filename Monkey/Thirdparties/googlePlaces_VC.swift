//
//  googlePlacesVC.swift
//  trophyCase
//
//  Created by Ibrahim on 27/07/17.
//  Copyright © 2017 Gunjan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol DelegateFromGooglePlacesVIew : class
{
	func onPlacesPressed(selectedPlaces:NSAttributedString,autoCompleteData:GMSAutocompletePrediction)
}


class GooglePlaces_VC: UIView,UITableViewDelegate,UITableViewDataSource{
	
	var autocompleteAddress = [GMSAutocompletePrediction]()
	var delegateFromGooglePlaces :DelegateFromGooglePlacesVIew?
	let tableVw : UITableView = UITableView()
    let lbl_noRecords = UILabel()
	
	override func layoutSubviews() {
		super.layoutSubviews()
		tableVw.isScrollEnabled = false
		tableVw.frame = CGRect.init(x: 0, y: 0 , w: self.frame.size.width, h: 200)
		tableVw.register(UINib(nibName: "googlePlacesCell", bundle: nil), forCellReuseIdentifier: "googlePlacesCell")
		tableVw.delegate=self
		tableVw.dataSource=self
        tableVw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableVw.separatorStyle = .none
        
        lbl_noRecords.frame =  CGRect(x:self.frame.size.width/2 - 100, y:70, width:200, height:60)
        //lbl_noRecords.center = self.center
        lbl_noRecords.text = "No Record Found"
        lbl_noRecords.textColor = UIColor.darkGray
        lbl_noRecords.textAlignment = .center
       // lbl_noRecords.backgroundColor = .orange
        
		self.addSubview(tableVw)
        self.addSubview(lbl_noRecords)
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print(autocompleteAddress.count)
		return autocompleteAddress.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "googlePlacesCell", for: indexPath) as? googlePlacesCell
		
		cell?.lbl_places?.numberOfLines = 0
		
		if(autocompleteAddress.count > 0 && autocompleteAddress.count > indexPath.row)
		{
			let autocompleMatch = autocompleteAddress[indexPath.row]
			cell?.lbl_places?.attributedText = autocompleMatch.attributedFullText
			print(autocompleMatch.attributedPrimaryText)
            print(autocompleMatch.attributedSecondaryText)
		}
		else if autocompleteAddress.count == 0 {
			
			cell?.lbl_places?.text = "No data Found"
		}
		return cell!
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let autocompleMatch = autocompleteAddress[indexPath.row]
		
		self.delegateFromGooglePlaces?.onPlacesPressed(selectedPlaces:autocompleMatch.attributedFullText,autoCompleteData:autocompleMatch)
		
	}
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	
	func placeAutocomplete(searchStr:String,textfield:UITextField,placesClient:GMSPlacesClient)
	{
        print("Search String >>> \(searchStr)")
        
		let filter = GMSAutocompleteFilter()
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            filter.type = .city
           // filter.country = "UK"
        }

		//filter.type = .noFilter
		self.autocompleteAddress = []
        self.tableVw.reloadData()
        if CheckPermission.shared.connectedToNetwork(){
            if searchStr.length > 0{
                placesClient.autocompleteQuery(searchStr, bounds: nil, filter: filter, callback: {
                    (results, error) -> Void in
                    guard error == nil else
                    {
                        self.autocompleteAddress = [GMSAutocompletePrediction]()
                        print("Autocomplete error \(String(describing: error))")
                        return
                    }
                    if let results = results
                    {
                        if results.count>0{
                            self.lbl_noRecords.isHidden = true
                        }
                        else{
                            self.lbl_noRecords.isHidden = false
                            
                        }
                        // print(" google results :-\(results)")
                        if(textfield.isFirstResponder)
                        {
                            self.autocompleteAddress = results
                            self.tableVw.isHidden = false
                            
                        }
                        self.tableVw.reloadData()
                        
                    }
                })
            }
            else{
                self.tableVw.reloadData()
                self.tableVw.isHidden = true
            }
        }
        else{
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg:Alerts.internetOff.rawValue, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        }

        }
 
	
}


extension UIResponder {
    var parentViewController: UIViewController? {
        return (self.next as? UIViewController) ?? self.next?.parentViewController
    }
}
