//
//  LoginViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 7/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class LoginViewController: ParentViewController {
    
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func loginPressed(_ sender: Any) {
        guard let userName = usernameText.text else {
            showErrorMessage(errorCode: "", errorMessage: "Username must be filled")
            return
        }
        if userName.count == 0 {
            showErrorMessage(errorCode: "", errorMessage: "Username must be filled")
            return
        }
        guard let password = passwordText.text else {
            showErrorMessage(errorCode: "", errorMessage: "Password must be filled")
            return
        }
        if password.count == 0 {
            showErrorMessage(errorCode: "", errorMessage: "Password must be filled")
            return
        }
        self.showLoading { () in
            LoginApiService.shared.sendRequest(userName: userName, password: password, onSuccess: { (success) in
                self.dismiss(animated: true, completion: {
                    UserDefaultService.shared.storeString(key: UserDefaultService.Key.USERNAME, value: userName)
                    self.performSegue(withIdentifier: "goToMainMenu", sender: self)
                })
            }, onFailure: { (errResponse) in
                self.dismiss(animated: true, completion: {
                    self.showErrorMessage(errorCode: errResponse.errorCode, errorMessage: errResponse.errorMessage)
                })
            })
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
}

