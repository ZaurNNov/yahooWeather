//
//  DataParser.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "DataParser.h"
#import "Cities.h"

@implementation DataParser

+ (NSArray *)parseCitiFromData:(NSData *)data
{
    id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    
    NSMutableArray <Cities *> *cities = [[NSMutableArray alloc] init];
    
    NSDictionary *resultsDict = [jsonResult[@"query"] objectForKey:@"results"]; // All results
    
    NSInteger fetchCount = [[jsonResult[@"query"] objectForKey:@"count"] integerValue];
    
    if (fetchCount != 0) {
        NSDictionary *placesDict = resultsDict[@"place"]; // All plases
        
        if (fetchCount == 1) {
            
            Cities *city = [[Cities alloc] initWithName:[placesDict objectForKey:@"name"]
                                                  woeid:[placesDict objectForKey:@"woeid"]];
            [cities addObject:city];
        }
        
        if (fetchCount > 1) {
            
            for (NSDictionary *dict in placesDict) {
                Cities *city = [[Cities alloc] initWithName:[dict objectForKey:@"name"]
                                                      woeid:[NSString stringWithFormat:@"%@", [dict objectForKey:@"woeid"]]];
                [cities addObject:city];
                city = nil;
            }
        }
    }
    
    return cities;
}

+ (NSDictionary *)resultsDictionaryFromData:(NSData *)data
{
    id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];

    NSMutableDictionary *cityDetailsDict = [[NSMutableDictionary alloc] init];
    
    NSDictionary *resultsDict = [jsonResult[@"query"] objectForKey:@"results"]; // All results
    
    if (resultsDict != Nil) {
        NSDictionary *channelDict = resultsDict[@"channel"]; // All details
        
        if (channelDict) {
            NSDictionary *wind = [channelDict objectForKey:@"wind"];
            NSLog(@"WindResult model: %@", wind);
            
            NSDictionary *itemsDict = channelDict[@"item"]; // All details
            NSDictionary *condition = [itemsDict objectForKey:@"condition"];
            NSLog(@"ConditionResult model: %@", condition);
            
            if (wind) {
                [cityDetailsDict setObject:[wind objectForKey:@"chill"] forKey:@"chill"];
                [cityDetailsDict setObject:[wind objectForKey:@"direction"] forKey:@"direction"];
                [cityDetailsDict setObject:[wind objectForKey:@"speed"] forKey:@"speed"];
            }
            
            if (condition) {
                [cityDetailsDict setObject:[condition objectForKey:@"code"] forKey:@"code"];
                [cityDetailsDict setObject:[condition objectForKey:@"temp"] forKey:@"temp"];
                [cityDetailsDict setObject:[condition objectForKey:@"text"] forKey:@"text"];
            }
            
            if (jsonResult[@"query"]) {
                [cityDetailsDict setObject:[jsonResult[@"query"] objectForKey:@"created"] forKey:@"date"];
            }
        }
    }
    
    resultsDict = nil;
    
    NSLog(@"%@", cityDetailsDict); // pause
    return cityDetailsDict;
}

@end
