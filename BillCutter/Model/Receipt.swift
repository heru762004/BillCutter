//
//  Receipt.swift
//  BillCutter
//
//  Created by Erick Theodorus on 09/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class Receipt {
    
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
    
    var listDetail = [ReceiptItem]()
    
}
