//
//  NotificationDataController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 12/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NotificationDataController {
    static let shared = NotificationDataController()
    
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
    
    func insertIntoNotification(message: String, itemName: String, amount: Double) {
        let idNotif = UserDefaultService.shared.retrieve(key: UserDefaultService.Key.ID_NOTIF)
        
        //insert as new data
        var notification: Notification
        notification = Notification(context: context)
        notification.id = idNotif
        notification.message = message
        notification.itemName = itemName
        notification.amount = amount
        save()
        UserDefaultService.shared.store(key: UserDefaultService.Key.ID_NOTIF, value: (idNotif + 1))
        
    }
    
    func getAllNotification() -> [Notification] {
        
        let request: NSFetchRequest<Notification> = Notification.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        do {
            let result = try context.fetch(request)
            return result
        } catch {
            
            print("Failed")
        }
        return []
    }
    
    func getLastNotification() -> Notification {
        
        let request: NSFetchRequest<Notification> = Notification.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        do {
            let result = try context.fetch(request)
            if result.first != nil {
                return result.first!
            } else {
                return Notification()
            }
        } catch {
            
            print("Failed")
        }
        return Notification()
    }
    
    func removeAllNotification() {
        let request: NSFetchRequest<Notification> = Notification.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        do {
            let result = try context.fetch(request)
            for managedObject in result {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
            save()
        } catch {
            
            print("Failed")
        }
    }
    
}
