//
//  DashboardApiService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 13/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class DashboardApiService {
    static let shared = DashboardApiService()
    
    let apiService: ApiService!
    
    private init(){
        self.apiService = ApiService()
    }
    
    func getDashboardProfile() -> Observable<Dashboard> {
        let path = "/profile/dashboard"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        return apiService.getString(path: path, headers: headers)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<DashboardResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? Dashboard()
                apiStatusResult.success = success
                return apiStatusResult
        }
    }
}
