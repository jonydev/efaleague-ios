//
//  UserInfoViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/8.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "UserInfoViewController.h"

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    upManager = [[QNUploadManager alloc] init];
    iconchange = false;
    self.automaticallyAdjustsScrollViewInsets=NO;
    baseinfoLabelArray = [[NSArray alloc]initWithObjects:@"姓名", @"身份证", @"手机号码", @"保单号", nil];
    userinfoLabelArray = [[NSArray alloc]initWithObjects:@"性别", @"身高", @"体重", @"年龄",  @"位置", nil];
    baselabelkey = [[NSArray alloc]initWithObjects:@"name", @"cards", @"telephone", @"policyno", nil];
    userlabelkey = [[NSArray alloc]initWithObjects:@"sex", @"height", @"weight", @"age",  @"position", nil];
    
    _imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickIcon)];
    [[self imageview] addGestureRecognizer:singleTap1];
    
    // 读缓存
    UserLoginHelper *helper = [UserLoginHelper shareInstance];
    NSDictionary *data = [helper getUserInfo];
    NSLog(@"data:%@", data);
    baseinfoContentArray = [[NSMutableArray alloc] initWithObjects:[data objectForKey:@"name"], [data objectForKey:@"cards"], [data objectForKey:@"telephone"], [data objectForKey:@"policyno"], nil];
    userinfoContentArray = [[NSMutableArray alloc] initWithObjects:[data objectForKey:@"sex"], [data objectForKey:@"height"], [data objectForKey:@"weight"], [data objectForKey:@"age"], [data objectForKey:@"position"], nil];
    
    imagepicker=[[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.allowsEditing = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickOK)];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *loginid = [ud objectForKey:@"loginId"];
    // 异步拉数据
    NSString *viewuser = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/viewMember?loginId=%@", loginid];
    NSLog(@"url: %@", viewuser);
    NSURL *url = [NSURL URLWithString:viewuser];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void) clickIcon {
    UIAlertController *setCon = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [setCon addAction:[UIAlertAction actionWithTitle:@"图库" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagepicker animated:YES completion:nil];

    }]];
    [setCon addAction:[UIAlertAction actionWithTitle:@"拍照" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagepicker animated:YES completion:nil];
        
    }]];
    [setCon addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
    setCon.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController: setCon animated: YES completion: nil];
}

- ( void )imagePickerController:( UIImagePickerController *)picker didFinishPickingMediaWithInfo:( NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    changedIcon = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_imageview setImage:changedIcon];
    iconchange = true;
}

