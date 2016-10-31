//
//  Popwebview.h
//  EfaLeague
//
//  Created by baidu on 16/9/8.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface Popwebview : UIViewController {
    UIWebView *webview;
}

@property (nonatomic) NSString *url;
@property (nonatomic) NSString *jsmethod;
//@property (nonatomic) IBOutlet UIWebView *webview;

//@property (nonatomic) IBOutlet UIBarButtonItem *backbtn;

@end
