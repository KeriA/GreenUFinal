//
//  UUCreateUserViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/12/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUCreateUserViewController.h"
#import "UUMainViewController.h"


#define invalidEmailString @"Please enter a valid email."
#define invalidPasswordString @"Passwords must be at least 5 characters long."
#define invalidUserNameString @"Display names must be no longer than 20 characters long."
#define emailExistsString @"Email already exists.  Please login or enter a new email."
#define invalidDisplayName @"Please enter a display name."
#define generalServerErrorString @"Server currently unavailable.  Please try again later."


@interface UUCreateUserViewController ()

@end

@implementation UUCreateUserViewController
{
    NSString* _userName;
    NSString* _userEmail;
    NSString* _userPassword;
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
        
        
        //set self as the delegate for register participant responses
        [_model setModelforRegisterParticipantScreenDelegate:self];
        
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
    self.view = [[UUCreateUserView alloc] initWithAppConstants:_appConstants];
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"";
}

/**************************************************************************************************
 *
 *                          for easy access to view
 *
 **************************************************************************************************/
- (UUCreateUserView*)getView
{
    return (UUCreateUserView*)[self view];
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
    
    // set the view's delegate to self (this controller)
    [(UUCreateUserView*)self.view setCreateUserViewDelegate:self];
    
    // set the subviews' delegates to self (this controller)
    [(UUCreateUserView*)self.view setTextFieldDelegates:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**********************************************************************************************************
 *
 *                          UUCreateUserView Delegate Methdods
 *
 **********************************************************************************************************/
#pragma - mark UUCreateUserViewDelegate Methods
- (void) signUpButtonWasPressed
{
    // first test to see if information was correctly filled
    UITextField* displayNameTextField = (UITextField *)[self.view viewWithTag:displayNameTFTag];
    //remove any leading or trailing spaces
    _userName = [self cleanDisplayName:displayNameTextField.text];
    
    //NSLog(@"display text is %@\n", displayNameString); // for testing
    
    UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTFTag];
    _userEmail = emailTextField.text;
    //NSLog(@"email text is %@\n", emailString); // for testing
    
    UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTFTag];
    _userPassword = passwordTextField.text;
    //NSLog(@"password text is %@\n", passwordString); // for testing
    
    if ([self displayNameIsOK:_userName])
    {
        if ([self emailIsOK:_userEmail])
        {
            if ([self passwordIsOK:_userPassword])
            {
                // SVProgressHUD is created as a singleton (i.e. it doesn't need to be explicitly allocated and instantiated; you directly call [SVProgressHUD <method>]).
                [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
                
                // remove any error messages
                [[self getView] updateErrorMessage:@""];
                
                [_model registerNewParticipantWithEmail:_userEmail andPassword:_userPassword andUserName:_userName];
                
            }
            else // password is not ok
            {
                [[self getView] updateErrorMessage:invalidPasswordString];
                UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTFTag];
                [passwordTextField becomeFirstResponder];
            }
        }// end email is OK
        else // email is NOT ok
        {
            [[self getView] updateErrorMessage:invalidEmailString];
            UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTFTag];
            [emailTextField becomeFirstResponder];
        }
    }// end display name is ok
    else //display name not ok
    {
        [[self getView] updateErrorMessage:invalidDisplayName];
        UITextField* displayNameTextField = (UITextField *)[self.view viewWithTag:displayNameTFTag];
        [displayNameTextField becomeFirstResponder];
        
    }// end else display name
    
}//end selectPhotoButtonWasPressed

- (void) faceBookButtonWasPressed
{
    NSLog(@"Facebook Button Was Pressed"); //for testing
    
}//end faceBookButtonWasPressed

- (void) twitterButtonWasPressed
{
    NSLog(@"Twitter Button was pressed"); //for testing
    
}//end twitterButtonWasPressed


/**********************************************************************************************************
 *
 *                                   UITextFieldDelegate Methods
 *
 **********************************************************************************************************/
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
    /*
     NSLog(@"textFieldShouldBeginEditing");
     textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];*/
    return YES;
    
}// end textFieldShouldBeginEditing

/**
 *  This method is called when the text field becomes active (i.e. became first responder)
 *
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // NSLog(@"textFieldDidEndEditing");
    
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
    /* NSLog(@"textFieldShouldEndEditing");
     textField.backgroundColor = [UIColor whiteColor];*/
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
    // do not allow spaces in passwords or emails
    if (textField.tag == passwordTFTag || textField.tag == emailTFTag)
    {
        if ([string isEqualToString:@" "])
        {
            return NO;
        }
        else {
            return YES;
        }
    }
    
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
 *  This method is called when the user presses the return key on the keyboard. In the following code,
 *  we find out which text field is active by looking at the tag property. If the "email" text field
 *  is active, the next text field, "password," should become active instead. If the "password" text
 *  field is active, "password" should resign, resigning the keyboard with it.
 *
 *  Return 'NO' to ignor (no notifications).
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"textFieldShouldReturn:");
    if (textField.tag == displayNameTFTag)
    {
        UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTFTag];
        [emailTextField becomeFirstResponder];
    }
    else if (textField.tag == emailTFTag)
    {
        UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTFTag];
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return YES;
    
    
}// end textFieldShouldReturn



