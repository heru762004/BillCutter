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
    
    @IBOutlet weak var tableContact: UITableView!
    var selectedGroupId: Int = -1
    
    var listPerson: [Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedGroupId != -1 {
            if let selectedGroup: Group = GroupDataController.shared.getGroupWithFilter(groupId: selectedGroupId) {
                groupNameText.text = selectedGroup.groupName
                let listUser = UserDataController.shared.getGroupWithFilterGroupId(groupId: selectedGroupId)
                for user in listUser {
                    let person = Person(name: user.userName!, phoneNumber: user.phoneNumber!)
                    listPerson.append(person)
                }
            }
        }
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
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
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
            let phoneNumber = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
            let person = Person(name: "\(contact.givenName) \(contact.familyName)", phoneNumber: phoneNumber)
            listPerson.append(person)
            print("Contact = \(contact.givenName) \(contact.familyName)")            
            print("Phone = \(phoneNumber)")
        }
        tableContact.reloadData()
//        let newFriends = contacts.compactMap { Friend(contact: $0) }
//        for friend in newFriends {
//            if !friendsList.contains(friend) {
//                friendsList.append(friend)
//            }
//        }
//        tableView.reloadData()
    }
}

extension AddGroupViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        cell.textLabel?.text = listPerson[indexPath.row].name
        cell.detailTextLabel?.text = listPerson[indexPath.row].phoneNumber
        return cell
    }
}
