//
//  MainViewController.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 13/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "MainViewController.h"
#import "YQL.h"
#import "Cityes.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusUIBarButtom;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchUIBarButtom;
- (IBAction)plusUIAction:(UIBarButtonItem *)sender;
- (IBAction)searchUIAction:(UIBarButtonItem *)sender;
@property (strong, nonatomic) YQL *yql;
@property (nonatomic, copy) NSArray *cities;
@property (nonatomic) Cityes *city;

@property (nonatomic) NSArray *resultForTable;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Init YQL
    self.yql = [[YQL alloc] init];
    
    // init Citi
    self.city = [[Cityes alloc] initWithName:@"Moscow"
                                       woeid:[NSString stringWithFormat:@"%d", 2454489]];
    
}




// Actions

- (IBAction)plusUIAction:(UIBarButtonItem *)sender
{


}

- (IBAction)searchUIAction:(UIBarButtonItem *)sender
{

    [self refresh];
    
}

- (void)refresh {
    
//NSString *quer1 = [NSString stringWithFormat:@"select woeid,name from geo.places(2) where text=\"%@\"", @"Moscow"];
    //NSDictionary *results = [self.yql requestToYahooWithQuery:quer1];
    //NSLog(@"%@", results);
    //self.cities = [YQL requestCity:quer1];
    
    self.city = [[Cityes alloc] initWithName:@"Moscow"
                                       woeid:[NSString stringWithFormat:@"%d", 2122265]];
    
    NSDictionary *detail = [YQL loadCityDetails:self.city];
    
    NSLog(@"%@", detail);
}



@end
