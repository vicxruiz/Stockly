//
//  OnboardingPageViewController.swift
//  Stockly
//
//  Created by Victor  on 5/21/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import UIKit

protocol OnboardingPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: Properties
    
    weak var onboardingDelegate: OnboardingPageViewControllerDelegate?
    
    var pageHeadings = ["Analyze Stocks With Ease", "Recommended Portfolios Just For You", "Market Projections For Your Favorite Stocks"]
    var pageImages = ["Onboarding1", "Onboarding1", "Onboarding1"]
    var pageSubheadings = ["Easy access to real-time stock analysis across a number of markets.", "Use Stock.ly's smart-learning behavior to make a new investment and expand your portfolio.", "Users will be able to effeciently learn the current path of index funds, like the S&P 500 or DOW Jones"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting data source and delegate to self to configure data
        dataSource = self
        delegate = self
        //creating screen
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    //MARK: Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    //MARK: Helper
    
    func contentViewController(at index: Int) -> OnboardingContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        // Passing data to new vc
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingContentViewController") as? OnboardingContentViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.subHeading = pageSubheadings[index]
            pageContentViewController.index = index
            
            return pageContentViewController
        }
        return nil
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    //MARK: Delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        //Updating page view controller with delegation
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
                currentIndex = contentViewController.index
                onboardingDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
    
}
