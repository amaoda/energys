//
//  RootPageTableViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/13.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "RootPageTableViewController.h"
#import "LoginViewController.h"
#import "RootPageTableViewCell.h"
#import "RootPageModel.h"
#import "RootSecondTableViewController.h"

@interface RootPageTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RootPageTableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.navigationItem.title = @"健身APP";
    
    if (!_isSecond) {
        if (1) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self presentViewController:loginVC animated:YES completion:nil];
        }
    }else{
        self.tableView.tableHeaderView = nil;
    }
    
    

    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (animated && _isSecond != YES) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]) {
            self.tabBarController.navigationItem.prompt = @"登录成功";
            NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:userName style:(UIBarButtonItemStyleDone) target:self action:@selector(barButtonAction:)];
            self.tabBarController.navigationItem.leftBarButtonItem = barButton;
        }else{
            self.tabBarController.navigationItem.prompt = @"您还未登录";
            UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:@"点击登录" style:(UIBarButtonItemStyleDone) target:self action:@selector(barButtonAction:)];
            self.tabBarController.navigationItem.leftBarButtonItem = barButton;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tabBarController.navigationItem.prompt = nil;
        });
    }
    
}

- (void)barButtonAction:(UIBarButtonItem *)barButton
{

    if ([barButton.title isEqualToString:@"点击登录"]) {
        LoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您是要退出吗?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            barButton.title = @"点击登录";
        }];
        [alertController addAction:yesAction];
        [alertController addAction:cancelAction];
        [self.tabBarController presentViewController:alertController animated:YES completion:nil];
    }
    
    
}

- (void)requestData
{
    [Request_AFNetWorking requestWithUrlString:@"/city/hotAndUpgradedList" parDic:nil method:GET finish:^(NSDictionary *dataDic) {
        NSLog(@"%@",dataDic);
    } error:^(NSError *requestError) {
        NSLog(@"%@",requestError);
    }];
    
    [self requestHotCity];
}

- (void)requestHotCity
{
    NSString *string = @"/homepage/choice?city=0510&page=1&perPage=20&jing=31.568&wei=120.299";
    [Request_AFNetWorking requestWithUrlString:string parDic:nil method:GET finish:^(NSDictionary *dataDic) {
        for (NSDictionary *dic in dataDic[@"result"][@"models"]) {
            RootPageModel *model = [[RootPageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    } error:^(NSError *requestError) {
        NSLog(@"%@",requestError);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
    //
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RootPageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RootPageTableViewCell" forIndexPath:indexPath];
    RootPageModel *model = self.dataArray[indexPath.section];
    cell.model = model;
    
    return cell;
}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    RootSecondTableViewController *rootSecondVC = segue.destinationViewController;
    RootPageTableViewCell *cell = (RootPageTableViewCell *)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    RootPageModel *model = self.dataArray[indexPath.section];
    
    rootSecondVC.ID = model.myid;
}


@end
