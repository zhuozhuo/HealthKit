//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
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
