//
//  UUSplashViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 4/2/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

/******
 *  Notes:  According to employees at Pixio (they create apps), an application cannot
 *          request data while still in the app delegate mode, or Apple will not approve the
 *          app.  This View was created to look like a seamless extension of the app delegate
 *          and shows the splash screen while requesting server data.
 *
 *          First, this controller will check for user login status
 *          and determine whether to show the login screen or the main menu.
 *
 *
 *          Once the user is successfully logged in, the splash view is shown to the user while basic info is
 *          requested from the server:
 *              1)  current month and topic 
 *              2)  previous month and topics
 *
 *
 *
 */

#import "UUSplashViewController.h"

@interface UUSplashViewController ()


@end

@implementation UUSplashViewController
{
    //used so that certain methods are
    //only called once (one time when the controller object
    //is created)
    //Boolean _firstTimeLoading;
    
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
        
        // the model will comunicate to this form when startup data is received
        [_model setModelForSplashScreenDelegate:self];
        
        //_firstTimeLoading = true;
        
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
    self.view = [[UUSplashView alloc] initWithAppConstants:_appConstants];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    //In your UIViewController there is a title property and it is that property
    //that will be displayed by the NavigationController. So when pushing a new
    //UIViewController onto the navigation stack set the title of that UIViewController
    //to whatever is appropriate.
    self.title  = @"";
    
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

/***
 *  
 *  Log the user in, either from stored email and password, having the 
 *  user enter their email and password, or by creating a new user.
 *
 */
- (void)viewDidAppear:(BOOL)animated
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [_model loginFromSplashScreen];
    
}//end viewDidAppeart5


/**********************************************************************************************************
 *
 *                          Server Response Recieved  (UUSModelForSplashScreenDelegate)
 *
 **********************************************************************************************************/
-(void) loginFromSplashScreenServerDataReceived:(int)responseCase
{
    //if we get here, the login was unsuccessful.  Navigate to login page
    [SVProgressHUD dismiss];
    
    
    //This method will replace the whole view controller stack inside the navigation controller.
    //The "old" controllers get released. The stack array begins with the root controller and its
    //last element is the topmost view controller.
    _loginViewController = [[UULoginViewController alloc]initWithModel:_model andAppConstants:_appConstants];
    [self.navigationController setViewControllers: [NSArray arrayWithObject: _loginViewController] animated: YES];

    
}//end LoginFromSplashScreenServerDataRecived



- (void) startupDataReceived:(int)responseCase
{
    [SVProgressHUD dismiss];
    
    switch (responseCase)
    {
        case SUCCESS: //continue to main menu
        {
            //This method will replace the whole view controller stack inside the navigation controller.
            //The "old" controllers get released. The stack array begins with the root controller and its
            //last element is the topmost view controller.
            _mainViewController = [[UUMainViewController alloc] initWithModel:_model andAppConstants:_appConstants];
            [self.navigationController setViewControllers: [NSArray arrayWithObject: _mainViewController] animated: YES];
            
            break;
        }
        default: //NETWORKERROR
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"Server Unavailable.  Please check your connection or try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [alert show];
            
            //This method will replace the whole view controller stack inside the navigation controller.
            //The "old" controllers get released. The stack array begins with the root controller and its
            //last element is the topmost view controller.
            _loginViewController = [[UULoginViewController alloc]initWithModel:_model andAppConstants:_appConstants];
            [self.navigationController setViewControllers: [NSArray arrayWithObject: _loginViewController] animated: YES];
            

            break;
        }
            
    }//end switch
    
    
}//end serverFinishedStartupCalls



@end
