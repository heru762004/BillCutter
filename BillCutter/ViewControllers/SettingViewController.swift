//
//  SettingViewController.swift
//  BillCutter
//
//  Created by Erick Theodorus on 11/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import Foundation

class SettingViewController: ParentViewController {
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func logoutButtonOnTap(_ sender: Any) {
        UserDefaultService.shared.clear(key: UserDefaultService.Key.USERNAME)
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
}
