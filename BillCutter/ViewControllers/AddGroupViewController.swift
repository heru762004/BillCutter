//
//  AddGroupViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 27/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {

    @IBOutlet weak var groupNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func doSubmit(_ sender: Any) {
        if let groupName = groupNameText.text {
            GroupDataController.shared.insertIntoGroup(groupName: groupName)
            self.dismiss(animated: true, completion: nil)
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
