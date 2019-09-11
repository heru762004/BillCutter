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
    var totalpayment = 0.0
    var statusPayment = ""

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        handphone <- map["handphone"]
        totalpayment <- map["totalpayment"]
        statusPayment <- map["statusPayment"]
    }
    
    func toGroupMember() -> GroupMember {
        let groupMember = GroupMember()
        groupMember.id = id
        groupMember.name = name
        groupMember.handphone = handphone
        groupMember.totalpayment = totalpayment
        groupMember.statusPayment = statusPayment
        return groupMember
    }
    
}

class GroupMemberListResponse: Mappable {
    var data = [GroupMemberResponse]()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data <- map["data"]
    }
    
    func toGroupMembers() -> [GroupMember] {
        var groupMember = [GroupMember]()
        data.forEach { (groupMembers) in
            groupMember.append(groupMembers.toGroupMember())
        }
        
        return groupMember
    }
    
}

