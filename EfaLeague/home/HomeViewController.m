//
//  HomeViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/5.
//  Copyright © 2016年 soarhe. All rights reserved.
//
#define UISCREENHEIGHT  self.view.bounds.size.height
#define UISCREENWIDTH  self.view.bounds.size.width
#import "HomeViewController.h"



@implementation HomeViewController

 - (void)viewDidLoad
{
    [super viewDidLoad];
    tableArray = [[NSMutableArray alloc] init];
    
    adscrollview = [[AdScrollView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENWIDTH/2.5)];
//    datamodel = [AdDataModel adDataModelWithImageNameAndAdTitleArray];
    //如果滚动视图的父视图由导航控制器控制,必须要设置该属性(ps,猜测这是为了正常显示,导航控制器内部设置了UIEdgeInsetsMake(64, 0, 0, 0))
    adscrollview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    adscrollview.imageNameArray = datamodel.imageNameArray;
    adscrollview.PageControlShowStyle = UIPageControlShowStyleRight;
    adscrollview.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//  [adscrollview setAdTitleArray:dataModel.adTitleArray withShowStyle:AdTitleShowStyleLeft];
    adscrollview.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    [self.scrollview addSubview:adscrollview];
    self.scrollview.backgroundColor = [UIColor darkGrayColor];
    
//    [_contentview setAutoresizesSubviews:NO];
//    [_contentview setAutoresizingMask:UIViewAutoresizingNone];
    
    // button点击响应
    [_jointeam addTarget:self action:@selector(clickjointeam) forControlEvents:UIControlEventTouchUpInside];
    [_joinmatch addTarget:self action:@selector(clickjoinmatch) forControlEvents:UIControlEventTouchUpInside];
    
    // 轮播点击响应
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onCLickScrollView)];
    [[self scrollview] addGestureRecognizer:singleTap1];
    self.scrollview.userInteractionEnabled = YES;
    
    _tableview.rowHeight = 150;

    [self pulldata];
    
}

-(void)clickjointeam{
    self.navigationController.tabBarController.selectedIndex = 2;
}

-(void)clickjoinmatch{
    self.navigationController.tabBarController.selectedIndex = 1;
}


-(void)onCLickScrollView{
    
    NSInteger current = [adscrollview getCurrentPage];
    NSLog(@"第%li幅图片被电击", (long)current);
    NSString* url = [datamodel getUrl:current];
    if (url == nil) {
        return;
    }
    Popwebview *pop;
    pop = [[Popwebview alloc] init];
    pop.url = url;
    
    UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: pop];
    if ([[UIDevice currentDevice].systemVersion floatValue]<6.0)
    {
        [self presentModalViewController:presNavigation animated:YES];
    } else{
        [self presentViewController:presNavigation animated:YES completion:^{
            NSLog(@"call back");}];
    }
}

-(void)pulldata {
    // 拉取轮播图数据，存于plist。
    NSURL *url = [NSURL URLWithString:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/bulletinData"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    // 同步拉取首页图片。
    NSURL *officeUrl = [NSURL URLWithString:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/officeData"];
    NSURLRequest *officerequest = [[NSURLRequest alloc]initWithURL:officeUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:officerequest returningResponse:nil error:nil];
    if (received == nil) {
        NSLog(@"home reload fail");
        [[self tableview] reloadData];
        return;
    }
    NSArray *officeArray = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
    NSLog(@"officeArray:%@", officeArray);
    if (officeArray != nil) {
        for (int i = 0; i < [officeArray count]; i++) {
            NSDictionary *tmpdic = [officeArray objectAtIndex:i];
            [tableArray addObject:[tmpdic objectForKey:@"id"]];
            // 拉图片
            NSURL *imageUrl = [NSURL URLWithString:[tmpdic objectForKey:@"photo"]];
            NSData *data = [NSData dataWithContentsOfURL:imageUrl];
            UIImage *image = [UIImage imageWithData:data];
            NSString *savename = [NSString stringWithFormat:@"homeimage%d", i];
            [UIImageJPEGRepresentation(image, 1) writeToFile:[GlobalVar generateSavePath:savename]  atomically:YES];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    // 更新plist
    [AdDataModel updateData:array];
    // 读取plist 更新视图
    datamodel = [AdDataModel adDataModelWithImageNameAndAdTitleArray];
//    NSLog(@"data: %@", datamodel.imageNameArray);
    adscrollview.imageNameArray = datamodel.imageNameArray;
    adscrollview.PageControlShowStyle = UIPageControlShowStyleRight;
    adscrollview.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    adscrollview.pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"rows num: %ld", tableArray.count);
    return tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    NSString *savepath = [GlobalVar generateSavePath:[NSString stringWithFormat:@"homeimage%ld", (long)indexPath.row]];
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:savepath]];
//    cell.selectedBackgroundView = back;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = back;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    NSString *officeId = tableArray[row];
    NSLog(@"officeid: %@", officeId);
    [MatchViewController setOfficeId:officeId];
    self.navigationController.tabBarController.selectedIndex = 1;
}


@end
