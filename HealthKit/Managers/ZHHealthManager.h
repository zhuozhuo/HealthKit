//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
//
//  Created by aimoke on 16/5/25.
//  Copyright © 2016年 zhuo. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

typedef void (^ZHHealthKitFinishBlock) (BOOL success,NSError *error);
typedef void (^ZHHealthKitIntegerValueBlock)(NSInteger value, NSError *error);

@interface ZHHealthManager : NSObject
@property (nonatomic) HKHealthStore * healthStore;

+(ZHHealthManager *)shareZHHealthManager;


/**
 *  request Authorization To Share Data in HealthKit
 *
 *  @param finish block
 */
-(void)requestAuthorizationToShareWithCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  Read User Age
 *
 *  @param finish finish block.
 */
-(void)readUsersAgeWithFinish:(ZHHealthKitIntegerValueBlock)finish;


/**
 *  write height data into HealthKit
 *
 *  @param height height `cm`
 *  @param unit   unit Option
 *  @param finish block
 */
-(void)saveHeightIntoHealthStore:(double)height withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  write weight data into HealthKit
 *
 *  @param weight weight `kg`
 *  @param unit   unit option
 *  @param finish finishBlock
 */
-(void)saveWeightIntoHealthStore:(double)weight withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save stepcount into HealthKit
 *
 *  @param steps     steps
 *  @param startDate startDate
 *  @param endDate   endDate
 *  @param finish    Block
 */
-(void)saveStepCount:(NSInteger)steps startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save walk distance into healthKit
 *
 *  @param walkDistance walk distance
 *  @param startDate    startDate
 *  @param endDate      endDate
 *  @param finish       block
 */
-(void)saveWalkDistance:(double)walkDistance startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save active Energy burn calories into healthKit
 *
 *  @param calories  calories
 *  @param startDate startDate
 *  @param endDate   endDate
 *  @param finish    block
 */
-(void)saveActiveEnergyBurnCalories:(double)calories startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save heartRate into HealthKit
 *
 *  @param heartRate heartRate
 *  @param finish    block
 */
-(void)saveHeartRate:(NSInteger)heartRate withCompletion:(ZHHealthKitFinishBlock)finish;


/**
 *  save sleep data into HealthKit
 *
 *  @param startDate start time
 *  @param endDate   end time
 *  @param finish    finish block
 */
-(void)saveSleepWithstartTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish;
@end
