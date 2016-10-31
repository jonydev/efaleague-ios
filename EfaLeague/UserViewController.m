//
//  UserViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/9.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "UserViewController.h"
#import "UserLoginHelper.h"

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    self.automaticallyAdjustsScrollViewInsets=NO;
    array = [[NSArray alloc] initWithObjects:@"个人信息", @"系统消息", @"分享", @"我要吐槽", @"设置", nil];
    iconArray = [[NSArray alloc] initWithObjects:@"userinfo", @"sysmessage", @"share", @"tucao", @"setting", nil];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:nil target:self action:@selector(clickLogin)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:nil target:self action:@selector(clickregister)];
}

- (void) clickregister {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注册", nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [alert show];
}

-(void) alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // 0＝取消，1=注册
    if (buttonIndex == 1) {
        NSString *loginName = [alertView textFieldAtIndex:0].text;
        NSString *password = [alertView textFieldAtIndex:1].text;
        if (loginName == nil || loginName.length == 0 || password == nil || password.length == 0) {
            // 错误框
            UIAlertView *invalid = [[UIAlertView alloc] initWithTitle:@"账号或密码不合法" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [invalid show];
            return;
        }
        // 同步调用注册接口
        NSString *loginUrl = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/createUser?loginName=%@&password=%@&name=%@&userType=1", loginName, password, loginName];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:loginUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
        if (dic != nil) {
            NSString* result = [dic objectForKey:@"result"];
            if (result != nil) {
                if ([result isEqualToString:@"success"]) {
                    UIAlertView *suc = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"新用户请尽快登录修改个人信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [suc show];
                } else if ([result isEqualToString:@"repeat"]) {
                    UIAlertView *repeat = [[UIAlertView alloc] initWithTitle:@"用户名重复" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [repeat show];
                } else {
                    UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"注册失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [fail show];
                }
            } else {
                UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"注册失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [fail show];
            }
        } else {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"注册失败" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [fail show];
        }
    }
}

- (void) clickLogin {
    UserLoginHelper *helper = [UserLoginHelper shareInstance];
    if ([helper isLogin]) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:nil message:@"你已登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [a show];
        return;
    }
    [helper PopLoginview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    [cell.imageView setImage:[UIImage imageNamed:@"first"]];
    [cell.imageView setImage:[UIImage imageNamed:iconArray[indexPath.row]]];
    cell.textLabel.text = array[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if (row == 0) {
        // 个人信息
        UserLoginHelper *helper = [UserLoginHelper shareInstance];
        if (![helper isLogin]) {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"请先登录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [fail show];
            return;
        }
        UserInfoViewController *userinfoviewcontroller = (UserInfoViewController*)[storyboard instantiateViewControllerWithIdentifier:@"UserInfoViewController"];
        [self.navigationController pushViewController:userinfoviewcontroller animated:YES];
    } else if (row == 4) {
        // 设置
        SettingViewController *settingviewcontroller = (SettingViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
        [self.navigationController pushViewController:settingviewcontroller animated:YES];
    } else if (row == 1) {
        // 系统消息
    } else if (row == 3) {
        // 我要吐槽
    } else if (row == 2) {
        // 分享
    }
}

@end
