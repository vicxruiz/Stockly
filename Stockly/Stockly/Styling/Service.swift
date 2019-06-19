//
//  Service.swift
//  Stockly
//
//  Created by Victor  on 5/21/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit

class Service {
    
    //Theme
    static let stocklyDesignTheme = UIColor(r: 113, g: 232, b: 225, a: 1)
    //Navigation
    static let navigationBarTintColor = UIColor.blue
    
    //Button
    static let buttonTitleColor = UIColor.white
    static let buttonBackgroundColor = UIColor.white
    static let buttonCornerRadius: CGFloat = 15
    static let butttonTitleFont: CGFloat = 18
    static let designGrayColor = UIColor(r: 206, g: 214, b: 227)
    //design == most of the app should have these colors
    static let baseColor = UIColor.blue
    static let darkBaseColor = UIColor(r: 0, g: 255, b: 173)
    static let lightBaseColor = UIColor.lightGray
    
    //user alerts
    static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [ UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
    
}
