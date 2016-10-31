//
//  NewsViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/5.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "NewsViewController.h"

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    _tabelView.rowHeight = 60;
    // 新闻tab 拉数据，更新tableview。
    newsarray = [[NSMutableArray alloc] init];
    // 拉数据
    [self pulldata];
}

- (void) pulldata {
    // 同步拉新闻数据
    NSString *newsUrl = @"http://120.76.206.174:8080/efaleague-web/appPath/appData/newsData?id=1";
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:newsUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *newsdata = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
    if (newsdata == nil) {
        return;
    }
    [newsarray removeAllObjects];
    for (int i = 0; newsdata != nil && i < [newsdata count]; i++) {
        NSDictionary *tmpdic = [newsdata objectAtIndex:i];
        // 下载图片
        NSString *iconSavepath = [GlobalVar generateSavePath:[tmpdic objectForKey:@"id"]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:[tmpdic objectForKey:@"photo"]]];
        UIImage *image = [UIImage imageWithData:data];
        [UIImageJPEGRepresentation(image, 1) writeToFile:iconSavepath  atomically:YES];
        [newsarray addObject:tmpdic];
    }
    [[self tabelView]reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return newsarray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    NSDictionary *tmpdic = newsarray[indexPath.row];
    NSString *iconSavepath = [GlobalVar generateSavePath:[tmpdic objectForKey:@"id"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (iconSavepath != nil && [fileManager fileExistsAtPath:iconSavepath]) {
        [cell.imageView setImage:[UIImage imageNamed:iconSavepath]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"teamicon"]];
    }
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = [tmpdic objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];

}

@end
