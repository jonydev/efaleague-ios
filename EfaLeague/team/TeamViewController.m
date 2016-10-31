//
//  TeamViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/5.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "TeamViewController.h"

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(clickrefresh)];
    
    receivedData = [[NSMutableData alloc] init];
    refreshingView = [[UIAlertView alloc] initWithTitle:@"刷新中" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    // 先读本地缓存数据
    TeamInfoHelper *helper = [TeamInfoHelper shareInstance];
    arrayData = [helper teamNameArray];
    showingData = [NSMutableArray arrayWithArray:arrayData];
    [self pulldata];
}

- (void) clickrefresh {
    [self pulldata];
}

- (void)viewDidAppear:(BOOL)animated {
    // 判断rightbtn状态
    // 判断是否领队、是否有球队
//    UserLoginHelper *Uhelper = [UserLoginHelper shareInstance];
//    NSInteger status = [Uhelper getUserTeamStatus];
//    if (status == 1) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑球队" style:UIBarButtonItemStylePlain target:self action:@selector(clickEdit)];
//    } else if (status == 2) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建球队" style:UIBarButtonItemStylePlain target:self action:@selector(clickCreate)];
//    } else {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    UserLoginHelper *Uhelper = [UserLoginHelper shareInstance];
    if ([Uhelper isLogin]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建球队" style:UIBarButtonItemStylePlain target:self action:@selector(clickCreate)];
    }
}

- (void) clickCreate {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    EditTeamViewController *edit = (EditTeamViewController*)[storyboard instantiateViewControllerWithIdentifier:@"EditTeamViewController"];
    edit.title = @"创建球队";
    edit.mStatus = false;
    [self.navigationController pushViewController:edit animated:YES];
}

- (void) pulldata {
    // 异步拉取球队数据。
    [refreshingView show];
    [receivedData resetBytesInRange:NSMakeRange(0, [receivedData length])];
    [receivedData setLength:0];
    NSURL *url = [NSURL URLWithString:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/allTeam?companyId=1"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    [refreshingView dismissWithClickedButtonIndex:0 animated:YES];
    NSLog(@"fail to pull");
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:nil];
    // 有效性验证
    if (dic == nil) {
        NSLog(@"dic is nil");
        return;
    } else {
        NSString *result = [dic objectForKey:@"result"];
        NSLog(@"allteam result: %@", result);
        if (result == nil || ![result isEqualToString:@"success"]) {
            return;
        }
    }
    // 组织plist数据
    NSMutableArray *teamArrayforSave;
    NSArray *teamArray = [dic objectForKey:@"rows"];
    if (teamArray == nil || [teamArray count] == 0) {
        return;
    } else {
        teamArrayforSave = [[NSMutableArray alloc] init];
        for (int i = 0; i < [teamArray count]; i++) {
            NSDictionary *dic = [teamArray objectAtIndex:i];
            NSMutableDictionary *dicToSave = [[NSMutableDictionary alloc] initWithDictionary:dic];
            NSString *id = [dic objectForKey:@"id"];
            if (id != nil) {
                // 同步拿球队详细信息
                NSString *teaminfoUrl = [NSString stringWithFormat:@"%@%@", @"http://120.76.206.174:8080/efaleague-web/appPath/appData/viewTeam?teamId=", id];
                NSURL *url = [NSURL URLWithString:teaminfoUrl];
//                NSLog(@"get teaminfo data start");
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
//                NSLog(@"get teaminfo data");
                NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                NSDictionary *teamInfodic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
                NSDictionary *teamInfoRowsdic = [[teamInfodic objectForKey:@"rows"] objectAtIndex:0];
                NSString *officeid = [[teamInfoRowsdic objectForKey:@"office"] objectForKey:@"id"];
                [dicToSave setValue:id forKey:@"id"];
                [dicToSave setValue:officeid forKey:@"officeid"];
//                NSLog(@"teaminfo: %@", teamInfoRowsdic);
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"leader"] forKey:@"leader"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"captain"] forKey:@"captain"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"win"] forKey:@"win"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"flat"] forKey:@"draw"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"loss"] forKey:@"loss"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"winning"] forKey:@"winning"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"home"] forKey:@"home"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"photo"] forKey:@"photo"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"gkNum"] forKey:@"gk"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"cbNum"] forKey:@"back"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"cmNum"] forKey:@"mid"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"cfNum"] forKey:@"forward"];
                [dicToSave setValue:[teamInfoRowsdic objectForKey:@"content"] forKey:@"intro"];
