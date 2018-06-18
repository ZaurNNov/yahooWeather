//
//  DetailViewController.h
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Cities;

@protocol DetailViewControllerSaveCityProtocol

- (void)saveCurrentCity:(Cities *)city;

@end

@interface DetailViewController : UIViewController

@property (nonatomic) Cities *city;

@property (nonatomic, weak) id <DetailViewControllerSaveCityProtocol> delegate;

@end
