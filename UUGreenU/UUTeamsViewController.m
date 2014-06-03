//
//  UUTeamsViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUTeamsViewController.h"

@interface UUTeamsViewController ()

@end

@implementation UUTeamsViewController
{
    NSString* _userCurrentTeam;
    NSString* _userSelectedTeamIDString;
}
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
        
        //get the user's current team
        _userCurrentTeam = [_model getUserTeamName];
        _userSelectedTeamIDString = @"";
        
        //set the response from model delegate
        [_model modelforNewTeamDelegate];
        
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
    self.view = [[UUTeamsView alloc] initWithAppConstants:_appConstants];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set view delegates
    [(UUTeamsView*)[self view] setTeamsViewDelegate:self];
    [(UUTeamsView*)self.view setTextFieldDelegates:self];
    [(UUTeamsView*)self.view setPickerDataSource:self];
    [(UUTeamsView*)self.view setPickerDelegate:self];
    [(UUTeamsView*)self.view setCurrentTeam:_userCurrentTeam];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"";
}


/******************************************************************************************************
 *
 *                          UUTeamsView Delegate Methdods
 *
 ******************************************************************************************************/
- (void) schoolButtonWasPressed
{
    NSLog(@"School Button Was Pressed");  //for testing
    _userSelectedTeamIDString = @"";
    [(UUTeamsView*)self.view setPickersForCategory:SCHOOLBUTTONTAG];
    [(UUTeamsView*)self.view showPickerView: 1];
    [(UUTeamsView*)self.view disableTeamsButtons];
    
}

- (void) businessButtonWasPressed
{
    NSLog(@"Business Button Was Pressed");  //for testing
    _userSelectedTeamIDString = @"";
    [(UUTeamsView*)self.view setPickersForCategory:BUSINESSBUTTONTAG];
    [(UUTeamsView*)self.view showPickerView: 2];
    [(UUTeamsView*)self.view disableTeamsButtons];
}

- (void) otherButtonWasPressed
{
    NSLog(@"Other Button Was Pressed");  //for testing
    _userSelectedTeamIDString = @"";
    [(UUTeamsView*)self.view setPickersForCategory:OTHERBUTTONTAG];
    [(UUTeamsView*)self.view showPickerView: 3];
    [(UUTeamsView*)self.view disableTeamsButtons];
    
}

- (void) newTeamCheckBoxButtonWasPressed:(id)Sender
{
    int buttonTag = (int)((UIButton*)Sender).tag;
    
    //NSString* buttonString;//for testing
    if (buttonTag == SCHOOLBUTTONTAG){
        //buttonString = @"School";
        [(UUTeamsView*)self.view setSchoolButtonPressedResults];
        
    }else if (buttonTag == BUSINESSBUTTONTAG){
        //buttonString = @"Business";
        [(UUTeamsView*)self.view setBusinessButtonPressedResults];
        
    }else{ //buttonTag == OTHERBUTTONTAG
        //buttonString = @"Other";
        [(UUTeamsView*)self.view setOtherButtonPressedResults];

    }
    
    //NSLog(@"new team button #%@ was pressed", buttonString);  //for testing
    
}//end newTeamButtonWasPressed

- (void) requestNewTeamButtonWasPressed
{
    NSLog(@"Request New Team Button Was Pressed");  //for testing
    
    if ([(UUTeamsView*)self.view teamNameLength] < 5)
    {
        NSString* alertMessage = @"Team names must be at least five characters long.";
        
        //show the alert message
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return;
    }else if ( ![(UUTeamsView*)self.view categorySelected] )
    {
        NSString* alertMessage = @"Please select a category.";
        
        //show the alert message
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }else{ //tell server to request a new team
        
        [SVProgressHUD show];
                
        NSString* newTeamName = [(UUTeamsView*)self.view getNewTeamName];
        NSString* newTeamType = [(UUTeamsView*)self.view getNewTeamType];
        [_model requestNemTeam:newTeamName andType:newTeamType];
    }
 
}//end request button was pressed

