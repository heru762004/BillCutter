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
    
    func insertIntoGroup(groupName: String, numOfMember: Int) {
        let idGroup = UserDefaultService.shared.retrieve(key: UserDefaultService.Key.ID_GROUP)
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "groupName = %@", groupName)
        
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count != 0 {
                // update
                let managedObject = fetchResults[0]
                managedObject.setValue(numOfMember, forKey: "numOfMember")
                save()
            } else {
                //insert as new data
                var group: Group
                
                group = Group(context: context)
                group.groupId = idGroup
                group.groupName = groupName
                group.numOfMember = Int64(numOfMember)
                save()
                UserDefaultService.shared.store(key: UserDefaultService.Key.ID_GROUP, value: (idGroup + 1))
            }
        } catch {
            
        }
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
    
    func getGroupWithFilter(groupId: Int) -> Group? {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        request.predicate = NSPredicate(format: "groupId = %d", groupId)
        do {
            let result = try context.fetch(request)
            return result.first!
        } catch {
            
            print("Failed")
        }
        return nil
    }
    
}
