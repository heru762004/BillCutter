//
//  GetProfileApiService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 12/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class GetProfileApiService {
    static let shared = GetProfileApiService()
    
    let apiService: ApiService!
    
    private init(){
        self.apiService = ApiService()
    }
    
    func getLoginProfile() -> Observable<LoginProfile> {
        let path = "/profile"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        return apiService.getString(path: path, headers: headers)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<GetLoginProfileResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? LoginProfile()
                apiStatusResult.success = success
                
                UserDefaultService.shared.storeString(key: UserDefaultService.Key.PHONE_NUMBER, value: apiStatusResult.handphone)
                return apiStatusResult
        }
    }
}
