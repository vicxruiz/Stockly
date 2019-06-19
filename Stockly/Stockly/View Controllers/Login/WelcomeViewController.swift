//
//  WelcomeViewController.swift
//  Stockly
//
//  Created by Victor  on 5/22/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import UIKit
import LBTAComponents
import FirebaseAuth
import JGProgressHUD
import FirebaseStorage
import FirebaseDatabase
import FacebookCore
import FacebookLogin
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

//updates nav bar for clear background
struct System {
    static func clearNavigationBar(forBar navBar: UINavigationBar) {
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
    }
}

class WelcomeController: UIViewController {
    //Properties
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var dismissScreenButton: UIBarButtonItem!
    var name: String?
    var email: String?
    var phoneNumber: String?
    
    //shows indicator sign
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNavBar()
        updateButtonViews()
    }
    
    //MARK: Views
    
    func updateButtonViews() {
        facebookButton.layer.masksToBounds = true
        facebookButton.layer.cornerRadius = Service.buttonCornerRadius
        facebookButton.setImage(#imageLiteral(resourceName: "facebook-logo2").withRenderingMode(.alwaysTemplate), for: .normal)
        facebookButton.tintColor = .white
        facebookButton.contentMode = .scaleAspectFit
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Service.buttonCornerRadius
        signUpButton.layer.masksToBounds = true
        signUpButton.layer.cornerRadius = Service.buttonCornerRadius
    }
    
    func updateNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let navController = navigationController {
            System.clearNavigationBar(forBar: navController.navigationBar)
            navController.view.backgroundColor = .clear
        }
        
        //updates attributes
        navigationController?.navigationBar.barTintColor = Service.designGrayColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.groupTableViewBackground]
    }
    
    //MARK: Actions
    
    @IBAction func dismissButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "signIn", sender: self)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "signUp", sender: self)
    }
    
    //handles user selection when facebook button pressed
    @IBAction func facebookButtonPressed(_ sender: Any) {
        hud.textLabel.text = "Logging in with Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success( _, _, let accessToken): self.signIntoFirebase(accessToken: accessToken)
            case .failed(let error):
                Service.showAlert(on: self, style: .alert, title: "Login Failure", message: error.localizedDescription)
            case .cancelled:
                Service.showAlert(on: self, style: .alert, title: "Login Cancelled", message: "User cancelled login attempt.")
                self.hud.dismiss()
            }
        }
    }
    
    //MARK: Backend Service
    
    func signIntoFirebase(accessToken: AccessToken?) {
        //logic to check for authentication
        guard let authenticationToken = accessToken?.tokenString else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: authenticationToken)
        hud.textLabel.text = "Signing In..."
        hud.show(in: view, animated: true)
        
        //firebase method to sign user in
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                Service.showAlert(on: self, style: .alert, title: "Sign In Error", message: error.localizedDescription)
                print("not signed in")
                self.hud.dismiss(animated: true)
                return
            }
            self.fetchFacebookUser()
            print("successfully authenticated with firebase")
        }
    }
    
    func fetchFacebookUser() {
        
        //allows to get back email and name from facebook user
        let params = ["fields" : "email, name"]
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "me", parameters: params, tokenString: AccessToken.current?.tokenString, version: nil, httpMethod: .get)
        
        connection.add(request, completionHandler: {
            (response, result, error) in
            if let error = error {
                print(error)
                return
            }
            if response != nil {
                self.saveUserIntoFirebase()
            }
        })
        connection.start()
    }
    
    func saveUserIntoFirebase() {
        //logic to check authentication
        guard let uid = Auth.auth().currentUser?.uid else {
            print("no uid")
            return
        }
        print(uid)
        self.name = Auth.auth().currentUser?.displayName ?? ""
        self.email = Auth.auth().currentUser?.email ?? ""
        let dictionaryValues = ["name": self.name,
                                "email": self.email]
        
        //updates the values instead of setting new user
        let databaseRef = Database.database().reference().child("users").child("\(uid)")
        databaseRef.updateChildValues(dictionaryValues as [AnyHashable : Any]) { error, ref in
            if let error = error {
                print("error saving using into firebase")
                print(error)
                return
            }
            print("Successfully saved user to database // facebook")
            self.hud.dismiss(animated: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue?.identifier == "signIn" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = Service.designGrayColor
        }
        
        if segue?.identifier == "signUp" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            navigationItem.backBarButtonItem?.tintColor = Service.designGrayColor
        }
    }
}
