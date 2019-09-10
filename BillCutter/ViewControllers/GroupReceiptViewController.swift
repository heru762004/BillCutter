//
//  GroupReceiptViewController.swift
//  BillCutter
//
//  Created by Erick Theodorus on 10/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class GroupReceiptViewController: ParentViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    var groupReceipt = GroupReceipt()
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        guard groupReceipt.listReceipt.count > 0 else { return }
        tableView.reloadData()
    }
    
}

extension GroupReceiptViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard groupReceipt.listReceipt.count > 0 else { return 0 }
        return groupReceipt.listReceipt[0].listDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupReceiptViewCell", for: indexPath)
        let receiptItem = groupReceipt.listReceipt[0].listDetail[indexPath.row]
        cell.textLabel?.text = "\(receiptItem.amount) x \(receiptItem.name)"
        cell.textLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        cell.detailTextLabel?.text = "\(receiptItem.total)"
        cell.detailTextLabel?.textColor = UIColor(displayP3Red: (254.0 / 255.0), green: (195.0 / 255.0), blue: (9.0 / 255.0), alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < groupReceipt.listReceipt[0].listDetail.count else { return }
        let receiptItem = groupReceipt.listReceipt[0].listDetail[indexPath.row]

        // Open Receipt Item Detail
        
    }
}
