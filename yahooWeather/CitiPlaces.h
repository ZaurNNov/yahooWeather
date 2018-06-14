//
//  CitiPlaces.h
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CitiPlaces : NSObject

@property (nonatomic, copy) NSDictionary *place;

- (instancetype)initWithPlaces:(NSDictionary *)place;


@end

