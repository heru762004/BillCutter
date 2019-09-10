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
}