//                NSLog(@"teamid:%@", id);
//                NSLog(@"name:%@, photo:%@", [teamInfoRowsdic objectForKey:@"name"], [teamInfoRowsdic objectForKey:@"photo"]);
                // 同步拿球队logo
//                NSLog(@"get logo start");
                NSString *imageURL = [teamInfoRowsdic objectForKey:@"photo"];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:imageURL]];
                UIImage *image = [UIImage imageWithData:data];
                [UIImageJPEGRepresentation(image, 1) writeToFile:[GlobalVar generateSavePath:[teamInfoRowsdic objectForKey:@"id"]]  atomically:YES];
//                NSLog(@"get logo");
                
                // 同步拿球队球员信息
//                NSLog(@"get member info start");
                NSString *memberurl = [NSString stringWithFormat:@"%@%@", @"http://120.76.206.174:8080/efaleague-web/appPath/appData/memberList?teamId=", id];
//                NSLog(@"member url: %@", memberurl);
                NSURL *url1 = [NSURL URLWithString:memberurl];
                NSURLRequest *request1 = [[NSURLRequest alloc]initWithURL:url1 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                NSData *received1 = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
                NSDictionary *memberdic = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
                NSArray *memberrowsArray = [memberdic objectForKey:@"rows"];
                NSMutableArray *memberArraytoSave = [[NSMutableArray alloc] init];
//                NSLog(@"get teaminfo data");
                for (int i = 0; i < [memberrowsArray count]; i++) {
                    NSDictionary *tmpdic = [memberrowsArray objectAtIndex:i];
//                    NSLog(@"photo:%@", [tmpdic objectForKey:@"photo"]);
                    [memberArraytoSave addObject:tmpdic];
                }
                [dicToSave setValue:memberArraytoSave forKey:@"member"];
                [teamArrayforSave addObject:dicToSave];
            }
        }
    }
    // 更新plist
    TeamInfoHelper *helper = [TeamInfoHelper shareInstance];
    [helper update:teamArrayforSave];
    arrayData = [helper teamNameArray];
    showingData = [helper teamNameArray];
    
    // reload data
    [self.tabelView reloadData];
    
    [refreshingView dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return showingData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    TeamInfoHelper *helper = [TeamInfoHelper shareInstance];
    NSDictionary *dic = [helper teaminfo:indexPath.row];
    NSString *iconpath = [GlobalVar generateSavePath:[dic objectForKey:@"id"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (iconpath != nil && [fileManager fileExistsAtPath:iconpath]) {
        [cell.imageView setImage:[UIImage imageNamed:iconpath]];
    } else {
        
        [cell.imageView setImage:[UIImage imageNamed:@"teamicon"]];
    }
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = showingData[indexPath.row];
    NSString *str = @"球员数：";
    str = [str stringByAppendingString:[dic objectForKey:@"num"]];
    cell.detailTextLabel.text = str;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"text change");
    [showingData removeAllObjects];
    if (searchText.length > 0) {
        for (NSString *str in arrayData) {
            if ([str hasPrefix:searchText]) {
                [showingData addObject:str];
            }
        }
    } else {
        for (NSString *str in arrayData) {
            [showingData addObject:str];
        }
    }

    [self.tabelView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TeamInfoViewController *teaminfocontroller = (TeamInfoViewController*)[storyboard instantiateViewControllerWithIdentifier:@"teaminfoviewcontroller"];
    teaminfocontroller.title = showingData[row];
    teaminfocontroller.teamrow = row;
    [self.navigationController pushViewController:teaminfocontroller animated:YES];
}


@end
