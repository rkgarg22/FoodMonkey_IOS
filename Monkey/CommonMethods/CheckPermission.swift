//
//  CheckPermission.swift
//  Kabootz
//
//  Created by Sierra 4 on 13/06/17.
//  Copyright © 2017 Sierra 4. All rights reserved.
//


import Photos
import Contacts
import Foundation
import AddressBook
import SystemConfiguration

enum PermissionType {
    
    case camera
    case photos
    case locationAlwaysInUse
    case contacts
    case microphone
    
}


class CheckPermission {
    
    static let shared = CheckPermission()
    
    
    //MARK: - Check Permission
    func permission(For : PermissionType, completion: @escaping (Bool) -> () ) {
        
        switch status(For: For) {
        case 1,2:
            completion(false)
        default:
            completion(true)
        }
        
        
    }
    
    
    //MARK: - Check Status
    private func status(For: PermissionType) -> Int {
        
        switch For {
        case .camera:
            return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo).rawValue
            
        case .contacts:
            if #available(iOS 9.0, *) {
                return CNContactStore.authorizationStatus(for: .contacts).rawValue
            } else {
                return PHPhotoLibrary.authorizationStatus().rawValue
            }
            
        case .locationAlwaysInUse:
            guard CLLocationManager.locationServicesEnabled() else { return 2 }
            return Int(CLLocationManager.authorizationStatus().rawValue)
            
        case .photos:
            return PHPhotoLibrary.authorizationStatus().rawValue
            
        case .microphone:
            let recordPermission = AVAudioSession.sharedInstance().recordPermission()
            return Int(recordPermission.rawValue)
        
        }

    }
    
    
    //MARK: - Check Internet Connection
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    } 
    
}
