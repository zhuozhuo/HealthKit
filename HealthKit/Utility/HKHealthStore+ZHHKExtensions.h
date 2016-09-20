//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
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
