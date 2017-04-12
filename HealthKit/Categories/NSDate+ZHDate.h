//
//  GitHub:https://github.com/zhuozhuo

//  博客：http://www.jianshu.com/users/39fb9b0b93d3/latest_articles

//  欢迎投稿分享：http://www.jianshu.com/collection/4cd59f940b02
//
//  Created by aimoke on 16/9/20.
//  Copyright © 2016年 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZHDate)

//根据时间戳获取时间
/**
 *  获取date 根据时间戳 毫秒
 *
 *  @param timestamp 毫秒时间戳
 *
 *  @return 日期
 */
+(NSDate *)getDateWithInterval:(long long)timestamp;


/**
 *  获取自1970年的时间戳毫秒
 *
 *  @return 毫秒时间戳
 */
-(long long)getTimeIntervalSince1970Millisecond;


/**
 *  获取秒时间戳
 *
 *  @param millisecond 根据毫秒时间戳获取秒时间戳
 *
 *  @return 返回秒时间戳
 */
-(long long)getSecondFromMillisecond:(long long)millisecond;


@end
