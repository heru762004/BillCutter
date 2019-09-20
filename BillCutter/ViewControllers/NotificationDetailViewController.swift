//
//  NotificationDetailViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 12/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class NotificationDetailViewController: UIViewController {

    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var notificationAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let notification = NotificationDataController.shared.getLastNotification()
        let notificationName = notification.itemName
        let notifAmount = notification.amount
        
        notificationTitle.text = notificationName
        notificationAmount.text = "$ \(notifAmount)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
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
//        let url = URL(string: "dbspaylah://")
        let url = URL(string: "https://www.dbs.com.sg/personal/mobile/paylink/index.html?tranRef=a8tJ0eacd5")
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
