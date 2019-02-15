  //
  //  Utility.swift
  //  TicketManagement
  //
  //  Created by Aseem 13 on 12/04/17.
  //  Copyright © 2017 Taran. All rights reserved.
  //
  
  import UIKit
  import NVActivityIndicatorView
  import EZSwiftExtensions
  import CoreLocation
  import Photos
  import AVFoundation
  import CoreImage
  import MobileCoreServices
  import CropViewController
  
  import MapKit
  
  typealias AWSBucketBlock = (_ assetName : String?,_ thumb : String?) -> ()
  //typealias success = (_ postalCode:String?) -> ()
  
   typealias success = (_ coordinates: CLLocationCoordinate2D, _ fullAddress: String?, _ address : String?, _ city : String?,_ state : String?, _ subLocality: String?, _ postalCode:String?  ) -> ()
  
  enum DateType{
    case time
    case date
  }
  
  enum utiltyCropStyle{
     case circurlar
     case rectangle
  }
  
  class Utility: UIViewController,NVActivityIndicatorViewable, UIImagePickerControllerDelegate,UINavigationControllerDelegate,TOCropViewControllerDelegate {
    
    static let shared = Utility()
    var responseBack : success?
    let geoCoder = CLGeocoder()
    var croppingType : TOCropViewCroppingStyle = .default
    let formatter = DateFormatter()
    var isEditedImage : Bool = false
    var completionHandler: ((UIImage,String)->Void)? = nil
    var completionHandlerVideo: ((UIImage,NSURL)->Void)? = nil
    var failureHandler: ((String)->Void)? = nil
    var pickerType = 0 //1-camera,2-gallery

    
    //MARK: Loader
    func loader()  {
        
        DispatchQueue.main.async {
            let size = CGSize(width: 40, height:40)
            self.startAnimating(size, message: "", type: NVActivityIndicatorType(rawValue: 23)!)
        }
    }
    
    func removeLoader()
    {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
    
    
    
    //MARK: JSON Converiosn to String
    
    func converyToJSONString (array : [Any]?) -> String{
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: array ?? [], options: JSONSerialization.WritingOptions.prettyPrinted)
            
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return JSONString
            }
            
        } catch {}
        return ""
    }
    
    //MARK: Convert milliSec to Date
    
    func convertSecondToDate(second : Int?, type : DateType) -> String{
        
        guard let sec = second else {return String()}
        let dateVar = Date.init(timeIntervalSince1970: TimeInterval(sec / 1000))
        formatter.dateFormat = type == .date ? "dd MMMM yyyy" : "dd MMM yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: dateVar)
        
    }
    
   
    func convertToDate(second : Int?) -> String{
        
        var dateVar = Date()
        if let sec = second {
            dateVar = Date.init(timeIntervalSince1970: TimeInterval(sec / 1000))
        }
        formatter.dateFormat = "hh:mm aa"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if dateVar.isToday{
            return formatter.string(from: dateVar)
        }else if dateVar.isYesterday{
            return formatter.string(from: dateVar)
        }else if dateVar.year == Date().year{
            let str = formatter.string(from: dateVar)
            formatter.dateFormat = "MMMM dd"
            return "\(dateVar.weekday), \(formatter.string(from: dateVar)) \(str)"
        }else{
            let str = formatter.string(from: dateVar)
            formatter.dateFormat = "MMMM dd yyyy"
            return "\(formatter.string(from: dateVar)) \(str)"
        }
        
    }
    
    
    func stringToDate(str : String?) -> Date?{
        
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale( identifier:"en_US_POSIX")
        guard let str = str else {return Date()}
        return formatter.date(from: str)
        
    }
    
    
    func dateToString(date : Date?) -> String?{
        
        formatter.dateFormat = "yyyy"
        formatter.locale = Locale(identifier:"en_US_POSIX")
        guard let date = date else{return ""}
        return formatter.string(from: date)
    }
    
    
   
    
    // for open camera for photos
    func camera ()
    {
        if checkPermissionOfCamera() == false{
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            //  picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            ez.topMostVC?.present(picker, animated: true, completion: nil)
        }
    }
    
    // for open camera for videos
    func cameraVideo ()
    {
        if checkPermissionOfCamera() == false{
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.videoMaximumDuration = 10.0
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .video
            
            ez.topMostVC?.present(picker, animated: true, completion: nil)
        }
    }
    
    // for access of videos
    func videos ()
    {
        
        
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.sourceType = .savedPhotosAlbum
        ez.topMostVC?.present(picker, animated: true, completion: nil)
    }
    
    
    
    // for access of photos
    func photos ()
    {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeImage as String]
        ez.topMostVC?.present(picker, animated: true, completion: nil)
    }
    
    //CheckPermitionIf camera Permition Off
    func checkPermissionOfCamera() -> Bool
    {
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied:
            CommonMethodsClass.showAlertViewOnWindow(titleStr: Keys.ErrorTitle.rawValue, messageStr: "This app does not have access to your camera", okBtnTitleStr: "OK")
            return false
        case .authorized: break
        case .restricted: break
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
                if granted {
                    print("Granted access to \(cameraMediaType)")
                } else {
                    
                    //  self.dismiss(animated:true, completion: nil)
                    
                }
            }
        }
        return true
    }
    
    //action sheet for take photo
    func openCameraAndPhotos (isEditImage:Bool,cropStyle:utiltyCropStyle, getImage:@escaping (UIImage,String) -> (),failure : @escaping (String) -> ()) {
        
        completionHandler=getImage
        failureHandler = failure
        isEditedImage = isEditImage
        croppingType = (cropStyle == utiltyCropStyle.circurlar) ? TOCropViewCroppingStyle.circular : TOCropViewCroppingStyle.default
        let alert = UIAlertController(title: nil, message: nil, preferredStyle:UIScreen.main.bounds.size.width <= 450.0 ? UIAlertControllerStyle.actionSheet : UIAlertControllerStyle.alert)
        let galleryAction = UIAlertAction(title: "Choose from Gallery", style: UIAlertActionStyle.default, handler: { action in
            self.pickerType = 2
            self.photos()
        })
        
        galleryAction.setValue(UIColor.AppColorGray, forKey: "titleTextColor")

        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: { action in
            self.pickerType = 1
            self.camera()
        })
        cameraAction.setValue(UIColor.AppColorGray, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            self.failureHandler!("userCancelled")
        })
        
        cancelAction.setValue(UIColor.AppColorGreen, forKey: "titleTextColor")
        alert.addAction(galleryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)

       // alert.view.tintColor = UIColor.AppColorGreen
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }
    
    //MARK::- Calculate address using cordinates
    func calculateAddress(lat : CLLocationDegrees , long : CLLocationDegrees , responseBlock : @escaping success)
    {
        
        geoCoder.reverseGeocodeLocation( CLLocation(latitude: lat, longitude: long), completionHandler: { (placemarks, error) -> Void in
            
            let placeMark = placemarks?[0]
            guard let address = placeMark?.addressDictionary?["FormattedAddressLines"] as? [String] else {return}
            
            let fullAddress = address.joined(separator: ", ")
            let addressOnly = placeMark?.addressDictionary?["Name"] as? String
            let city = placeMark?.addressDictionary?["City"] as? String
            let state = placeMark?.addressDictionary?["State"] as? String
            let subLocality = placeMark?.addressDictionary?["Street"] as? String
            let postalCode = placeMark?.addressDictionary?["ZIP"] as? String
            responseBlock(CLLocationCoordinate2D(latitude: lat, longitude: long), fullAddress,addressOnly,city,state,subLocality, postalCode)
        })
        
    }
    
    func openMapsWithOptions(lat:String,long:String,address:String){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle:UIScreen.main.bounds.size.width <= 450.0 ? UIAlertControllerStyle.actionSheet : UIAlertControllerStyle.alert)
        let googleMapsAction = UIAlertAction(title: "Open with Google Maps", style: UIAlertActionStyle.default, handler: { action in
            self.openGoogleMaps(lat: lat, long: long)
        })
        
        googleMapsAction.setValue(UIColor.AppColorGray, forKey: "titleTextColor")
        
        let appleMapsAction = UIAlertAction(title: "Open with Apple Maps", style: UIAlertActionStyle.default, handler: { action in
            let url = "http://maps.apple.com/maps?saddr=\(lat),\(long)"
            self.openAppleMaps(lat: lat, long: long, address: address)
        })
        appleMapsAction.setValue(UIColor.AppColorGray, forKey: "titleTextColor")
        
        let copyAddressAction = UIAlertAction(title: "Copy Address", style: UIAlertActionStyle.default, handler: { action in
            let url = "https://www.google.com/maps/@\(lat),1\(long)"
            self.copyAddress(address: url)
        })
        copyAddressAction.setValue(UIColor.AppColorGray, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
        })
        
        cancelAction.setValue(UIColor.AppColorGreen, forKey: "titleTextColor")
        
        alert.addAction(googleMapsAction)
        alert.addAction(appleMapsAction)
        
        if address != ""
        {
            alert.addAction(copyAddressAction)

        }
        alert.addAction(cancelAction)
        
        alert.view.tintColor = UIColor.AppColorGreen
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }
    
    func openAppleMaps(lat:String,long:String,address:String){
        let regionDistance:CLLocationDistance = 1000;
        let coordinates = CLLocationCoordinate2DMake(Double(lat)!, Double(long)!)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = address
        mapItem.openInMaps(launchOptions: options)
    }
    
    func openGoogleMaps(lat:String,long:String){
        if let UrlNavigation = URL.init(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation){
                if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                }
            }
            else {
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                }
            }
        }
        else
        {
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
            }
        }
    }

    
    func copyAddress(address:String){
        UIPasteboard.general.string = address
        CommonMethodsClass.showAlertWithSingleButton(title: Keys.Success.rawValue, msg: "Address copied to clipboard.", vc: ez.topMostVC!, isDelegateRequired: false, imgName: Images.succes.rawValue)
    }
    
    //action sheet for take video
    func openCameraAndVideos (getVideo:@escaping (UIImage,NSURL) -> (),failure : @escaping (String) -> ()) {
        
        completionHandlerVideo = getVideo
        failureHandler = failure
        //isEditedImage = isEditVideo
        let alert = UIAlertController(title: "Please Select", message: "", preferredStyle:UIScreen.main.bounds.size.width <= 450.0 ? UIAlertControllerStyle.actionSheet : UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { action in
            self.cameraVideo()
        }))
        alert.addAction(UIAlertAction(title: "Videos", style: UIAlertActionStyle.default, handler: { action in
            self.videos()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            self.failureHandler!("userCancelled")
        }))
        alert.view.tintColor = UIColor.AppColorGreen
        ez.topMostVC?.present(alert, animated: true, completion: nil)
    }
    
    
    //crop view controller delegate
    func cropViewController(_ cropViewController: TOCropViewController, didCropImageToRect cropRect: CGRect, angle: Int) {
        
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        if cancelled{
            ez.topMostVC?.dismiss(animated: true, completion: {
                if self.pickerType == 1{
                    //camera
                    self.camera()
                }
                else if self.pickerType == 2{
                    //gallery
                    self.photos()
                }
            })
        }
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropToImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        self.pickerType = 0
        ez.topMostVC?.dismiss(animated:true, completion: nil) //5
        completionHandler!(image,"assert.JPG")
    }
    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircleImage image: UIImage, rect cropRect: CGRect, angle: Int) {
        self.pickerType = 0
        ez.topMostVC?.dismiss(animated:true, completion: nil) //5
        completionHandler!(image,"assert.JPG")

    }
    
    // image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        /////
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
            
            
            guard let image = self.thumbnailForVideoAtURL(url:info[UIImagePickerControllerMediaURL] as! NSURL)else { return }
            
            
            completionHandlerVideo!(image,info[UIImagePickerControllerMediaURL] as! NSURL)
            
        }
        
        ez.topMostVC?.dismiss(animated: true, completion: {
            /////
            if(self.isEditedImage==true){
                if let image = info[UIImagePickerControllerOriginalImage]{
                    let chosenImage = image as! UIImage //2
                    let cropViewController = TOCropViewController.init(croppingStyle: self.croppingType, image: chosenImage)
                    cropViewController.delegate = self
                    ez.topMostVC?.present(cropViewController, animated: true, completion: nil)
                }
            }
            else{
                if let image = info[UIImagePickerControllerOriginalImage]{
                    let chosenImage = image as! UIImage //2
                    self.completionHandler!(chosenImage,"assert.JPG")
                }
            }
        })


       
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerType = 0
        ez.topMostVC?.dismiss(animated: true, completion: nil)
    }
    
    
    
    func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
            return nil
        }
    }
   
    //action sheet for take photo
    func openCamera (getImage:@escaping (UIImage,String) -> (),failure : @escaping (String) -> ()) {
        
        completionHandler=getImage
        failureHandler = failure
        croppingType = .default
        self.camera()
    }
    
    //action sheet for take photo
    func openPhotos (getImage:@escaping (UIImage,String) -> (),failure : @escaping (String) -> ()) {
        
        completionHandler=getImage
        failureHandler = failure
        croppingType = .default
        self.photos()
    }
    
    
  }
  
class DLog: NSObject {
    
    init(title:String, log:Any) {
        #if DEBUG
            print(title, log)
        #endif
        
    }
    
}
  

