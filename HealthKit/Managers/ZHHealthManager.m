//
//  ZHHealthManager.m
//  TestHealthKit
//
//  Created by aimoke on 16/5/25.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "ZHHealthManager.h"
#import <UIKit/UIKit.h>
#import "HKHealthStore+ZHHKExtensions.h"
#import "NSDate+ZHDate.h"

@implementation ZHHealthManager
+(ZHHealthManager *)shareZHHealthManager
{
    static ZHHealthManager *healthManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        healthManager = [[ZHHealthManager alloc]init];
        
    });
    return healthManager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.healthStore = [[HKHealthStore alloc] init];
    }
    
    return self;
}


#pragma mark - Piblic Methods
-(void)requestAuthorizationToShareWithCompletion:(ZHHealthKitFinishBlock)finish
{
    if ([HKHealthStore isHealthDataAvailable]) {
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error){
            if (finish) {
                finish(success,error);
            }
        }];
    }else{
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"健康应用不可用!", @"健康应用不可用!"),NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Health Kit not available.", @"Health Kit not available."),NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", @"Have you tried turning it off and on again?")};
        NSError *error = [NSError errorWithDomain:NSPOSIXErrorDomain code:-10 userInfo:userInfo];
        if (finish) {
            finish(NO,error);
        }
        
        NSLog(@"Health Kit not available");
    }
}




#pragma mark - Health Kit TypesToWrite
-(NSSet *)dataTypesToWrite
{
    HKQuantityType *stepCountQuantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantityType *walkDistanceQuantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKQuantityType *activeEnergyBurnQuantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *heartQuantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    HKCategoryType *sleepCategoryType = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    
    return [NSSet setWithObjects:stepCountQuantityType, walkDistanceQuantityType, activeEnergyBurnQuantityType,sleepCategoryType,heartQuantityType,heightType,weightType, nil];
}

- (NSSet *)dataTypesToRead {
    HKCharacteristicType *ageTypte = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    return [NSSet setWithObjects:ageTypte, nil];
    return nil;
}


#pragma mark - Reading HealthKit Data
-(void)readUsersAgeWithFinish:(ZHHealthKitIntegerValueBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        return;
    }
    NSError *error;
    NSDate *dateOfBirth = [self.healthStore dateOfBirthWithError:&error];
    NSInteger age = 0;
    if (dateOfBirth) {
        NSDate *now = [NSDate date];
        NSDateComponents *ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:dateOfBirth toDate:now options:NSCalendarWrapComponents];
        NSUInteger usersAge = [ageComponents year];
        age = usersAge;
        error = nil;
    }
    if (finish) {
        finish(age,error);
    }
}


#pragma mark - Writing HealthKit Data
-(void)saveHeightIntoHealthStore:(double)height withCompletion:(ZHHealthKitFinishBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        return;
    }
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    if ([self.healthStore authorizationStatusForType:weightType] != HKAuthorizationStatusSharingAuthorized) {
        NSLog(@"未经用户允许访问直接返回");
        return;
        
    }

    HKUnit *hkUnit = [HKUnit inchUnit];
    height = height/100;
    hkUnit = [HKUnit meterUnit];
    HKQuantity *heightQuantity = [HKQuantity quantityWithUnit:hkUnit doubleValue:height];
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    if ([self.healthStore authorizationStatusForType:heightType]) {
        
    }
    NSDate *now = [NSDate date];
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:heightType quantity:heightQuantity startDate:now endDate:now];
    [self.healthStore saveObject:heightSample withCompletion:^(BOOL success, NSError *error){
            if (finish) {
                finish(success, error);
            }
        }];

}


-(void)saveWeightIntoHealthStore:(double)weight withCompletion:(ZHHealthKitFinishBlock)finish
{
    HKUnit *hkUnit = [HKUnit poundUnit];
    weight = weight*1000;//kg 转化为g
    hkUnit = [HKUnit gramUnit];
    
    HKQuantity *weightQuantity = [HKQuantity quantityWithUnit:hkUnit doubleValue:weight];
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    NSDate *now = [NSDate date];
    HKQuantitySample *heightSample = [HKQuantitySample quantitySampleWithType:weightType quantity:weightQuantity startDate:now endDate:now];
    [self.healthStore saveObject:heightSample withCompletion:^(BOOL success, NSError *error){
        if (finish) {
            finish(success, error);
        }
    }];

}

