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
    
    NSInteger fetchCount = [[jsonResult[@"query"] objectForKey:@"count"] integerValue];
    
    if (fetchCount != 0) {
        NSDictionary *placesDict = [[jsonResult[@"query"] objectForKey:@"results"] valueForKey:@"place"]; // All plases
        
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
    
    if ([jsonResult[@"query"] objectForKey:@"results"]) {
        
        if ([[jsonResult[@"query"] objectForKey:@"results"] valueForKey:@"channel"]) {
            NSDictionary *wind = [[[jsonResult[@"query"] objectForKey:@"results"] valueForKey:@"channel"] valueForKey:@"wind"];
            
            NSDictionary *itemsDict = [[[jsonResult[@"query"] objectForKey:@"results"] valueForKey:@"channel"] valueForKey:@"item"]; // All details
            NSDictionary *condition = [itemsDict objectForKey:@"condition"];
            
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
            
            wind = nil;
            itemsDict = nil;
            condition = nil;
        }
    }
    
    NSLog(@"%@", cityDetailsDict); // pause
    return cityDetailsDict;
}

@end
