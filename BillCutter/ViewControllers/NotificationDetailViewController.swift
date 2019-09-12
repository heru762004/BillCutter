//
//  NotificationDetailViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 12/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class NotificationDetailViewController: UIViewController {

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

    @IBAction func settlePayment(_ sender: Any) {
        let url = URL(string: "dbspaylah://")
        UIApplication.shared.open(url!, options: [:]) { (success) in
            print(success)
        }
    }
    
    @IBAction func doClose(_ sender: Any) {
        self.dismiss(animated: true) {
            //
        }
    }
    
}
