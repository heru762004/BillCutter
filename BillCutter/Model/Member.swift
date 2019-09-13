//
//  Member.swift
//  BillCutter
//
//  Created by Heru Prasetia on 13/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class Member {
    var groupId = 0
    var name = ""
    var handphone = ""
    
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
