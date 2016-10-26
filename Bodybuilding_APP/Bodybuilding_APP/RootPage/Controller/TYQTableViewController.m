//
//  TYQTableViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/24.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "TYQTableViewController.h"

@interface TYQTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@end

@implementation TYQTableViewController

- (IBAction)barButtonAction:(id)sender {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",_dataDic[@"eId"]]]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@",_dataDic[@"eId"]]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"购买成功" message:@"恭喜您👏" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *style = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:style];
        [self presentViewController:alert animated:YES completion:nil];

    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请勿重复购买" message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *style = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:style];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"eLogo"]]];
    _label.text = _dataDic[@"eName"];
    _label2.text = _dataDic[@"clubName"];
    _label3.text = [NSString stringWithFormat:@"原价:%@",_dataDic[@"orginPrice"]];
    _label4.text = [NSString stringWithFormat:@"现价:%@",_dataDic[@"price"]];
    _label5.text = @"销售数量: 0  有效期: 2015-06-20 - 2016-06-20 可用时段:8:30-23:00";
    _label6.text = @"本体验券所有解释权归本店家所有";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
