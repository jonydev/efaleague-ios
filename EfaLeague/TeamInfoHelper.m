//
//  TeamInfoHelper.m
//  EfaLeague
//
//  Created by baidu on 16/9/10.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "TeamInfoHelper.h"

@implementation TeamInfoHelper

static TeamInfoHelper* _instance = nil;

+(id) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
        [_instance selfinit];
    }) ;
    [_instance selfinit];
    return _instance ;
}

- (void) copyAssets {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Teaminfo" ofType:@"plist"];
    NSArray *asset = [[NSArray alloc]initWithContentsOfFile:plistPath];
    [asset writeToFile:[self getplistPath] atomically:YES];
}

- (void) selfinit {
    NSString *plistPath = [self getplistPath];
    data = [[NSArray alloc]initWithContentsOfFile:plistPath];
}

- (NSInteger) teamcount {
    return data.count;
}
- (NSDictionary*) teaminfo:(int) index {
    return [data objectAtIndex:index];
}

- (NSArray*) teamNameArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < data.count; i++) {
        NSDictionary *dic = data[i];
        [array addObject: [dic objectForKey:@"name"]];
    }
    return array;
}

- (void) update:(NSMutableArray*) array {
    NSString *plistPath = [self getplistPath];
    [array writeToFile:plistPath atomically:YES];
    [self selfinit];
}

- (NSString*) getplistPath {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"Teaminfo.plist"];
    return fileName;
}



@end
