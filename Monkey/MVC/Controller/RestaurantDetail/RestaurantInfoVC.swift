//
//  RestaurantInfoVC.swift
//  dem
//
//  Created by apple on 02/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import MapKit

class RestaurantInfoVC: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    var array = ["Where to find us","Description","","Opening hours","Delivery areas"]
    public var arrWeekDay = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Satudrday",
        "Sunday"
        ]
    var Resturant_id = 0
    var deliveryAreas = [String]()
    var restDetail : SpecificRestaurantListModal?
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.estimatedRowHeight = 120
        tblView.rowHeight = UITableViewAutomaticDimension
        self.Resturant_id = (self.parent as? RestaurantMenuMXVC)?.Resturant_id ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var customerId : String?
        if let customer_id = DBManager.accessUserDefaultsForKey(keyStr: Keys.Customer_id.rawValue) as? Int{
            customerId = "\(customer_id)"
        }
        APIManager.shared.request(with: LoginEndpoint.restaurantDetails(TokenKey: CommonMethodsClass.getDeviceToken(), Resturant_id: self.Resturant_id,Customer_id: customerId)){[weak self] (response) in
            self?.handleRestaurantDetailsResponse(response: response)
        }
    }
    
    //MARK:- api handler
    
    func handleRestaurantDetailsResponse(response : Response){
        switch response {
        case .success(let responseValue):
            if let dict = responseValue as? RestaurantDetailsModal
            {
                if let code = dict.Code{
                    
                    if let msg = dict.Message{
                        if code == "200"{
                            if let arrRestaurant_Details = dict.Resturants?.Restaurant_Details{
                                let restDetail = arrRestaurant_Details[0]
                                if let areas = dict.Resturants?.deliveryAreas
                                {
                                    deliveryAreas = areas
                                }
                                self.restDetail = restDetail
                                self.tblView.reloadData()
                            }
                        }else{
                            
                            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.succes.rawValue)
                        }
                    }
                }
            }
            
        case .failure(let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Error.rawValue, msg: /msg, vc: self, isDelegateRequired: false, imgName: Images.error.rawValue)
        case .Warning(let msg):
            
            CommonMethodsClass.showAlertWithSingleButton(title: Keys.Warning.rawValue , msg: /msg , vc: self, isDelegateRequired: false, imgName: Images.warning.rawValue)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3{
            return 7
        }else if section == 4{
            
            return deliveryAreas.count
            
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 0
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30))
        returnedView.backgroundColor = .white
        if section == 2{
            return nil
        }
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        label.font = UIFont(name: FontName.LatoRegular.rawValue, size: 20.0)
        label.text = self.array[section]
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return array[section]
//    }
//
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapInfoCell") as! MapInfoCell
            if let restDetail = self.restDetail{
                let center = CLLocationCoordinate2D(latitude: restDetail.cordinate_latitude ?? 0.0, longitude: restDetail.cordinate_longitude ?? 0.0)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                cell.mapvw.setRegion(region, animated: true)
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                annotation.subtitle = "Current location"
                cell.mapvw.addAnnotation(annotation)
                let value  = (restDetail.Rest_Street_Line1 ?? "") + "  " + (restDetail.Rest_Street_Line2 ?? "") + ","
                let value1 = (restDetail.Rest_City ?? "") + "," + "\n" + (restDetail.Rest_Post_Code ?? "")
                cell.lbl_currentAdd.text = value + value1
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
            cell.lbl_desc.text = self.restDetail?.Rest_Info
            if self.restDetail?.Rest_Info == "" || self.restDetail?.Rest_Info == nil{
                cell.btnOutlet_readMore.isHidden = true
            }else{
                cell.btnOutlet_readMore.isHidden = false
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingInfoCell") as! RatingInfoCell
            return cell
        case 3:
              let cell = tableView.dequeueReusableCell(withIdentifier: "DurationCell") as! DurationCell
               cell.lbl_weekDay.text = arrWeekDay[indexPath.row]
              if let restDetail = self.restDetail{
              var startTime = ""
              var endTime = ""
              switch indexPath.row{
              case 0:
                startTime = restDetail.Monday_Open ?? "00:00"
                endTime = restDetail.Monday_close ?? "00:00"
              case 1:
                startTime = restDetail.Tuesday_open ?? "00:00"
                endTime = restDetail.Tuesday_close ?? "00:00"
              case 2:
                startTime = restDetail.Wednesday_open ?? "00:00"
                endTime = restDetail.Wednesday_close ?? "00:00"
              case 3:
                startTime = restDetail.Thursday_open ?? "00:00"
                endTime = restDetail.Thursday_close ?? "00:00"
              case 4:
                startTime = restDetail.Friday_open ?? "00:00"
                endTime = restDetail.Friday_close ?? "00:00"
              case 5:
                startTime = restDetail.Saturday_open ?? "00:00"
                endTime = restDetail.Saturday_close ?? "00:00"
              case 6:
                startTime = restDetail.Sunday_open ?? "00:00"
                endTime = restDetail.Sunday_close ?? "00:00"
              default:
                break
              }
              cell.lbl_time.text = startTime + "-" + endTime
                if startTime == "Closed"{
                    cell.lbl_time.text = "  Closed"
                }
              }
            return cell
        case 4:
              let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCell") as! DeliveryCell
              cell.lbl_area.text = deliveryAreas[indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }

}

class MapInfoCell:UITableViewCell{
    @IBOutlet weak var mapvw: MKMapView!
    @IBOutlet weak var lbl_currentAdd: UILabel!
    
}

class DescriptionCell:UITableViewCell{
    @IBOutlet weak var lbl_desc : UILabel!
    @IBOutlet weak var btnOutlet_readMore: UIButton!
}

class RatingInfoCell:UITableViewCell{
    
    @IBOutlet weak var lbl_heading: UILabel!
    @IBOutlet weak var lbl_link: UILabel!
}

class DurationCell:UITableViewCell{
    @IBOutlet weak var lbl_weekDay: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    
}

class DeliveryCell:UITableViewCell{
    @IBOutlet weak var lbl_area: UILabel!
    
}
