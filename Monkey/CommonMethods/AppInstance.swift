//
//  AppInstance.swift
//  CEMETRY_APP
//
//  Created by KHUSHBOO on 28/05/16.
//  Copyright © 2016 KHUSHBOO. All rights reserved.
//


import UIKit

private let _applicationInstance = AppInstance()


class AppInstance: NSObject {
    
    class var applicationInstance : AppInstance {
        
        return _applicationInstance
        
    }
    
}
