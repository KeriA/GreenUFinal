//
//  UUAboutViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUAboutViewController.h"

@interface UUAboutViewController ()

@end

@implementation UUAboutViewController
/***
 *
 *      Constructor:  create a weak reference to the model
 */
- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        
        //fill in the data model to use
        _model = model;
        _appConstants = appConstants;
        
    }
    
    return self;
    
}// end contstructor

/******************************************************************************************************
 *
 *                              View Handlers
 *
 ******************************************************************************************************/

-(void) loadView
{
    self.view = [[UUAboutView alloc] initWithAppConstants:_appConstants];
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"GreenU";
}

/******************************************************************************************************
 *
 *                              Auto Generated View Handlers
 *
 ******************************************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set view delegates
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