-(void)saveStepCount:(NSInteger)steps startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        NSLog(@"未经用户允许访问直接返回");
        return;
    }
    NSDate *date = [NSDate date];
    //由于是以一个小时为单位作为保存所以结束时间要大于当前时间
    if ([date getTimeIntervalSince1970Millisecond]<[endDate getTimeIntervalSince1970Millisecond])
    {
        return;
    }
    HKQuantityType *stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    if ([self.healthStore authorizationStatusForType:stepCountType] != HKAuthorizationStatusSharingAuthorized) {
        return;
        
    }
    
    HKUnit *hkUnit = [HKUnit countUnit];
    HKQuantity *stepCountQuantity = [HKQuantity quantityWithUnit:hkUnit doubleValue:steps];
    NSPredicate *predicate = [self getPredicateForSamplesWithStartTime:startDate withEndDate:endDate];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:stepCountType predicate:predicate completion:^(HKQuantity *quantity, NSError *error){
        if (!error) {
            if (quantity) {
                if (finish) {
                    finish(YES,nil);
                }
                NSLog(@"查询到计步数据:startTime:%@",startDate);
            }else{
                NSLog(@"未查询到计步数据添加");
                HKQuantitySample *stepCountSample = [HKQuantitySample quantitySampleWithType:stepCountType quantity:stepCountQuantity startDate:startDate endDate:endDate];
                [self.healthStore saveObject:stepCountSample withCompletion:^(BOOL success, NSError *error){
                    if (finish) {
                        finish(success,error);
                    }
                }];
                
            }
        }else{
            if (finish) {
                finish(NO,nil);
            }
            NSLog(@"查询步数出错:%@",error.localizedDescription);
        }
    }];
}


-(void)saveWalkDistance:(double)walkDistance startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        NSLog(@"未经用户允许访问直接返回");
        return;
    }
    NSDate *date = [NSDate date];
    //由于是以一个小时为单位作为保存所以结束时间要大于当前时间
    if ([date getTimeIntervalSince1970Millisecond]<[endDate getTimeIntervalSince1970Millisecond])
    {
        return;
    }
    HKQuantityType *walkDistanceType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    if ([self.healthStore authorizationStatusForType:walkDistanceType] != HKAuthorizationStatusSharingAuthorized) {
        return;
        
    }
    HKUnit *hkUnit = [HKUnit meterUnit];
    HKQuantity *walkDistanceQuantity = [HKQuantity quantityWithUnit:hkUnit doubleValue:walkDistance];
    
    NSPredicate *predicate = [self getPredicateForSamplesWithStartTime:startDate withEndDate:endDate];
    
    [self.healthStore aapl_mostRecentQuantitySampleOfType:walkDistanceType predicate:predicate completion:^(HKQuantity *quantity, NSError *error){
        if (!error) {
            if (quantity) {
                if (finish) {
                    finish(YES,nil);
                }
                NSLog(@"查询到距离数据:startTime:%@",startDate);
            }else{
                NSLog(@"未查询到距离数据添加");
                HKQuantitySample *walkDistanceSample = [HKQuantitySample quantitySampleWithType:walkDistanceType quantity:walkDistanceQuantity startDate:startDate endDate:startDate];
                [self.healthStore saveObject:walkDistanceSample withCompletion:^(BOOL success, NSError *error){
                    if (finish) {
                        finish(success,error);
                    }
                }];
            }
        }else{
            if (finish) {
                finish(NO,nil);
            }
            NSLog(@"查询距离数据出错:%@",error.localizedDescription);
        }
    }];
}


-(void)saveActiveEnergyBurnCalories:(double)calories startTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        NSLog(@"未经用户允许访问直接返回");
        return;
    }
    NSDate *date = [NSDate date];
    //由于是以一个小时为单位作为保存所以结束时间要大于当前时间
    if ([date getTimeIntervalSince1970Millisecond]<[endDate getTimeIntervalSince1970Millisecond])
    {
        return;
    }
    HKQuantityType *activeCaloriesType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    if ([self.healthStore authorizationStatusForType:activeCaloriesType] != HKAuthorizationStatusSharingAuthorized) {
        return;
        
    }
    
    HKUnit *hkUnit = [HKUnit kilocalorieUnit];
    HKQuantity *activeCaloriesQuantity = [HKQuantity quantityWithUnit:hkUnit doubleValue:calories];
    
    NSPredicate *predicate = [self getPredicateForSamplesWithStartTime:startDate withEndDate:endDate];
    [self.healthStore aapl_mostRecentQuantitySampleOfType:activeCaloriesType predicate:predicate completion:^(HKQuantity *quantity, NSError *error){
        if (!error) {
            if (quantity) {
                if (finish) {
                    finish(YES,nil);
                }
                NSLog(@"查询到卡路里数据:startTime:%@",startDate);
            }else{
                NSLog(@"未查询到卡路里数据添加");
                HKQuantitySample *activeCaloriesSample = [HKQuantitySample quantitySampleWithType:activeCaloriesType quantity:activeCaloriesQuantity startDate:startDate endDate:endDate];
                [self.healthStore saveObject:activeCaloriesSample withCompletion:^(BOOL success, NSError *error){
                    if (finish) {
                        finish(success,error);
                    }
                }];
            }
        }else{
            if (finish) {
                finish(NO,nil);
            }
            NSLog(@"查询卡路里数据出错:%@",error.localizedDescription);
        }
    }];
}


