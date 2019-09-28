//
//  ReceiptMemberResponse.swift
//  BillCutter
//
//  Created by Erick Theodorus on 28/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class ReceiptMemberResponse: Mappable {
    var id = 0
    var name = ""
    var handphone = ""
    var totalpayment = 0.0
    var totalOwe = 0.0
    var statusPayment = ""
    var receiptHdrId = 0
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["groupMemberId"]
        name <- map["groupMemberName"]
        handphone <- map["groupMemberHandphone"]
        totalpayment <- map["spendAmount"]
        statusPayment <- map["status"]
        totalOwe <- map["spendAmount"]
        receiptHdrId <- map["receiptHdrId"]
    }
    
    func toGroupMember() -> GroupMember {
        let groupMember = GroupMember()
        groupMember.id = id
        groupMember.name = name
        groupMember.handphone = handphone
        groupMember.totalpayment = totalpayment
        groupMember.statusPayment = statusPayment
        groupMember.totalOwe = totalOwe
        groupMember.receiptHdrId = receiptHdrId
        return groupMember
    }
}

class ReceiptMemberListResponse: Mappable {
    var data = [ReceiptMemberResponse]()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data <- map["listMember"]
    }
    
    func toGroupMembers() -> [GroupMember] {
        var groupMember = [GroupMember]()
        data.forEach { (groupMembers) in
            groupMember.append(groupMembers.toGroupMember())
        }
        
        return groupMember
    }
    
}
