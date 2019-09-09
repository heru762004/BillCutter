//
//  GroupResponse.swift
//  BillCutter
//
//  Created by Erick Theodorus on 09/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class GroupReceiptResponse: Mappable {
    var id = 0
    var name = ""
    var description = ""
    var splitType = ""
    var modifiedDate = ""
    var spendingAmt = 0.0
    var listReceipt = [ReceiptResponse]()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        splitType <- map["splitType"]
        modifiedDate <- map["modifiedDate"]
        listReceipt <- map["listReceipt"]
        spendingAmt <- map["spendingAmt"]
    }
    
    func toGroupReceipt() -> GroupReceipt {
        let groupReceipt = GroupReceipt()
        groupReceipt.id = id
        groupReceipt.name = name
        groupReceipt.description = description
        groupReceipt.splitType = splitType
        groupReceipt.modifiedDate = modifiedDate
        groupReceipt.spendingAmt = spendingAmt
        listReceipt.forEach { (receiptResponse) in
            groupReceipt.listReceipt.append(receiptResponse.toReceipt())
        }
        
        return groupReceipt
    }
    
}

class GroupsListResponse: Mappable {
    var data = [GroupReceiptResponse]()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        data <- map["data"]
    }
    
    func toGroupList() -> [GroupReceipt] {
        var groupsReceipt = [GroupReceipt]()
        data.forEach { (groupReceipt) in
            groupsReceipt.append(groupReceipt.toGroupReceipt())
        }
        
        return groupsReceipt
    }
    
}
