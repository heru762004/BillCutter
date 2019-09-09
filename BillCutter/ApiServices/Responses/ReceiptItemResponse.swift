//
//  ReceiptItemResponse.swift
//  BillCutter
//
//  Created by Erick Theodorus on 09/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class ReceiptItemResponse: Mappable {
    var id = 0
    var createdDate = ""
    var modifiedDate = ""
    var receiptHdrId = 0
    var name = ""
    var amount = 0
    var price = 0.0
    var total = 0.0
    var discount = 0.0
    var serviceCharge = 0.0
    var description = ""
    var splitType = ""
 
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        createdDate <- map["createdDate"]
        modifiedDate <- map["modifiedDate"]
        receiptHdrId <- map["receiptHdrId"]
        name <- map["name"]
        amount <- map["amount"]
        price <- map["price"]
        total <- map["total"]
        discount <- map["discount"]
        serviceCharge <- map["serviceCharge"]
        description <- map["description"]
        splitType <- map["splitType"]
    }
    
    func toReceiptItem() -> ReceiptItem {
        let receiptItem = ReceiptItem()
        receiptItem.id = id
        receiptItem.createdDate = createdDate
        receiptItem.modifiedDate = modifiedDate
        receiptItem.receiptHdrId = receiptHdrId
        receiptItem.name = name
        receiptItem.amount = amount
        receiptItem.price = price
        receiptItem.total = total
        receiptItem.discount = discount
        receiptItem.serviceCharge = serviceCharge
        receiptItem.description = description
        receiptItem.splitType = splitType
        return receiptItem
    }
    
}
