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

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBAction func backButton(_ sender: Any?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutButton.addTarget(self, action: #selector(handleSignOutButtonTapped), for: .touchUpInside)
    }
    
    @objc func handleSignOutButtonTapped(sender: UIButton!) {
        let signOutAction = UIAlertAction(title: "Sign Out", style: .destructive) {
            (action) in
            do {
                try Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingNavigationViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            catch let err {
                print("Failed to sign out with error", err)
                Service.showAlert(on: self, style: .alert, title: "Sign Out Error", message: err.localizedDescription)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }
    
}
