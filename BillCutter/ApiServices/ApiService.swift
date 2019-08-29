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

class SweetEscapeApiClient {
    
    private let configuration = URLSessionConfiguration.default
    private let serverUrl = "https://w3uoqtppme.execute-api.ap-southeast-1.amazonaws.com/Prod"
    
    private static let successResponseCode = 200
    private static let sessionExpiredResponseCode = 401
    
    func getString(path: String, headers: [String: String] =  ["":""], apiVersion: String = "v1/") -> Observable<(Bool, String)> {
        return doRequest(path: path, headers: headers, method: .get, params: nil, apiVersion: apiVersion)
    }
    
    func postString(path: String, headers: [String: String], params: [String: Any], apiVersion: String = "v1/") -> Observable<(Bool, String)> {
        return doRequest(path: path, headers: headers, method: .post, params: params, apiVersion: apiVersion)
    }
    
    func putString(path: String, headers: [String: String], params: [String: Any], apiVersion: String = "v1/") -> Observable<(Bool, String)> {
        return doRequest(path: path, headers: headers, method: .put, params: params, apiVersion: apiVersion)
    }
    
    private func populateHeaders(
        dict: [String:String]? = nil) -> [String:String] {
        var headers = [String:String]()
        //        headers["API-KEY"] = "17d32457220C136fA34bA83964d493Be"
        
        if let dict = dict {
            for (k, v) in dict where !k.isEmpty {
                headers[k] = v
            }
        }
        
        return headers
    }
    
    private func doRequest(path: String, headers: [String: String], method: Alamofire.HTTPMethod, params: [String: Any]?, apiVersion: String) -> Observable<(Bool, String)> {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let manager = SessionManager.default
        return manager.rx.request(method, serverUrl + path, parameters: params, headers: populateHeaders(dict: headers))
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
            })
            .map { (response, string) in
                return (response.statusCode == SweetEscapeApiClient.successResponseCode, string)
        }
    }
}