-(void)saveHeartRate:(NSInteger)heartRate withCompletion:(ZHHealthKitFinishBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        return;
    }
    HKQuantityType *heartRateType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    if ([self.healthStore authorizationStatusForType:heartRateType] != HKAuthorizationStatusSharingAuthorized) {
        NSLog(@"未经用户允许访问直接返回");
        return;
        
    }
    HKUnit *hkUnit = [[HKUnit countUnit]unitDividedByUnit:[HKUnit minuteUnit]];
    HKQuantity *heartRateQuantity = [HKQuantity quantityWithUnit:hkUnit doubleValue:heartRate];
    
    NSDate *now = [NSDate date];
    HKQuantitySample *heartRateSample = [HKQuantitySample quantitySampleWithType:heartRateType quantity:heartRateQuantity startDate:now endDate:now];
    [self.healthStore saveObject:heartRateSample withCompletion:^(BOOL success, NSError *error){
        if (finish) {
            finish(success,error);
        }
    }];

}


-(void)saveSleepWithstartTime:(NSDate *)startDate endTime:(NSDate *)endDate withCompletion:(ZHHealthKitFinishBlock)finish
{
    NSInteger systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion <8.0){//系统少于8.0不可用
        return;
    }
    if (![HKHealthStore isHealthDataAvailable])//健康不可用直接返回
    {
        return;
    }
    HKCategoryType *categorySleepAnalysisType = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    if ([self.healthStore authorizationStatusForType:categorySleepAnalysisType] != HKAuthorizationStatusSharingAuthorized) {
         NSLog(@"未经用户允许访问直接返回");
        return;
        
    }
    long long startTimestamp = [startDate getTimeIntervalSince1970Millisecond];
    long long endTimeStamp = [endDate getTimeIntervalSince1970Millisecond];
    NSAssert(endTimeStamp > startTimestamp, @"sleep end time must greater than start time");
    
    NSDate *startTime = startDate;
    NSDate *endTime = endDate;
    
    NSPredicate *predicate = [self getPredicateForSamplesWithStartTime:startTime withEndDate:endTime];

    HKCategorySample *asleepSample = [HKCategorySample categorySampleWithType:categorySleepAnalysisType value:HKCategoryValueSleepAnalysisAsleep startDate:startTime endDate:endTime];
    NSMutableArray *muArray = [NSMutableArray array];
    [muArray addObject:asleepSample];
    [self.healthStore aapl_mostRecentCategorySampleOfType:categorySleepAnalysisType predicate:predicate completion:^(HKCategorySample *cateGorySample, NSError *error){
        if (!error) {
            if (cateGorySample) {
                NSLog(@"查询睡眠数据已经存在StartTime:%@",startTime);
            }else{
                NSLog(@"查询睡眠数据不存在添加StartTime:%@",endTime);
                [self.healthStore saveObjects:muArray withCompletion:^(BOOL success, NSError *error){
                    if (finish) {
                        finish(success,error);
                    }
                }];
                
            }
        }else{
            NSLog(@"查询睡眠数据失败Error:%@",error.localizedDescription);
        }
    }];


}



#pragma mark - Private Methods
-(NSPredicate *)getPredicateForSamplesWithStartTime:(NSDate *)startDate withEndDate:(NSDate *)endDate
{
    NSPredicate *timePredicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
    NSPredicate *sourcePredicate = [HKQuery predicateForObjectsFromSource:[HKSource defaultSource]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[sourcePredicate,timePredicate]];
    return predicate;
    
}


@end
