//
//  YQL.h
//  yql-ios
//
//  Created by Guilherme Chapiewski on 10/19/12.
//  Copyright (c) 2012 Guilherme Chapiewski. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cities;

@interface YQL : NSObject

+ (void)fetchCitiesWithSearchText:(NSString *)searchText completionBlock:(void (^)(NSArray *cities))completionBlock;
+ (void)fetchCityDetails:(Cities *)city completionBlock:(void (^)(NSDictionary *cityDetails))completionBlock;

@end
