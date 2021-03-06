//
//  YQL.m
//  yql-ios
//
//  Created by Guilherme Chapiewski on 10/19/12.
//  Copyright (c) 2012 Guilherme Chapiewski. All rights reserved.
//

#import "YQL.h"
#import "DataParser.h"
#import "Cities.h"

#define QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q="
#define QUERY_SUFFIX @"&format=json"

#define SELECT_SUFFIX @"SELECT * FROM weather.forecast WHERE woeid="

// #define QUERY_SUFFIX @"&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
// inputLanguage=ru-RU
// &gflags=L&locale=RU&lang=ru_RU

@implementation YQL

// Return Cities Array in complition block
+ (void)fetchCitiesWithSearchText:(NSString *)searchText completionBlock:(void (^)(NSArray *cities))completionBlock {
    
    NSString *query = [NSString stringWithFormat:@"select woeid, name from geo.places(10) where text=\"%@\"", searchText];
    
//    NSMutableArray *arr = [NSMutableArray array]; // Return Cities array
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *encodedString = [query stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, encodedString, QUERY_SUFFIX];
    
//    NSLog(@"\n%@: %@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), strRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@", strRequest]]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:24 *60];
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    NSArray *array = [NSArray arrayWithArray:[DataParser parseCitiFromData:data]];
//                    NSMutableArray *arrays = [[NSMutableArray alloc] init];
//                    [arrays addObjectsFromArray:array];
//                    [arr addObjectsFromArray:[DataParser parseCitiFromData:data]];
                    if (completionBlock != nil) {
                        completionBlock(array);
//                        completionBlock(arr.copy);
                    }
//                    arrays = nil;
                    array = nil;
                    //NSLog(@"%@", arr);
                }] resume];
    
    query = nil;
    set = nil;
    encodedString = nil;
    strRequest = nil;
    session = nil;
    request = nil;
}

// Return City Detail in complition block
+ (void)fetchCityDetails:(Cities *)city completionBlock:(void (^)(NSDictionary *citiDetails))completionBlock {
    
    NSString *woeid = [NSString stringWithFormat:@"%@", [city woeid]];
    
//    NSMutableDictionary *details = [[NSMutableDictionary alloc] init]; // return
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *encodedSELECT = [SELECT_SUFFIX stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *encodedString = [woeid stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@", QUERY_PREFIX, encodedSELECT, encodedString, QUERY_SUFFIX];
    
//    NSLog(@"/n%@: %@ -> %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), strRequest);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", strRequest]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:24 *60];
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
//                    [details setDictionary:[DataParser resultsDictionaryFromData:data]];
                    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[DataParser resultsDictionaryFromData:data] copyItems:YES];
                    
                    if (completionBlock != nil) {
                        completionBlock(dict);
//                        completionBlock(details.copy);

                    }
                    
                    dict = nil;
                    //NSLog(@"%@", details);
                }] resume];
    
    woeid = nil;
    set = nil;
    encodedSELECT = nil;
    encodedString = nil;
    strRequest = nil;
    session = nil;
    request = nil;
}

@end
