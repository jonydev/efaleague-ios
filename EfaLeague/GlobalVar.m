//
//  GlobalVar.m
//  EfaLeague
//
//  Created by baidu on 16/9/18.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "GlobalVar.h"

@implementation GlobalVar

static Boolean homeget;
static Boolean teamget;
static GlobalVar* _instance = nil;

+(id) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    [_instance initialize];
    return _instance ;
}

- (void) initialize {
    homeget = NO;
}

- (void) setHomeGet:(Boolean) get {
    homeget = get;
}
- (Boolean) getHome {
    return homeget;
}

- (void) setTeamGet:(Boolean) get {
    teamget = get;
}
- (Boolean) getTeam {
    return teamget;
}

+ (NSString*) generateSavePath:(NSString*) filename {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fullpath = [path stringByAppendingPathComponent:filename];
    return fullpath;

}

//+ (NSString*) makeToken {
//    const char *secretKeyStr = [SK UTF8String];
//    
//    NSString *policy = [self marshal];
//    
//    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *encodedPolicy = [GTM_Base64 stringByWebSafeEncodingData:policyData padded:TRUE];
//    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
//}

@end
