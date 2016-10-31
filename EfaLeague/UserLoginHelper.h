//
//  UserLoginHelper.h
//  EfaLeague
//
//  Created by baidu on 16/9/10.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserLoginHelper : NSObject {
    NSDictionary *data;
    UIAlertView *loading;
}

+(id) shareInstance;
- (Boolean) isLogin;
- (void) PopLoginview;
- (NSString*) getUserToken;
- (void) Logout;
- (NSDictionary*) getUserInfo;
- (void) update:(NSMutableDictionary*)newData;
- (void) update:(NSString*) key second: (NSString*) value;
- (int) getUserTeamStatus; //0指未登录，//1指有球队, //2指无球队
//- (void) Login;


@end
