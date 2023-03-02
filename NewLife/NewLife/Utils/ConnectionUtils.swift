//
//  ConnectionUtils.swift
//  NewLife
//
//  Created by Shadi on 25/02/2019.
//  Copyright © 2019 Inceptiontech. All rights reserved.
//

import Foundation
import Alamofire

class ConnectionUtils: NSObject {
    
    static let sessionManager: Session = {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        return Session(configuration: configuration)
    }()
    
    static let acceptableStatusCodes = 200..<300
    
    class func performGetRequest(url:URL, parameters: Parameters?, completion: @escaping (Data?, CustomError?) -> ()) {
        sessionManager.request(url, method: .get , parameters: parameters, encoding: URLEncoding.default, headers: getHeader()).validate(statusCode: acceptableStatusCodes).responseJSON { (response) in
            let result = getData(from: response)
            completion(result.data, result.error)
        }
    }
    
    class func performPostRequest(url:URL, parameters: Parameters?, completion: @escaping (Data?, CustomError?) -> ()) {
        
        sessionManager.request(url, method: .post , parameters: parameters, encoding:  JSONEncoding.default, headers: getHeader()).validate(statusCode: acceptableStatusCodes).responseJSON { (response) in
            let result = getData(from: response)
            completion(result.data, result.error)
        }
    }
    
    class func performDeleteRequest(url:URL, parameters: Parameters?, completion: @escaping (Data?, CustomError?) -> ()) {
        
        sessionManager.request(url, method: .delete , parameters: parameters, encoding:  URLEncoding.default, headers: getHeader()).validate(statusCode: acceptableStatusCodes).responseJSON { (response) in
            let result = getData(from: response)
            completion(result.data, result.error)
        }
    }
    
    class func performUploadRequest(data: Data, name: String, fileName: String, mimeType: String, url:URL, parameters: Parameters?, completion: @escaping (CustomError?) -> ()) {
        
      
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
        }, to: url, headers: getHeader()).response { (response) in
            var error: CustomError? = nil
            if let responseError = response.error {
                let nsError = responseError as NSError
                let message: String? = nsError.localizedFailureReason ?? nsError.localizedDescription
                error = CustomError(message: message, statusCode: nsError.code)
            }
            completion(error)
        }
    }
    
    class func downloadFile(remoteUrl: URL, localFileUrl: URL, completion: @escaping (CustomError?) -> ()) {
        
        let destination: DownloadRequest.Destination = { _, _ in
            return (localFileUrl, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        AF.download(remoteUrl, to: destination).response { response in
            var error: CustomError? = nil
            if let responseError = response.error {
                let nsError = responseError as NSError
                let message: String? = nsError.localizedFailureReason ?? nsError.localizedDescription
                error = CustomError(message: message, statusCode: nsError.code)
            }
            completion(error)
        }
    }
    
    class private func getData(from response: AFDataResponse<Any>) -> (data: Data?, error: CustomError?) {
        
        var error: CustomError? = nil
        var data:Data? = nil
        
        switch response.result {
        case .success:
            data = response.data
            break
        case .failure(let _error):
            let nsError = (_error as NSError)
            var message: String? = nsError.localizedFailureReason ?? nsError.localizedDescription
            var errorModel: ErrorModel? = nil
            if let data = response.data {
                errorModel = ErrorModel(data: data)
                if let _message = errorModel?.message {
                    message = _message
                }
            }
            error = CustomError(message: message, statusCode: nsError.code)
            break
        }
        return (data, error)
    }
    
    class func getHeader() -> HTTPHeaders {
        
        var headers: HTTPHeaders = [
            "Authorization": Api.authorization,
            "platform": "Mobile",
            "os" : "ios",
            "app-version" : UIApplication.appVersion,
            "device-id" : UIDevice.deviceID,
            "language" : Language.languageCode()
        ]
        if let token = UserDefaults.userToken(), token != Api.anonymousToken {
             headers["token"] = token
        }
        
        return headers
    }
}

extension Request {
    public func debugLog() -> Self {
        debugPrint(self)
        return self
    }
}
