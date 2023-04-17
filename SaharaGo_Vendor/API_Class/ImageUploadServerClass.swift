//
//  NetworkEngine.swift
//  LLRTS
//
//  Created by Ritesh on 07/09/20.
//

import UIKit
import Alamofire


class ImageUploadServerClass: NSObject {
    
    static let sharedInstance = ImageUploadServerClass()

    func getRequestHandler(_ urlString: String,isBaseAuthorized: Bool!,  completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
        var headers = ["content-type": "application/json"]
        if let token = UserDefaults.standard.object(forKey: "token") {
            headers["token"] = "\(token)"
        }
        Alamofire.request(
            URL(string: urlString)!,
            method: .get,
            parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<600)
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
//                    HttpStatusCodeManage.showErrorAlertMessage(response.response?.statusCode ?? 404)
                    completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
                    return
                }
                guard ((response.response?.statusCode) != 401)
                else {
                   // logOutUser()
                    return
                }
                guard let responseJSON = response.result.value else {
                    completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
                    return
                }
                completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
        }
    }


    func callJobRequestHandler(_ urlString: String, httpMethodName: String, jsonData:Data?,completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = httpMethodName
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        if let token = KeychainService.loadToken(service: service, account: account) {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        if let token = UserDefaults.standard.object(forKey: "token") {
            request.setValue("\(token)", forHTTPHeaderField: "token")
        }
        request.httpBody = jsonData
        Alamofire.request(request).responseJSON {
            (response) in
            guard response.result.isSuccess else {
//                HttpStatusCodeManage.showErrorAlertMessage(response.response?.statusCode ?? 404)
                completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
                return
            }
            guard ((response.response?.statusCode) != 401)
            else {
               // logOutUser()
                return
            }
            guard let responseJSON = response.result.value else {
                completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
                return
            }
            completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
        }
    }


    func patchWithoutParamRequestHandler(_ urlString: String, method: String, completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        if let token = KeychainService.loadToken(service: service, account: account) {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
        Alamofire.request(request).responseJSON {
            (response) in
            guard response.result.isSuccess else {
//                HttpStatusCodeManage.showErrorAlertMessage(response.response?.statusCode ?? 404)
                completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
                return
            }
            guard ((response.response?.statusCode) != 401)
            else {
                //logOutUser()
                return
            }
            guard let responseJSON = response.result.value as? [String: Any] else {
                completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
                return
            }
            completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
        }
    }


    func multipartPostRequestHandler(_ urlString: String, mimeType: String, fileName: String, params:Dictionary<String,AnyObject>, fileData : Data?, completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
        var headers = [
            "content-type": "application/json",
        ]
//        if let token = KeychainService.loadToken(service: service, account: account) {
//            headers["Authorization"] = "Bearer \(token)"
//        }
        Alamofire.upload(multipartFormData: { multipart in
            if fileData != nil {
                multipart.append(fileData!, withName: "file", fileName: fileName, mimeType: mimeType)
            }
            for (key, value) in params {
                multipart.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to: urlString, method: .post, headers: headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _): upload .validate(statusCode: 200..<600) .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
//                    HttpStatusCodeManage.showErrorAlertMessage(response.response?.statusCode ?? 404)
                    completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
                    return
                }
                guard ((response.response?.statusCode) != 401)
                else {
                   // logOutUser()
                    return
                }
                guard let responseJSON = response.result.value as? [String: Any] else {
                    completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
                    return
                }
                completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
                }
            case .failure(let encodingError):
                completionHandler(nil, encodingError as NSError? ,nil)
            }
        }
    }

    func HTTPsendRequest(request: URLRequest,
                         callback: @escaping (Error?, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if (err != nil) {
                callback(err,nil)
            } else {
                callback(nil, String(data: data!, encoding: String.Encoding.utf8))
            }
        }
        task.resume()
    }

    func HTTPPostJSON(url: String,  data: Data,
                      callback: @escaping (Error?, String?) -> Void) {

        var request = URLRequest(url: URL(string: url)!)

        request.httpMethod = "POST"
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        request.httpBody = data
        HTTPsendRequest(request: request, callback: callback)
    }
    
    
    
   // MARK: - New Network Class Code
    
