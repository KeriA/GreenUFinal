//
//  UUSpecificChallengeViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 5/15/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUSpecificChallengeViewController.h"

@interface UUSpecificChallengeViewController ()

@end

@implementation UUSpecificChallengeViewController
{
    //components the form will use for both "one time" and "repeat"
    int _monthNumber;
    int _yearNumber;
    int _challengeType;
    int _topicArrayLocation;
    int _challengeNumber;
    int _userPoints;
    int _totalPoints;
    int _numDaysPossibleForChallenge;
    NSArray* _userCompletionDatesFromModel; //data from the server
    int _numDaysUserhasAlreadyCompleted;

    NSString* _topicTeaser;
    NSString* _topicDescription;
    
    //componenets only used for "repeat"
    NSString* _calendarMonthString;
    int _numDaysUserHasSelectedFromCalendar;
    int _firstDayOfMonth;  //0 = SUN, 1 = MON, etc
    int _numberOfDaysInMonth;
    
    NSCalendar* _calendar;
    NSDate* _MonthFirstDay;

    NSMutableArray* _userCompletionDatesAsDayString; //@"6",  etc...  create this array from _userCompletionDates
    NSMutableArray* _userSelectedDatesFromCalendarAsString;
    
}

/***
 *
 *      Constructor:  create a weak reference to the model
 */
- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andTopicsArrayLocation:(int) topicArrayLocation andChallengeNumber:(int) challengeNumber
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        
        //fill in the data model to use
        _model = model;
        _appConstants = appConstants;
        _topicArrayLocation = topicArrayLocation;
        _challengeNumber = challengeNumber;
        
        // set delegate to recieve responces from model
        [_model setModelForChallengePointsUpdatedDelegate:self];
        
        //get current challenge info
        _challengeType = [_model getChallengeType:topicArrayLocation andChallengeNumber:challengeNumber];
        _topicTeaser = [_model getChallengeTeaser:topicArrayLocation andChallengeNumber:challengeNumber];
        _topicDescription = [_model getChallengeDescr:topicArrayLocation andChallengeNumber:challengeNumber];
        _userPoints = [_model getChallengePointsForUser:topicArrayLocation andChallengeNumber:challengeNumber];
        _totalPoints = [_model getChallengePointsTotalPossible:topicArrayLocation andChallengeNumber:challengeNumber];
        _numDaysPossibleForChallenge = [_model getChallengeNumDaysPossible:topicArrayLocation andChallengeNumber:challengeNumber];
        _userCompletionDatesFromModel = [_model getUserCompletionArrayChallengeMonth:topicArrayLocation andChallengeNumber:challengeNumber];
        _numDaysUserhasAlreadyCompleted = (int)[_userCompletionDatesFromModel count];
        
        NSLog(@"NUMBER OF DAYS POSSIBLE FOR THIS CHALLENGE:  %d", _numDaysPossibleForChallenge);
        NSLog(@"NUMBER OF DAYS USER HAS COMPLETED %d", _numDaysUserhasAlreadyCompleted);
        
 
        
        //get current date information
        _monthNumber = [_model getMonthNumAsInt:topicArrayLocation];
        _yearNumber = [_model getYearNumAsInt:topicArrayLocation];
        
        //just needs to be initialized here - this array will be used for both types
        _userSelectedDatesFromCalendarAsString = [[NSMutableArray alloc] init];

        
        //create calendar components for type "repeat"
        if (_challengeType == REPEAT)
        {
            _calendarMonthString = [NSString stringWithFormat:@"%@ %d", [_appConstants getMonthTextForCalendarView: _monthNumber], _yearNumber];
            _numDaysUserHasSelectedFromCalendar = 0;  //initialize to '0'
            
            _userCompletionDatesAsDayString = [self getUserCompletedDatesAsString];
            
            //use a calendar object to get the number of days in the month, and the
            //day of the week that the month starts on.
            _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
            NSString* monthString;
            if (_monthNumber < 10){
                monthString = [NSString stringWithFormat:@"0%d",_monthNumber];
            }else{
                monthString = [NSString stringWithFormat:@"%d", _monthNumber];
            }
            NSString* dateString = [NSString stringWithFormat:@"%d%@01",_yearNumber, monthString];
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyyMMdd"];
            NSDate* date = [dateFormat dateFromString:dateString];
            //NSLog(@"date is %@", date); //for testing
            
            _firstDayOfMonth = (int)[_calendar ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:date];
            _firstDayOfMonth = _firstDayOfMonth - 1;  //the calendar returns SUN = 1, this form uses SUN = 0
            //NSLog(@"first weekday is: %d", _firstDayOfMonth); //for testing
            
            NSRange days = [_calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
            //NSLog(@"day renge is %d", (int)days.length);
            _numberOfDaysInMonth = (int)days.length;
            
            
           
        }//end if REPEAT
        
    }//end if self
    
    return self;
    
}// end contstructor



