//
//  UserLoginHelper.m
//  EfaLeague
//
//  Created by baidu on 16/9/10.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "UserLoginHelper.h"

@implementation UserLoginHelper

static UserLoginHelper* _instance = nil;

+(id) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
        [_instance initial];
    }) ;
    [_instance readplist];
    return _instance ;
}

- (void) initial {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Userinfo" ofType:@"plist"];
    NSDictionary *tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [tmp writeToFile:[self getPlistPath] atomically:YES];
}

- (void) readplist {
    if (loading == nil) {
        loading = [[UIAlertView alloc] initWithTitle:nil
                                             message: @"登录中..."
                                            delegate: nil
                                   cancelButtonTitle: @"取消"
                                   otherButtonTitles: nil];
    }
    // read plist;
    NSString *plistPath = [self getPlistPath];
    data = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
}

-(Boolean) isLogin {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *loginName = [ud objectForKey:@"loginName"];
    if (loginName != nil && loginName.length > 0) {
        return YES;
    } else {
        return NO;
    }
//    if (data == nil) {
//        [self readplist];
//    }
//    if (data != nil) {
//        NSString *loginName = [data objectForKey:@"loginName"];
//        if (loginName == nil || loginName.length == 0) {
//            return NO;
//        } else {
//            return YES;
//        }
//    } else {
//        return NO;
//    }
}

- (void) PopLoginview {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", @"找回密码", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

-(void) alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    // 0＝取消，1=登录，2=找回。
    if (buttonIndex == 1) {
        // 转菊花
        [loading show];
        // 同步发登录请求
        NSString *loginName = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        if (loginName == nil || loginName.length == 0 || password == nil || password.length == 0) {
            // 取消菊花
            [loading dismissWithClickedButtonIndex:0 animated:YES];
            // 错误框
            UIAlertView *invalid = [[UIAlertView alloc] initWithTitle:@"账号或密码不合法" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [invalid show];
            return;
        }
        NSString *loginUrl = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/checkLogin?loginName=%@&password=%@", loginName, password];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:loginUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (received == nil) {
            // 登录失败
            [loading dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [fail show];
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
        if (dic != nil) {
            // 判断结果
            NSString* result = [dic objectForKey:@"result"];
            NSDictionary *infodic = [[dic objectForKey:@"rows"] objectAtIndex:0];
            if (result != nil && [result isEqualToString:@"true"] && infodic != nil) {
                // 写plist
                NSMutableDictionary *write = [[NSMutableDictionary alloc] initWithDictionary:data];
                NSString *plistPath = [self getPlistPath];
//                NSString *plistPath;
                // 这里返回的id实际上是loginId。
                [write setObject:[infodic objectForKey:@"id"] forKey:@"loginId"];
                [write setObject:loginName forKey:@"loginName"];
                [write writeToFile:plistPath atomically:YES];
                [self readplist];
                // userdefault
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:loginName forKey:@"loginName"];
                [ud setObject:[infodic objectForKey:@"id"] forKey:@"loginId"];
                [ud synchronize];
                
                UIAlertView *suc = [[UIAlertView alloc] initWithTitle:@"登录成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [suc show];
            } else {
                // 登录失败
                UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"登录失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [fail show];
            }
        }
        // 取消菊花
        [loading dismissWithClickedButtonIndex:0 animated:YES];
    } else if (buttonIndex == 2) {
        NSLog(@"找回密码");
    }
}

- (NSString*) getPlistPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"Userinfo.plist"];
    return fileName;
}

- (void) Logout {
    NSMutableDictionary *write = [[NSMutableDictionary alloc] initWithDictionary:data];
    NSString *plistPath = [self getPlistPath];
    [write setObject:@"" forKey:@"loginName"];
    [write setObject:@"" forKey:@"id"];
    [write writeToFile:plistPath atomically:YES];
    [self readplist];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"" forKey:@"loginName"];
    [ud setObject:@"" forKey:@"loginId"];
    [ud synchronize];
}

- (NSDictionary*) getUserInfo {
    return data;
}

- (void) update:(NSMutableDictionary*) newData {
//    [newData setValue:[data objectForKey:@"id"] forKey:@"id"];
    [newData setValue:[data objectForKey:@"loginName"] forKey:@"loginName"];
//    [newData setValue:[data objectForKey:@"password"] forKey:@"password"];
    NSString *plistPath = [self getPlistPath];
    [newData writeToFile:plistPath atomically:YES];
    [self readplist];
}

- (void) update:(NSString*) key second: (NSString*) value {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:data];
    [dic setValue:value forKey:key];
    [dic writeToFile:[self getPlistPath] atomically:YES];
    [self readplist];
}

- (int) getUserTeamStatus {
    if (![self isLogin]) {
        return 0;
    } else {
        NSNumber *status = [data objectForKey:@"teamstatus"];
        return [status intValue];
    }
}

@end
