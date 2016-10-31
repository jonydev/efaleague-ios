//
//  EditTeamViewController.m
//  EfaLeague
//
//  Created by baidu on 16/9/20.
//  Copyright © 2016年 soarhe. All rights reserved.
//

#import "EditTeamViewController.h"

@implementation EditTeamViewController

- (void)viewDidLoad {
    upManager = [[QNUploadManager alloc] init];
    imagepicker=[[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.allowsEditing = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(clickOK)];
    self.automaticallyAdjustsScrollViewInsets=NO;
    sectionLabel = [[NSArray alloc] initWithObjects:@"球队名称", @"球队驻地", @"球队介绍", @"球队logo", nil];
    if (_teaminfo != nil) {
        NSString *up = [_teaminfo objectForKey:@"up"];
        if (up == nil) {
            up = @"红色";
        }
        NSString *down = [_teaminfo objectForKey:@"down"];
        if (down == nil) {
            down = @"红色";
        }
        NSString *home = [_teaminfo objectForKey:@"home"];
        if (home == nil) {
            home = @"";
        }
        NSString *intro = [_teaminfo objectForKey:@"intro"];
        if (home == nil) {
            intro = @"";
        }
        rowtext = [[NSMutableArray alloc] initWithObjects:[_teaminfo objectForKey:@"name"], home, intro, [_teaminfo objectForKey:@"photo"],nil];
    } else {
        rowtext = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", @"", nil];
    }
}

- (void) clickOK {
    UserLoginHelper *helper = [UserLoginHelper shareInstance];
    NSString *loginId = [[helper getUserInfo] objectForKey:@"loginId"];
    NSString *name = rowtext[0];
    if (_mStatus == false) {
        // 创建
        if (name != nil && name.length > 0) {
            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/createTeam?companyId=1&leader=%@&name=%@&home=%@&content=%@photo=%@", loginId, name, rowtext[1], rowtext[2], [_teaminfo objectForKey:@"photo"]];
            NSLog(@"createTeam url: %@", url);
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (received != nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
                if (dic != nil) {
                    NSLog(@"createTeam reuslt;%@", dic);
                    NSString *result = [dic objectForKey:@"result"];
                    if (result != nil && [result isEqualToString:@"success"]) {
                        UIAlertView *suc = [[UIAlertView alloc] initWithTitle:nil message:@"创建成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [suc show];
                    } else {
                        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"错误" message:@"创建失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [fail show];
                    }
                } else {
                    UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"错误" message:@"创建失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [fail show];
                }
            } else {
                UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"错误" message:@"创建失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [fail show];
            }
        } else {
            UIAlertView *inval = [[UIAlertView alloc] initWithTitle:@"错误" message:@"球队名不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [inval show];
        }
    } else {
        // 编辑
        if (name != nil && name.length > 0) {
            NSString *url = [NSString stringWithFormat:@"http://120.76.206.174:8080/efaleague-web/appPath/appData/updateTeam?id=%@&name=%@&home=%@&content=%@photo=%@", _teamId, name, rowtext[1], rowtext[2], [_teaminfo objectForKey:@"photo"]];
            NSLog(@"editteam url: %@", url);
            NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (received != nil) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
                if (dic != nil) {
                    NSLog(@"createTeam reuslt;%@", dic);
                    NSString *result = [dic objectForKey:@"result"];
                    if (result != nil && [result isEqualToString:@"success"]) {
                        [_teaminfo setValue:name forKey:@"name"];
                        [_teaminfo setValue:rowtext[1] forKey:@"home"];
                        [_teaminfo setValue:rowtext[2] forKey:@"intro"];
                        UIAlertView *suc = [[UIAlertView alloc] initWithTitle:nil message:@"编辑成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [suc show];
                    } else {
                        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"错误" message:@"编辑失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [fail show];
                    }
                } else {
                    UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"错误" message:@"编辑失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [fail show];
                }
            } else {
                UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"错误" message:@"编辑失败，请稍候重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [fail show];
            }
        } else {
            UIAlertView *inval = [[UIAlertView alloc] initWithTitle:@"错误" message:@"球队名不可为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [inval show];
        }
    }
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionLabel count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sectionLabel[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 3) {
        // 列寬
        CGFloat contentWidth = 300;
        // 用何種字體進行顯示
        UIFont *font = [UIFont systemFontOfSize:20];
        
        // 該行要顯示的內容
        NSString *content = rowtext[indexPath.section];
        // 計算出顯示完內容需要的最小尺寸
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
        
        // 這裏返回需要的高度
        return size.height + 20;
    } else {
        return 50;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    if (indexPath.section == 3) {
        // logo
        if (icon != nil) {
            [cell.imageView setImage:icon];
            icon = nil;
        } else {
//            NSString *iconurl = [_teaminfo objectForKey:@"photo"];
            NSString *iconurl = [NSString stringWithFormat:@"%@%@", QINIU, [rowtext objectAtIndex:indexPath.section]];
            NSLog(@"iconurl: %@", iconurl);
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconurl]];
            if (data == nil) {
                [cell.imageView setImage:[UIImage imageNamed:@"teamicon"]];
            } else {
                [cell.imageView setImage:[UIImage imageWithData:data]];
            }
        }
        
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
        CGSize itemSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    } else {
        UIFont *font = [UIFont systemFontOfSize:20];
        NSString *content = sectionLabel[indexPath.section];
        CGFloat contentWidth = 300;
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
        CGRect rect = [cell.textLabel textRectForBounds:cell.textLabel.frame limitedToNumberOfLines:0];
        // 設置顯示榘形大小
        rect.size = size;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.frame = rect;
        cell.textLabel.text = rowtext[indexPath.section];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = font;
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    currentsection = [indexPath section];
    currentrow = [indexPath row];
    if (indexPath.section <= 2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:sectionLabel[currentsection] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改",nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alert show];
    } else if (indexPath.section == 3) {
        // 拿图
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
    } else {
        // 选择颜色，无接口
    }
}

- ( void )imagePickerController:( UIImagePickerController *)picker didFinishPickingMediaWithInfo:( NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    icon = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_tableview reloadData];
    // 上传
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
            NSData *updata = UIImageJPEGRepresentation(icon, 1);
            [upManager putData:updata key:[_teaminfo objectForKey:@"id"] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info = %@\n", info);
                NSLog(@"key = %@\n",key);
                NSLog(@"resp = %@\n", resp);
                
//                NSString *iconurl = [NSString stringWithFormat:@"%@%@", QINIU, key];
                [_teaminfo setValue:key forKey:@"photo"];
                
            } option:nil];
        }
    }
}

-(void) alertView : (UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        rowtext[currentsection] = [alertView textFieldAtIndex:0].text;
        [[self tableview] reloadData];
    }
}

@end
