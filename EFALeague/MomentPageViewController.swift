//
//  MomentPageViewController.swift
//  EFALeague
//
//  Created by Zhou Huang on 19/03/2017.
//  Copyright © 2017 Jonyzz. All rights reserved.
//

import Foundation
import  UIKit
import WebKit

class MomentPageViewController : UIViewController, WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView?
    var contentCallback : String = "MomentPageViewCallBack"
    var homeUrl : String = "http://120.76.206.174:8080/efafootball-web/moment.html"
    var createArticle : String = "http://120.76.206.174:8080/efafootball-web/moment-new.html"
    
    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name : contentCallback)
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = contentController
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: webViewConfig)
        view = webView
        self.webView?.navigationDelegate = self
        self.webView?.uiDelegate = self
        
        let image = UIImage(named: "NavigationImage")
        let imageView = UIImageView(image: image)
        navigationItem.titleView = imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView!.load(URLRequest(url: URL(string: homeUrl)!))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    }
    
    @IBAction func onBackCallBack() {
        if(webView?.canGoBack)! {
            webView!.goBack()
        }
    }
    
    @IBAction func onCreateArticle() {
        webView!.load(URLRequest(url: URL(string: createArticle)!))
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "知道了", style:
        .cancel) { (action) in
            
            completionHandler()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

