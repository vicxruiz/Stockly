//
//  StockNewsViewController.swift
//  Stockly
//
//  Created by Victor  on 6/20/19.
//  Copyright © 2019 com.Victor. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class StockNewsViewContorller: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        makeURLRequest()
    }
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    func makeURLRequest() {
        guard let url = url else {
            return
        }
        let myURL = URL(string: "\(url)")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
