//
//  ListGroupApiService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 30/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift

class ListGroupApiService {
    static let shared = ListGroupApiService()
    
    let path = "/groups"
    
    let apiService: SweetEscapeApiClient!
    
    //Initializer access level change now
    private init(){
        self.apiService = SweetEscapeApiClient()
    }
    
    func sendRequest(onSuccess success: @escaping (_ resp: String) -> Void, onFailure failure: @escaping (_ err: ErrorResponse) -> Void) {
        let finalPath = "\(path)"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        print("accessToken = \(accessToken)")
        self.apiService.getString(path: finalPath, headers: ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]).debug().observeOn(MainScheduler.instance).subscribe(onNext: { (status, json) in
            
            let data: Data = json.data(using: String.Encoding.utf8, allowLossyConversion: true)!
            do {
                let dicData = try JSONSerialization.jsonObject(with: data, options:[])
                print(dicData)
                
                if status {
                    print("SUCCESS JSON RESPONSE = \(json)")
                    // need to be store because we need to pass it during other request
//                    if let accessToken = dicData["access_token"] as? String {
//                        UserDefaultService.shared.storeString(key: UserDefaultService.Key.ACCESS_TOKEN, value: accessToken)
                        success("")
//                    }
                } else {
                    print("ERROR JSON RESPONSE = \(json)")
                    var errCode = ""
                    var errMessage = ""
                    if let dic = dicData as? [String: Any] {
                        if let errorCode = dic["status"] as? String {
                            errCode = errorCode
                        }
                        if let errorMessage = dic["message"] as? String {
                            errMessage = errorMessage
                        }
                        if let errorMessage = dic["error_description"] as? String {
                            errMessage = errorMessage
                        }
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
