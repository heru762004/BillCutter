//
//  DetailAssignViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 28/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class DetailAssignViewController: UIViewController {

    @IBOutlet weak var tableContact: UITableView!
    
    var listPerson: [Person] = []
    
    var selectedGroupId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedGroupId)
        let listUser = UserDataController.shared.getGroupWithFilterGroupId(groupId: selectedGroupId)
        for user in listUser {
            let person = Person(name: user.userName!, phoneNumber: user.phoneNumber!)
            listPerson.append(person)
        }
        tableContact.reloadData()
        // Do any additional setup after loading the view.
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

extension DetailAssignViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPerson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath)
        cell.textLabel?.text = listPerson[indexPath.row].name
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        cell.detailTextLabel?.text = listPerson[indexPath.row].phoneNumber
        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
}
