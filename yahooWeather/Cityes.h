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

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *woeid;

- (instancetype)initWithName:(NSString *)name
                       woeid:(NSString *)woeid;

@end

