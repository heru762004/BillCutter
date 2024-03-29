//
//  RegisterViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 14/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit
import RxSwift

class RegisterViewController: ParentViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var mobileNumberText: UITextField!
    @IBOutlet weak var emailAddressText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var verifyPasswordText: UITextField!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        usernameText.resignFirstResponder()
        mobileNumberText.resignFirstResponder()
        emailAddressText.resignFirstResponder()
        passwordText.resignFirstResponder()
        verifyPasswordText.resignFirstResponder()
    }

    @IBAction func registerPressed(_ sender: Any) {
        guard let username = usernameText.text, let email = emailAddressText.text, let phone = mobileNumberText.text, let password = passwordText.text, let verifyPassword = verifyPasswordText.text else {
            return
        }
        guard !username.isEmpty || !phone.isEmpty || !email.isEmpty else {
            ViewUtil.showAlert(controller: self, message: "Fill the username or email or phone number!")
            return
        }
        
        guard !password.isEmpty else {
            ViewUtil.showAlert(controller: self, message: "Fill the password!")
            return
        }
        
        guard password == verifyPassword else {
            ViewUtil.showAlert(controller: self, message: "Password and verify password doesn't match!")
            return
        }

        showLoading { () in
            RegisterApiService.shared.register(username: username, password: password, email: email, phone: phone)
                .catchError {  _ in
                    self.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: self, message: "Error! Please check your internet connection.")
                    })
                    return Observable.empty()
                }
                .subscribe(onNext: { [weak self] apiResultStatus in
                    guard let weakSelf = self else { return }
                    self?.dismiss(animated: true, completion: {
                        ViewUtil.showAlert(controller: weakSelf, message: "", title: apiResultStatus.message, handler: { (uiAlertAction) in
                            if apiResultStatus.error == false {
                                self?.navigationController?.popViewController(animated: true)
                            }
                        })
                    })

                }).disposed(by: self.disposeBag)
        }
    }

}
