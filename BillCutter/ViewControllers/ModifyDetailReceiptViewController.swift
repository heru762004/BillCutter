//
//  ModifyDetailReceiptViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 24/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import CurrencyTextField

class ModifyDetailReceiptViewController: UIViewController {

    @IBOutlet weak var itemName: UITextField!
    
    @IBOutlet weak var itemPrice: CurrencyTextField!
    
    var items: [Item] = []
    var selectedIdx: Int = 0
    
    static let TYPE_ADD = 1
    static let TYPE_EDIT = 2
    
    var type = 0
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if type == ModifyDetailReceiptViewController.TYPE_ADD {
            titleText.text = "Add Item"
            saveButton.setTitle("Add", for: .normal)
            itemName.text = ""
            itemPrice.setAmount(0.00)
        } else if type == ModifyDetailReceiptViewController.TYPE_EDIT {
            titleText.text = "Manage Item"
            saveButton.setTitle("Save", for: .normal)
            // Do any additional setup after loading the view.
            if (items.count > selectedIdx) {
                itemName.text = items[selectedIdx].name
                itemPrice.setAmount(Double(items[selectedIdx].price))
            }
        }
    }
    
    @IBAction func closeScreen(_ sender: Any) {
        self.dismiss(animated: true) {
            // do something
        }
    }
    
    @IBAction func saveItem(_ sender: Any) {
        if type == ModifyDetailReceiptViewController.TYPE_ADD {
            if let myItemName = itemName.text {
                
                let textFieldStr = itemPrice.text
                var cleanNumericString = ""
                if let textFieldString = textFieldStr{
                    
                    //Remove $ sign
                    var toArray = textFieldString.components(separatedBy: "$")
                    cleanNumericString = toArray.joined(separator: "")
                    
                }
                let textFieldNumber = Double(cleanNumericString)
                var amoutFloat: Float = 0.0
                if let textFieldNumber = textFieldNumber{
                    amoutFloat = Float(textFieldNumber)
                    var myItem = Item(name: myItemName, price: amoutFloat)
                    self.items.append(myItem)
                    
                    ItemDataController.shared.removeAllItem()
                    for item in self.items {
                        ItemDataController.shared.addItem(item: item)
                    }
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        } else if type == ModifyDetailReceiptViewController.TYPE_EDIT {
            if let myItemName = itemName.text {
                items[selectedIdx].name = myItemName
                let textFieldStr = itemPrice.text
                var cleanNumericString = ""
                if let textFieldString = textFieldStr{
                    
                    //Remove $ sign
                    var toArray = textFieldString.components(separatedBy: "$")
                    cleanNumericString = toArray.joined(separator: "")
                    
                }
                let textFieldNumber = Double(cleanNumericString)
                var amoutFloat: Float = 0.0
                if let textFieldNumber = textFieldNumber{
                    amoutFloat = Float(textFieldNumber)
                    items[selectedIdx].price = amoutFloat
                    print("items selectedIdx price = \(items[selectedIdx].price)")
                }
                
                ItemDataController.shared.removeAllItem()
                for item in self.items {
                    ItemDataController.shared.addItem(item: item)
                }
                self.dismiss(animated: true, completion: nil)
            }
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

}
