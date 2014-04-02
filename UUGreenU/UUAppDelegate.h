//
//  UUAppDelegate.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMainViewController.h"
#import "UULoginViewController.h"
#import "UUNavigationController.h"
/*******
 *  Program notes:
 *
 *    * SVProgressHUD:  downloaded from the latest version from Github, dragged it into the project.  
 *         Also needed to add QuartzCore.framework to the project.  Then, under "supporting files" 
 *         added #import "SVProgressHUD.h"  to the file UUGreenU-Prefix.pch so that this header will
 *         be included in all classes.
 *
 *
 */



/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/
/*  Development Issues that need to be completed
 *
 *  1.  <open>
 *
 *  2.  <open>
 */
/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/

/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/
/*  stopping point notes
 *
 *  9/3/13:  Worked on UUCreateUserController and View.  Issues that need to be addressed:
 *     1.  make the fb and twitter button backdrops clear
 *     2.  center the GreenU Sign Up label - see if this needs to be done somewhere else in the app for all navigation
 *     3.  Add UITextFields to the table view cells in the controller (move these fields from the view to controller)
 *     4.  learn how to launch an agreement page from text field agreement label
 *     5.  error checking of user input, send all info to the model to be sent to server
 *     6.  in the Sign In View, update so that it references Program constants for background view, fonts, etc.
 *     7.  Learn how backup project in Git
 *
 *
 *  2/12/14  stopping point
 *     1.  Main View:  fix "highlighgted/pressed" state of tableview cells
 *     2.  Main View:  make arrows out of the cells
 *     3.  Main view:  add shadowing to text 
 *  
 *     Login View:
 *     1.  find out why some logins are rejected after already registering them
 *     2.
 *
 *
 */
/************************************************************************************************************************/
/************************************************************************************************************************/
/************************************************************************************************************************/




@interface UUAppDelegate : UIResponder <UIApplicationDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
    UUMainViewController* _mainViewController;
    UULoginViewController* _loginViewController;
    
}



@property (strong, nonatomic) UIWindow *window;

@end
