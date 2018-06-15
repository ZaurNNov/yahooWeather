//
//  SearchResultsController.h
//  yahooWeather
//
//  Created by A1 on 15.06.2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cityes;

@protocol SearchResultsControllerDelegate

-(void)searchResultControllerDidSelectCity:(Cityes *)city;

@end

@interface SearchResultsController : UITableViewController

@property (nonatomic, copy) NSArray <Cityes *>*cities;
@property (nonatomic, weak) id<SearchResultsControllerDelegate> delegate;


@end


