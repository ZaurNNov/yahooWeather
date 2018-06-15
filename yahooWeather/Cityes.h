//
//  Cityes.h
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Cityes : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *woeid;

- (instancetype)initWithName:(NSString *)name
                       woeid:(NSString *)woeid;

@end

