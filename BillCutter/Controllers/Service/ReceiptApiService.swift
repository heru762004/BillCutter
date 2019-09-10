//
//  ReceiptApiService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 10/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class ReceiptApiService {
    static let shared = ReceiptApiService()
    
    let apiService: ApiService!
    
    private init(){
        self.apiService = ApiService()
    }
    
    func addReceipt(itemName: String, itemAmount: String, members: [Person]) -> Observable<ApiStatusResult> {
        let path = "/receipt/item"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        let params: [String: Any] = ["name": itemName,
                                     "amount": itemAmount,
                                     "total": itemAmount,
                                     "tagMember": members,
                                     "action": "ADD",
                                     "splitType": "EQUAL"
                                    ]
        
        return apiService.postString(path: path, headers: headers, params: params)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<ApiStatusResultResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? ApiStatusResult()
                apiStatusResult.success = success
                return apiStatusResult
        }
    }
}
