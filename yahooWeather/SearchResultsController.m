//
//  SearchResultsController.m
//  yahooWeather
//
//  Created by A1 on 15.06.2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "SearchResultsController.h"
#import "Cities.h"

@interface SearchResultsController ()


@end

@implementation SearchResultsController

static NSString *CellId = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellId];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    Cities *city = self.cities[indexPath.row];
    
    cell.textLabel.text = city.name;
    cell.detailTextLabel.text = city.woeid;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Cities *city = self.cities[indexPath.row];
    [self.delegate searchResultControllerDidSelectCity:city];
}


@end
