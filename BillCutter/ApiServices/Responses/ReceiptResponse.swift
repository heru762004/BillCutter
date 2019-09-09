//
//  ReceiptResponse.swift
//  BillCutter
//
//  Created by Erick Theodorus on 09/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class ReceiptResponse: Mappable {
    var id = 0
    var createdDate = ""
    var modifiedDate = ""
    var name = ""
    var receiptDate = ""
    var receiptNo = ""
    var subtotal = 0.0
    var discount = 0.0
    var grandtotal = 0.0
    var receipt_url = ""
    var userId = 0
    var groupId = 0
    var splitType = ""
    var serviceCharge = ""
    var paidBy = ""

    var listDetail = [ReceiptItemResponse]()

    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        createdDate <- map["createdDate"]
        modifiedDate <- map["modifiedDate"]
        name <- map["name"]
        receiptDate <- map["receiptDate"]
        receiptNo <- map["receiptNo"]
        subtotal <- map["subtotal"]
        discount <- map["discount"]
        grandtotal <- map["grandtotal"]
        receipt_url <- map["receipt_url"]
        userId <- map["userId"]
        groupId <- map["groupId"]
        splitType <- map["splitType"]
        serviceCharge <- map["serviceCharge"]
        paidBy <- map["paidBy"]
        listDetail <- map["listDetail"]
    }
    
    func toReceipt() -> Receipt {
        let receipt = Receipt()
        receipt.id = id
        receipt.createdDate = createdDate
        receipt.modifiedDate = modifiedDate
        receipt.name = name
        receipt.receiptDate = receiptDate
        receipt.receiptNo = receiptNo
        receipt.subtotal = subtotal
        receipt.discount = discount
        receipt.grandtotal = grandtotal
        receipt.receipt_url = receipt_url
        receipt.userId = userId
        receipt.groupId = groupId
        receipt.splitType =  splitType
        receipt.serviceCharge = serviceCharge
        receipt.paidBy = paidBy

        listDetail.forEach { (receiptItemResponse) in
            receipt.listDetail.append(receiptItemResponse.toReceiptItem())
        }
        
        return receipt
    }
    
    
}
