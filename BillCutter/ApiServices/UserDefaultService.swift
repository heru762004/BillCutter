//
//  UserDefaultService.swift
//  BillCutter
//
//  Created by Heru Prasetia on 27/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class UserDefaultService {
    static let shared = UserDefaultService()
    var userDefault: UserDefaults
    
    struct Key {
        static let ID_GROUP = "ID_GROUP"
        static let ID_USER = "ID_USER"
    }
    
    //Initializer access level change now
    private init(){
        self.userDefault = UserDefaults.standard
    }
    
    func store(key: String, value: Int64) {
        self.userDefault.set(value, forKey: key)
        self.userDefault.synchronize()
    }
    
    func retrieve(key: String) -> Int64 {
        if self.userDefault.object(forKey: key) == nil {
            return 0
        } else {
            return self.userDefault.object(forKey: key) as! Int64
        }
    }
}