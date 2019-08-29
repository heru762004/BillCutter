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
    
    func sendRequest(userName: String, password: String) {
        let finalPath = "\(path)\(userName)&password=\(password)"
        self.apiService.postString(path: finalPath, headers: ["Authorization": "Basic bm9sdHVqdWhkdWE6Y3Jvc3N0aGVsaW1pdA=="], params: [:]).debug().observeOn(MainScheduler.instance).subscribe(onNext: { (status, json) in
            if status {
                print("SUCCESS JSON RESPONSE = \(json)")
            } else {
                print("ERROR JSON RESPONSE = \(json)")
            }
        }, onError: { (err) in
            print(err)
        }, onCompleted: {
            print("oncompleted")
        }) {
            print("ondisposed")
        }
    }
}
