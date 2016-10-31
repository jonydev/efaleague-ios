//
//  NewsViewController.h
//  EfaLeague
//
//  Created by baidu on 16/9/5.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVar.h"

@interface NewsViewController : UIViewController {
    NSMutableArray *newsarray;
}

@property (nonatomic) IBOutlet UITableView *tabelView;

@end
