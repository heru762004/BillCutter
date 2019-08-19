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
    var people: [Person]
    
    init(name: String, price: Float) {
        self.name = name
        self.price = price
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
