//
//  TagMemberResponse.swift
//  BillCutter
//
//  Created by Erick Theodorus on 27/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class TagMemberResponse: Mappable {
    
    var id = -1
    var groupId = ""
    var name = ""
    var handphone = ""
    var percentage = 0.0
    var amount = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        groupId <- map["groupId"]
        name <- map["name"]
        handphone <- map["handphone"]
        percentage <- map["percentage"]
        amount <- map["amount"]
    }
    
    func toTagMember() -> TagMember {
        let tagMember = TagMember()
        tagMember.id = id
        tagMember.groupId = groupId
        tagMember.name = name
        tagMember.handphone = handphone
        tagMember.percentage = percentage
        tagMember.amount = amount
        return tagMember
    }
    
}
