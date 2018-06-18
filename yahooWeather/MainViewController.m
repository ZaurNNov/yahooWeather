//
//  MainViewController.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 13/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "MainViewController.h"
#import "YQL.h"
#import "Cities.h"
#import "SearchResultsController.h"
#import "DetailViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, SearchResultsControllerDelegate, DetailViewControllerSaveCityProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationBar;

@property (strong, nonatomic) YQL *yql;
@property (nonatomic) Cities *city;

@property (nonatomic) NSMutableArray <Cities *>*resultForSavedCitiesTable; // saved city - self tableview data
@property (nonatomic) UISearchController *searchController;
@property (nonatomic) SearchResultsController *searchResultController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultForSavedCitiesTable = [NSMutableArray array];
    self.tableView.rowHeight = 70; // self savedCities
    
    // Init YQL
    self.yql = [[YQL alloc] init];
    
    // Create search
    [self createSerachControllerAndConfigureIt];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadCityList];
//    // Create search
//    [self createSerachControllerAndConfigureIt];
}

-(void)createSerachControllerAndConfigureIt {
    
    // Create a UITableViewController to present search results since the actual view controller is not a subclass of UITableViewController in this case
    self.searchResultController = [[SearchResultsController alloc] init];
    self.searchResultController.delegate = self;
    
    // Init UISearchController with the search results controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchResultController];
    
    // Link the search controller
    self.searchController.searchResultsUpdater = self;
    
    // This is obviously needed because the search bar will be contained in the navigation bar
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    // Required (?) to set place a search bar in a navigation bar
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    [self.searchController.searchBar sizeToFit];
    
    // This is where you set the search bar in the navigation bar, instead of using table view's header ...
    self.navigationItem.titleView = self.searchController.searchBar;
    self.searchController.searchBar.placeholder = @"Find city here...";
    
    // To ensure search results controller is presented in the current view controller
    self.definesPresentationContext = YES;
    
    // Setting delegates and other stuff
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
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

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self reloadCityList];
    
    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
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
    [self reloadCityList];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    
    if (searchText == nil) {
        
        // If empty the search results are the same as the original data
        
    } else {
        [self fetchCitiesForSearchResult:searchText];
    }
}

-(void)reloadCityList {
//    [self.resultForSavedCitiesTable]
    [self.tableView reloadData];
}

-(NSString *)searchString:(UISearchController *)searchController {
    
    return searchController.searchBar.text;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)fetchCitiesForSearchResult:(NSString *)searchText {
    
    [YQL fetchCitiesWithSearchText:searchText completionBlock:^(NSArray *cities) {
        self.searchResultController.cities = cities;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResultController.tableView reloadData];
        });
    }];
}

- (void)fetchCitiesWithReturn:(NSString *)searchText completionBlock:(void (^)(NSArray *cities))completionBlock {
    
    NSMutableArray *arr = [NSMutableArray array]; // Return Cities array
    
    [YQL fetchCitiesWithSearchText:searchText completionBlock:^(NSArray *cities) {
        self.searchResultController.cities = cities;
        [arr addObjectsFromArray:cities];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchResultController.tableView reloadData];
            
            if (completionBlock !=nil) {
                completionBlock(arr.copy);
                [self.tableView reloadData];
            }
        });
    }];
}

// TableView delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // Create cell
    static NSString *CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    Cities *city = self.resultForSavedCitiesTable[indexPath.row];
    
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %@", city.woeid];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultForSavedCitiesTable.count;
}

#pragma mark - UISearchResults delegate

-(void)detailViewCity:(Cities *)city
{
    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"DetailViewController" bundle:nil];
    
    DetailViewController *detailViewController = [detailStoryboard instantiateInitialViewController];
    detailViewController.city = city;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)searchResultControllerDidSelectCity:(Cities *)city
{
    [self detailViewCity:city];
}

- (void)saveCurrentCity:(Cities *)city {
    
    [self.resultForSavedCitiesTable addObject:city];
    [self reloadCityList];
    NSLog(@"\nPausa");
    
//    for (Cities *searchCurrentCity in self.resultForSavedCitiesTable) {
//        if (searchCurrentCity == city) {
//            return;
//        } else {
//            [self.resultForSavedCitiesTable addObject:city];
//            [self reloadCityList];
//        }
//    }
}

// self table select row method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self detailViewCity:self.resultForSavedCitiesTable[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
