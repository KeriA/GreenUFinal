//
//  UULoginViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UULoginViewController.h"
#import "UUMainViewController.h" //keep this here to avoid circular referencing:
//  mainviewcontroller imports loginview controller and viceversa

@interface UULoginViewController ()

@end

@implementation UULoginViewController
{
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
        
        // set delegate to recieve responces from model
        [_model setModelForLoginScreenDelegate:self];
        
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
    self.view = [[UULoginView alloc] initWithAppConstants:_appConstants];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    //In your UIViewController there is a title property and it is that property
    //that will be displayed by the NavigationController. So when pushing a new
    //UIViewController onto the navigation stack set the title of that UIViewController
    //to whatever is appropriate.
    self.title  = @"";
    
    //hide the 'back' button
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
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
    [(UULoginView*)self.view setLoginViewDelegate:self];
    [(UULoginView*)self.view setTextFieldDelegates:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************************************************************************************
 *
 *                              UULoginViewDelegateMethods
 *
 ******************************************************************************************************/
-(void) forgotPasswordButtonWasPressed
{
    NSLog(@"Forgot Button Was Pressed"); //for testing
    
    // first test to see if information was correctly filled
    UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTag];
    _userEmail = emailTextField.text;

    
    if ([self emailIsOK:_userEmail])
    {
        [SVProgressHUD show];
        [_model userRequestsPassword:_userEmail];
        
    }else{
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid email format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        //set focus to email text field
        UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTag];
        [emailTextField becomeFirstResponder];

    }
    
}//end forgot button

-(void) loginButtonWasPressed
{
    //resign the keyboard
    [self.view endEditing:YES];
    
    // first test to see if information was correctly filled
    UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTag];
    _userEmail = emailTextField.text;
    //NSLog(@"email text is %@\n", emailString); // for testing
    
    UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTag];
    _userPassword = passwordTextField.text;
    
    if ([self emailIsOK:_userEmail])
    {
        if ([self passwordIsOK:_userPassword])
        {
            
            // SVProgressHUD is created as a singleton (i.e. it doesn't need to be explicitly allocated and instantiated; you directly call [SVProgressHUD <method>]).
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            
            [_model loginFromLoginScreenWithEmail:_userEmail andPassword:_userPassword];
            
        }
        else //password not ok
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Password must be at least 5 characters long." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            //set focus to password text field
            UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTag];
            [passwordTextField becomeFirstResponder];
        }
    }
    else //email not ok
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter a valid email format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        //set focus to email text field
        UITextField* emailTextField = (UITextField *)[self.view viewWithTag:emailTag];
        [emailTextField becomeFirstResponder];
    }
    
}
-(void) faceBookLoginButtonWasPressed
{
    NSLog(@"FaceBook button was pressed\n"); //for testing
}
-(void) signUpButtonWasPressed
{
    //NSLog(@"Sign Up button was pressed\n"); //for testing
    
    UUCreateUserViewController* createUserViewController = [[UUCreateUserViewController alloc] initWithModel:_model andAppConstants:_appConstants];
    [[self navigationController] setNavigationBarHidden:NO];
    
    
    //title property is set in the 'view will appear' method of the 'createUserViewController'
    [[self navigationController] pushViewController:createUserViewController animated:TRUE];
    
}

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
    //NSLog(@"textFieldShouldBeginEditing");
    //textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
    
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
    if ([string isEqualToString:@" "])
    {
        return NO;
    }
    else {
        return YES;
    }
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
    NSLog(@"textFieldShouldReturn:");

    if (textField.tag == emailTag)  //emailtextfield
    {
        UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTag];
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
    //NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    
}// end touchesBegan



/**********************************************************************************************************
 *
 *                                  Server Callback functions
 *
 **********************************************************************************************************/

- (void) loginFromLoginScreenServerDataReceived:(int)responseCase
{
    [SVProgressHUD dismiss];
    
    //if we get here, login was unsuccessful
    NSString* alertMessage;
        
        
    switch (responseCase)
    {
        case NETWORKERROR:
        {
            alertMessage = @"Server Unavailable.  Please check your connection or try again later.";
            break;
        }
        case 1001:  // invalid email format
        {
            alertMessage = @"Please enter a valid email format.";
            break;
        }
        case 1004:  //login failure
        {
            alertMessage = @"Either an incorrect email or password was entered.  Please check your email address and password and try again.";
            break;
        }
        default:
        {
            alertMessage = @"Either an incorrect email or password was entered.  Please check your email address and password and try again.";
            break;
        }
                
    }//end switch
    
    //show the alert message
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
        
    //set the focus back to the email field
    UITextField* emailTextField = (UITextField*)[self.view viewWithTag:emailTag];
    [emailTextField becomeFirstResponder];
    
    
}//end startupDataReceived


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
}//end startupdata received

-(void) responseForRequestPasswordReceived:(int)responseCase
{
    [SVProgressHUD dismiss];
    
    NSString* alertMessage;
    
    switch (responseCase)
    {
        case (SUCCESS):
        {
            alertMessage = @"Please check your email later for your password.";
            break;
        }
        case (NETWORKERROR):
        {
            alertMessage = @"A Network error has occurred.  Please check your connection and try again.";
            break;
        }
        case (1001):
        {
            alertMessage = @"Please enter a valid email format.";
            break;
        }
        case (1006):
        {
            alertMessage = @"The email entered has not been registered with Greenu.  Please check your email or sign up for GreenU.";
            break;
        }
        default:
        {
            alertMessage = @"A Network error has occurred.  Please check your connection and try again.";
            break;
        }
    }
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}//end requestpassword



/**********************************************************************************************************
*
*                                   helper Methods
*
**********************************************************************************************************/
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







@end
