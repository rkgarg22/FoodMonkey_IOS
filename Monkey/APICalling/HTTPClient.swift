

//
//  HTTPClient.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import Foundation
import Alamofire


typealias HttpClientSuccess = (Any?) -> ()
typealias HttpClientFailure = (String) -> ()

class HTTPClient {
    
    func JSONObjectWithData(data: NSData) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data as Data, options: []) }
        catch { return .none }
    }
    
    func postRequest(withApi api : Router , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ){
        
        let fullPath = api.baseURL + api.route
        print(fullPath)
        print(api.parameters ?? "")
        print(api.header)
        
        Alamofire.request(fullPath, method: api.method, parameters: api.parameters, encoding: JSONEncoding.default, headers: headerNeeded(api: api) ? api.header : nil ).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                
                if let header = response.response?.allHeaderFields["xlogintoken"] as? String{
                    DBManager.setValueInUserDefaults(value: header, forKey: ParamKeys.accessToken.rawValue)
                }
                
                success(data)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func getRequest(withApi api : Router , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure ){
        
        let fullPath = api.baseURL + api.route
        print(fullPath)
        print(api.parameters ?? "")
        print(api.header)
        
        Alamofire.request(fullPath, method: api.method, parameters: api.parameters, encoding: URLEncoding.default, headers: headerNeeded(api: api) ? api.header : nil ).responseJSON { (response) in
            
            switch response.result {
            case .success(let data):
                
                if let header = response.response?.allHeaderFields["xlogintoken"] as? String{
                    DBManager.setValueInUserDefaults(value: header, forKey: ParamKeys.accessToken.rawValue)
                }
                
                success(data)
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    
    //upload media to server.. mediaType:0 for photo , 1 for video
    func uploadMediaToServer(api:Router,imgMedia:[String:Data],videoMedia:[String:Data],success:@escaping HttpClientSuccess,failure:@escaping HttpClientFailure){
        let fullPath = api.baseURL + api.route
        print(fullPath)
        print(api.parameters ?? "")
        print(api.header)
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while((topVC!.presentedViewController) != nil){
            topVC = topVC!.presentedViewController
        }
        
        var url = try! URLRequest.init(url: fullPath, method: api.method, headers: api.header)
        url.timeoutInterval = 180
        let imgMimeType : String = "image/jpeg"
        let imgFileName = "a.jpeg"
        
        let  videoMimeType = "video/mp4"
        let  videoFileName = "a.mp4"
        
        
        Alamofire.upload(multipartFormData: { (formdata) in
            if let params = api.parameters{
                for (key, value) in params {
                    formdata.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
            for (key,value) in imgMedia{
                formdata.append(value, withName: key, fileName: imgFileName, mimeType: imgMimeType)
            }
            for (key,value) in videoMedia{
                formdata.append(value, withName: key, fileName: videoFileName, mimeType: videoMimeType)
            }
        }, with: url) { (encodingResult) in
            switch encodingResult{
            case .success(let upload,_,_):
                upload.responseJSON(completionHandler: { (response) in
                    switch response.result{
                    case .success(_):
                        success(response.result.value)
                        break
                    case .failure(let encodingError):
                        failure(encodingError.localizedDescription)
                        break
                    }
                })
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
    }
    
    func headerNeeded(api : Router) -> Bool{
        switch api.route {
            
        case APIConstants.signUp, APIConstants.login, APIConstants.addToken:
            return false
            
        default: return true
        }
    }
   
    
}

