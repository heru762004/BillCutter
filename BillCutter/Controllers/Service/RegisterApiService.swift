//
//  RegisterApiService.swift
//  BillCutter
//
//  Created by Erick Theodorus on 03/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class RegisterApiService {

    static let shared = RegisterApiService()
    
    let path = "/register"
    let apiService: ApiService!
    
    private init(){
        self.apiService = ApiService()
    }

    func register(username: String, password: String, email: String, phone: String) -> Observable<ApiStatusResult> {
        let params: [String: Any] = ["username": username,
                                     "password": password,
                                     "email": email,
                                     "handphone": phone]
        
        return apiService.postString(path: path, headers: ["Content-Type": "application/json"], params: params)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<ApiStatusResultResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? ApiStatusResult()
                apiStatusResult.success = success
                return apiStatusResult
        }
    }
    
}
