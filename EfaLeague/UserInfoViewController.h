//
//  UserInfoViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/8.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginHelper.h"
#import "GlobalVar.h"
#import <QiniuSDK.h>

@interface UserInfoViewController : UIViewController {
    NSArray *baselabelkey;
    NSArray *userlabelkey;
    NSArray *baseinfoLabelArray;
    NSArray *userinfoLabelArray;
    NSMutableArray *baseinfoContentArray;
    NSMutableArray *userinfoContentArray;
    NSInteger currentsection;
    NSInteger currentrow;
    UIImagePickerController *imagepicker;
    Boolean iconchange;
    QNUploadManager *upManager;
    UIImage *changedIcon;
}

@property (nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic) IBOutlet UIImageView *imageview;

@end
