//
//  GlobalVar.h
//  EfaLeague
//
//  Created by baidu on 16/9/18.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define QINIU @"http://obxgaesml.bkt.clouddn.com/"
#define AK @"fq2Nxrta1gQznVDmnxg23XzHO2_vcUf0H7cvXV3-"
#define SK @"6c-ajcooA7O5IeGWDXRgLcgIzt85dUPFOhdq6pD_"

@interface GlobalVar : NSObject

+ (id) shareInstance;
+ (NSString*) generateSavePath:(NSString*) filename;
- (void) setHomeGet:(Boolean) get;
- (Boolean) getHome;
- (void) setTeamGet:(Boolean) get;
- (Boolean) getTeam;

//+ (NSString*) makeToken;

@end
