//
//  TagMember.swift
//  BillCutter
//
//  Created by Heru Prasetia on 10/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class TagMember {
    var id = 0
    var groupId = ""
    var name = ""
    var handphone = ""
    var percentage = 0.0
    var amount = 0

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
    
    func toIdDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label, key == "id" {
                dict[key] = child.value
            }
        }
        return dict
    }
}
