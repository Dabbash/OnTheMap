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
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailTextField.borderStyle = UITextField.BorderStyle.roundedRect
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        
        loginButton.layer.cornerRadius = 3
        
        
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        let url = URL(string: "https://auth.udacity.com/sign-up")
               UIApplication.shared.open(url!)
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        OTMClient.loginAnother(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            OTMClient.getUserData { user, error in
                print(user)
            }
            performSegue(withIdentifier: "loginSuccess", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
            print("not suceesfull")
        }
    }
    
    func showLoginFailure(message: String) {
        setLoggingIn(false)
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signupButton.isHidden = !loggingIn
    }

}

