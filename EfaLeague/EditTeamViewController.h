//
//  EditTeamViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/20.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginHelper.h"
#import "TeamInfoHelper.h"
#import "GlobalVar.h"
#import <QiniuSDK.h>

@interface EditTeamViewController : UIViewController {
    NSArray *sectionLabel;
    NSMutableArray *rowtext;
    NSInteger currentsection;
    NSInteger currentrow;
    UIImagePickerController *imagepicker;
    UIImage *icon;
    QNUploadManager *upManager;
}

@property (nonatomic) NSString *teamId;

@property (nonatomic) Boolean mStatus;// true:edit, false:create.

@property (nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic) NSDictionary *teaminfo;

@end
