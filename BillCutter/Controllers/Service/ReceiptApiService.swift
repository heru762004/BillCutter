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
    
    func addReceipt(itemName: String, itemAmount: String, members: [TagMember]) -> Observable<ApiStatusResult> {
        let path = "/receipt/item"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        var member_temp = [[String:Any]]()
        for member in members {
            member_temp.append(member.toDict())
        }
        let params: [String: Any] = ["name": itemName,
                  "amount": itemAmount,
                  "total": itemAmount,
                  "tagMember": member_temp,
                  "action": "ADD",
                  "splitType": "EQUAL"
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString!)
        } catch {
            print(error.localizedDescription)
        }
        
        return apiService.postString(path: path, headers: headers, params: params)
            .map { (success, jsonString)  in
                let apiStatusResult = Mapper<ApiStatusResultResponse>().map(JSONString: jsonString)?.toApiStatusResult() ?? ApiStatusResult()
                apiStatusResult.success = success
                return apiStatusResult
        }
    }
}