/******************************************************************************************************
 *
 *                              View Handlers
 *
 ******************************************************************************************************/

-(void) loadView
{
    self.view = [[UUSpecificChallengeView alloc] initWithAppConstants: _appConstants andMonthNumber:_monthNumber andType:_challengeType];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set view delegates
    [(UUSpecificChallengeView*)self.view setSpecificChallengeViewDelegate:self];
    [(UUSpecificChallengeView*)self.view setCalendarViewDelegate:self];
    
    //check to see if this challenge is complete
    if (_numDaysUserhasAlreadyCompleted >= _numDaysPossibleForChallenge){
        [(UUSpecificChallengeView*)self.view setComponentsToComplete];
    }else{
        [(UUSpecificChallengeView*)self.view setComponentsToInComplete];
    }

}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"GreenU";
    
    //set the challenge test
    [(UUSpecificChallengeView*)self.view setChallengeTeaser:_topicTeaser andDescription:_topicDescription];
    
    //set the user points
    [(UUSpecificChallengeView*)self.view updatePointsForChallenge:_userPoints andChallengePoints:_totalPoints];

    [(UUSpecificChallengeView*)self.view setCalendarMonthAndYear:_calendarMonthString];
    //set the calendar
    if (_challengeType == REPEAT){
        [(UUSpecificChallengeView*)self.view setCalendar:_firstDayOfMonth numDays:_numberOfDaysInMonth daysCompleted:_userCompletionDatesAsDayString andMonthString:_calendarMonthString];
        
    }
    
    
}//end viewWillAppear

/**********************************************************************************************************
 *
 *                          Model Delegate Methdods
 *
 **********************************************************************************************************/
