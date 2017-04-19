//
//  BaseController.swift
//  EFALeague
//
//  Created by Zhou Huang on 19/04/2017.
//  Copyright © 2017 Jonyzz. All rights reserved.
//
import Foundation
import  UIKit
import WebKit
import Foundation


class BaseController : UIViewController, WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: "提醒", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "知道了", style:
        .cancel) { (action) in
            
            completionHandler()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
        
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler:
        { (ac) -> Void in
            completionHandler(true)  //按确定的时候传true
        })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler:
        { (ac) -> Void in
            completionHandler(false)  //取消传false
        })
        
        alert.addAction(actionOk)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NSLog(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        NSLog(error.localizedDescription)
    }
}
