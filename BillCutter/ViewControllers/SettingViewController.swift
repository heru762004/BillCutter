//
//  SettingViewController.swift
//  BillCutter
//
//  Created by Erick Theodorus on 11/09/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class SettingViewController: ParentViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.showLoading {
            GetProfileApiService.shared.getLoginProfile()
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: {[weak self] statusResponse in
                    self?.dismiss(animated: true, completion: {
                        if statusResponse.success {
                            self?.nameLabel.text = statusResponse.name
                            self?.usernameLabel.text = statusResponse.username
                            self?.emailLabel.text = statusResponse.email
                            self?.phoneLabel.text = statusResponse.handphone
                        } else {
                            self?.showErrorMessage(errorCode: "", errorMessage: statusResponse.message)
                        }
                    })
                }).disposed(by: self.disposeBag)
        }
        
    }
    
    @IBAction func logoutButtonOnTap(_ sender: Any) {
        UserDefaultService.shared.clear(key: UserDefaultService.Key.USERNAME)
        UserDefaultService.shared.clear(key: UserDefaultService.Key.ACCESS_TOKEN)
        UserDefaultService.shared.clear(key: UserDefaultService.Key.PHONE_NUMBER)
        NotificationDataController.shared.removeAllNotification()
        self.performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
}
