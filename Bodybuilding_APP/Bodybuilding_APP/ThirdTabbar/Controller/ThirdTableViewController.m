//
//  ThirdTableViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/16.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "ThirdTableViewController.h"
#import "thirdTableViewCell.h"
#import "modelddd.h"

@interface ThirdTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ThirdTableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

- (void)requestData
{
    NSString *url = @"/goods/list?type=2&page=0&perPage=50";
    [Request_AFNetWorking requestWithUrlString:url parDic:nil method:GET finish:^(NSDictionary *dataDic) {
        NSLog(@"%@",dataDic);
        for (NSDictionary *dic in dataDic[@"result"][@"models"]) {
            modelddd *model = [[modelddd alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    } error:^(NSError *requestError) {
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    thirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdTableViewCell" forIndexPath:indexPath];
    modelddd *model = self.dataArray[indexPath.section];
    cell.titleLabel.text = model.goodsName;
    cell.label1.text = [NSString stringWithFormat:@"商品数量:%@  所需积分:%@",model.goodsAmount,model.goodsScore];
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.goodsImg]];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
