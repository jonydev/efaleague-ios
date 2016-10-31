//
//  TeamInfoViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/9.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "TeamInfoViewController.h"
#import "UserLoginHelper.h"
#import "TeamInfoHelper.h"

@implementation TeamInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib

    // 数据from plist
    TeamInfoHelper *helper = [TeamInfoHelper shareInstance];
    teaminfo = [helper teaminfo:_teamrow];
//    NSLog(@"photo: %@", [teaminfo objectForKey:@"photo"]);
    NSString *tmp = [teaminfo objectForKey:@"gk"];
    if (tmp != nil) {
        _gk.text = [@"门将：" stringByAppendingString:tmp];
    } else {
        _gk.text = @"门将：0";
    }
    tmp = [teaminfo objectForKey:@"back"];
    if (tmp != nil) {
        _back.text = [@"后卫：" stringByAppendingString:tmp];
    } else {
        _back.text = @"后卫：0";
    }
    tmp = [teaminfo objectForKey:@"mid"];
    if (tmp != nil) {
        _midfield.text = [@"中场：" stringByAppendingString:tmp];
    } else {
        _midfield.text = @"中场：0";
    }
    tmp = [teaminfo objectForKey:@"forward"];
    if (tmp != nil) {
        _forward.text = [@"前锋：" stringByAppendingString:tmp];
    } else {
        _forward.text = @"前锋：0";
    }
    tmp = [teaminfo objectForKey:@"leader"];
    if (tmp != nil) {
        _leader.text = [@"领队：" stringByAppendingString:tmp];
    } else {
        _leader.text = @"领队：";
    }
    tmp = [teaminfo objectForKey:@"captain"];
    if (tmp != nil) {
        _captain.text = [@"队长：" stringByAppendingString:tmp];
    } else {
        _captain.text = @"队长：";
    }
}

- (void) viewDidAppear:(BOOL)animated {
    // 同步请求判断显示申请加入还是编辑球队
    Boolean isLeader = false;
    NSString *teamId = [teaminfo objectForKey:@"id"];
    NSString *loginId = [[[UserLoginHelper shareInstance] getUserInfo] objectForKey:@"loginId"];
    if (teamId != nil && teamId.length > 0 && loginId != nil && loginId.length > 0) {
        NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/checkLeader?teamId=%@&loginId=%@",
                         teamId, loginId];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (data != nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *suc = [result objectForKey:@"result"];
            if (suc != nil && [suc isEqualToString:@"success"]) {
                isLeader = true;
            }
        }
    }
    if (isLeader) {
        // 右上角按钮编辑球队
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑球队" style:UIBarButtonItemStylePlain target:self action:@selector(clickEdit)];
    } else {
        // 右上角按钮申请加入
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"申请加入" style:UIBarButtonItemStylePlain target:self action:@selector(clickJoin)];
    }

}

-(void) clickEdit {
    // 跳编辑界面
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    EditTeamViewController *edit = (EditTeamViewController*)[storyboard instantiateViewControllerWithIdentifier:@"EditTeamViewController"];
    edit.title = @"编辑球队";
    edit.mStatus = true;
    edit.teamId = [teaminfo objectForKey:@"id"];
    edit.teaminfo = teaminfo;
    [self.navigationController pushViewController:edit animated:YES];
}

-(void)clickJoin{
    NSLog(@"click join");
    // 是否登录
    UserLoginHelper *helper = [UserLoginHelper shareInstance];
    if (![helper isLogin]) {
        [helper PopLoginview];
        return;
    }
    // 判断是否已加入球队
    int status = [helper getUserTeamStatus];
    if (status == 1) {
        // 已有球队
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你已加入球队" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    // 发请求加入球队
    UIAlertView *doing = [[UIAlertView alloc] initWithTitle:nil message:@"申请中" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [doing show];
    NSString *teamid = [teaminfo objectForKey:@"id"];
    NSString *loginid = [[helper getUserInfo] objectForKey:@"loginId"];
    NSLog(@"teamid: %@, loginId: %@", teamid, loginid);
    NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/joinTeam?teamId=%@&loginId=%@", teamid, loginid];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    [doing dismissWithClickedButtonIndex:0 animated:YES];
    if (received != nil) {
        UIAlertView *suc = [[UIAlertView alloc] initWithTitle:nil message:@"申请成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [suc show];
        return;
    }
    UIAlertView *fail = [[UIAlertView alloc] initWithTitle:nil message:@"申请失败，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [fail show];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        NSArray *array = [teaminfo objectForKey:@"member"];
        return array.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"球队战绩";
    } else if (section == 1) {
        return @"球队介绍";
    } else {
        return @"球队成员";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        // 列寬
        CGFloat contentWidth = 300;
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:20];
        
        // 該行要顯示的內容
        NSString *content = [teaminfo objectForKey:@"intro"];;
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
        
        // 這裏返回需要的高度
        return size.height + 20;
    } else {
        return 30;
    }


    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    UITableViewCell *cell;
    NSArray *array = [teaminfo objectForKey:@"member"];
    NSDictionary *memberdic = array[row];
    if (section == 0) {
        // 球队战绩
        cell = [tableView dequeueReusableCellWithIdentifier:@"record"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"record"];
        }
//        cell.textLabel.text=@"胜/0 平/0 负/0 胜率:0%";
        cell.textLabel.text=[NSString stringWithFormat:@"胜/%@ 平/%@ 负%@ 胜率:%@", [teaminfo objectForKey:@"win"], [teaminfo objectForKey:@"draw"], [teaminfo objectForKey:@"loss"], [teaminfo objectForKey:@"winning"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (section == 1) {
        // 球队介绍
        cell = [tableView dequeueReusableCellWithIdentifier:@"intro"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"intro"];
        }
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text=[teaminfo objectForKey:@"intro"];
        
        
    } else {
        // 球队成员
        cell = [tableView dequeueReusableCellWithIdentifier:@"member"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:@"member"];
        }
        cell.textLabel.text=[memberdic objectForKey:@"name"];
        NSString *iconurl = [NSString stringWithFormat:@"%@%@", QINIU, [memberdic objectForKey:@"photo"]];
//        NSString *iconurl = [memberdic objectForKey:@"photo"];
//        NSLog(@"iconurl:%@",iconurl);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconurl]];
        if (data == nil) {
            [cell.imageView setImage:[UIImage imageNamed:@"teamicon"]];
        } else {
            [cell.imageView setImage:[UIImage imageWithData:data]];
        }
        
//        NSString *iconpath = [GlobalVar generateSavePath:[memberdic objectForKey:@"icon"]];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if (iconpath != nil && [fileManager fileExistsAtPath:iconpath]) {
//            [cell.imageView setImage:[UIImage imageNamed:iconpath]];
//        } else {
//            [cell.imageView setImage:[UIImage imageNamed:@"teamicon"]];
//        }
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if (section == 0) {
        // 跳对阵表
        Popwebview *pop = [[Popwebview alloc] init];
        pop.url = @"http://120.76.206.174:8080/Match/teamRecord.html";
        pop.jsmethod = [NSString stringWithFormat:@"setParam(\"%@\", \"%@\")", [teaminfo objectForKey:@"officeid"], [teaminfo objectForKey:@"id"]];
        UINavigationController *presNavigation = [[UINavigationController alloc] initWithRootViewController: pop];
        if ([[UIDevice currentDevice].systemVersion floatValue]<6.0)
        {
            [self presentModalViewController:presNavigation animated:YES];
        } else{
            [self presentViewController:presNavigation animated:YES completion:^{
                NSLog(@"call back");}];
        }
    }
}



@end
