//
//  LoginViewController.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 6.09.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var isLoginSuccessful: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
       
        isLoginSuccessful = { [weak self] success in
                           if success {
                               self?.performSegue(withIdentifier: "goToHome", sender: self)
                           } else {
                               self?.showAlert(title: "Error", message: "Login is not successful. Please check your e-mail or password fields.")
                           }
                       }
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
                isLoginSuccessful?(false)
                return
            }
        if !isValidEmail(email: email) {
                    showAlert(title: "Hata", message: "Invalid e-mail address. Please enter a valid e-mail address.")
                        return
            }

            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] result, error in
                if error != nil {
                    print("Oturum açma hatası: (error.localizedDescription)")
                    self?.isLoginSuccessful?(false)
                    return
                }

                if result?.user != nil {
                    self?.isLoginSuccessful?(true)
                }
            }
    }
    

    
    func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

        func isValidEmail( email: String) -> Bool {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailTest.evaluate(with: email)
        }
}
