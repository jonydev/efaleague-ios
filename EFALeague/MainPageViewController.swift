//
//  MainPageViewController.swift
//  EFALeague
//
//  Created by Zhou Huang on 15/01/2017.
//  Copyright © 2017 Jonyzz. All rights reserved.
//

import Foundation
import  UIKit
import WebKit

class MainPageViewController : UIViewController, WKScriptMessageHandler {
    var webView: WKWebView?
    var contentCallback : String = "callbackHandler"
    var homeUrl : String = "http://120.76.206.174:8080/efafootball-web/home.html"
//    var homeUrl : String = "http://120.77.159.148:3000/efafootball-web/home.html"
    
    override func loadView() {
        let contentController = WKUserContentController()
        contentController.add(self, name : contentCallback)
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.userContentController = contentController
        
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: webViewConfig)
        view = webView
    }
    
    override func viewDidLoad() {
        self.webView!.load(URLRequest(url: URL(string: homeUrl)!))
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("javascript call success")
        if let messageBody:NSDictionary = message.body as? NSDictionary {
            let functionToRun = String(describing: messageBody.value(forKey: "functionToRun")!);
            switch(functionToRun) {
            case "joinTeam":
                print ("joinTeam")
                self.tabBarController?.selectedIndex = 2
            case "matchSignUp":
                print ("matchSignUp")
                self.tabBarController?.selectedIndex = 1
            default:
                return {}();
            }
        }
    }
    
    @IBAction func onBackCallBack() {
        print("goBack click")
        if(webView?.canGoBack)! {
            webView?.goBack()
        }
    }
}
