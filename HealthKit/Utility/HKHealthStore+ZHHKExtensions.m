//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
//
//  Created by aimoke on 16/5/31.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "HKHealthStore+ZHHKExtensions.h"

@implementation HKHealthStore (ZHHKExtensions)
-(void)aapl_mostRecentQuantitySampleOfType:(HKQuantityType *)quantityType predicate:(NSPredicate *)predicate completion:(void (^)(HKQuantity *quantity, NSError *error))completion
{
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc]initWithSampleType:quantityType predicate:predicate limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error){
        if (!results) {
            if (completion) {
                completion(nil,error);
            }
            return ;
        }
        if (completion) {
            HKQuantitySample *quantitySample = results.firstObject;
            HKQuantity *quantity = quantitySample.quantity;
            completion(quantity,error);
        }
    }];
    [self executeQuery:query];
}

-(void)aapl_mostRecentCategorySampleOfType:(HKCategoryType *)categoryType predicate:(NSPredicate *)predicate completion:(void (^)(HKCategorySample *, NSError *))completion
{
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    
    HKSampleQuery *query = [[HKSampleQuery alloc]initWithSampleType:categoryType predicate:predicate limit:1 sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error){
        if (!results) {
            if (completion) {
                completion(nil,error);
            }
            return ;
        }
        if (completion) {
            HKCategorySample *quantitySample = results.firstObject;
            completion(quantitySample,error);
        }
    }];
    [self executeQuery:query];

}
@end
