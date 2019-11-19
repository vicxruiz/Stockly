//
//  SignUpViewController.swift
//  Stockly
//
//  Created by Victor  on 5/22/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//


import Foundation
import UIKit
import FirebaseAuth
import JGProgressHUD
import LBTAComponents
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    //Properties
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    @IBOutlet weak var signUpAccept: UIButton!
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        //error handling and ui presentations
        if self.usernameField.text == "" {
            self.hud.dismiss(animated: true)
            Service.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Name Field Required")
            return
        }
        if self.phoneNumberField.text == "" {
            self.hud.dismiss(animated: true)
            Service.showAlert(on: self, style: .alert, title: "Sign Up Error", message: "Phone Number Required")
            return
        }
        guard let name = usernameField.text else {return}
        let nameIsValid = isValidName(testStr: name)
        if !nameIsValid {
            Service.showAlert(on: self, style: .alert, title: "Name Invalid", message: "Please Provide Valid Name")
            return
        }
        
        guard let email = emailField.text else {return}
        let emailIsValid = isValidEmail(testStr: email)
        if !emailIsValid {
            Service.showAlert(on: self, style: .alert, title: "Email Invalid", message: "Please Provide Valid Email")
            return
        }
        guard let phoneNumber = phoneNumberField.text else {return}
        let phoneNumberisValid = isValidPhoneNumber(testStr: phoneNumber)
        if !phoneNumberisValid {
            Service.showAlert(on: self, style: .alert, title: "Phone Number Invalid", message: "Please Provide Valid Phone Number")
            return
        }
        guard let password = passwordField.text else {return}
        hud.textLabel.text = "Signing Up..."
        hud.show(in: view, animated: true)
        
        //firebase method to create new user
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                self.hud.dismiss(animated: true)
                print("Failed to sign up with error", error)
                Service.showAlert(on: self, style: .alert, title: "Sign Up Error", message: error.localizedDescription)
                return
            }
            
            self.saveUserIntoFirebase()
            self.hud.dismiss(animated: true)
            UserDefaults.standard.set(name, forKey: "name")
            
            //adds alert message
            let alertController = UIAlertController(title: "Sign Up Successful", message: "Time to check out some stocks", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            })
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: Checks
    
    //name check
    func isValidName(testStr:String) -> Bool {
        let nameRegEx = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: testStr)
    }
    
    //email check
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //number check
    func isValidPhoneNumber(testStr:String) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phoneTest.evaluate(with: testStr)
    }
    
    //adds data to database
    func saveUserIntoFirebase() {
        guard let name = usernameField.text else {return}
        guard let email = emailField.text else {return}
        guard let phoneNumber = phoneNumberField.text else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let dictionaryValues = ["name": name,
                                "phone number": phoneNumber,
                                "email": email]
        
        let databaseRef = Database.database().reference().child("users/\(uid)")
        databaseRef.setValue(dictionaryValues) { error, ref in
            if let error = error {
                print(error)
                return
            }
            print("Successfully saved user to database")
        }
    }
    
    
    override func viewDidLoad() {
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        signUpAccept.layer.masksToBounds = true
        signUpAccept.layer.cornerRadius = 5
        self.hideKeyboardWhenTappedAround()
        //        usernameField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let backItem = UIBarButtonItem()
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = UIColor.init(r: 255/255, g: 135/255, b: 135/255, a: 1)
    }
    
}

