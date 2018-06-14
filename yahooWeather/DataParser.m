//
//  DataParser.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "DataParser.h"
#import "Cityes.h"
#import "WindResult.h"
#import "ConditionResult.h"

@implementation DataParser

+ (NSArray *)parseCitiFromData:(NSData *)data
{
    id jsonResult = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    //NSLog(@"%@", jsonResult);
    
    NSDictionary *queryDict = jsonResult[@"query"]; // All data
    
    NSDictionary *resultsDict = queryDict[@"results"]; // All results
    
    NSArray *placesArray = resultsDict[@"place"]; // All plases
    
    NSMutableArray *cities = [[NSMutableArray alloc] init];
    for (NSDictionary *place in placesArray) {
        
        
        Cityes *citi = [[Cityes alloc] initWithName:[place objectForKey:@"name"]
                                              woeid:[NSString stringWithFormat:@"%@", [place objectForKey:@"woeid"]]];
        [cities addObject:citi];
        //        [place objectForKey:@"name"];
        //        [place objectForKey:@"woeid"];
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
    
    
    NSLog(@"%@", detailsResult); // pause
    return detailsResult;
}

@end
