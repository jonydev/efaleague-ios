//
//  UserViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/9.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"
#import "SettingViewController.h"

@interface UserViewController : UIViewController {
    NSArray *array;
    NSArray *iconArray;
}

@property (nonatomic) IBOutlet UITableView *tableview;

@end
