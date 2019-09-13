//
//  DashboardResponse.swift
//  BillCutter
//
//  Created by Heru Prasetia on 13/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import ObjectMapper

class DashboardResponse: Mappable {
    var message = ""
    var outstandingBill = 0.0
    var oweByGroups = 0.0
    var spendingToday = 0.0
    var spendingByMonth = 0.0
    var spendingUpToDate = 0.0
    var spendingAvgMonth = 0.0
    var error = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        message <- map["message"]
        error <- map["error"]
        outstandingBill <- map["outstandingBill"]
        oweByGroups <- map["oweByGroups"]
        spendingToday <- map["spendingToday"]
        spendingByMonth <- map["spendingByMonth"]
        spendingToday <- map["spendingToday"]
        spendingUpToDate <- map["spendingUpToDate"]
        spendingAvgMonth <- map["spendingAvgMonth"]
    }
    
    func toApiStatusResult() -> Dashboard {
        let apiStatusResult = Dashboard()
        apiStatusResult.message = message
        apiStatusResult.error = error
        apiStatusResult.outstandingBill = outstandingBill
        apiStatusResult.oweByGroups = oweByGroups
        apiStatusResult.spendingToday = spendingToday
        apiStatusResult.spendingByMonth = spendingByMonth
        apiStatusResult.spendingToday = spendingToday
        apiStatusResult.spendingUpToDate = spendingUpToDate
        apiStatusResult.spendingAvgMonth = spendingAvgMonth
        return apiStatusResult
    }
    
}
