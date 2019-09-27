//
//  ReceiptDetailItem.swift
//  BillCutter
//
//  Created by Heru Prasetia on 11/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class ReceiptDetailItem {
    
    var id = 0
    var name = ""
    var amount = 0
    var price = 0.0
    var total = 0.0
    var tagMembers = [TagMember]()
    
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}
