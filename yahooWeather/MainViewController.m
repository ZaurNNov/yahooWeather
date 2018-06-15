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

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationBar;

@property (strong, nonatomic) YQL *yql;
@property (nonatomic) Cityes *city;
@property (nonatomic) NSArray *resultForSavedCitiesTable; // saved citi - self tableview data
@property (nonatomic, copy) NSArray *detailsForCiti; // data for seque
@property (nonatomic, strong) NSArray *searchResult; // search result for search table

@property (nonatomic) UISearchController *searchController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self.NavigationBar setHidesSearchBarWhenScrolling:true];
    
    // Init YQL
    self.yql = [[YQL alloc] init];
    
    // Create search
    [self createSerachControllerAndConfigureIt];
    

}

-(void)createSerachControllerAndConfigureIt {
    
    // Create a UITableViewController to present search results since the actual view controller is not a subclass of UITableViewController in this case
    UITableViewController *searchResultsController = [[UITableViewController alloc] init];
    
    // Init UISearchController with the search results controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    // Link the search controller
    self.searchController.searchResultsUpdater = self;
    
    // This is obviously needed because the search bar will be contained in the navigation bar
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    // Required (?) to set place a search bar in a navigation bar
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    
    // This is where you set the search bar in the navigation bar, instead of using table view's header ...
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"Find citi here...";
    
    // To ensure search results controller is presented in the current view controller
    self.definesPresentationContext = YES;
    
    // Setting delegates and other stuff
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.delegate = self;
    
    /*
     // Add the search bar
     self.tableView.tableHeaderView = searchController.searchBar;
     self.definesPresentationContext = YES;
     [searchController.searchBar sizeToFit];
     */
}


#pragma mark - UISearchBarDelegate
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

#pragma mark - UISearchControllerDelegate
// Called after the search controller's search bar has agreed to begin editing or when
// 'active' is set to YES.
// If you choose not to present the controller yourself or do not implement this method,
// a default presentation is performed on your behalf.
//
// Implement this method if the default presentation is not adequate for your purposes.
//
- (void)presentSearchController:(UISearchController *)searchController {
    
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        
    } else {
        
        [self fetchCitiesForSearchResult:searchText];
        
        // if has data
    }
}

-(void) loadCitiList {
//    [self fetchCitiesForSearchResult:@"Москва"];
//    [self fetchCitiesForSearchResult:@"Нижний Новгород"];
      [self fetchCitiesForSearchResult:@"Нижний"];
}

//-(void)configureSearchController {
//    [self.searchController searchResultsController];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.searchBar.placeholder = @"Search City...";
//    self.searchController.searchBar.delegate = self;
//    [self.searchController.searchBar sizeToFit];
//    self.tableView.tableHeaderView = [self.searchController searchBar];
//}

// Actions
//- (IBAction)plusUIAction:(UIBarButtonItem *)sender
//{
//    if (self.searchResult[0]) {
//        self.city = self.searchResult[0];
//        [self fetchDetailForCiti: self.city];
//    }
//}

//- (IBAction)searchUIAction:(UIBarButtonItem *)sender
//{
//    [self fetchCitiesForSearchResult:@"Нижний Новгород"];
//}

- (void)fetchCitiesForSearchResult:(NSString *)searchText {
    //NSString *quer1 = [NSString stringWithFormat:@"select woeid,name from geo.places(2) where text=\"%@\"", @"Moscow"];
    
    [YQL fetchCitiesWithSearchText:searchText completionBlock:^(NSArray *cities) {
        self.searchResult = cities;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", self.searchResult);
            
            [self.tableView reloadData];
        });
    }];
}

- (void)fetchDetailForCiti:(Cityes *)citi {
    
    // get Citi details array:
    // Array[2] = { WindResult, ConditionResult }
    [YQL fetchCityDetails:self.city completionBlock:^(NSArray *citiDetails) {
        self.detailsForCiti = citiDetails;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", self.detailsForCiti);
            
            // new controller.detailsForCiti = self.detailsForCiti;
            // new controller.city = self.city;
            // signal segue or etc ->
        });
    }];
}

// TableView delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    // Create cell
    static NSString *CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    // Configure cell
//    Cityes *citi = self.resultForSavedCitiesTable[indexPath.row];
    Cityes *citi = self.searchResult[indexPath.row];
    
    cell.textLabel.text = citi.name;
    cell.detailTextLabel.text = citi.woeid;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.resultForSavedCitiesTable.count;
    return self.searchResult.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

@end
