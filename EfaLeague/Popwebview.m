//
//  Popwebview.m
//  EfaLeague
//
//  Created by baidu on 16/9/8.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "Popwebview.h"

@implementation Popwebview

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // back button
    UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickbackbtn)];

    self.navigationItem.leftBarButtonItem = backbtn;

    NSURL *nsurl = [[NSURL alloc]initWithString:_url];

    NSLog(@"pop loaded");
    webview = [[UIWebView alloc]init];
    webview.delegate = self;
    webview.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    [self.navigationController.navigationBar setHidden:false];
    [self.view addSubview:webview];
    // 左对齐
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:webview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.0f];
    // 右对齐
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:webview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.0f];
    
    // 上对齐
    NSLayoutConstraint* topConstraint = [NSLayoutConstraint constraintWithItem:webview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
    
    //高度相同
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint constraintWithItem:webview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    leftConstraint.active = YES;
    rightConstraint.active = YES;
    topConstraint.active = YES;
    heightConstraint.active = YES;
    [webview loadRequest:[NSURLRequest requestWithURL:nsurl]];
    
}


- (void)clickbackbtn {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"click back btn");
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismissed");}];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //    NSLog(@"webview finish");
    NSLog(@"webview loaded");
    if (_jsmethod != nil && _jsmethod.length > 0) {
        JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        [context evaluateScript:_jsmethod];
        _jsmethod = nil;
    }
}
@end
