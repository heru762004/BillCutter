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
    
    //Initializer access level change now
    private init(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        
        
    }
    
    private func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
    }
    
    func insertIntoGroup(groupName: String) {
        let idGroup = UserDefaultService.shared.retrieve(key: UserDefaultService.Key.ID_GROUP)
        var group: Group
        
        group = Group(context: context)
//        let entity = NSEntityDescription.entity(forEntityName: "Group", in: context)
        group.groupId = idGroup
        group.groupName = groupName
//        let newGroup = Group(entity: entity!, insertInto: context)
        save()
        UserDefaultService.shared.store(key: UserDefaultService.Key.ID_GROUP, value: (idGroup + 1))
    }
    
    func getAllGroups() -> [Group] {
        
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        //request.predicate = NSPredicate(format: "age = %@", "12")
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            
            print("Failed")
        }
        return []
    }
    
    
}
