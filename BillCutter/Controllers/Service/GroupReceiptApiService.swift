//
//  GroupReceiptApiService.swift
//  BillCutter
//
//  Created by Erick Theodorus on 09/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class GroupReceiptApiService {
    
    static let shared = GroupReceiptApiService()
    
    let apiService: ApiService!
    
    private init(){
        self.apiService = ApiService()
    }
    
    func createGroup(groupName: String) -> Observable<AddReceipt> {
        let path = "/groups"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        let params: [String: Any] = ["name": "\(groupName)",
            "description": "\(groupName)",
            "splitType": "EQUAL"]
        
        return apiService.postString(path: path, headers: headers, params: params)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<CreateGroupResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? AddReceipt()
                apiStatusResult.success = success
                return apiStatusResult
        }
    }
    
    func getGroupList() -> Observable<[GroupReceipt]> {
        let path = "/groups"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        return apiService.getString(path: path, headers: headers)
            .map { (success, jsonString)  in
                let groupList = Mapper<GroupsListResponse>().map(JSONString: jsonString)?.toGroupList() ?? [GroupReceipt]()
                return groupList
        }
    }
    
    func getGroupReceipt(id: Int) -> Observable<GroupReceipt> {
        let path = "/groups/\(id)/receipts"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        return apiService.getString(path: path, headers: headers)
            .map { (success, jsonString)  in
                let groupReceipt = Mapper<GroupReceiptResponse>().map(JSONString: jsonString)?.toGroupReceipt() ?? GroupReceipt()
                return groupReceipt
        }
    }
    
}
