//
//  UUProfileViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUProfileViewController.h"

// user image size
#define IMAGEHEIGHT 160.0
#define IMAGEWIDTH  130.0

@interface UUProfileViewController ()

@end

@implementation UUProfileViewController
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
    self.view = [[UUProfileView alloc] initWithAppConstants:_appConstants];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set the view's delegate to self (this controller)
    [(UUProfileView*)self.view setProfileViewDelegate:self];
    [(UUProfileView*)self.view setTextFieldDelegates:self];

}//end viewDidLoad

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"Profile";
    [(UUProfileView*)self.view updateUserName:[_model getUserName]];
    [(UUProfileView*)self.view updateTeamName:[_model getUserTeamName]];
    UIImage* userProfileImage = [_model getUserImage];
    UIImage* userProfileImageSelected = userProfileImage;
    if (userProfileImage == nil){
        userProfileImage = [UIImage imageNamed:@"genericUserImage.png"];
        userProfileImageSelected = [UIImage imageNamed:@"genericUserImageSelected.png"];
    }
    [(UUProfileView*)self.view updateUserImage:userProfileImage andSelectedImage:userProfileImageSelected];
    NSString* userpassword = [_model getUserPassword];
    int length = [userpassword length];
    
    NSString* maskedPassword = @"*";
    for (int i = 0; i < length - 1; i++)
    {
        maskedPassword = [maskedPassword stringByAppendingString:@"*"];
    }
    [(UUProfileView*)self.view updateUserPassword:maskedPassword];
    
    
    
}//end viewWillAppear


/**********************************************************************************************************
 *
 *                          UUProfileView Delegate Methdods
 *
 **********************************************************************************************************/
#pragma - mark UUProfileViewDelegate Methods
- (void) userImageButtonWasPressed
{
    //NSLog(@"User Image Button Was Pressed"); //for testing
    UIImagePickerController*  _imagePickerController = [[UIImagePickerController alloc] init];
    [_imagePickerController setDelegate:self];
    
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
    
}//end userImageButtonWasPressed

- (void) changeUserNameButtonWasPressed
{
    NSLog(@"Change User Name Button Was Pressed"); //for testing

}// end changeUserNameButtonWasPressed

- (void) changeTeamButtonWasPressed
{
    NSLog(@"Change Team Button Was Pressed"); //for testing
    
}//end changeTeamButtonWasPressed

- (void) changePasswordButtonWasPressed
{
    NSLog(@"Change Password Button Was Pressed"); //for testing
    
}//end changePasswordButtonWasPressed


/**********************************************************************************************************
 *
 *                          UUImageViewController Delegate Methdods
 *
 **********************************************************************************************************/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
    
    
    UIImage* originalImage = nil;
    originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if(originalImage==nil)
    {
        originalImage = [info objectForKey:UIImagePickerControllerCropRect];
    }
   
    //resize the photo so it will fit in the square
    CGSize imageSize = CGSizeMake(IMAGEWIDTH, IMAGEHEIGHT);
    
    UIImage* resizedImage = [self imageWithImage:originalImage scaledToSize:imageSize];
    
    //update user info - send new pic to server
    
    [(UUProfileView*)self.view updateUserImage:resizedImage andSelectedImage: resizedImage];
    [_model setUserProfileImage:resizedImage];
    
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
       [self dismissViewControllerAnimated:TRUE completion:nil];
}
/***
 * This resizes the image so it will fit in the alloted space
 *
 */
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
    //CGRect cropRect = CGRectMake(40, 0, 640, 960);
    
    //CGImageRef imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
    //[self.imageView setImage:[UIImage imageWithCGImage:imageRef]];

}//end image


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
    return NO;
    
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
    /*
    if (textField.tag == emailTag)  //emailtextfield
    {
        UITextField* passwordTextField = (UITextField *)[self.view viewWithTag:passwordTag];
        [passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }*/
    return YES;
    
}// end textFieldShouldReturn

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
