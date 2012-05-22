//
//  C4DateTime.h
//  clockLabel
//
//  Created by Travis Kirton on 12-05-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"

@interface C4DateTime : C4Object

#pragma mark Date & Time
+(NSInteger)day;
+(NSString *)dayString;
+(NSString *)daySuffix;
+(NSInteger)hour;
+(NSString *)hourString;
+(NSInteger)minute;
+(NSString *)minuteString;
+(NSInteger)week;
+(NSString *)weekString;
+(NSInteger)month;
+(NSInteger)millis;
+(NSString *)monthString;
+(NSInteger)second;
+(NSString *)secondString;
+(NSInteger)year;
+(NSInteger)weekday;
+(NSString *)weekdayString;
+(NSString *)dayName;
+(NSString *)monthName;

-(NSString *)dayName;
-(NSString *)monthName;

-(NSInteger)day;
-(NSString *)dayString;
-(NSString *)daySuffix;
-(NSInteger)hour;
-(NSString *)hourString;
-(NSInteger)minute;
-(NSString *)minuteString;
-(NSInteger)week;
-(NSString *)weekString;
-(NSInteger)month;
-(NSString *)monthString;
-(NSInteger)millis;

-(NSInteger)second;
-(NSString *)secondString;
-(NSInteger)year;

-(NSInteger)weekday;
-(NSString *)weekdayString;

@end
