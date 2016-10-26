//
//  RootSecondTableViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/24.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "RootSecondTableViewController.h"
#import "TYQTableViewController.h"

@interface RootSecondTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iamge1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UIImageView *image4;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@end

@implementation RootSecondTableViewController

{
    NSDictionary *_dic;
}

- (void)setValueWithDic:(NSDictionary *)dic
{
    [_iamge1 sd_setImageWithURL:[NSURL URLWithString:dic[@"clubLogo"]]];
    _titleLabel.text = dic[@"clubName"];
    _addressLabel.text = dic[@"clubAddressB"];
    _timeLabel.text = dic[@"clubTime"];
    [_image2 sd_setImageWithURL:[NSURL URLWithString:dic[@"clubPic"][0][@"imgUrl"]]];
    [_image3 sd_setImageWithURL:[NSURL URLWithString:dic[@"clubPic"][1][@"imgUrl"]]];
    [_image4 sd_setImageWithURL:[NSURL URLWithString:dic[@"clubPic"][2][@"imgUrl"]]];
    
    _label1.text = [NSString stringWithFormat:@"开业时间: %@",dic[@"openTime"]];
    _label2.text = [NSString stringWithFormat:@"拥有分店数量: %@",dic[@"storeNums"]];
    _label3.text = [NSString stringWithFormat:@"教练数量: %@",dic[@"clubPerson"]];

    _introLabel.text = dic[@"clubIntroduce"];
    
//    CGRect frame = _introLabel.frame;
//    frame.size.height = [self customHeight:dic[@"clubIntroduce"] FontOfSize:15 width:self.view.frame.size.width - 30];
//    _introLabel.frame = frame;
}

// 自适应高度

- (CGFloat)customHeight:(NSString *)content FontOfSize:(CGFloat)size width:(CGFloat)width

{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:size],NSFontAttributeName, nil];
    
    CGRect textRect = [content boundingRectWithSize: CGSizeMake(width, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
    
    return textRect.size.height;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

}

- (void)requestData
{
    NSString *url = [NSString stringWithFormat:@"/clubController/getClubDetails?clubKeyId=%@",_ID];
    [Request_AFNetWorking requestWithUrlString:url parDic:nil method:GET finish:^(NSDictionary *dataDic) {
        [self setValueWithDic:dataDic[@"result"]];
        _dic = dataDic[@"result"][@"experienceInfos"][0];
//        NSLog(@"%@",_dic);
    } error:^(NSError *requestError) {
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
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


#pragma mark - Navigation

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (_dic) {
        return YES;
    }
    return NO;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    TYQTableViewController *VC = segue.destinationViewController;
    VC.dataDic = _dic;

}


@end
