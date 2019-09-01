//
//  AssignToViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 28/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class AssignToViewController: UIViewController {
    
    @IBOutlet weak var paidByText: UILabel!
    
    @IBOutlet weak var itemNameText: UILabel!
    
    @IBOutlet weak var priceText: UILabel!
    
    @IBOutlet weak var tagItemText: UITextView!
    
    var itemName: String?
    var itemPrice: Float = 0.0
    
    override func viewDidLoad() {
        self.navigationItem.title = "Split Item"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.orange]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        itemNameText.text = itemName
        var twoDecimalPlaces = ""
        if itemPrice >= 0.0 {
            twoDecimalPlaces = String(format: "$%.2f", itemPrice)
        } else {
            twoDecimalPlaces = String(format: "%.2f", itemPrice)
            twoDecimalPlaces = twoDecimalPlaces.replacingOccurrences(of: "-", with: "")
            twoDecimalPlaces = String(format: "-$%@", twoDecimalPlaces)
        }
        priceText.text = twoDecimalPlaces
        
        let userName = UserDefaultService.shared.retrieveString(key: UserDefaultService.Key.USERNAME)
        paidByText.text = userName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func doShowActionMenu(_ sender: Any) {
        // 1
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        // 2
        let groupTag = UIAlertAction(title: "Tag by Group", style: .default, handler: { (actionSheetController) in
            // show group menu
        })
        let userTag = UIAlertAction(title: "Tag by User", style: .default, handler: { (actionSheetController) in
            // show user menu
        })
        
        // 3
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // 4
        optionMenu.addAction(groupTag)
        optionMenu.addAction(userTag)
        optionMenu.addAction(cancelAction)
        
        // 5
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       
    }
    
}

