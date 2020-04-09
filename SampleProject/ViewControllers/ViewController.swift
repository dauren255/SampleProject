//
//  ViewController.swift
//  SampleProject
//
//  Created by Бурибеков Даурен on 06/03/2020.
//  Copyright © 2020 Бурибеков Даурен. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
            let ref = Firestore.firestore().collection("messages")
                   
        ref.whereField("chatId", isEqualTo: "firstchat").addSnapshotListener { snapshot, error in
                       
                       var tempMessages = [Message]()
                       
                       if error != nil {
                           print(error!.localizedDescription)
                           return
                       }
                       
                       for document in snapshot!.documents {
                           let chatId = document["chatId"] as! String
                           let senderId = document["senderId"] as! String
                           let messageText = document["message"] as! String
                           let timestamp = document["timestamp"] as! Timestamp
                           let date = timestamp.dateValue()

                           let message = Message(chatId: chatId, senderId: senderId, messageText: messageText, timeStamp: date)
                           tempMessages.append(message)
                       }
                       
                       print(tempMessages)
                   }
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "GoToTheMainPage", sender: self)
        }
        super.viewDidLoad()
        setBg()
    }
    
    func setBg(){
        self.signInButton.layer.cornerRadius = 10
    }
    
    private func configureTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    private func configureTextFields(){
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func signInAction(_ sender: Any?) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) {
            (result, error) in
            if (error != nil) {
                let alertController = UIAlertController(title: "Ошибка", message:
                    error?.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.emailField.text = ""
            self.passwordField.text = ""
            self.performSegue(withIdentifier: "GoToTheMainPage", sender: self)
        }
    }
}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
