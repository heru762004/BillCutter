//
//  LoginApiService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 29/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift

class LoginApiService {
    static let shared = LoginApiService()
    
    let path = "/oauth/token?grant_type=password&username="
    
    let apiService: SweetEscapeApiClient!
    
    //Initializer access level change now
    private init(){
        self.apiService = SweetEscapeApiClient()
    }
    
    func sendRequest(userName: String, password: String, onSuccess success: @escaping (_ resp: String) -> Void, onFailure failure: @escaping (_ err: ErrorResponse) -> Void) {
        let finalPath = "\(path)\(userName)&password=\(password)"
        self.apiService.postString(path: finalPath, headers: ["Authorization": "Basic bm9sdHVqdWhkdWE6Y3Jvc3N0aGVsaW1pdA=="], params: [:]).debug().observeOn(MainScheduler.instance).subscribe(onNext: { (status, json) in
            
            let data: Data = json.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            do {
                var dicData: [String: Any] = try JSONSerialization.jsonObject(with: data, options:[]) as! [String: Any]
                print(dicData)
                
                if status {
                    print("SUCCESS JSON RESPONSE = \(json)")
                    // need to be store because we need to pass it during other request
                    if let accessToken = dicData["access_token"] as? String {
                        UserDefaultService.shared.storeString(key: UserDefaultService.Key.ACCESS_TOKEN, value: accessToken)
                        success("")
                    }
                } else {
                    print("ERROR JSON RESPONSE = \(json)")
                    var errCode = ""
                    var errMessage = ""
                    if let errorCode = dicData["status"] as? String {
                        errCode = errorCode
                    }
                    if let errorMessage = dicData["message"] as? String {
                        errMessage = errorMessage
                    }
                    if let errorMessage = dicData["error_description"] as? String {
                        errMessage = errorMessage
                    }
                    let errObj = ErrorResponse(errorCode: errCode, errorMessage: errMessage)
                    failure(errObj)
                }
            } catch {
                let errObj = ErrorResponse(errorCode: "", errorMessage: error.localizedDescription)
                failure(errObj)
            }
        }, onError: { (err) in
            print(err)
            let errObj = ErrorResponse(errorCode: "", errorMessage: err.localizedDescription)
            failure(errObj)
        }, onCompleted: {
            print("oncompleted")
        }) {
            print("ondisposed")
        }
    }
}
