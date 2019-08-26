//
//  GroupDataController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 26/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GroupDataController {
    static let shared = GroupDataController()
    
    var context: NSManagedObjectContext!
    var entity: NSEntityDescription!
    //Initializer access level change now
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.entity = NSEntityDescription.entity(forEntityName: "Group", in: context)
    }
    
    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func insertIntoGroup(groupName: String) {
        let newGroup = NSManagedObject(entity: entity!, insertInto: context)
        newGroup.setValue(groupName, forKey: "groupName")
        save()
    }
    
    func getAllGroups() -> [Group] {
        var groups: [Group] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let group = Group()
                group.groupId = data.value(forKey: "groupId") as! Int64
                group.groupName = data.value(forKey: "groupName") as! String
                groups.append(group)
            }
            
        } catch {
            
            print("Failed")
        }
        return groups
    }
}
