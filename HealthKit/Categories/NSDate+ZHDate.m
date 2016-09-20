//
//  NSDate+ZHDate.m
//  HealthKit
//
//  Created by aimoke on 16/9/20.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import "NSDate+ZHDate.h"

@implementation NSDate (ZHDate)

+(NSDate *)getDateWithInterval:(long long)timestamp
{
    return [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    
}


-(long long)getTimeIntervalSince1970Millisecond
{
    long long timeInterval = (long long)[self timeIntervalSince1970];
    return timeInterval*1000;
}


-(long long)getSecondFromMillisecond:(long long)millisecond
{
    return millisecond/1000;
}

@end
