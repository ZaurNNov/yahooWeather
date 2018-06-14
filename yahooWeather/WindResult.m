//
//  WindResult.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "WindResult.h"

@implementation WindResult

- (instancetype)initWithChill:(NSString *)chill
                    direction:(NSString *)direction
                        speed:(NSString *)speed {
    
    self = [super init];
    
    if (self) {
        _chill = [chill copy];
        _direction = [direction copy];
        _speed = [speed copy];
    }
    
    return self;
}

@end
