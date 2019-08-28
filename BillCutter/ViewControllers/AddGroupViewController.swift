//
//  AddGroupViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 27/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import ContactsUI

class AddGroupViewController: UIViewController {

    @IBOutlet weak var groupNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func doSubmit(_ sender: Any) {
        if let groupName = groupNameText.text {
            GroupDataController.shared.insertIntoGroup(groupName: groupName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func doAddMember(_ sender: Any) {
        // 1
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        // 2
        contactPicker.predicateForEnablingContact = NSPredicate(
            format: "ANY self.phoneNumbers.'value'.'digits' BEGINSWITH %@", "+65")
        present(contactPicker, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddGroupViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contacts: [CNContact]) {
        
        for contact in contacts {
            print("Contact = \(contact.givenName) \(contact.familyName)")
            let phoneNumber = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
            print("Phone = \(phoneNumber)")
        }
//        let newFriends = contacts.compactMap { Friend(contact: $0) }
//        for friend in newFriends {
//            if !friendsList.contains(friend) {
//                friendsList.append(friend)
//            }
//        }
//        tableView.reloadData()
    }
}
