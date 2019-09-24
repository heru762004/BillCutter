//
//  GroupReceiptHeaderViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 24/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation
import RxSwift

class GroupReceiptHeaderViewController: ParentViewController  {
    @IBOutlet weak var tableView: UITableView!
    var groupReceipt = GroupReceipt()
    var selectedIdx: Int = -1
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        print("GROUP LIST RECEIPT = \(groupReceipt.listReceipt.count)")
        guard groupReceipt.listReceipt.count > 0 else { return }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupReceipt" {
            guard let destinationViewController = segue.destination as? GroupReceiptViewController, let groupReceipt = sender as? GroupReceipt else { return }
            destinationViewController.groupReceipt = groupReceipt
            destinationViewController.selectedIdx = selectedIdx
        } else if segue.identifier == "showGroupMember" {
            guard let destinationViewController = segue.destination as? GroupMemberViewController else { return }
            destinationViewController.groupId = groupReceipt.id
        } else if segue.identifier == "showGroupSummary" {
            guard let destinationViewController = segue.destination as? GroupSummaryViewController else { return }
            destinationViewController.groupReceipt = groupReceipt
            destinationViewController.selectedIdx = selectedIdx
        }
    }
    
    @IBAction func viewGroupMember(_ sender: Any) {
        self.performSegue(withIdentifier: "showGroupMember", sender: groupReceipt)
    }
    
    @IBAction func viewGroupSummary(_ sender: Any) {
        self.performSegue(withIdentifier: "showGroupSummary", sender: groupReceipt)
    }
    
    private func loadGroupReceiptView(groupReceipt: GroupReceipt) {
        performSegue(withIdentifier: "showGroupReceipt", sender: groupReceipt)
    }
}


extension GroupReceiptHeaderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard groupReceipt.listReceipt.count > 0 else { return 0 }
        return groupReceipt.listReceipt.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupReceiptHeaderViewCell", for: indexPath)
        let receiptItem = groupReceipt.listReceipt[indexPath.row]
        cell.textLabel?.text = "\(receiptItem.name)"
        print("ReceiptItem name = \(receiptItem.name)")
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        cell.detailTextLabel?.text = "\(receiptItem.grandtotal)"
        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedIdx = indexPath.row
        self.loadGroupReceiptView(groupReceipt: groupReceipt)
        // Open Receipt Item Detail
        
    }
}
