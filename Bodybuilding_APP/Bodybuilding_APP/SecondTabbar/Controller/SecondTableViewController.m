//
//  SecondTableViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/16.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "SecondTableViewController.h"
#import "SecondTableViewCell.h"
#import "Modelsecond.h"
#import "RootPageTableViewController.h"

@interface SecondTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SecondTableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self requestData];
    self.tableView.rowHeight = 100;
}

- (void)requestData
{
    NSString *url = @"/homepage/category";
    [Request_AFNetWorking requestWithUrlString:url parDic:nil method:GET finish:^(NSDictionary *dataDic) {
        NSLog(@"%@",dataDic);
        for (NSDictionary *dic in dataDic[@"result"][@"models"]) {
            Modelsecond *model = [[Modelsecond alloc] init];
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 10;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"34234242" forIndexPath:indexPath];
    Modelsecond *model = self.dataArray[indexPath.row];
    cell.label.text = model.name;
    [cell.img sd_setImageWithURL:[NSURL URLWithString:model.backImgUrl]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RootPageTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RootPageTableViewController"];
    vc.isSecond = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
