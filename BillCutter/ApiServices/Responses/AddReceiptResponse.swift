//
//  AddReceiptResponse.swift
//  BillCutter
//
//  Created by Heru Prasetia on 11/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class AddReceiptResponse: Mappable {
    var id = ""
    var message = ""
    var error = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        message <- map["message"]
        error <- map["error"]
    }
    
    func toApiStatusResult() -> AddReceipt {
        let apiStatusResult = AddReceipt()
        apiStatusResult.id = id
        apiStatusResult.message = message
        apiStatusResult.error = error
        return apiStatusResult
    }
    
}
