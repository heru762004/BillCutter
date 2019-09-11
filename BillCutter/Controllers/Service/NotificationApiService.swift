//
//  NotificationApiService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 11/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class NotificationApiService {
    static let shared = NotificationApiService()
    
    let apiService: ApiService!
    
    private init(){
        self.apiService = ApiService()
    }
    
    func sendNotification(groupId: String, receiptId: String) -> Observable<ApiStatusResult> {
        let path = "/groups/notif"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        //{"id":"1", "action":"ATTACH", "groupId":2}
        let params: [String: Any] = [
            "receiptHdrId" : receiptId,
            "groupMemberId": groupId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString!)
        } catch {
            print(error.localizedDescription)
        }
        
        return apiService.postString(path: path, headers: headers, params: params)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<ApiStatusResultResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? ApiStatusResult()
                apiStatusResult.success = success
                return apiStatusResult
        }
    }
}
