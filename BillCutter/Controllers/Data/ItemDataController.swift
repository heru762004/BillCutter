//
//  ItemDataController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 24/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class ItemDataController {
    
    static let shared = ItemDataController()
    
    var items: [Item] = []
    
    //Initializer access level change now
    private init(){}
    
    func addItem (item: Item) {
        items.append(item)
    }
    
    func removeAllItem () {
        items.removeAll()
    }
    
    func removeItemAtIndex (idx: Int) {
        items.remove(at: idx)
    }
    
    func getAllItem() -> [Item] {
        return items
    }
}
