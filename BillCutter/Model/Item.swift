//
//  Item.swift
//  BillCutter
//
//  Created by Heru Prasetia on 19/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class Item {
    var name: String
    var price: Float
    var isGst: Bool
    var isGrandTotal: Bool
    var isRoundingAmount: Bool
    var people: [Person]
    
    init(name: String, price: Float, isGst: Bool, isGrandTotal: Bool, isRoundingAmount: Bool) {
        self.name = name
        self.price = price
        self.isGst = isGst
        self.isGrandTotal = isGrandTotal
        self.isRoundingAmount = isRoundingAmount
        people = []
    }
    
    // Add person to array of people who holds
    // responsibility for this item
    func addPerson(person: Person) {
        
        people.append(person)
    }
    
    // remove person from people array who holds
    // responsibility for this item
    func removePerson(person: Person) {
        
        var count:Int = 0
        for p in people {
            if p === person {
                people.remove(at: count)
                break
            }
            count += 1
        }
    }
}
