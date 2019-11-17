//
//  ForgotPasswordViewController.swift
//  Stockly
//
//  Created by Victor  on 11/17/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //sends email to user for password reset
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                DispatchQueue.main.async {
                    Service.showAlert(on: self, style: .alert, title: "Passowrd Reset Failure", message: error?.localizedDescription)
                }
                return
            } else {
                DispatchQueue.main.async {
                    Service.showAlert(on: self, style: .alert, title: "Success", message: "Passowrd reset successfully sent to email")
                }
            }
        }
    }
    
}