- (void) pickerDoneButtonWasPressed
{
    NSLog(@"Picker Done Button Was Pressed");  //for testing
    [(UUTeamsView*)self.view hidePickerView];
    [(UUTeamsView*)self.view enableTeamsButtons];
 
}

- (void) joinTeamButtonWasPressed
{
    NSLog(@"Join Selected Team Button Was Pressed");  //for testing
    
    NSString* alertMessage;
    
    if ([_userSelectedTeamIDString isEqualToString:@""])
    {
        alertMessage = @"Please select a team";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
    }else{ //send request to server
        
        [SVProgressHUD show];
        [_model changeUserTeam:_userSelectedTeamIDString];
    }
    
}//end joinTeamButtonWasPressed

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
    int count;
    NSString* categoryString;
    
    switch (pickerView.tag)
    {
        case SCHOOLBUTTONTAG:
        {
            categoryString = SCHOOL;
            break;
        }
        case BUSINESSBUTTONTAG:
        {
            categoryString = BUSINESS;
            break;
        }
        default:
        {
            categoryString = OTHER;
            break;
        }
    }//end switch

    count = [_model getNumberOfTeamsForCategory:categoryString];
    
    return count;
    
}//end numberOfRows



/***********************************************************************************************
 *
 *                          UIPickerViewDelegate methods
 *
 ***********************************************************************************************/
#pragma mark - UIPickerViewDelegate

/***
 *  This method allows for customization of the text
 */
- (NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString* categoryString;
    
    switch (pickerView.tag)
    {
        case SCHOOLBUTTONTAG:
        {
            categoryString = SCHOOL;
            break;
        }
        case BUSINESSBUTTONTAG:
        {
            categoryString = BUSINESS;
            break;
        }
        default:
        {
            categoryString = OTHER;
            break;
        }
    }
    
    NSString* titleString = [_model getTeamNameforCategory:categoryString andRowNumber:(int)row];
    
    
    //NSAttributedString *attString = [[NSAttributedString alloc] initWithString:labelString attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:titleString attributes:@{NSForegroundColorAttributeName:[_appConstants mustardYellowColor]}];
    
    return attString;
    
}//end attributedTitleForRow

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //NSLog(@"Take Picker Button Was Pressed"); //for testing
    NSString* categoryString;
    
    switch (pickerView.tag)
    {
        case SCHOOLBUTTONTAG:
        {
            categoryString = SCHOOL;
            break;
        }
        case BUSINESSBUTTONTAG:
        {
            categoryString = BUSINESS;
            break;
        }
        default:
        {
            categoryString = OTHER;
            break;
        }
    }
    
    _userSelectedTeamIDString = [_model getTeamIdAsStringForCategory:categoryString andRowNumber:(int)row];
    
    
}//end didSelectRow



/******************************************************************************************************
 *
 *                              UITextFieldDelegate Methods
 *
 ******************************************************************************************************/
#pragma - mark UITextFieldDelegate Methods

/** FYI
 *  Some notes about delegate methods and notifications:  We can use the methods provided by the delegate,
 *  or alternatively, we can add an observer to listen for the notifications.  Example:
 *
 *  You can get that event in textField's delegate using textFieldDidBeginEditing: method.
 *  Alternatively you can add observer to listen for UITextFieldTextDidBeginEditingNotification notification.
 *
 *  Here are the notifications provided from the UITextFields:
 *
 *  UIKIT_EXTERN NSString *const UITextFieldTextDidBeginEditingNotification;
 *  UIKIT_EXTERN NSString *const UITextFieldTextDidEndEditingNotification;
 *  UIKIT_EXTERN NSString *const UITextFieldTextDidChangeNotification;
 *
 */

