//
//  HomeViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/5.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "AdScrollView.h"
#import "AdDataModel.h"
#import <UIKit/UIKit.h>
#import "Popwebview.h"
#import "GlobalVar.h"
#import "MatchViewController.h"

@interface HomeViewController : UIViewController {
    AdScrollView *adscrollview;
    AdDataModel *datamodel;
    NSMutableArray *tableArray; // 保存联赛id
}

@property (nonatomic) IBOutlet UIButton *jointeam;

@property (nonatomic) IBOutlet UIButton *joinmatch;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

//@property (weak, nonatomic) IBOutlet UIImageView *saturday;
//
//@property (weak, nonatomic) IBOutlet UIImageView *sunday;

//@property (nonatomic) IBOutlet UIScrollView *contentview;

@property (nonatomic) IBOutlet UITableView *tableview;

@end