- (void) clickOK {
    NSDictionary *dic = [[UserLoginHelper shareInstance] getUserInfo];
    if (iconchange && changedIcon != nil) {
        iconchange = false;
        // 拿token
        NSURL *tokenurl = [NSURL URLWithString:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/getImageByToken"];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:tokenurl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
        NSData *receivedata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (receivedata != nil) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:receivedata options:kNilOptions error:nil];
            NSString *token = [result objectForKey:@"message"];
            NSLog(@"qiniu token:%@", token);
            if (token != nil) {
                // 上传七牛
                NSData *updata = UIImageJPEGRepresentation(changedIcon, 1);
                [upManager putData:updata key:[dic objectForKey:@"id"] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                    NSLog(@"info = %@\n", info);
                    NSLog(@"key = %@\n",key);
                    NSLog(@"resp = %@\n", resp);
                    
                    // 请求修改接口
                    NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&telephone=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@&photo=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"telephone"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"], key];
                    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSLog(@"update member url: %@", url);
                    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                    
                    NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                    if (received1 == nil) {
                        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:nil message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [fail show];
                        return;
                    }
                    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
                    NSLog(@"update member result: %@", result);
                    UIAlertView *suc = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [suc show];
                    
                } option:nil];
            }
        }

    } else {
        // 请求修改接口
        NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&telephone=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"telephone"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"]];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"update member url: %@", url);
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        
        NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if (received1 == nil) {
            UIAlertView *fail = [[UIAlertView alloc] initWithTitle:nil message:@"修改失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [fail show];
            return;
        }
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
        NSLog(@"update member result: %@", result);
        UIAlertView *suc = [[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [suc show];
    }

}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    UserLoginHelper *helper = [UserLoginHelper shareInstance];
    NSLog(@"viewMember: %@", dic);
    if (dic != nil) {
        NSArray *array = [dic objectForKey:@"rows"];
        if (array != nil && [array count] > 0) {
            @try {
                NSMutableDictionary *newData = [[NSMutableDictionary alloc] initWithDictionary:[array objectAtIndex:0]];
                if (![[newData allKeys] containsObject:@"photo"]) {
                    // 头像
                    [newData setValue:@"" forKey:@"photo"];
                }
                if (![[newData allKeys] containsObject:@"name"]) {
                    // 姓名
                    [newData setValue:@"" forKey:@"name"];
                }
                if (![[newData allKeys] containsObject:@"cards"]) {
                    // 身份证
                    [newData setValue:@"" forKey:@"cards"];
                }
                if (![[newData allKeys] containsObject:@"telephone"]) {
                    // 手机号
                    [newData setValue:@"" forKey:@"telephone"];
                }
                if (![[newData allKeys] containsObject:@"policyno"]) {
                    // 保单号
                    [newData setValue:@"" forKey:@"policyno"];
                }
                if (![[newData allKeys] containsObject:@"sex"]) {
                    // 性别
                    [newData setValue:@"" forKey:@"sex"];
                }
                if (![[newData allKeys] containsObject:@"height"]) {
                    // 身高
                    [newData setValue:@"" forKey:@"height"];
                }
                if (![[newData allKeys] containsObject:@"weight"]) {
                    // 体重
                    [newData setValue:@"" forKey:@"weight"];
                }
                if (![[newData allKeys] containsObject:@"age"]) {
                    // 年龄
                    [newData setValue:@"" forKey:@"age"];
                }
                if (![[newData allKeys] containsObject:@"position"]) {
                    // 位置
                    [newData setValue:@"" forKey:@"position"];
                }
                [helper update:newData];
            } @catch (NSException *e) {
                // 在此创建球员信息
                NSDictionary *data = [helper getUserInfo];
                NSString *viewuser = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/createMember?loginId=%@", [data objectForKey:@"loginId"]];
                NSURL *url = [NSURL URLWithString:viewuser];
                NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
                NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
                NSLog(@"createMember result: %@", result);
                
                NSMutableDictionary *newData = [[NSMutableDictionary alloc] init];
                [newData setValue:@"" forKey:@"name"];
                [newData setValue:@"" forKey:@"cards"];
                [newData setValue:@"" forKey:@"telephone"];
                [newData setValue:@"" forKey:@"policyno"];
                [newData setValue:@"" forKey:@"sex"];
                [newData setValue:@"" forKey:@"height"];
                [newData setValue:@"" forKey:@"weight"];
                [newData setValue:@"" forKey:@"age"];
                [newData setValue:@"" forKey:@"position"];
                [newData setValue:@"" forKey:@"photo"];
            }

            NSDictionary *data = [[NSDictionary alloc] initWithDictionary:[helper getUserInfo]];
            
            
            NSString *iconurl = [NSString stringWithFormat:@"%@%@", QINIU, [data objectForKey:@"photo"]];
            NSData *icondata = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconurl]];
            UIImage *icon;
            if (icondata != nil) {
                icon = [[UIImage alloc] initWithData:icondata];
            } else {
                icon = [UIImage imageNamed:@"teamicon"];
            }
            
            [_imageview setImage:icon];
            
            baseinfoContentArray[0] = [data objectForKey:@"name"];
            baseinfoContentArray[1] = [data objectForKey:@"cards"];
            baseinfoContentArray[2] = [data objectForKey:@"telephone"];
            baseinfoContentArray[3] = [data objectForKey:@"policyno"];
            userinfoContentArray[0] = [data objectForKey:@"sex"];
            userinfoContentArray[1] = [data objectForKey:@"height"];
            userinfoContentArray[2] = [data objectForKey:@"weight"];
            userinfoContentArray[3] = [data objectForKey:@"age"];
            userinfoContentArray[4] = [data objectForKey:@"position"];
            [self.tableview reloadData];
        }
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [baseinfoLabelArray count];
    } else if (section == 1) {
        return [userinfoLabelArray count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"基本信息";
    } else {
        return @"个人信息";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:@"cell"];
    }
    

    if (section == 0) {
        cell.textLabel.text = baseinfoLabelArray[row];
        NSString *str = baseinfoContentArray[row];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", str];
    } else {
        cell.textLabel.text = userinfoLabelArray[row];
        NSString *str = userinfoContentArray[row];
        if (row == 1) {
            // 身高
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@cm", str] ;
        } else if (row == 2) {
            // 体重
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@kg", str];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", str];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currentsection = [indexPath section];
    currentrow = [indexPath row];
    NSString *alerttitle;
    if (currentsection == 0) {
        alerttitle = baseinfoLabelArray[currentrow];
    } else {
        alerttitle = userinfoLabelArray[currentrow];
    }
    if ([alerttitle isEqualToString:@"性别"]) {
        UIAlertController *setCon = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [setCon addAction:[UIAlertAction actionWithTitle:@"男" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            // 刷新视图
            userinfoContentArray[0] = @"男";
            [[self tableview]reloadData];
            // 写入plist
            UserLoginHelper *helper = [UserLoginHelper shareInstance];
            [helper update:userlabelkey[0] second:@"男"];
//            NSDictionary *dic = [helper getUserInfo];
//            // 发请求更新
//            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&number=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"number"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"]];
//            NSLog(@"update member url: %@", url);
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//            NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            if (received1 == nil) {
//                NSLog(@"update fail");
//                return;
//            }
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
//            NSLog(@"update member result: %@", result);
        }]];
        [setCon addAction:[UIAlertAction actionWithTitle:@"女" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            // 刷新视图
            userinfoContentArray[0] = @"女";
            [[self tableview]reloadData];
            // 写入plist
            UserLoginHelper *helper = [UserLoginHelper shareInstance];
            [helper update:userlabelkey[0] second:@"女"];
//            NSDictionary *dic = [helper getUserInfo];
//            // 发请求更新
//            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&number=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"number"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"]];
//            NSLog(@"update member url: %@", url);
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//            NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            if (received1 == nil) {
//                NSLog(@"update fail");
//                return;
//            }
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
//            NSLog(@"update member result: %@", result);
        }]];
        [setCon addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController: setCon animated: YES completion: nil];
    } else if ([alerttitle isEqualToString:@"位置"]) {
        UIAlertController *posiCon = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [posiCon addAction:[UIAlertAction actionWithTitle:@"GK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            // 刷新视图
            userinfoContentArray[4] = @"GK";
            [[self tableview]reloadData];
            // 写入plist
            UserLoginHelper *helper = [UserLoginHelper shareInstance];
            [helper update:userlabelkey[4] second:@"GK"];
//            NSDictionary *dic = [helper getUserInfo];
//            // 发请求更新
//            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&number=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"number"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"]];
//            NSLog(@"update member url: %@", url);
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//            NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            if (received1 == nil) {
//                NSLog(@"update fail");
//                return;
//            }
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
//            NSLog(@"update member result: %@", result);
        }]];
        [posiCon addAction:[UIAlertAction actionWithTitle:@"DC" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            userinfoContentArray[4] = @"DC";
            [[self tableview]reloadData];
            // 写入plist
            UserLoginHelper *helper = [UserLoginHelper shareInstance];
            [helper update:userlabelkey[4] second:@"DC"];
//            NSDictionary *dic = [helper getUserInfo];
//            // 发请求更新
//            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&number=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"number"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"]];
//            NSLog(@"update member url: %@", url);
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//            NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            if (received1 == nil) {
//                NSLog(@"update fail");
//                return;
//            }
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
//            NSLog(@"update member result: %@", result);
        }]];
        [posiCon addAction:[UIAlertAction actionWithTitle:@"CM" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            userinfoContentArray[4] = @"CM";
            [[self tableview]reloadData];
            // 写入plist
            UserLoginHelper *helper = [UserLoginHelper shareInstance];
            [helper update:userlabelkey[4] second:@"CM"];
//            NSDictionary *dic = [helper getUserInfo];
//            // 发请求更新
//            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&number=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"number"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"]];
//            NSLog(@"update member url: %@", url);
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//            NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            if (received1 == nil) {
//                NSLog(@"update fail");
//                return;
//            }
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
//            NSLog(@"update member result: %@", result);
        }]];
        [posiCon addAction:[UIAlertAction actionWithTitle:@"FW" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
            userinfoContentArray[4] = @"FW";
            [[self tableview]reloadData];
            // 写入plist
            UserLoginHelper *helper = [UserLoginHelper shareInstance];
            [helper update:userlabelkey[4] second:@"FW"];
//            NSDictionary *dic = [helper getUserInfo];
//            // 发请求更新
//            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateMember?id=%@&loginId=%@&name=%@&cards=%@&number=%@&policyno=%@&sex=%@&height=%@&weight=%@&age=%@&position=%@", [dic objectForKey:@"id"], [dic objectForKey:@"loginId"], [dic objectForKey:@"name"], [dic objectForKey:@"cards"], [dic objectForKey:@"number"], [dic objectForKey:@"policyno"], [dic objectForKey:@"sex"], [dic objectForKey:@"height"], [dic objectForKey:@"weight"], [dic objectForKey:@"age"], [dic objectForKey:@"position"]];
//            NSLog(@"update member url: %@", url);
//            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//            NSData *received1 = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//            if (received1 == nil) {
//                NSLog(@"update fail");
//                return;
//            }
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:received1 options:kNilOptions error:nil];
//            NSLog(@"update member result: %@", result);
        }]];
        [posiCon addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil]];
        [self presentViewController: posiCon animated: YES completion: nil];
    } else {
        NSString *message = @"";
        if (currentsection == 0) {
            message = baseinfoContentArray[currentrow];
        } else if (currentsection == 1) {
            message = userinfoContentArray[currentrow];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alerttitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert textFieldAtIndex:0].text = message;
        [alert show];
    }

}

