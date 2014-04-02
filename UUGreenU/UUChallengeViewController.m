//
//  UUChallengeViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUChallengeViewController.h"


@interface UUChallengeViewController ()
{
    int _currentMonth;
    int _numberOfPreviousMonths;
    NSString* _currentTopicString;
    
    // this will hold previous months URL, topic String, month number
    NSMutableArray* _previousMonthsInfo;
    
}

@end

@implementation UUChallengeViewController
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
        
        //get current date information
        _currentMonth = [_model getCurrentMonth];
        
        
        //get current challenge info
        _currentTopicString = [_model getCurrentChallengeTopic];
        
        
        
        // get some previous months information
        
        
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
    self.view = [[UUChallengeView alloc] initWithAppConstants:_appConstants];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set view delegates
    [(UUChallengeView*)self.view setChallengeViewDelegate:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"GreenU";
    
    [(UUChallengeView*)self.view setCurrentMonth:_currentMonth];
    [(UUChallengeView*)self.view setTopicString:_currentTopicString];
}

/**********************************************************************************************************
 *
 *                          UUChallengeView Delegate Methdods
 *
 **********************************************************************************************************/
- (void) takeChallengeButtonWasPressed
{
    NSLog(@"Take Challenge Button Was Pressed"); //for testing
    
}//end takeChallengeButttonWasPressed

- (void) previousChallengesButtonWasPressed
{
    NSLog(@"Previous Challenges Button Was Pressed"); //for testing
    
}//end previousChallengesButtonWasPressed

/******************************************************************************************************
 *
 *                              Auto Generated View Handlers
 *
 ******************************************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
