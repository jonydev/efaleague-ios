//
//  MatchViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/9.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface MatchViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *intro; // 简介
@property (nonatomic) IBOutlet UIButton *schedule; // 赛程
@property (nonatomic) IBOutlet UIButton *list; // 榜单
@property (nonatomic) IBOutlet UIButton *discuss; // 讨论
@property (nonatomic) IBOutlet UIWebView *webview;

+ (void) setOfficeId:(NSString*) officeId;

@end
