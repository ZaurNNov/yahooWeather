//
//  SearchResultsController.h
//  yahooWeather
//
//  Created by A1 on 15.06.2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Cities;

@protocol SearchResultsControllerDelegate

-(void)searchResultControllerDidSelectCity:(Cities *)city;

@end

@interface SearchResultsController : UITableViewController

@property (nonatomic, copy) NSArray <Cities *>*cities;
@property (nonatomic, weak) id<SearchResultsControllerDelegate> delegate;


@end


