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
        LoginApiService.shared.sendRequest(userName: "aaaa", password: "aaaa")
        //self.performSegue(withIdentifier: "goToMainMenu", sender: self)
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "goToRegister", sender: self)
    }
}