/**********************************************************************************************************
 *
 *                          Server Response Recieved
 *
 **********************************************************************************************************/
-(void) registerParticipantServerDataReceived:(int)responseCase
{
    [SVProgressHUD dismiss];
    
    //if we get here, register participant was NOT successful
    switch (responseCase)
    {
        case 1001:  // invalid email format
        {
            [[self getView] updateErrorMessage:invalidEmailString];
            //set the focus to the email field
            UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTFTag];
            [emailTextField becomeFirstResponder];
            
            break;
        }
        case 1002: // invalid password format
        {
            [[self getView] updateErrorMessage:invalidPasswordString];
            //set the focus to the password field
            UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTFTag];
            [passwordTextField becomeFirstResponder];
            
            break;
        }
        case 1003: // invalid username format
        {
            [[self getView] updateErrorMessage:invalidUserNameString];
            //set the focus to the password field
            UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:displayNameTFTag];
            [passwordTextField becomeFirstResponder];
            
            break;
        }
        case 1004: //email already exists
        {
            [[self getView] updateErrorMessage:emailExistsString];
            //set focus to email field
            UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTFTag];
            [emailTextField becomeFirstResponder];
            
            break;
        }
        default: //general server error
        {
            [[self getView] updateErrorMessage:generalServerErrorString];
            //set focus to display name field
            UITextField* displayTextField = (UITextField *)[self.view viewWithTag:displayNameTFTag];
            [displayTextField becomeFirstResponder];
            
            break;
        }
            
    }//end switch
    
}//end registerParticipantServerDataRecieved

- (void) startupDataReceived:(int)responseCase
{
    [SVProgressHUD dismiss];
    
    switch (responseCase)
    {
        case SUCCESS:
        {
            // launch the main view
            //This method will replace the whole view controller stack inside the navigation controller.
            //The "old" controllers get released. The stack array begins with the root controller and its
            //last element is the topmost view controller.
            UUMainViewController* _mainViewController = [[UUMainViewController alloc] initWithModel:_model andAppConstants:_appConstants];
            [self.navigationController setViewControllers: [NSArray arrayWithObject: _mainViewController] animated: YES];
            
            break;
        }
        default:  //NETWORKERROR
        {
            NSString* alertMessage = @"Server Unavailable.  Please check your connection or try again later.";
            
            //show the alert message
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
            break;
        }
    }//end switch
    
}//end startupDataReceived

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
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    
}// end touchesBegan

/**********************************************************************************************************
 *
 *                                   helper Methods
 *
 **********************************************************************************************************/
-(BOOL) displayNameIsOK:(NSString*) displayString
{
    int stringLength = (int)[displayString length];
    if ( stringLength < 1 || stringLength > 20)
        return NO;
    //check that not all characters are spaces
    for (int i = 0; i < stringLength; i++)
    {
        
        if ([displayString characterAtIndex:i] != ' ')
            return YES;
    }
    
    return NO;  // all characters were spaces
    
}// end displayNameIsOK

-(BOOL) emailIsOK:(NSString*) emailString
{
    if ([emailString length] < 5)
        return NO;
    
    //walk through the string making sure it has an '@' character
    if ([emailString rangeOfString:@"@"].location == NSNotFound)
        return NO;
    
    return YES;
    
}//end emailIsOK:

-(BOOL) passwordIsOK:(NSString*) passwordString
{
    
    if ([passwordString length] < 5 || [passwordString length] > 25)
        return NO;
    
    return YES;
}// end passwordISOK

//remove leading and trailing spaces
- (NSString*) cleanDisplayName: (NSString*)name
{
    int stringLength = (int)[name length];
    int firstRealCharacter = -1;
    int lastRealCharacter = -1;
    
    for (int i = 0; i < stringLength; i++)
    {
        if ([name characterAtIndex:i] != ' ')
        {
            firstRealCharacter = i;
            break;
        }
        
    }
    
    // walk backwards through the name string
    for (int i = stringLength - 1; i > -1; i--)
    {
        if ([name characterAtIndex:i] != ' ')
        {
            lastRealCharacter = i;
            break;
        }
        
    }
    
    if (firstRealCharacter == -1 || lastRealCharacter == -1) // no real characters
        return @"";
    
    //create a substring
    NSRange stringRange = NSMakeRange(firstRealCharacter, lastRealCharacter - firstRealCharacter + 1);
    NSString* newName = [name substringWithRange:stringRange];
    
    return newName;
    
}// end clean name

@end
