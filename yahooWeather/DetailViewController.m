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
#import "NSObject+customCategory.h"
#import "MainViewController.h"


@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityID;

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
    
    static NSString *notFound = @"Not found";
    NSLog(@"%@", self.detailsForCity);
    
    // if nil = @"example text"
    

    
    // Citi name & woeid
    self.cityNameLabel.text = self.city.name; // Fetch City name
    self.cityID.text = [NSString stringWithFormat:@"City id: %@", self.city.woeid]; // City ID
    
    // Temperature
    if ([self.detailsForCity objectForKey:@"temp"]) {
        double temp = [self celsiosFromFahrenheit:[[self.detailsForCity objectForKey:@"temp"] intValue]];
        self.temperatureLabel.text = [NSString stringWithFormat:@"%.1f ℃",temp];
        
    } else {
        self.temperatureLabel.text = notFound;
    }
    
    // Description text
    NSString *descriptionText = [NSString stringWithFormat:@"%@\nspeed: %@", [self.detailsForCity objectForKey:@"text"], [self.detailsForCity objectForKey:@"speed"]];
    self.descriptionLabel.text = descriptionText; // Fetch wind and other data
    
    // Detail text = fetch date
    if ([self.detailsForCity objectForKey:@"date"]) {
        /*
        // @"yyyy MMM dd hh:mm" - show in app
        // Fetch Date
        NSDate *fetchDate = [self.detailsForCity objectForKey:@"date"];
        self.detailsLabel.text = [self setCustomStringFromDate:fetchDate];
         */
        self.detailsLabel.text = [self setCustomStringFromDate:[NSDate date]]; // current date
        
    } else {
        
        self.detailsLabel.text = [self setCustomStringFromDate:[NSDate date]]; // current date
    }
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
    
    [self saveCurrentCity:self.city];
    [self.navigationController popViewControllerAnimated:YES];
    //self.navigationController.viewControllers; // массив контроллеров в навигейшн контролллере (предпоследний - родитель этого)
}

- (void)saveCurrentCity:(Cities *)city {
    [self.delegate saveCurrentCity:city];
}

@end
