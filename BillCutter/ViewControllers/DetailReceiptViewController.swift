//
//  DetailReceiptViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 19/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class DetailReceiptViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableReceipt: UITableView!
    var items: [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptCell", for: indexPath) as! DetailReceiptTableViewCell
        cell.itemName.text = items[indexPath.row].name
        let twoDecimalPlaces = String(format: "%.2f", items[indexPath.row].price)
        cell.buttonPrice.setTitle(twoDecimalPlaces, for: .normal)
        cell.buttonPrice.tag = indexPath.row
        
        // add target to button price, so user can change the price
        cell.buttonPrice.addTarget(self, action: #selector(priceButtonTapped), for: UIControl.Event.touchUpInside)
        
        cell.buttonDelete.tag = indexPath.row
        // Add target to the deleteButton so that the row can be deleted when tapped
        cell.buttonDelete.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return cell
    }

    @objc func priceButtonTapped(sender: UIButton!) {
        // Create the alert controller.
        let alert = UIAlertController(title: "Enter Price", message: nil, preferredStyle: .alert)
        
        // Add the text field
        alert.addTextField { (textField) in
            textField.keyboardType = .decimalPad
        }
        
        // Grab the value from the text field,
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            
            if !(textField?.text?.isEmpty)! {
                
                self.items[sender.tag].price = Float((textField?.text)!)!
                self.tableReceipt.reloadData()
            }
        }))
        
        // Add cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    @objc func deleteButtonTapped(sender: UIButton!) {
        self.items.remove(at: sender.tag)
        self.tableReceipt.reloadData()
//        self.tableReceipt.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .left)
    }
}
