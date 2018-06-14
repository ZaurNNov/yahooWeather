//
//  YQL.h
//  yql-ios
//
//  Created by Guilherme Chapiewski on 10/19/12.
//  Copyright (c) 2012 Guilherme Chapiewski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cityes.h"

@interface YQL : NSObject

+ (NSArray *)requestCity:(NSString *)query;
+ (NSArray *)loadCityDetails: (Cityes *)city;

@end
