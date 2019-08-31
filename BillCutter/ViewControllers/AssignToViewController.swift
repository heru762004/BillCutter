//
//  AssignToViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 28/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class AssignToViewController: UIViewController {
    
    @IBOutlet weak var itemNameText: UILabel!
    
    @IBOutlet weak var priceText: UILabel!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
       
    }
    
}

