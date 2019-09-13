//
//  DashboardViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 13/9/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class DashboardViewController: ParentViewController {

    @IBOutlet weak var todaySpendingText: UILabel!
    
    @IBOutlet weak var thisMonthSpendingText: UILabel!
    
    @IBOutlet weak var upToDateSpendingText: UILabel!
    
    @IBOutlet weak var averageMonthSpendingText: UILabel!
    
    @IBOutlet weak var outstandingBalanceText: UILabel!
    
    
    @IBOutlet weak var totalOwedText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showLoading {
            DashboardApiService.shared.getDashboardProfile()
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: {[weak self] groupList in
                    self?.dismiss(animated: true, completion: {
                        self?.todaySpendingText.text = "$\(groupList.spendingToday)"
                        self?.thisMonthSpendingText.text = "$\(groupList.spendingByMonth)"
                        self?.upToDateSpendingText.text = "$\(groupList.spendingUpToDate)"
                        self?.averageMonthSpendingText.text = "$\(groupList.spendingAvgMonth)"
                        self?.outstandingBalanceText.text = "$\(groupList.outstandingBill)"
                        self?.totalOwedText.text = "$\(groupList.oweByGroups)"
                    })
                })
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
