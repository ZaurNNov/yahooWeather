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
//#import "SearchResultsController.h"
#import "DetailViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, DetailViewControllerSaveCityProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UINavigationItem *NavigationBar;

@property (strong, nonatomic) YQL *yql;
@property (nonatomic) Cities *city;

@property (nonatomic) NSMutableArray <Cities *>*savedCities; // saved city - self tableview data
@property (nonatomic) NSMutableArray <Cities *>*searchCities; // search Result Data
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) BOOL searchResultActive; // key for visible search or saved data

//@property (nonatomic) UISearchController *searchController;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.savedCities = [NSMutableArray array];
    self.searchCities = [NSMutableArray array];
    self.searchResultActive = false;
    
    self.tableView.rowHeight = 70; // self savedCities
    self.tableView.tableHeaderView = nil;
    
    // Init YQL
    self.yql = [[YQL alloc] init];
    
    // Create search
    [self createSerachControllerAndConfigureIt];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadCityList];
}

-(void)createSerachControllerAndConfigureIt {
    
    // Create a UITableViewController to present search results since the actual view controller is not a subclass of UITableViewController in this case
    // self.searchResultController = [[SearchResultsController alloc] init];
    // self.searchResultController.delegate = self;
    
    // Init UISearchController with the search results controller
    //self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    // Link the search controller
    //self.searchController.searchResultsUpdater = self;
    
    // This is obviously needed because the search bar will be contained in the navigation bar
    //self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    // Required (?) to set place a search bar in a navigation bar
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.searchBar.showsCancelButton = YES;
    [self.searchBar sizeToFit];
    
    // This is where you set the search bar in the navigation bar, instead of using table view's header ...
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.placeholder = @"Find city here...";
    
    // To ensure search results controller is presented in the current view controller
    self.definesPresentationContext = YES;
    
    // Setting delegates and other stuff
    //self.searchController.delegate = self;
    //self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchBar.delegate = self;
    
    /*
     // Add the search bar in header
     self.tableView.tableHeaderView = self.searchBar;
     */
}

#pragma mark - UISearchBarDelegate
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchResultActive = true;
    [self reloadCityList];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    self.searchResultActive = false;
    [self.searchCities removeAllObjects];
    [self reloadCityList];
    NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchCities removeAllObjects];
    self.searchResultActive = true;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.searchResultActive = false;
    [searchBar resignFirstResponder];
    [self reloadCityList];
}

//#pragma mark - UISearchControllerDelegate
//// Called after the search controller's search bar has agreed to begin editing or when
//// 'active' is set to YES.
//// If you choose not to present the controller yourself or do not implement this method,
//// a default presentation is performed on your behalf.
////
//// Implement this method if the default presentation is not adequate for your purposes.
////
//- (void)presentSearchController:(UISearchController *)searchController {
//
//}
//
//- (void)willPresentSearchController:(UISearchController *)searchController {
//    // do something before the search controller is presented
//}
//
//- (void)didPresentSearchController:(UISearchController *)searchController {
//    // do something after the search controller is presented
//}
//
//- (void)willDismissSearchController:(UISearchController *)searchController {
//    // do something before the search controller is dismissed
//    [self reloadCityList];
//}
//
//- (void)didDismissSearchController:(UISearchController *)searchController {
//    // do something after the search controller is dismissed
//}

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

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    // Fetching
    [self fetchCitiesForSearchResult:searchText];
//    [self reloadCityList];
}

//-(void)searchText:(NSString *)text {
//    [self fetchCitiesForSearchResult:text];
//}


-(void)reloadCityList {
    self.searchResultActive = false;
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}

-(NSString *)searchString:(UISearchController *)searchController {
    
    return searchController.searchBar.text;
}

- (void)fetchCitiesForSearchResult:(NSString *)searchText {
    
    [YQL fetchCitiesWithSearchText:searchText completionBlock:^(NSArray *cities) {
        [self.searchCities removeAllObjects];
        [self.searchCities addObjectsFromArray:cities];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.searchResultActive = true;
            [self.tableView reloadData];
        });
    }];
}

// TableView delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // Create cell
    static NSString *CellId = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    if (self.searchResultActive) {
        Cities *city = self.searchCities[indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %@", city.woeid];
    } else {
        Cities *city = self.savedCities[indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %@", city.woeid];
    }
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchResultActive) {
        return self.searchCities.count;
    } else {
        return self.savedCities.count;
    }
}

#pragma mark - UISearchResults delegate

-(void)detailViewCity:(Cities *)city
{
    UIStoryboard *detailStoryboard = [UIStoryboard storyboardWithName:@"DetailViewController" bundle:nil];
    
    DetailViewController *detailViewController = [detailStoryboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    
    detailViewController.city = city;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
    self.searchResultActive = NO;
}

-(void)selectCity:(Cities *)city
{
    [self detailViewCity:city];
}

// Delegate method for DetailVC
- (void)saveCurrentCity:(Cities *)city {
    NSLog(@"\nPausa");
    
    // нужна проверка на наличие города в имеющихся
    // хотябы по ИД
    
    [self.savedCities addObject:city];
    [self.searchCities removeAllObjects];
    self.searchResultActive = false;
    [self.searchBar resignFirstResponder];

    [self reloadCityList];
}

// self table select row method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchResultActive) {
        [self selectCity:self.searchCities[indexPath.row]];
    } else {
        [self selectCity:self.savedCities[indexPath.row]];
    }
}

@end
