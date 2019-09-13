//
//  CreateGroupResponse.swift
//  BillCutter
//
//  Created by Heru Prasetia on 13/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class CreateGroupResponse: Mappable {
    var id = 0
    var message = ""
    var error = false
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        error <- map["error"]
        id <- map["id"]
    }
    
    func toApiStatusResult() -> AddReceipt {
        let apiStatusResult = AddReceipt()
        apiStatusResult.message = message
        apiStatusResult.error = error
        apiStatusResult.id = id
        return apiStatusResult
    }
}
