//
//  GroupTagViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 3/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class GroupTagViewController: ParentViewController {

    @IBOutlet weak var tableGroup: UITableView!
    
    var groups: [Group] = []
    var itemName: String?
    var itemPrice: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        groups = GroupDataController.shared.getAllGroups()
        tableGroup.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showLoading()
        ListGroupApiService.shared.sendRequest(onSuccess: { (successResult) in
            self.dismiss(animated: true, completion: {
                
            })
        }) { (error) in
            self.dismiss(animated: true, completion: {
                self.showErrorMessage(errorCode: error.errorCode, errorMessage: error.errorMessage)
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupTagViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = "\(groups[indexPath.row].groupName!) (\(groups[indexPath.row].numOfMember))"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let groupId = Int(groups[indexPath.row].groupId)
        let listUser: [User] = UserDataController.shared.getGroupWithFilterGroupId(groupId: groupId)
        let listOfItem: [Item] = ItemDataController.shared.getAllItem()
        ItemDataController.shared.removeAllItem()
        let owe: Float = itemPrice / Float(listUser.count)
        for item in listOfItem {
            if item.name == itemName {
                for user in listUser {
                    let person = Person(name: user.userName!, phoneNumber: user.phoneNumber!)
                    person.owe += owe
                    item.addPerson(person: person)
                }
                ItemDataController.shared.addItem(item: item)
            } else {
                ItemDataController.shared.addItem(item: item)
            }
        }
        let listOfItem2: [Item] = ItemDataController.shared.getAllItem()
        for item in listOfItem {
            print(item.name)
            print(item.price)
            print(item.people)
        }
        self.dismiss(animated: true, completion: nil)
//        self.performSegue(withIdentifier: "goToCreateGroup", sender: nil)
    }
}
