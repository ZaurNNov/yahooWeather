//
//  AppDelegate.m
//  yahooWeather
//
//  Created by Zaur Giyasov on 13/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIWindow *window = [[UIWindow alloc] init];
    self.window = window;
    //window.frame = [UIScreen mainScreen].bounds;
    
    UIStoryboard *mainStoriboard = [UIStoryboard storyboardWithName:@"MainViewController" bundle:nil];
    //[mainStoriboard instantiateInitialViewController];
    MainViewController *mvc = [mainStoriboard instantiateViewControllerWithIdentifier:@"mainVC"];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:mvc];
    self.window.rootViewController = nc;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
