//
//  GroupMemberApiService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 10/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class GroupMemberApiService {
    static let shared = GroupMemberApiService()
    
    let apiService: ApiService!
    
    private init(){
        self.apiService = ApiService()
    }
    
    func getGroupMember(groupId: Int) -> Observable<[GroupMember]> {
        let path = "/groups/\(groupId)/members"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        return apiService.getString(path: path, headers: headers)
            .map { (success, jsonString)  in
                let groupMember = Mapper<GroupMemberListResponse>().map(JSONString: jsonString)?.toGroupMembers() ?? [GroupMember]()
                return groupMember
        }
    }
    
    func getGroupMember(groupId: Int, receiptHeaderId: Int) -> Observable<[GroupMember]> {
        let path = "/groups/\(groupId)/receipts/\(receiptHeaderId)"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        return apiService.getString(path: path, headers: headers)
            .map { (success, jsonString)  in
                let groupMember = Mapper<GroupMemberListResponse>().map(JSONString: jsonString)?.toGroupMembers() ?? [GroupMember]()
                return groupMember
        }
    }
    
    func addMember(listMembers: [Member]) -> Observable<ApiStatusResult> {
        
        let path = "/groups/addmember"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        var members = [[String: Any]]()
        for member in listMembers {
            members.append(member.toDict())
        }
        let params: [String: Any] = ["data": members]
        
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
    
    func removeMember(groupId: Int, memberId: Int) -> Observable<ApiStatusResult> {
        
        let path = "/groups/members/delete"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        let params: [String: Any] = ["groupId": "\(groupId)", "id": "\(memberId)"]
        
        return apiService.postString(path: path, headers: headers, params: params)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<ApiStatusResultResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? ApiStatusResult()
                apiStatusResult.success = success
                return apiStatusResult
        }
    }
    
    
}
