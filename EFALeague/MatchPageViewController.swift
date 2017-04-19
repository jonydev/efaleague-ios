//
//  MatchPageViewController.swift
//  EFALeague
//
//  Created by Zhou Huang on 15/01/2017.
//  Copyright © 2017 Jonyzz. All rights reserved.
//

import Foundation

import  UIKit
import WebKit

class MatchPageViewController : BaseController, WKScriptMessageHandler {
    var webView: WKWebView?
    var contentCallback : String = "MainPageViewCallBack"
    var homeUrl : String = "http://120.76.206.174:8080/efafootball-web/match.html"
    
    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name : contentCallback)
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = contentController
        
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: webViewConfig)
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        view = webView
        
        let image = UIImage(named: "NavigationImage")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView!.load(URLRequest(url: URL(string: homeUrl)!))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
    @IBAction func onBackCallBack() {
        if(webView?.canGoBack)! {
            webView!.goBack()
        }
    }
}
