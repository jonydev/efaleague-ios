//
//  TeamInfoViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/9.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTeamViewController.h"
#import "Popwebview.h"
#import "GlobalVar.h"

@interface TeamInfoViewController : UIViewController {
    NSDictionary *teaminfo;
}

@property (nonatomic) NSInteger teamrow;
@property (nonatomic) NSString *Teamname;
@property (nonatomic) IBOutlet UIView *upperview;
@property (nonatomic) IBOutlet UILabel *gk;
@property (nonatomic) IBOutlet UILabel *back;
@property (nonatomic) IBOutlet UILabel *midfield;
@property (nonatomic) IBOutlet UILabel *forward;
@property (nonatomic) IBOutlet UILabel *leader;
@property (nonatomic) IBOutlet UILabel *captain;

@end
