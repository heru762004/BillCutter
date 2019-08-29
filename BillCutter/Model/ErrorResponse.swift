//
//  ErrorResponse.swift
//  BillCutter
//
//  Created by Heru Prasetia on 29/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class ErrorResponse {
    var errorCode: String
    var errorMessage: String
    
    init(errorCode: String, errorMessage: String) {
        self.errorCode = errorCode
        self.errorMessage = errorMessage
    }
}
