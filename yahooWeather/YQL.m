//
//  YQL.m
//  yql-ios
//
//  Created by Guilherme Chapiewski on 10/19/12.
//  Copyright (c) 2012 Guilherme Chapiewski. All rights reserved.
//

#import "YQL.h"
#import "DataParser.h"


#define QUERY_PREFIX @"http://query.yahooapis.com/v1/public/yql?q="
#define QUERY_SUFFIX @"&format=json"

#define SELECT_SUFFIX @"SELECT * FROM weather.forecast WHERE woeid="

// #define QUERY_SUFFIX @"&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
// inputLanguage=ru-RU
// &gflags=L&locale=RU&lang=ru_RU

@implementation YQL

// Return Cities Array in complition block
+ (void)fetchCitiesWithSearchText:(NSString *)searchText completionBlock:(void (^)(NSArray *cities))completionBlock {
    
    NSString *query = [NSString stringWithFormat:@"select woeid,name from geo.places(2) where text=\"%@\"", searchText];
    
    NSMutableArray *arr = [NSMutableArray array]; // Return Cities array
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *encodedString = [query stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, encodedString, QUERY_SUFFIX];
    
    //NSLog(@"%@", strRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                                    [NSURL URLWithString:[NSString stringWithFormat:@"%@", strRequest]]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:24 *60];
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    [arr addObjectsFromArray:[DataParser parseCitiFromData:data]];
                    if (completionBlock !=nil) {
                        completionBlock(arr.copy);
                    }
                    //NSLog(@"%@", arr);
                    
                }] resume];
}

// Return City Detail in complition block
+ (void)fetchCityDetails:(Cityes *)city completionBlock:(void (^)(NSArray *citiDetails))completionBlock {
    
    NSString *woeid = [NSString stringWithFormat:@"%@", [city woeid]];
    
    NSMutableArray *details = [[NSMutableArray alloc] init]; // return
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *encodedSELECT = [SELECT_SUFFIX stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *encodedString = [woeid stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@", QUERY_PREFIX, encodedSELECT, encodedString, QUERY_SUFFIX];
    
    NSLog(@"%@", strRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", strRequest]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:24 *60];
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    [details addObjectsFromArray:[DataParser resultsDictionaryFromData:data]];
                    if (completionBlock !=nil) {
                        completionBlock(details.copy);
                    }
                    //NSLog(@"%@", details);
                    
                }] resume];
}

//NSString *quer1 = [NSString stringWithFormat:@"select woeid,name from geo.places(2) where text=\"%@\"", @"Moscow"];
// Return Cities Array
+ (NSArray *)requestCity:(NSString *)query {
    
    NSMutableArray *arr = [NSMutableArray array]; // Return Cities array
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *encodedString = [query stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, encodedString, QUERY_SUFFIX];
    
    //NSLog(@"%@", strRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:[NSString stringWithFormat:@"%@", strRequest]]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:24 *60];
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    [arr addObjectsFromArray:[DataParser parseCitiFromData:data]];
                    //NSLog(@"%@", arr);
                    
                }] resume];
    
    return arr;
}


// Return City Detail
+ (NSArray *)loadCityDetails: (Cityes *)city {
    
    NSString *woeid = [NSString stringWithFormat:@"%@", [city woeid]];

    NSMutableArray *details = [[NSMutableArray alloc] init]; // return
    
    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
    NSString *encodedSELECT = [SELECT_SUFFIX stringByAddingPercentEncodingWithAllowedCharacters:set];
    NSString *encodedString = [woeid stringByAddingPercentEncodingWithAllowedCharacters:set];
    
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@", QUERY_PREFIX, encodedSELECT, encodedString, QUERY_SUFFIX];
    
    NSLog(@"%@", strRequest);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", strRequest]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:24 *60];
    
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    [details addObjectsFromArray:[DataParser resultsDictionaryFromData:data]];
                    
                }] resume];
    
    return details;
}


//- (NSDictionary *) query: (NSString *)statement {
//    NSString *query = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, [statement stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], QUERY_SUFFIX];
//
//    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
//
//    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
//
//    return results;
//}

//- (NSDictionary *)requestToYahooWithQuery:(NSString *)query {
//    //    NSString *queryWithPercent = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
//    //                                                                                                      NULL,
//    //                                                                                                      (CFStringRef)query,
//    //                                                                                                      NULL,
//    //                                                                                                      (CFStringRef)@"=",
//    //                                                                                                      kCFStringEncodingUTF8 ));
//    //    NSString *request2 = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, queryWithPercent, querySuffix];
//    
//    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
//    NSString *encodedString = [query stringByAddingPercentEncodingWithAllowedCharacters:set];
//    NSString *request = [NSString stringWithFormat:@"%@%@%@", QUERY_PREFIX, encodedString, QUERY_SUFFIX];
//    
//    
//    NSLog(@"%@", request);
//    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:request] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *error = nil;
//    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error] : nil;
//    
//    if (error) {
//        NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
//    }
//    
//    return results;
//}

@end
