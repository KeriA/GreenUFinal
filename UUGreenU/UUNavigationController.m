//
//  UUNavigationController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

/****
 *  This class was added to allow easier customization of the Navigation Bar
 *
 */

#import "UUNavigationController.h"

@interface UUNavigationController ()

@end

@implementation UUNavigationController

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants andRootViewController:(UIViewController*)rootController
{
    self = [super initWithRootViewController:rootController];
    if (self) {
        // Custom initialization
        
        _appConstants = appConstants;
        
        //Set the background to black
        //self.navigationBar.barTintColor = [UIColor redColor]; //for testing
        self.navigationBar.barTintColor = [UIColor blackColor];
        
        
        NSShadow* shadow = [[NSShadow alloc] init];
        //shadow.shadowColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        //shadow.shadowColor = [UIColor whiteColor];
        shadow.shadowColor = [UIColor grayColor];
        shadow.shadowOffset = CGSizeMake(0,1);
        
        
        NSDictionary* navAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [UIColor whiteColor], NSForegroundColorAttributeName,
                                       shadow, NSShadowAttributeName,
                                       [_appConstants getBoldFontWithSize:20.0], NSFontAttributeName,
                                       nil];
        /*
        NSDictionary* navAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [_appConstants brightGreenColor], NSForegroundColorAttributeName,
                                       shadow, NSShadowAttributeName,
                                       [_appConstants getBoldFontWithSize:30.0], NSFontAttributeName,
                                       nil];*/

        
        [[UINavigationBar appearance] setTitleTextAttributes:navAttributes];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; //changes the color of the back button
    

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/******************************************************************************************************
 *
 *                             Override methods
 *
 ******************************************************************************************************/

/***
 *  With the release of iOS 7, you’re allowed to change the appearance of the status bar per view 
 *  controller. You can use a UIStatusBarStyle constant to specify whether the status bar content 
 *  should be dark or light content. By default, the status bar displays dark content. In other words, 
 *  items such as time, battery indicator and Wi-Fi signal are displayed in dark color. 
 */
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
