//
//  Cities.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "Cities.h"

@implementation Cities

- (instancetype)initWithName:(NSString *)name
                       woeid:(NSString *)woeid
{
    self = [super init];
    
    if (self) {
        _name = [name copy];
        _woeid = [woeid copy];
    }
    
    return self;
}

@end

///
/*
 {
 "query":{
 "count":2,
 "created":"2018-06-14T07:56:21Z",
 "lang":"en-US",
 "results":{
 "place":[
 {
 "name":"Moscow",
 "woeid":"2122265"
 },
 {
 "name":"Moscow",
 "woeid":"2454489"
 }
 ]
 }
 }
 }
 */
