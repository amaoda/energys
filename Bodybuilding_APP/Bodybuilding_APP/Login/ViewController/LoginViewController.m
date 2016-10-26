//
//  LoginViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/16.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)LoginButtonAction:(id)sender {
    if (_userNameTF.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入用户名" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    if (_passwordTF.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"登录中..";
    
        NSString *username = _userNameTF.text;
        NSString *password = _passwordTF.text;
        if (username.length == 0 || password.length == 0) {
            return;
        }
        //如果登录了那么这里在判断  上一次是否按了退出按钮   yse  表示按了
        if ( [[Utilities getUserDefaults:@"AddUserAndPw"] boolValue]) {
            
            //表示用户 登录后  按了退出  这边依旧设置未登录  因为这里是默认从appdelage 进入  所以  全局变量inOrup  这边默认是NO （也就是未登录）
            //然后让  SignUpSuccessfully这个键为YES   那么在进入登录界面时  会运行  viewWillA 里面的放法
            [[StorageMgr singletonStorageMgr]removeObjectForKey:@"SignUpSuccessfully"];
            [[StorageMgr singletonStorageMgr]addKey:@"SignUpSuccessfully" andValue:@YES];
            //最后把  之前退出时  缓存了一个Username 的值给  全局变量 的Username    这样退出之后就会有用户名显示
            [[StorageMgr singletonStorageMgr]addKey:@"Username" andValue:[Utilities getUserDefaults:@"Username"]];
            return;
        }
        //这里是当判断到用户有登陆过  并且没有退出过   开启APP时   默认请求登录
        NSString *exponent = [[StorageMgr singletonStorageMgr] objectForKey:@"exponent"];
        NSString *modulus = [[StorageMgr singletonStorageMgr] objectForKey:@"modulus"];
        //MD5将原始密码进行MD5加密
        NSString *MD5Pwd = [password getMD5_32BitString];
        //将MD5加密过后的密码进行RSA非对称加密
        NSString *RSAPwd = [NSString encryptWithPublicKeyFromModulusAndExponent:MD5Pwd.UTF8String modulus:modulus exponent:exponent];
        
        NSDictionary *dic = @{@"userName":username,
                              @"password":RSAPwd,
                              @"deviceType":@7001,
                              @"deviceId":[Utilities uniqueVendor]};
        
        [RequestAPI postURL:@"/login" withParameters:dic success:^(id responseObject) {
            //NSLog(@"obj =======  %@",responseObject);
            if ([responseObject[@"resultFlag"] integerValue] == 8001) {
                NSLog(@"自动登录成功");
                NSDictionary *result = responseObject[@"result"];
                
                //这里将 全局变量键inOrUp  设置成yes  就可以运行leftVC  里的viewWillA  里的方法
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"inOrUp"];
                [[StorageMgr singletonStorageMgr]addKey:@"inOrUp" andValue:@YES];
                
                //紧接着这边给缓存  键Username  给值（result[@"contactTel"]）
                [Utilities removeUserDefaults:@"Username"];
                [Utilities setUserDefaults:@"Username" content:result[@"contactTel"]];
                
                NSString *strUser = [Utilities getUserDefaults:@"switchUser"];
                NSLog(@"strUser = %@",strUser);
                if ([strUser isEqualToString:@"openUser"]) {
                    [Utilities removeUserDefaults:@"switch"];
                    [Utilities setUserDefaults:@"switch" content:@"open"];
                }
                
                //这里获取到  ID  并存进全局变量
                NSString *memberId = result[@"memberId"];
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"memberId"];
                [[StorageMgr singletonStorageMgr]addKey:@"memberId" andValue:memberId];
                
                NSDictionary *dict = @{@"memberId":result[@"memberId"],
                                       @"memberSex":result[@"memberSex"],
                                       @"memberName":result[@"memberName"],
                                       @"birthday":result[@"birthday"],
                                       @"identificationcard":result[@"identificationcard"]
                                       };
                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"dict"];
                [[StorageMgr singletonStorageMgr]addKey:@"dict" andValue:dict];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setBool:YES forKey:@"isLogin"];
                [userDefaults setObject:_userNameTF.text forKey:@"userName"];
                [hud hide:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        } failure:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
}
- (IBAction)passageUserButtonAction:(id)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:NO forKey:@"isLogin"];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
