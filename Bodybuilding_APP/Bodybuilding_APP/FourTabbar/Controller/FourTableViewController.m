//
//  FourTableViewController.m
//  Bodybuilding_APP
//
//  Created by shao_Mac on 16/10/16.
//  Copyright © 2016年 23444. All rights reserved.
//

#import "FourTableViewController.h"
#import <HealthKit/HealthKit.h>

#if TARGET_IPHONE_SIMULATOR//模拟器

#define jiqing @"moniqi"

#elif TARGET_OS_IPHONE//真机

#define jiqing @"zhenji"

#endif

@interface FourTableViewController ()

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) NSMutableArray *timeArray;
@property (strong,nonatomic) HKHealthStore *healthStore;
@property (weak, nonatomic) IBOutlet UILabel *bushuLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation FourTableViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)timeArray
{
    if (!_timeArray) {
        _timeArray = [NSMutableArray array];
    }
    return _timeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.sectionFooterHeight = 50;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getpermission];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(void)getpermission{
    //查看healthKit在设备上是否可用，ipad不支持HealthKit
    /*
     调用 isHealthDataAvailable 方法来查看HealthKit在该设备上是否可用。HealthKit在iPad上不可用。
     */
    if(![HKHealthStore isHealthDataAvailable] || [jiqing isEqualToString:@"moniqi"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请用真机打开" message:@"模拟器不支持计步器" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *style = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:style];
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }
    
    //创建healthStore实例对象
    self.healthStore = [[HKHealthStore alloc] init];
    
    //设置需要获取的权限这里仅设置了步数
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:stepCount, nil];
    
    //从健康应用中获取权限
    
    _hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    _hud.backgroundColor = [UIColor whiteColor];
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.labelText = @"数据统计中";
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            NSLog(@"获取步数权限成功");
            //获取步数后我们调用获取步数的方法
            
            self.navigationItem.title = @"详细步数";
            [self readStepCount];
            
        }
        else
        {
            NSLog(@"获取步数权限失败");
            [_hud hide:YES];
        }
    }];
    
}

//查询数据
- (void)readStepCount
{
    
    [self saveStepCount];
    //查询样本信息
    HKSampleType *sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];

    HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:nil limit:1 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (!error) {
            if (results.count > 0) {
                
                
                //把结果装换成字符串类型
                HKQuantitySample *result = results[0];
                HKQuantity *quantity = result.quantity;
                
                double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                
                NSLog(@"%f",value);
                
                _bushuLabel.text = [NSString stringWithFormat:@"%.0f步",value];
                if (value > 5000) {
                    _contentLabel.text = @"超过五千步,你好棒呀";
                }else if (value < 5000){
                    _contentLabel.text = [NSString stringWithFormat:@"您才走了%.0f步,今天不达标哦",value];
                }else{
                    _contentLabel.text = @"我很自豪,我今天超过1万步啦...";
                }
                
                
            }
        }
    }];

        dispatch_async(dispatch_get_main_queue(), ^{
            [_hud hide:YES];
        });
    
    //执行查询
    [self.healthStore executeQuery:sampleQuery];
}

-(void)saveStepCount{
    [self.dataArray removeAllObjects];
    [self.timeArray removeAllObjects];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *interval = [[NSDateComponents alloc]init];
    interval.day = 7;
    //设置一个计算的时间点
    
    NSDateComponents *anchorComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth |NSCalendarUnitYear | NSCalendarUnitWeekday  fromDate:[NSDate date]];
    NSInteger offset =  (7 + anchorComponents.day)%7 ;
    anchorComponents.day -= offset;
    
    //设置从几点开始计时
    anchorComponents.hour = 23;
    interval.day = 1;
    NSDate *anchorDate = [calendar dateFromComponents:anchorComponents];
    
    HKQuantityType *qiantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    //创建查询   intervalcomponents:按照多少时间间隔查询
    HKStatisticsCollectionQuery *query = [[HKStatisticsCollectionQuery alloc]initWithQuantityType:qiantityType quantitySamplePredicate:nil options:HKStatisticsOptionCumulativeSum anchorDate:anchorDate intervalComponents:interval];
    
    
    //查询结果
    query.initialResultsHandler = ^(HKStatisticsCollectionQuery *query,HKStatisticsCollection *results,NSError *error){
        if (error) {
            NSLog(@"error = %@",error.description);
        }else{
            
            NSDate *endDate = [NSDate date];
            
            /*value 这个参数很重要  －7：表示从今天开始逐步查询后面7天的步数
             NSCalendarUnitDay  表示按照什么类型输出
             */
            NSDate *startDate = [calendar dateByAddingUnit:NSCalendarUnitWeekday value:-7 toDate:endDate options:0];
            
            [results enumerateStatisticsFromDate:startDate toDate:endDate withBlock:^(HKStatistics * _Nonnull result, BOOL * _Nonnull stop) {
                HKQuantity *quantity = result.sumQuantity;
                
                if (quantity) {
                    NSDate *date = result.endDate;
                    
                    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                    [outputFormatter setLocale:[NSLocale currentLocale]];
                    [outputFormatter setDateFormat:@"MM月dd日 HH:mm"];
                    NSString *str = [outputFormatter stringFromDate:date];
                    [self.timeArray addObject:[NSString stringWithFormat:@"时间: %@",str]];
                    double value = [quantity doubleValueForUnit:[HKUnit countUnit]];
                    NSString *string  = [NSString stringWithFormat:@"当日布数：%d",(int)value];
                    [self.dataArray addObject:string];
                    [self.tableView reloadData];
                }
            }];
        }
    };
    
    [_healthStore executeQuery:query];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"13222" forIndexPath:indexPath];
    
    cell.textLabel.text = self.timeArray[indexPath.row];
    cell.detailTextLabel.text = self.dataArray[indexPath.row];
    
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
