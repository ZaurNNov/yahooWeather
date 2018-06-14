//
//  ConditionResult.h
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConditionResult : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *temp;
@property (nonatomic, copy) NSString *text;


- (instancetype)initWithCode:(NSString *)code
                        date:(NSString *)date
                        temp:(NSString *)temp
                        text:(NSString *)text;

@end

/*
 
 condition: {
 code: "26",
 date: "Thu, 14 Jun 2018 02:00 PM MSK",
 temp: "61",
 text: "Cloudy"
 },
 
 */