-(void) alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {
        return;
    }
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    
    NSString *key;
    if (currentsection == 0) {
        baseinfoContentArray[currentrow] = tf.text;
        key = baselabelkey[currentrow];
    } else {
        userinfoContentArray[currentrow] = tf.text;
        key = userlabelkey[currentrow];
    }
    // 有效性检验
    NSString* val = [self isValidate:key value:tf.text];
    if (val == nil || ![val isEqualToString:@"pass"]) {
        UIAlertView *notvalidate = [[UIAlertView alloc] initWithTitle:@"错误" message:val delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [notvalidate show];
        return;
    }
    [[self tableview]reloadData];
    // 写入本地plist
    NSLog(@"key:%@, value:%@", key, tf.text);
    UserLoginHelper *helper = [UserLoginHelper shareInstance];
    [helper update:key second:tf.text];

}

- (NSString*) isValidate:(NSString*) key value:(NSString*) value {
    if (key == nil || value == nil) {
        return @"参数错误";
    } else if ([key isEqualToString:baselabelkey[1]]) {
        // 身份证
        if (value.length != 15 && value.length != 18) {
            return @"身份证号码应为15或18位";
        }
    } else if ([key isEqualToString:baselabelkey[2]]) {
        // 手机号
        if (value.length != 11 || ![self isPureInt:value]) {
            return @"手机号码应为11位数字";
        }
    } else if ([key isEqualToString:baselabelkey[3]]) {
        // 保单号
        if (![self isPureInt:value]) {
            return @"保单号只应包含数字";
        }
    } else if ([key isEqualToString:userlabelkey[0]]) {
        // 性别
        if (![value isEqualToString:@"男"] && ![value isEqualToString:@"女"]) {
            return @"您确定性别非男非女吗？";
        }
    } else if ([key isEqualToString:userlabelkey[1]]) {
        // 身高
        if (![self isPureInt:value]) {
            return @"身高请输入数字";
        }
        if ([value intValue] > 229 || [value intValue] < 80) {
            return @"您确定比姚明还高或者比郭敬明还矮？";
        }
    } else if ([key isEqualToString:userlabelkey[2]]) {
        if (![self isPureInt:value]) {
            return @"体重请输入数字";
        }
    } else if ([key isEqualToString:userlabelkey[3]]) {
        if (![self isPureInt:value]) {
            return @"年龄请输入数字";
        }
        if ([value intValue] < 10 || [value intValue] > 60) {
            return @"您确定这个年纪能踢球吗？";
        }
    }
    return @"pass";
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end
