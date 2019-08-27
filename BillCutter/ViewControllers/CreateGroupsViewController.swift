//
//  CreateGroupsViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 25/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class CreateGroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableGroup: UITableView!
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groups = GroupDataController.shared.getAllGroups()
        tableGroup.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = groups[indexPath.row].groupName
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }

    @IBAction func doCreateGroup(_ sender: Any) {
        self.performSegue(withIdentifier: "goToCreateGroup", sender: nil)
    }
}
