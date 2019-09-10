//
//  GroupMemberResponse.swift
//  BillCutter
//
//  Created by Heru Prasetia on 10/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupMemberResponse: Mappable {
    var id = 0
    var name = ""
    var handphone = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        handphone <- map["handphone"]
    }
    
    func toGroupMember() -> GroupMember {
        let groupMember = GroupMember()
        groupMember.id = id
        groupMember.name = name
        groupMember.handphone = handphone
        return groupMember
    }
    
}
