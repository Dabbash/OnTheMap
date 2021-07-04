//
//  ViewController.swift
//  OnTheMap
//
//  Created by Ahmed AlKharraz on 02/07/2021.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = "ahmed.dabbash@gmail.com"
        passwordTextField.text = "Dabbash.92"
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        OTMClient.loginAnother(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            performSegue(withIdentifier: "loginSuccess", sender: nil)
        } else {
            print("not suceesfull")
        }
    }

}

