//
//  ApiStatusResponse.swift
//  BillCutter
//
//  Created by Erick Theodorus on 03/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiStatusResultResponse: Mappable {
    var message = ""
    var error = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        error <- map["error"]
    }
    
    func toApiStatusResult() -> ApiStatusResult {
        let apiStatusResult = ApiStatusResult()
        apiStatusResult.message = message
        apiStatusResult.error = error
        return apiStatusResult
    }
    
}
