//
//  DetailViewController.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 14/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "DetailViewController.h"
#import "Cities.h"
#import "YQL.h"


@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButtom;
- (IBAction)saveBarButtomAction:(UIBarButtonItem *)sender;

@property (nonatomic, copy) NSDictionary *detailsForCity; // data from seque etc

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadCityDetail:self.city];
}

-(void)loadCityDetail:(Cities *)city {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self fetchDetailForCiti:city];
    });
}

-(void)updateSelfData {
    /*
     [cityDetailsDict setObject:wi.chill forKey:@"chill"];
     [cityDetailsDict setObject:wi.direction forKey:@"direction"];
     [cityDetailsDict setObject:wi.speed forKey:@"speed"];
     
     [cityDetailsDict setObject:cond.code forKey:@"code"];
     [cityDetailsDict setObject:cond.code forKey:@"date"];
     [cityDetailsDict setObject:cond.code forKey:@"temp"];
     [cityDetailsDict setObject:cond.code forKey:@"text"];
     */
    
    /*
    [self.detailsForCity objectForKey:@"chill"];
    [self.detailsForCity objectForKey:@"direction"];
    [self.detailsForCity objectForKey:@"speed"];
    
    [self.detailsForCity objectForKey:@"code"];
    [self.detailsForCity objectForKey:@"date"];
    [self.detailsForCity objectForKey:@"temp"];
    [self.detailsForCity objectForKey:@"text"];
    */
    
    NSLog(@"%@", self.detailsForCity);
    
    NSString *detailText = [NSString stringWithFormat:@"%@ %@ speed:%@", [self.detailsForCity objectForKey:@"chill"], [self.detailsForCity objectForKey:@"direction"], [self.detailsForCity objectForKey:@"speed"]];
    
    NSString *cityNameText = self.city.name;
    
    NSString *descriptionText = [NSString stringWithFormat:@"%@ - %@ \n%@", [self.detailsForCity objectForKey:@"code"], [self.detailsForCity objectForKey:@"text"], [self.detailsForCity objectForKey:@"date"]];
    
    NSString *tempText = [self.detailsForCity objectForKey:@"temp"];
    
    self.detailsLabel.text = detailText; // Fetch Date
    self.cityNameLabel.text = cityNameText; // Fetch City name
    self.descriptionLabel.text = descriptionText; // Fetch wind and other data
    self.temperatureLabel.text = tempText; // Fetch temp in Celios
}

- (void)fetchDetailForCiti:(Cities *)city {
    
    // get City details array:
    // Array[2] = { WindResult, ConditionResult }
    [YQL fetchCityDetails:self.city completionBlock:^(NSDictionary *citiDetails) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", self.detailsForCity);
            self.detailsForCity = citiDetails;
            [self updateSelfData];
            [self.view setNeedsDisplay];
        });
    }];
}

- (IBAction)saveBarButtomAction:(UIBarButtonItem *)sender {

    // self.city -> to mainViewController
    // create array and add to "main" resultForSavedCitiesTable array
    
    NSArray <Cities *>*city = [NSArray arrayWithObject:self.city];
    NSLog(@"%@", city);
    
//    self.navigationController.presentingViewController.resultForSavedCitiesTable
    
}
@end
