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
    int _topicsArrayLocation;
    NSString* _currentTopicTitle;
    NSString* _currentMonthString;
    
    // this will hold previous months URL, topic String, month number
    NSMutableArray* _previousMonthsInfo;
    
    bool _pickerViewIsHidden;
    
    
}

@end

@implementation UUChallengeViewController
/***
 *
 *      Constructor:  create a weak reference to the model
 */
- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andTopicsArrayLocation: (int) topicsArrayLocation
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        
        //fill in the data model to use
        _model = model;
        _appConstants = appConstants;
        _topicsArrayLocation = topicsArrayLocation;
        
        //get current date information
        // example:  suppose current month is May  = 5,
        // we retrieve the number '5' out of the first element in the topics array (i.e. position CURRENTMONTH)
        _currentMonth = [_model getMonthNumAsInt:topicsArrayLocation];
        
         
        //get current challenge info
        _currentTopicTitle = [_model getMonthTopicTitle:topicsArrayLocation];
        
        _numberOfPreviousMonths = [_model getNumberOfPreviousTopics];
        
        _pickerViewIsHidden = true;
        
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
    [(UUChallengeView*)self.view setPickerDataSource:self];
    [(UUChallengeView*)self.view setPickerDelegate:self];
    
    
    //test code
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"GreenU";
    
    [(UUChallengeView*)self.view setCurrentMonth:_currentMonth];
    [(UUChallengeView*)self.view setTopicString:_currentTopicTitle];
    

}

/**********************************************************************************************************
 *
 *                          UUChallengeView Delegate Methdods
 *
 **********************************************************************************************************/
- (void) takeChallengeButtonWasPressed
{
    //NSLog(@"Take Challenge Button Was Pressed"); //for testing
    [self createAndPushTabViewController:_topicsArrayLocation];
    
}//end takeChallengeButttonWasPressed

- (void) previousChallengesButtonWasPressed
{
    //NSLog(@"Previous Challenges Button Was Pressed"); //for testing
    if (_pickerViewIsHidden){
            [(UUChallengeView*)self.view showPickerView];
    }else{
            [(UUChallengeView*)self.view hidePickerView];
    }

    _pickerViewIsHidden = (!_pickerViewIsHidden);
    
    
}//end previousChallengesButtonWasPressed



/***********************************************************************************************
 *
 *                          UIPickerViewDataSource methods
 *
 ***********************************************************************************************/
#pragma mark - UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _numberOfPreviousMonths;
}



/***********************************************************************************************
 *
 *                          UIPickerViewDelegate methods
 *
 ***********************************************************************************************/
#pragma mark - UIPickerViewDelegate

 - (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView* theView = (UILabel*)view;
    
    if (!theView){
        theView = [[UILabel alloc]init];
        //set up label properties - frame, font, colors, etc
        theView.backgroundColor = [UIColor clearColor];
        [(UILabel*)theView setFont:[_appConstants getStandardFontWithSize:18.0]];
        [(UILabel*)theView setTextColor:[_appConstants mustardYellowColor]];
        [(UILabel*)theView setTextAlignment:NSTextAlignmentCenter];
        //[(UILabel*)theView frame].size.height = 15.0;
        
    }
    
    NSString* titleString = [_model getMonthTopicTitle:(int)(row+1)]; //+1 because location '0' is current topic
    int monthNumber = [_model getMonthNumAsInt:(int)(row+1)];
    NSString* monthString = [_appConstants getMonthText:monthNumber];
    NSString* labelString = [NSString stringWithFormat:@"%@  %@",monthString, titleString];
    
    [(UILabel*)theView setText:labelString];
    
    return theView;
}

/***
 *  This method allows for customization of the text
 *
- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* titleString = [_model getMonthTopicTitle:(int)(row+1)]; //+1 because location '0' is current topic
    int monthNumber = [_model getMonthNumAsInt:(int)(row+1)];
    NSString* monthString = [_appConstants getMonthText:monthNumber];
    NSString* labelString = [NSString stringWithFormat:@"%@  %@",monthString, titleString];
    
   // NSAttributedString *attString = [[NSAttributedString alloc] initWithString:labelString attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIFont* font = [_appConstants getStandardFontWithSize:7.0];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:labelString attributes:@{NSForegroundColorAttributeName:[_appConstants mustardYellowColor], NSFontAttributeName: font}];
    
    return attString;
    
}//end attributedTitleForRow */

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"Take Picker Button Was Pressed"); //for testing

    int prevTopicsArrayLocation = (int)row+1;  //+1 because '0' is the current topic
    [self createAndPushTabViewController:prevTopicsArrayLocation];
    
}//end didSelectRow

/******************************************************************************************************
 *
 *                              Convenience Methods
 *
 ******************************************************************************************************/
- (void) createAndPushTabViewController:(int)topicArrayLocation
{
    
    _challengeTabViewController = [[UUChallengeTabViewController alloc] initWithModel:_model andAppConstants:_appConstants andTopicsArrayLocation:topicArrayLocation];
    [[self navigationController] pushViewController:_challengeTabViewController animated:TRUE];
   
}//end createAndPushTabViewController



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