//    static let sharedInstance = NetworkEngine()
//
//        func getRequestHandler(_ urlString: String,  completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
//
//            #if DEBUG
//            print("HTTP METHOD: GET")
//            print("REQUEST URL : \(urlString)")
//            #endif
//
//
//            var headers = [
//                "content-type": "application/json",
//            ]
//
////            if let token = KeychainService.loadToken(service: service, account: account), token.count > 0 {
////                headers["authorization"] = token
////            }
//
//            Alamofire.request(
//                URL(string: urlString)!,
//                method: .get,
//                parameters: nil, encoding: JSONEncoding.default, headers: headers)
//                .validate(statusCode: 200..<600)
//                .responseJSON { (response) -> Void in
//                    guard response.result.isSuccess else {
//                        print("Error while fetching remote rooms: \(String(describing: response.result.error))")
//                        completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
//                        return
//                    }
//
//                    guard let responseJSON = response.result.value as? [String: Any] else {
//                        print("Invalid tag information received from the service")
//                        completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
//                        return
//                    }
//
//                    completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
//
//            }
//        }
//
//        func postRequestHandler(_ urlString: String, params:Dictionary<String,AnyObject>,completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
//
//            #if DEBUG
//            print("HTTP METHOD: POST")
//            print("REQUEST URL : \(urlString)")
//            print("PARAMS : \(params)")
//
//            #endif
//
//            var headers = [
//                "content-type": "application/json",
//            ]
//
////            if let token = KeychainService.loadToken(service: service, account: account), token.count > 0 {
////                headers["authorization"] = token
////            }
//            Alamofire.request(
//                URL(string: urlString)!,
//                method: .post,
//                parameters: params, encoding: JSONEncoding.default, headers: headers)
//                .validate(statusCode: 200..<600)
//                .responseJSON { (response) -> Void in
//                    guard response.result.isSuccess else {
//                        print("Error while fetching remote rooms: \(String(describing: response.result.error))")
//                        completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
//                        return
//                    }
//
//                    guard let responseJSON = response.result.value as? [String: Any] else {
//                        print("Invalid tag information received from the service")
//                        completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
//                        return
//                    }
//
//                    completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
//
//            }
//
//
//
//        }
//
//        func patchRequestHandler(_ urlString: String, params:Dictionary<String,AnyObject>, completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
//
//            #if DEBUG
//            print("HTTP METHOD: PATCH")
//            print("REQUEST URL : \(urlString)")
//            print("PARAMS : \(params)")
//
//            #endif
//
//            var headers = [
//                "content-type": "application/json",
//            ]
//
////            if let token = KeychainService.loadToken(service: service, account: account), token.count > 0 {
////                headers["authorization"] = token
////            }
//
//            Alamofire.request(
//                URL(string: urlString)!,
//                method: .patch,
//                parameters: params,encoding: JSONEncoding.default, headers: headers)
//                .validate(statusCode: 200..<600)
//                .responseJSON { (response) -> Void in
//                    guard response.result.isSuccess else {
//                        print("Error while fetching remote rooms: \(String(describing: response.result.error))")
//                        completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
//                        return
//                    }
//
//                    guard let responseJSON = response.result.value as? [String: Any] else {
//                        print("Invalid tag information received from the service")
//                        completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
//                        return
//                    }
//
//                    completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
//
//            }
//
//
//        }
//
//
//        func deleteRequestHandler(_ urlString: String, completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
//
//            #if DEBUG
//            print("HTTP METHOD: DELETE")
//            print("REQUEST URL : \(urlString)")
//            #endif
//
//            var headers = [
//                "content-type": "application/json",
//            ]
//
////            if let token = KeychainService.loadToken(service: service, account: account), token.count > 0 {
////                headers["authorization"] = token
////            }
//
//            Alamofire.request(
//                URL(string: urlString)!,
//                method: .delete,
//                parameters: nil,encoding: JSONEncoding.default, headers: headers)
//                .validate(statusCode: 200..<600)
//                .responseJSON { (response) -> Void in
//                    guard response.result.isSuccess else {
//                        print("Error while fetching remote rooms: \(String(describing: response.result.error))")
//                        completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
//                        return
//                    }
//
//                    guard let responseJSON = response.result.value as? [String: Any] else {
//                        print("Invalid tag information received from the service")
//                        completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
//                        return
//                    }
//
//                    completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
//
//            }
//
//        }
//
//        func multipartPostRequestHandler(_ urlString: String, params:Dictionary<String,AnyObject>, fileData : Data?, completionHandler:@escaping (AnyObject?, NSError?, Int?)->()) ->() {
//
//            #if DEBUG
//            print("HTTP METHOD: POST")
//            print("REQUEST URL : \(urlString)")
//            print("PARAMS : \(params)")
//
//            #endif
//
//            var headers = [
//                "content-type": "application/json",
//            ]
//
////            if let token = KeychainService.loadToken(service: service, account: account), token.count > 0 {
////                headers["authorization"] = token
////            }
//            Alamofire.upload(multipartFormData: { multipart in
//                if fileData != nil {
//                    multipart.append(fileData!, withName: "uploadImage", fileName: "userIamge\(arc4random_uniform(9)).jpg", mimeType: "image/jpeg")
//                }
//                for (key, value) in params {
//                    multipart.append(value.data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//                print(multipart)
//            }, to: urlString, method: .post, headers: headers) { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload
//                        .validate(statusCode: 200..<600)
//                        .responseJSON { (response) -> Void in
//                            print(response)
//                            guard response.result.isSuccess else {
//                                print("Error while fetching remote rooms: \(String(describing: response.result.error))")
//                                completionHandler(nil, response.result.error as NSError? ,response.response?.statusCode)
//                                return
//                            }
//                            guard let responseJSON = response.result.value as? [String: Any] else {
//                                print("Invalid tag information received from the service")
//                                completionHandler(nil, response.result.error as NSError?,response.response?.statusCode)
//                                return
//                            }
//                            completionHandler(responseJSON as AnyObject, nil,response.response?.statusCode)
//
//                    }
//                case .failure(let encodingError):
//                    print("encodingError: \(encodingError)")
//                    completionHandler(nil, encodingError as NSError? ,nil)
//                }
//            }
//        }
    
}
