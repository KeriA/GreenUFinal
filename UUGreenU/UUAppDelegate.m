//
//  UUAppDelegate.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUAppDelegate.h"

@implementation UUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor]; //should never show - for testing
    
    // SVProgressHUD is created as a singleton (i.e. it doesn't need to be explicitly allocated and instantiated; you directly call [SVProgressHUD <method>]).
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    
    // create the model so it can be passed into the controllers
    _model = [[UUModel alloc] init];
    
    // create the app constants object - controllers and views will reference this for colors, backgrounds,  etc.
    // We need to send the screen height so we can set the appropriate background image
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;        
    _appConstants = [[UUApplicationConstants alloc] initWithHeight:screenHeight];
    
    /* At this point, we need to check that the user has already created a login.  If this is the case
     * then locally (in the plist data) there will already be a key received from the server.  We then
     * bring the user directly to the main menu.
     * If a key does not exist, then we bring up the login view */
    if (true)  // for testing
    //if ([_model hasUserKey])
    {
        [SVProgressHUD dismiss];
        _mainViewController = [[UUMainViewController alloc] initWithModel:_model andAppConstants:_appConstants];
        UUNavigationController* mainNavigationController = [[UUNavigationController alloc] initWithAppConstants:_appConstants andRootViewController: _mainViewController];
        
        // make the mainNavigationController the root controller
        [self.window setRootViewController: mainNavigationController];         
        [self.window makeKeyAndVisible];
        
    }
    else // no user key found, prompt the login screen
    {
        [SVProgressHUD dismiss];
        _loginViewController = [[UULoginViewController alloc] initWithModel:_model andAppConstants:_appConstants];
        
        //The navigation controller gives the bar across the top
        UUNavigationController* mainNavigationController = [[UUNavigationController alloc] initWithAppConstants:_appConstants andRootViewController: _loginViewController];
        
        // make the mainNavigationController the root controller
        [self.window setRootViewController: mainNavigationController];
        [self.window makeKeyAndVisible];

    }

    
    
    //[self.window makeKeyAndVisible];
    return YES;
}


/******************************************************************************************************
 *
 *                              Auto Generated Focus Handler Methods
 *
 ******************************************************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
