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

class MomentPageViewController : BaseController, WKScriptMessageHandler {
    var webView: WKWebView?
    var contentCallback : String = "callbackHandler"
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
        NSLog("javascript call success")
        if let messageBody:NSDictionary = message.body as? NSDictionary {
            let functionToRun = String(describing: messageBody.value(forKey: "functionToRun")!);
            switch(functionToRun) {
            case "loadView":
                NSLog ("loadView")
                self.webView!.load(URLRequest(url: URL(string: homeUrl)!))
            default:
                return {}();
            }
        }
    }
    
    @IBAction func onBackCallBack() {
        if(webView?.canGoBack)! {
            webView!.goBack()
        }
    }
    
    @IBAction func onCreateArticle() {
        webView!.load(URLRequest(url: URL(string: createArticle)!))
    }
}

