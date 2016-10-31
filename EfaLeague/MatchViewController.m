//
//  MatchViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/9.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "MatchViewController.h"

@implementation MatchViewController

static NSString *mOfficeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    if (mOfficeId == nil) {
        // 默认id
        mOfficeId = @"372ccd0399674ba5aabd5b984a25cf40";
    }
    
    _webview.delegate = self;
    
    [_intro addTarget:self action:@selector(clickintro) forControlEvents:UIControlEventTouchUpInside];
    [_schedule addTarget:self action:@selector(clickschedule) forControlEvents:UIControlEventTouchUpInside];
    [_list addTarget:self action:@selector(clicklist) forControlEvents:UIControlEventTouchUpInside];
    [_discuss addTarget:self action:@selector(clickdiscuss) forControlEvents:UIControlEventTouchUpInside];
    [self clickintro];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(clickback)];
}

- (void) viewDidAppear:(BOOL)animated {
    [_webview reload];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    NSLog(@"webview finish");
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [context evaluateScript:[NSString stringWithFormat:@"setOfficeId(\"%@\")", mOfficeId]];
}

+ (void) setOfficeId:(NSString*) officeId {
    mOfficeId = officeId;
}

- (void) clickintro {
//    NSString *str = @"https://baidu.he-kai.com/share/Match/teamRecord.html";
    NSString *str = @"http://120.76.206.174:8080/Match/intro.html";
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:str]];
    [_webview loadRequest:request];
}

- (void) clickschedule {
    NSString *str = @"http://120.76.206.174:8080/Match/Schedule.html";
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:str]];
    [_webview loadRequest:request];
}

- (void) clicklist {
    NSString *str = @"http://120.76.206.174:8080/Match/Billboard.html";
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:str]];
    [_webview loadRequest:request];
}

- (void) clickdiscuss {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"敬请期待" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
//    NSString *str = @"http://sina.cn";
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:str]];
//    [_webview loadRequest:request];
}

- (void) clickback {
    if (_webview.canGoBack) {
        [_webview goBack];
    }
}

@end
