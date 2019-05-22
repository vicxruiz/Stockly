//
//  OnboardingViewController.swift
//  Stockly
//
//  Created by Victor  on 5/21/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController, OnboardingPageViewControllerDelegate {
    
    //MARK: Properties
    
    var onboardingPageViewController: OnboardingPageViewController?
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var getStartedButton: UIButton! {
        didSet {
            getStartedButton.layer.masksToBounds = true
            getStartedButton.layer.cornerRadius = Service.buttonCornerRadius
        }
    }
    
    @IBOutlet var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = Service.buttonCornerRadius
            nextButton.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Actions
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        performSegue(withIdentifier: "welcome", sender: self)
    }
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "welcome", sender: self)
    }
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = onboardingPageViewController?.currentIndex {
            switch index {
            case 0...1:
                onboardingPageViewController?.forwardPage()
            case 2:
                break
            default: break
            }
        }
        updateUI()
    }
    
    //Logic to update ui at different screens
    func updateUI() {
        if let index = onboardingPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                getStartedButton.isHidden = true
                nextButton.isHidden = false
                skipButton.isHidden = false
            case 2:
                nextButton.isHidden = true
                skipButton.isHidden = true
                getStartedButton.isHidden = false
            default: break
            }
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? OnboardingPageViewController {
            onboardingPageViewController = pageViewController
            onboardingPageViewController?.onboardingDelegate = self
        }
    }
    
}

