//
//  DataParser.h
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

+ (NSArray *)parseCitiFromData:(NSData *)data;
+ (NSArray *)resultsDictionaryFromData:(NSData *)data;

@end
