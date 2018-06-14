//
//  ConditionResult.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "ConditionResult.h"

@implementation ConditionResult

- (instancetype)initWithCode:(NSString *)code
                        date:(NSString *)date
                        temp:(NSString *)temp
                        text:(NSString *)text {
    
    self = [super init];
    
    if (self) {
        _code = [code copy];
        _date = [date copy];
        _temp = [temp copy];
        _text = [text copy];
    }
    
    return self;
}

@end
