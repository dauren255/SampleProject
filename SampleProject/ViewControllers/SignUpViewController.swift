//
//  SignUpViewController.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 04/04/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.systemGreen
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
            (result, error) in
            
            if let error = error {
                print(error.localizedDescription)
                let alertController = UIAlertController(title: "Ошибка", message:
                    error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            let alertController = UIAlertController(title: "Подтверждение", message:
                "Пользователь добавлен!", preferredStyle: .alert)
            Firestore.firestore().collection("users").document(self.loginField.text!).setData(
                [
                    "uid": Auth.auth().currentUser?.uid,
                    "email": Auth.auth().currentUser?.email,
                    "username": self.loginField.text
                    
                ]
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            self.present(alertController, animated: true, completion: nil)
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
