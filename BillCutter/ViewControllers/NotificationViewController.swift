//
//  NotificationViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 12/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class NotificationViewController: ParentViewController {

    @IBOutlet weak var notifTable: UITableView!
    
    var notifMessage: [Notification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notifMessage = NotificationDataController.shared.getAllNotification()
        self.notifTable.reloadData()
        super.viewDidAppear(animated)
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


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifMessage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath)
        cell.textLabel?.text = "\(notifMessage[indexPath.row].message!)"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


