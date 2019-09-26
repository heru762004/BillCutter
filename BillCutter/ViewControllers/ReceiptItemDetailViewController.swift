//
//  ReceiptItemViewController.swift
//  BillCutter
//
//  Created by Erick Theodorus on 26/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class ReceiptItemDetailViewController: ParentViewController {
    
    @IBOutlet weak var itemNamelabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var paidByLabel: UILabel!
    @IBOutlet weak var splitingMethodLabel: UILabel!
    @IBOutlet weak var tagMemberList: UITableView!
    
    var paidBy = ""
    var groupId = -1
    var receiptItem = ReceiptItem()
    
    override func viewDidLoad() {
        itemNamelabel.text = receiptItem.name
        itemPriceLabel.text = "\(receiptItem.total)"
        paidByLabel.text = paidBy
        splitingMethodLabel.text = receiptItem.splitType
        tagMemberList.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupMember" {
            guard let destinationViewController = segue.destination as? GroupMemberViewController else { return }
            destinationViewController.groupId = groupId
        }
    }
    @IBAction func addTagButtonOnClick(_ sender: Any) {
        
    }
    
}
