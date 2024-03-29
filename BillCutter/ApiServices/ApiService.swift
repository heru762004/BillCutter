//
//  ApiService.swift
//  BillCutter
//
//  Created by Erick Theodorus on 25/08/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class ApiService {
    
    private let configuration = URLSessionConfiguration.default
    private let serverUrl = "https://w3uoqtppme.execute-api.ap-southeast-1.amazonaws.com/Prod"
    
    private static let successResponseCode = 200
    private static let sessionExpiredResponseCode = 401
    
    func getString(path: String, headers: [String: String] =  ["":""]) -> Observable<(Bool, String)> {
        return doRequest(path: path, headers: headers, method: .get, params: nil)
    }
    
    func postString(path: String, headers: [String: String], params: [String: Any]) -> Observable<(Bool, String)> {
        return doRequest(path: path, headers: headers, method: .post, params: params)
    }
    
    func putString(path: String, headers: [String: String], params: [String: Any]) -> Observable<(Bool, String)> {
        return doRequest(path: path, headers: headers, method: .put, params: params)
    }
    
    private func populateHeaders(dict: [String:String]? = nil) -> [String:String] {
        var headers = [String:String]()
//                headers["Content-Type"] = "application/json"
        
        if let dict = dict {
            for (k, v) in dict where !k.isEmpty {
                headers[k] = v
            }
        }
        
        return headers
    }
    
    private func doRequest(path: String, headers: [String: String], method: Alamofire.HTTPMethod, params: [String: Any]?) -> Observable<(Bool, String)> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager = SessionManager.default
        return manager.rx.request(method, serverUrl + path, parameters: params, encoding: JSONEncoding.default, headers: populateHeaders(dict: headers))
            .flatMap { alamofireRequest in
                alamofireRequest.rx.responseString()
            }
            .do(onNext: { (response, string) in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            },
                onError: { _ in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
            },
                onCompleted: {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }).debug()
            .map { (response, string) in
                return (response.statusCode == ApiService.successResponseCode, string)
        }
    }
}
