//
//  TeamInfoHelper.h
//  EfaLeague
//
//  Created by baidu on 16/9/10.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamInfoHelper : NSObject {
        NSArray *data;
}

+(id) shareInstance;
- (NSInteger) teamcount;
- (NSDictionary*) teaminfo:(int) index;
- (NSArray*) teamNameArray;
- (void) update:(NSMutableArray*) array;

@end
