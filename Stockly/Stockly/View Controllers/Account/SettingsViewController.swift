//
//  SettingsViewController.swift
//  Stockly
//
//  Created by Victor  on 5/23/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        logOutButton.addTarget(self, action: #selector(handleSignOutButtonTapped), for: .touchUpInside)
    }
    
    func updateViews() {
        guard let currentUser = Auth.auth().currentUser else {
            Service.showAlert(on: self, style: .alert, title: "Error Getting User", message: "please check connection and try again.")
            return}

        if UserDefaults.standard.value(forKey: "name") != nil {
            print("hello")
            nameLabel.text = UserDefaults.standard.value(forKey: "name") as? String
            emailLabel.text = currentUser.email
            nameLabel.isHidden = false
            emailLabel.isHidden = false
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let databaseRef: DatabaseReference!
            databaseRef = Database.database().reference()

            
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict  = snapshot.value as? [String: Any] else {return}
                let user = CurrentUser(uid: uid, dictionary: dict)
                self.nameLabel.text = user.name
                self.emailLabel.text = currentUser.email
            }) { (err) in
                DispatchQueue.main.async {
                    Service.showAlert(on: self, style: .alert, title: "Error Finding User", message: err.localizedDescription)
                }
            }
        }
    }
    
    @objc func handleSignOutButtonTapped(sender: UIButton!) {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) {
            (action) in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.removeObject(forKey: "name")
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingNavigationViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            catch let err {
                print("Failed to sign out with error", err)
                DispathQueue.main.async {
                    Service.showAlert(on: self, style: .alert, title: "Sign Out Error", message: err.localizedDescription)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
    
}
