//
//  GetLoginProfileResponse.swift
//  BillCutter
//
//  Created by Heru Prasetia on 12/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class GetLoginProfileResponse: Mappable {
    var message = ""
    var email = ""
    var username = ""
    var handphone = ""
    var name = ""
    var error = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        error <- map["error"]
        email <- map["email"]
        username <- map["username"]
        handphone <- map["handphone"]
        name <- map["name"]
    }
    
    func toApiStatusResult() -> LoginProfile {
        let apiStatusResult = LoginProfile()
        apiStatusResult.message = message
        apiStatusResult.error = error
        apiStatusResult.name = name
        apiStatusResult.username = username
        apiStatusResult.email = email
        apiStatusResult.handphone = handphone
        return apiStatusResult
    }
    
}