- (void) userChallengePointsUpdatedwithError:(bool)error
{
    [SVProgressHUD dismiss];
    
    //update the user points
    _userPoints = [_model getChallengePointsForUser:_topicArrayLocation andChallengeNumber:_challengeNumber];
    _totalPoints = [_model getChallengePointsTotalPossible:_topicArrayLocation andChallengeNumber:_challengeNumber];
    _numDaysPossibleForChallenge = [_model getChallengeNumDaysPossible:_topicArrayLocation andChallengeNumber:_challengeNumber];
    _userCompletionDatesFromModel = [_model getUserCompletionArrayChallengeMonth:_topicArrayLocation andChallengeNumber:_challengeNumber];
    _numDaysUserhasAlreadyCompleted = (int)[_userCompletionDatesFromModel count];
    
    
    
    [(UUSpecificChallengeView*)self.view updatePointsForChallenge:_userPoints andChallengePoints:_totalPoints];
    
    if (_challengeType == REPEAT){
        _userCompletionDatesAsDayString = [self getUserCompletedDatesAsString];
        [_userSelectedDatesFromCalendarAsString removeAllObjects];
        [(UUSpecificChallengeView*)self.view setCalendar:_firstDayOfMonth numDays:_numberOfDaysInMonth daysCompleted:_userCompletionDatesAsDayString andMonthString:_calendarMonthString];
        
    }
    
    
    //check to see if this challenge is complete
    if (_numDaysUserhasAlreadyCompleted >= _numDaysPossibleForChallenge){
        [(UUSpecificChallengeView*)self.view setComponentsToComplete];
    }else{
        [(UUSpecificChallengeView*)self.view setComponentsToInComplete];
    }
    
    if (error)
    {
        NSString* alertMessage = @"Network connection may have been interrupted.  Please check that your submitted challenge completions were registered.";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

    
    
}//end userChallengePointsUpdated



/**********************************************************************************************************
 *
 *                          UUSpecificChallengeView Delegate Methdods
 *
 **********************************************************************************************************/

-(void) submitButtonWasPressed
{
    NSLog(@"submit button was pressed");  //for testing
    
    //check to see if the user has selected dates
    int numUserDates = (int)[_userSelectedDatesFromCalendarAsString count];
    
    if (numUserDates <= 0)
    {
        NSString* alertMessage;
        
        if (_challengeType == ONETIME){
            alertMessage = @"Please mark the challenge as complete before submitting.";
        }else{
            alertMessage = @"Please select the dates when this challenge was completed.";
        }
        
        //show the alert message
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else{ //inform the model to make the call
        
        [SVProgressHUD show];
        
        NSMutableArray* datesArray = [[NSMutableArray alloc] init];
        
        //create an array of dates to send to the server
        for (int i = 0; i < [_userSelectedDatesFromCalendarAsString count]; i++)
        {
            NSString* dateString = [NSString stringWithFormat:@"%d/%@/%d", _monthNumber, [_userSelectedDatesFromCalendarAsString objectAtIndex:i], _yearNumber];
            [datesArray addObject:dateString];
        }
        
        
        [_model updateUserPointsWithTopicsArrayLocation:_topicArrayLocation andChallengeNumber:_challengeNumber andDatesArray:datesArray];
        
    }
    
}//end submitButtonWasPressed

- (void) calendarButtonWasPressed
{
    NSLog(@"calendar button was pressed");  //for testing
    [(UUSpecificChallengeView*)self.view showCalendarView];
}

- (void) oneTimeButtonWasPressed
{
    
    if ([(UUSpecificChallengeView*)self.view oneTimeBoxIsSelected])
    { //empty the array
        [_userSelectedDatesFromCalendarAsString removeAllObjects];
        
    }else{//load the first day of the month into the array
        NSString* firstDateString = @"1";
        
        [_userSelectedDatesFromCalendarAsString addObject:firstDateString];
        
    }
    //NSLog(@"one time button was pressed");  //for testing
    [(UUSpecificChallengeView*)self.view toggleCheckBox];
}

- (void) facebookButtonWasPressed
{
    NSLog(@"facebook button was pressed");  //for testing
}

- (void) twitterButtonWasPressed
{
    NSLog(@"twitter button was pressed");   //for testing
}

- (void) calendarDoneButtonWasPressed
{
    NSLog(@"calendar done button was pressed");  //for testing
    [(UUSpecificChallengeView*)self.view hideCalendarView];
}

/***
 * This method will toggle the calendar buttons between
 * selected or not selected, and also send the user an alert
 * if too many dates have been selected.
 *
 */
- (void) calendarDayButtonWasPressed:(id)sender
{
    int buttonTag = (int)((UIButton*)sender).tag;
    NSLog(@"calendar day button #%d was pressed", buttonTag);  //for testing

    NSString* dateString = [NSString stringWithFormat:@"%d", buttonTag];
    
    bool buttonHasAlreadyBeenSelected = false;
    
    //first check the selected state of this button
    for (int i = 0; i < [_userSelectedDatesFromCalendarAsString count]; i++)
    {
        NSString* testString = [_userSelectedDatesFromCalendarAsString objectAtIndex:i];
        if ([testString isEqualToString:dateString])  //already selected, deselect
        {
            [_userSelectedDatesFromCalendarAsString removeObject:testString];
            buttonHasAlreadyBeenSelected = true;
            [(UUSpecificChallengeView*)self.view setButtonToUnselectedState:buttonTag];
            break;
        }
    }//end for i
    
    if (!buttonHasAlreadyBeenSelected)
    {
        if (_numDaysPossibleForChallenge <= (_numDaysUserhasAlreadyCompleted + (int)[_userSelectedDatesFromCalendarAsString count ]) )
        {
            NSString* alertMessage = @"No more days may be selected as this will exceed the number of days possible for this challenge.";
            
            //show the alert message
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

            
        }else{
            
            //add to the array
            [_userSelectedDatesFromCalendarAsString addObject:dateString];
            [(UUSpecificChallengeView*)self.view setButtonToSelectedState:buttonTag];
            
        }//end else

    }//end if !buttonAlready selected

  
    
}//end calendarDayButtonWasPressed


/******************************************************************************************************
 *
 *                              Helper Functions
 *
 ******************************************************************************************************/
/*
 * From the server function specs, the dates array will be an array of strings in the format
 *    "2014-03-20T00:00:00"
 *
 *    This function will return just the day dates as string, for example, "20"
 */

- (NSMutableArray*) getUserCompletedDatesAsString
{
    NSMutableArray* completedDatesArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i < _numDaysUserhasAlreadyCompleted; i++)
    {
        NSString* subString = [[_userCompletionDatesFromModel objectAtIndex:i] substringWithRange:NSMakeRange(8, 2)];
        [completedDatesArray addObject:subString];
    }
    
    return completedDatesArray;
    
}

/**********************************************************************************************************
 *
 *                          Auto-generated Methdods
 *
 **********************************************************************************************************/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
