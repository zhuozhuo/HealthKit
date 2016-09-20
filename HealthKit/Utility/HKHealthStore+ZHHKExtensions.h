//
//  HKHealthStore+ZHHKExtensions.h
//  ImcoWatch
//
//  Created by aimoke on 16/5/31.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <HealthKit/HealthKit.h>

@interface HKHealthStore (ZHHKExtensions)

// Fetches the single most recent quantity of the specified type.

- (void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(HKQuantity *mostRecentQuantity, NSError *error))completion;


- (void)aapl_mostRecentCategorySampleOfType:(HKCategoryType *)categoryType predicate:(NSPredicate *)predicate completion:(void (^)(HKCategorySample *mostRecentQuantity, NSError *error))completion;

@end
