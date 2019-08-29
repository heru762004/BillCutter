//
//  LoginViewController.swift
//  BillCutter
//
//  Created by Heru Prasetia on 7/8/19.
//  Copyright © 2019 Heru Prasetia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
        self.showLoading()
        LoginApiService.shared.sendRequest(userName: userName, password: password, onSuccess: { (success) in
            self.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "goToMainMenu", sender: self)
            })
        }, onFailure: { (errResponse) in
            self.dismiss(animated: true, completion: {
                self.showErrorMessage(errorCode: errResponse.errorCode, errorMessage: errResponse.errorMessage)
            })
        })
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
    func showLoading() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorMessage(errorCode :String, errorMessage :String) {
        let alertController = UIAlertController(title: "Error : \(errorCode)", message: errorMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            self.dismiss(animated: true, completion: {
                // not used
            })
        }))
        present(alertController, animated: true, completion: nil)
    }
}

