//
//  CitiPlaces.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "CitiPlaces.h"
#import "Cityes.h"


@implementation CitiPlaces

- (instancetype)initWithPlaces:(NSDictionary *)place
{
    self = [super init];
    
    if (self) {
        _place = [place copy];
    }
    
    return self;
}

@end

//
/*
results = {
    place = ({
              name = Moscow;
              woeid = 2122265;
            },
 
            {
              name = Moscow;
              woeid = 2454489;
            }
    );
};
 */
//
