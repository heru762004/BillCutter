//
//  UserDataController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 28/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserDataController {
    static let shared = UserDataController()
    
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
    
    func insertIntoGroup(userName: String, groupId: Int, phoneNumber: String) {
        let idUser = UserDefaultService.shared.retrieve(key: UserDefaultService.Key.ID_USER)
        var user: User
        
        user = User(context: context)
        user.id = idUser
        user.userName = userName
        user.groupId = Int64(groupId)
        user.phoneNumber = phoneNumber
        save()
        UserDefaultService.shared.store(key: UserDefaultService.Key.ID_USER, value: (idUser + 1))
    }
    
    func getAllUser() -> [User] {
        
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            
            print("Failed")
        }
        return []
    }
    
    func getGroupWithFilterUserId(userId: Int) -> User? {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", userId)
        do {
            let result = try context.fetch(request)
            return result.first!
        } catch {
            
            print("Failed")
        }
        return nil
    }
    
    func getGroupWithFilterGroupId(groupId: Int) -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        request.predicate = NSPredicate(format: "groupId = %d", groupId)
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            
            print("Failed")
        }
        return []
    }
    
}