/**
 *  This method is called just before the text field becomes active. This is a good place to customize
 *  the behavior of your application. In this instance, the background color of the text field changes
 *  when this method is called to indicate the text field is active. (If 'no' is returned, editing is disallowed)
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == NEWTEAMTAG){
        //NSLog(@"textFieldShouldBeginEditing");
        [(UUTeamsView*)self.view disableTeamsButtons];
        textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
        
        [(UUTeamsView*)self.view liftTextField];
        return YES;
    }else{
        return NO;
    }
    
}// end textFieldShouldBeginEditing

/**
 *  This method is called when the text field becomes active (i.e. became first responder)
 *
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"textFieldDidEndEditing");
    
}// end textFieldDidBeginEditing

/**
 *  This method is called JUST BEFORE the text field becomes inactive.  Here we set the background color
 *  back to white so that the text field can go back to its original color. This method allows
 *  cusomization of the application behavior as the text field becomes inactive.
 *
 *  Returning YES allows editing to stop and resign first responder status.  NO disallows the editing
 *  session to end.
 *
 */
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //NSLog(@"textFieldShouldEndEditing");
    //textField.backgroundColor = [UIColor whiteColor];
    return YES;
    
}// end textFieldShouldEndEditing


/**
 *  This method is called WHEN the textfield becomes inactive.  This method allows cusomization of
 *  the application behavior as the text field becomes inactive.
 *
 *  This method may be called if forced even if shouldEndEditing returns NO
 *  (e.g. view removed from window) or endEditing:YES called
 *
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == NEWTEAMTAG){
        [(UUTeamsView*)self.view returnTextField];
    }
    //NSLog(@"textFieldDidEndEditing");
    
}// end textFieldDidEndEditing


/**
 *  This method is called each time the user types a character on the keyboard. In fact, this
 *  method is called JUST BEFORE a character is displayed.  The method is useful if certain
 *  characters need to be restricted from a text field.  In the code below, the "#" has been
 *  disallowed.
 *
 *  Returning 'NO' will not change the text.
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"textField:shouldChangeCharactersInRange:replacementString:");
    /*if ([string isEqualToString:@" "])
    {
        return NO;
    }
    else {
        return YES;
    }*/
    
    return YES;
    
}// end shouldChangeCharactersInRange

/**
 *  This method is called when the user presses the clear button, the gray "x," inside the text field.
 *  Before the active text field is cleared, this method gives an opportunity to make any needed customizations.
 *  Return NO to ignore (no notifications).
 *
 */
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    //NSLog(@"textFieldShouldClear:");
    return YES;
    
}// end textFieldShouldClear

/**
 *  This method is called when the user presses the return key on the keyboard. I
 *
 *  Return 'NO' to ignor (no notifications).
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"textFieldShouldReturn:");
    [(UUTeamsView*)self.view enableTeamsButtons];
    textField.backgroundColor = [UIColor grayColor];
    [textField resignFirstResponder];
    return YES;
    
}// end textFieldShouldReturn

/******************************************************************************************************
 *
 *                              Response from Model
 *
 ******************************************************************************************************/
-(void) responseforRequestNewTeamReceived:(int)responseCase
{
    NSString* alertMessage;
    [SVProgressHUD dismiss];
    
    if (responseCase == SUCCESS)
    {
        alertMessage = @"Your request has been submitted.  Please check back later for team listing.";
        
    }else if (responseCase == NETWORKERROR)
    {
        alertMessage = @"A network error has occured.  Please check your connection and try again.";
        
    }else{
        
        alertMessage = @"The team and category already exists.";
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}//end responseForRequestNewTEam

- (void) responseForChangeTeamResponseReceived:(int)responseCase
{
    [SVProgressHUD dismiss];
    
    if (responseCase == SUCCESS){
        //update the view
        _userCurrentTeam = [_model getUserTeamName];
        [(UUTeamsView*)self.view setCurrentTeam:_userCurrentTeam];
        
    }else{//NETWORKERROR
        NSString* alertMessage = @"A network error has occured.  Please check your connection and try again.";
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
}//end responseForChangeTeam

/**********************************************************************************************************
 *
 *                                   UIResponder Methods
 *
 **********************************************************************************************************/
#pragma - mark UIResponder Methods

/*
 *  Resigning the keyboard when the background is tapped can be accomplished in different ways.
 *  The code below is an example of one technique - the user can dismiss the keyboard simply
 *  by tapping on the screen.
 */
/*-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesBegan:withEvent:");
    [(UUTeamsView*)self.view enableTeamsButtons];
    [(UUTeamsView*)self.view resetTextFieldColor];
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    
}// end touchesBegan
*/


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
