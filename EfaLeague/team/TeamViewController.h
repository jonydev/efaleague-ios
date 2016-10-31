//
//  TeamViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/5.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfoViewController.h"
#import "TeamInfoHelper.h"
#import "UserLoginHelper.h"
#import "GlobalVar.h"
#import "EditTeamViewController.h"

@interface TeamViewController : UIViewController {
    NSMutableArray *arrayData;
    NSMutableArray *showingData;
    NSMutableData *receivedData;
    UIAlertView *refreshingView;
}

@property (nonatomic) IBOutlet UITableView *tabelView;
@property (nonatomic) IBOutlet UISearchBar *searchbar;

@end
