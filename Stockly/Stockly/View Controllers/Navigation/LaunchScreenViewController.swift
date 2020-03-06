//
//  LaunchScreenViewController.swift
//  Stockly
//
//  Created by Victor  on 5/22/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase


class LaunchScreenViewController: UIViewController {
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // splashscreen for delay of 2, then goes to home
        checkLoggedInUserStatus()
        perform(#selector(LaunchScreenViewController.showmainmenu), with: nil, afterDelay: 2)
    }
    
    //MARK: - Helpers
    
    fileprivate func checkLoggedInUserStatus() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    @objc func showmainmenu(){
        performSegue(withIdentifier: "home", sender: self)
    }

}
