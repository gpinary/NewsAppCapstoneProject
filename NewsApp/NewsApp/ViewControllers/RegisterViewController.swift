//
//  RegisterViewController.swift
//  NewsApp
//
//  Created by Gökçe Pınar Yıldız on 6.09.2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    
    
    func validateFields() ->String? {
        //Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in the all fields"
        }
        //Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters,contains a special character and a number"
        }
        
        return nil
    }
    @IBAction func registerClicked(_ sender: Any) {
        //validate the fields
        
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
                           showAlert(title: "Error", message: "E-mail and password cannot be empty")
                           return
                       }
        let error = validateFields()
        
        if error != nil {
            //There's something wrong with the fields,show error messsage
            showError(error!)
            
        }
        else {
            //Create cleaned versions of the data
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
          
            //create user
            Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
                //Check for errors
                if error != nil {
                    //There was an error creating the user
                    showError("Error creating the user")
                }
                else {
                    //User was created successfully,now store the name
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["name":name , "uid":firebaseResult!.user.uid]) { (error)in
                        
                        if error != nil {
                            //Show error message
                            showError("error saving user data")
                        }
                    }
                    
                    //Go to our homescreen
                    transitionToHome()

                }
            }
        }
        
        func showError(_ message:String){
        }
        
        func transitionToHome(){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginViewController = storyboard.instantiateViewController(withIdentifier:"LoginViewController") as? LoginViewController{
                navigationController?.pushViewController(loginViewController, animated: true)
            }
            
            
            
            
        }
        
        func showAlert(title: String, message: String) {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                present(alertController, animated: true, completion: nil)
            }

    }
    
    
    

}
