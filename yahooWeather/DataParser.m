//
//  DataParser.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "DataParser.h"
#import "Cities.h"
#import "WindResult.h"
#import "ConditionResult.h"

@implementation DataParser

+ (NSArray *)parseCitiFromData:(NSData *)data
{
    id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    //NSLog(@"%@", jsonResult);
    
    NSMutableArray *cities = [[NSMutableArray alloc] init];
    
    NSDictionary *queryDict = jsonResult[@"query"]; // All data
    
    NSDictionary *resultsDict = queryDict[@"results"]; // All results
    
    NSInteger fetchCount = [queryDict[@"count"] integerValue];
    
    if (fetchCount > 1) {
        NSDictionary *placesDict = resultsDict[@"place"]; // All plases
        
           for (NSDictionary *dict in placesDict) {
               Cities *city = [[Cities alloc] initWithName:[dict objectForKey:@"name"]
                                                     woeid:[NSString stringWithFormat:@"%@", [dict objectForKey:@"woeid"]]];
               [cities addObject:city];
           }
    } else if (fetchCount == 1) {
        NSDictionary *placesDict = resultsDict[@"place"]; // Only 1 Citi
        
        NSString *townName = [placesDict objectForKey:@"name"];
        NSString *townWoeid = [placesDict objectForKey:@"woeid"];
        
        Cities *city = [[Cities alloc] initWithName:townName
                                               woeid:[NSString stringWithFormat:@"%@", townWoeid]];
        [cities addObject:city];
    }
    
    return cities;
}

+ (NSArray *)resultsDictionaryFromData:(NSData *)data
{
    id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    //NSLog(@"%@", jsonResult);
    NSMutableArray *detailsResult = [[NSMutableArray alloc] init];
    
    NSDictionary *queryDict = jsonResult[@"query"]; // All data
    
    NSDictionary *resultsDict = queryDict[@"results"]; // All results
    
    NSDictionary *channelDict = resultsDict[@"channel"]; // All details
    
    NSDictionary *wind = [channelDict objectForKey:@"wind"];
    NSLog(@"WindResult model: %@", wind);

    WindResult *wi = [[WindResult alloc] initWithChill:[wind objectForKey:@"chill"]
                                                 direction:[wind objectForKey:@"direction"]
                                                     speed:[wind objectForKey:@"speed"]];
    
    [detailsResult addObject:wi];
    
    NSDictionary *itemsDict = channelDict[@"item"]; // All details
    NSDictionary *condition = [itemsDict objectForKey:@"condition"];
    NSLog(@"ConditionResult model: %@", condition);
    
    ConditionResult *cond = [[ConditionResult alloc] initWithCode:[condition objectForKey:@"code"]
                                                            date:[condition objectForKey:@"date"]
                                                            temp:[condition objectForKey:@"temp"]
                                                            text:[condition objectForKey:@"text"]];
    
    [detailsResult addObject:cond];
    
    
    //NSLog(@"%@", detailsResult); // pause
    return detailsResult;
}

@end
