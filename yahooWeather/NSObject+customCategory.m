//
//  NSObject+customCategory.m
//  SqliteNotes
//
//  Created by Zaur Giyasov on 01/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "NSObject+customCategory.h"

@implementation NSObject (customCategory)

// [self.detailsForCity objectForKey:@"date"]
// date = "2018-06-18T06:42:45Z";
// "yyyy-MM-DDTHH:MM:SSZ" - parse date
// @"yyyy MMM dd hh:mm" - show in app

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateStrFormat = @"dd MMM yyyy HH:mm";
    [dateFormatter setDateFormat:dateStrFormat];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+0200]];
    return dateFormatter;
}

-(NSString *)setCustomStringFromDate:(NSDate *)date {
    //Example:
    //double timeCreated = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notecreated"]] doubleValue];
    
    NSDateFormatter * dateFormatter = [self dateFormatter];
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    return currentDateString;
}

-(NSDate *)setCustomDateFromString:(NSString *)dateText {
    //dateText = NSString *ss = @"2012-09-16 23:59:59";
    
    NSDateFormatter * dateFormatter = [self dateFormatter];
    NSDate *capturedDate = [dateFormatter dateFromString: dateText];
    return capturedDate;
}

-(double)setCustomDoubleFromDate:(NSDate *)date {
    return [date timeIntervalSinceDate:date];
}

-(double)celsiosFromFahrenheit:(int)fahrenheit {
    // fahrenheit = int
    // celsius = 5.0/9 * (fahrenheit - 32)
    
    double celsius = (5.0 / 9 * (fahrenheit - 32));
    NSLog(@"Fahrenheit: %d => Celsius: %f", fahrenheit, celsius);
    return celsius;
}

//-(NSDate *)dateFromTime:(double)time {
//    NSDate *dateCreated = [NSDate dateWithTimeIntervalSinceReferenceDate:time];
//    return dateCreated;
//}

//-(NSString *)textFromDate:(NSDate *)date {
//    double dt = [self dateDoubleFromDate:date];
//    return [self dateFofmattedFromDouble:dt];
//}

//-(NSString *)dateFofmattedFromDouble:(double)time {
//    //Example:
//    //double timeCreated = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"notecreated"]] doubleValue];
//
//    NSString *dateStrFormat = @"YYYY-MM-dd HH:MM:ss";
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    dateFormat.dateFormat = dateStrFormat;
//    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
//    NSString *currentDateString = [dateFormat stringFromDate:[self dateFromTime:time]];
//    //NSLog(@"Time NSDateFormatter: %@", [dateFormat stringFromDate:[self dateFromTime:time]]);
//    return currentDateString;
//}

@end
