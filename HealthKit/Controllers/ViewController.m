//
//  ViewController.m
//  HealthKit
//
//  Created by aimoke on 16/9/20.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ViewController.h"
#import "ZHHealthManager.h"


@interface ViewController ()
{
    NSArray *dataArray;
}

@end

@implementation ViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"HealthKit";
    self.showTableView.delegate = self;
    self.showTableView.dataSource = self;
    self.showTableView.tableFooterView = [UIView new];
    dataArray = @[@"Open HealthKit",@"Step",@"StepDistance",@"Active EnergyBurn",@"Height",@"Sleep",@"Weight",@"HeartRate",@"User Age"];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#ifdef __IPHONE_7_0
-(UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeNone;
}
#endif

#pragma mark － TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHHealthManager *manager = [ZHHealthManager shareZHHealthManager];
    switch (indexPath.row) {
        case 0:{
            
            [manager requestAuthorizationToShareWithCompletion:^(BOOL success, NSError *error){
                if (success) {
                    NSLog(@"请求访问健康数据成功!");
                }else{
                    NSLog(@"请求健康数据失败Error:%@",[error localizedDescription]);
                }
            }];
            
        }
            break;
        case 1:{//step
            [manager saveStepCount:1000 startTime:[NSDate date] endTime:[NSDate date] withCompletion:^(BOOL success,NSError *error){
                if (success) {
                    NSLog(@"写入计步数据成功!");
                }else{
                    NSLog(@"写入计步数据错误:%@",error.localizedDescription);
                }
            }];
        }
            break;
        case 2:{//step distance
            [manager saveWalkDistance:1000 startTime:[NSDate date] endTime:[NSDate date] withCompletion:^(BOOL success, NSError *error){
                if (success) {
                    NSLog(@"写入步数距离数据成功!");
                }else{
                    NSLog(@"写入步数距离错误:%@",error.localizedDescription);
                }
            }];
        }
            break;
        case 3:{//Active EnergyBurn
            [manager saveActiveEnergyBurnCalories:1000 startTime:[NSDate date] endTime:[NSDate date] withCompletion:^(BOOL success,NSError *error){
                if (success) {
                    NSLog(@"写入活动卡路里数据成功!");
                }else{
                    NSLog(@"写入活动卡路里数据错误:%@",error.localizedDescription);
                }
            }];
        }
            break;
        case 4:{//Height
            [manager saveHeightIntoHealthStore:170 withCompletion:^(BOOL success, NSError *error){
                if (success) {
                    NSLog(@"写入身高数据成功!");
                }else{
                    NSLog(@"写入身高数据错误:%@",error.localizedDescription);
                }
                
            }];
        }
            break;
        case 5:{//Sleep
            NSDate *endTime = [NSDate  dateWithTimeIntervalSinceNow:60*60*2];
            NSDate *startTime = [NSDate date];
            [manager saveSleepWithstartTime:startTime endTime:endTime withCompletion:^(BOOL success, NSError *error){
                if (success) {
                    NSLog(@"添加睡眠数据成功StartTime:%@",startTime);
                }else{
                    NSLog(@"添加睡眠数据失败StartTime:%@",endTime);
                }

            }];

        }
            break;
        case 6:{//Weight
            [manager saveWeightIntoHealthStore:60 withCompletion:^(BOOL success, NSError *error){
                if (success) {
                    NSLog(@"写入体重数据成功!");
                }else{
                    NSLog(@"写入体重数据错误:%@",error.localizedDescription);
                }
                
            }];
        }
            break;
        case 7:{//HeartRate
            [manager saveHeartRate:100 withCompletion:^(BOOL success, NSError *error){
                if (success) {
                    NSLog(@"写入心率数据成功!");
                }else{
                    NSLog(@"写入心率数据错误:%@",error.localizedDescription);
                }
            }];
        }
            break;
        case 8:{
            [manager readUsersAgeWithFinish:^(NSInteger age, NSError *error){
                if (error) {
                    NSLog(@"读取年龄出错Error:%@",[error localizedDescription]);
                }else{
                    NSLog(@"User Age:%ld",age); 
                }
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
