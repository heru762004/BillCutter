//
//  ReceiptItemDetailResponse.swift
//  BillCutter
//
//  Created by Erick Theodorus on 27/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class ReceiptDetailItemResponse: Mappable {

    var id = 0
    var name = ""
    var amount = 0
    var price = 0.0
    var total = 0.0
    var tagMembers = [TagMemberResponse]()

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        amount <- map["amount"]
        price <- map["price"]
        total <- map["total"]
        tagMembers <- map["tagMember"]
    }
    
    func toReceiptDetailItem() -> ReceiptDetailItem {
        let receiptDetailItem = ReceiptDetailItem()
//        receiptDetailItem.id = id
        receiptDetailItem.name = name
        receiptDetailItem.amount = amount
        receiptDetailItem.price = price
        receiptDetailItem.total = total
        tagMembers.forEach { (tagMember) in
            receiptDetailItem.tagMembers.append(tagMember.toTagMember())
        }
        return receiptDetailItem
    }
}
