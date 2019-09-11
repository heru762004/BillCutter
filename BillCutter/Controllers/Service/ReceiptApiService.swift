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
    
    func createReceipt(receiptTitle: String, receiptItem: [ReceiptDetailItem]) {
        let path = "/receipt"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        var member_item = [[String:Any]]()
        for member in receiptItem {
            member_item.append(member.toDict())
        }
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        let format2 = DateFormatter()
        format2.dateFormat = "yyyyMMddHHmmss"
        
        let receiptNo = format2.string(from: date)
        let subtotal = "0"
        let discount = "0"
        let receiptDate = formattedDate
        let params: [String: Any] = [
            "name": receiptTitle,
            "receiptDate": receiptDate,
            "receiptNo": receiptNo,
            "subtotal": subtotal,
            "discount": discount,
            "grandtotal": subtotal,
            "seeDetail": member_item
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data
            
            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addReceipt(itemName: String, itemAmount: String, members: [TagMember]) -> Observable<ApiStatusResult> {
        let path = "/receipt/item"
        let accessToken = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.ACCESS_TOKEN)
        
        let headers = ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json"]
        
        var member_temp = [[String:Any]]()
        for member in members {
            member_temp.append(member.toDict())
        }
        let params: [String: Any] = [
                  "receiptHdrId" : "1",
                  "name": itemName,
                  "amount": itemAmount,
                  "total": itemAmount,
                  "tagMember": member_temp,
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
