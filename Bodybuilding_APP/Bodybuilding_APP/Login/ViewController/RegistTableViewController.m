//
//  RegistTableViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/25.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "RegistTableViewController.h"

@interface RegistTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UITextField *pass2tf;

@end

@implementation RegistTableViewController


- (IBAction)backButon:(id)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)prompt:(id)sender {
    
    if (_phoneTF.text.length == 0) {
        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"请正确填写手机号" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:al animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [al dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    
    if (_code.text.length == 0) {
        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"请正确填写验证码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:al animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [al dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    
    if (_passTF.text.length == 0) {
        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"请正确填写密码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:al animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [al dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    
    if (![_pass2tf.text isEqualToString:_passTF.text]) {
        UIAlertController *al = [UIAlertController alertControllerWithTitle:@"请请输入相同的密码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [self presentViewController:al animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [al dismissViewControllerAnimated:YES completion:nil];
        });
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"注册中..";
    NSString *exponent = [[StorageMgr singletonStorageMgr] objectForKey:@"exponent"];
    NSString *modulus = [[StorageMgr singletonStorageMgr] objectForKey:@"modulus"];
    //MD5将原始密码进行MD5加密
    NSString *MD5Pwd = [_passTF.text getMD5_32BitString];
    //将MD5加密过后的密码进行RSA非对称加密
    NSString *RSAPwd = [NSString encryptWithPublicKeyFromModulusAndExponent:MD5Pwd.UTF8String modulus:modulus exponent:exponent];
    
    
    NSDictionary *dic = @{@"userTel":_phoneTF.text,
                          @"userPsw":RSAPwd,
                          @"nickName":_phoneTF.text,
                          @"city":@0511,
                          @"nums":_code.text,
                          @"deviceId":[Utilities uniqueVendor]};
    
    [RequestAPI postURL:@"/register" withParameters:dic success:^(id responseObject) {
        if ([responseObject[@"resultFlag"] integerValue] == 0) {
            
            [[StorageMgr singletonStorageMgr]addKey:@"Username" andValue:_phoneTF.text];
            [[StorageMgr singletonStorageMgr]addKey:@"Password" andValue:_passTF.text];
            //现将同名 键 在单例化全局变量中删除   以保证该键的唯一性
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"SignUpSuccessfully"];
            //在初始化一个同名 键 为yes  表示注册成功
            [[StorageMgr singletonStorageMgr]addKey:@"SignUpSuccessfully" andValue:@YES];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [Utilities errorShow:responseObject[@"resultFlag"] onView:self];
        }
        [hud hide:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error) {
        NSLog(@"error = %@",[error userInfo]);
        [hud hide:YES];
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.text = @"请60后重试...";
        cell.userInteractionEnabled = NO;
        
        NSDictionary *dic = @{@"userTel":_phoneTF.text,
                              @"type":@1};
        [Request_AFNetWorking requestWithUrlString:@"/register/verificationCode" parDic:dic method:GET finish:^(NSDictionary *dataDic) {
        
        } error:^(NSError *requestError) {
            
        }];
        
        
    }
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
