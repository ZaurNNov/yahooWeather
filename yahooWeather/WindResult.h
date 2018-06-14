//
//  WindResult.h
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WindResult : NSObject

@property (nonatomic, copy) NSString *chill;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *speed;


- (instancetype)initWithChill:(NSString *)chill
                    direction:(NSString *)direction
                        speed:(NSString *)speed;

@end

/*
 
 wind: {
 chill: "61",
 direction: "45",
 speed: "11"
 },
 */
