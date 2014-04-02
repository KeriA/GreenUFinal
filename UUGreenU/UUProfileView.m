//
//  UUProfileView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUProfileView.h"

@implementation UUProfileView
{
    UIButton*    _userImageButton;
    UILabel*     _userNameLabel;
    UIButton*    _changeUserNameButton;
    UILabel*     _teamLabel;
    UITextField* _teamTextField;
    UIButton*    _changeTeamButton;
    UILabel*     _passwordLabel;
    UITextField* _passwordTextField;
    UIButton*    _changePasswordButton;
    
}

@synthesize profileViewDelegate;

/***
 *
 *      Constructor
 */
- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;
{
    self = [super init];
    if (self) {
        // Initialization code
        
        _appConstants = appConstants;
        [self setBackgroundColor:[UIColor colorWithPatternImage:[appConstants getBackgroundImage]]];
        
        //create subviews
        
        
        //this button just looks like a picture
        _userImageButton= [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        _userImageButton.backgroundColor = [UIColor clearColor];
        [_userImageButton setTitle:@"" forState:UIControlStateNormal];
        //[_userImageButton setImage:[UIImage imageNamed:@"genericUserImage.png"] forState:UIControlStateNormal];
        //[_userImageButton setImage:[UIImage imageNamed:@"genericUserImageSelected.png"] forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewController
        [_userImageButton addTarget: profileViewDelegate
                            action:@selector(userImageButtonWasPressed)
                  forControlEvents:UIControlEventTouchDown];
        
        
        _userNameLabel = [[UILabel alloc] init];
        [_userNameLabel setBackgroundColor:[UIColor clearColor]];
        [_userNameLabel setText:@""];
        [_userNameLabel setTextColor:[UIColor whiteColor]];
        [_userNameLabel setFont:[_appConstants getStandardFontWithSize:14.0]];
        [_userNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_userNameLabel setNumberOfLines:2];
        [_userNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        //this button looks like a link
        _changeUserNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeUserNameButton.backgroundColor = [UIColor clearColor];
        CALayer* theLayer = [_changeUserNameButton layer];
        [theLayer setMasksToBounds:YES];
        [theLayer setCornerRadius: 6.0];
        [theLayer setBorderWidth: 0.0];// we want this button to look like a link, so no border
        [theLayer setBorderColor:[UIColor clearColor].CGColor];
        // This button needs to look like a link - with underlined text - use NSAttributed String
        NSDictionary* underlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* attStringNormal = [[NSAttributedString alloc] initWithString:@"Change User Name" attributes:underlineAttributeNormal];
        [_changeUserNameButton setAttributedTitle:attStringNormal forState:UIControlStateNormal];
        
        NSDictionary* underlineAttributeHighlighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* attStringHighlighted = [[NSAttributedString alloc] initWithString:@"Change User Name" attributes:underlineAttributeHighlighted];
        [_changeUserNameButton setAttributedTitle:attStringHighlighted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_changeUserNameButton addTarget: profileViewDelegate
                          action:@selector(changeUserNameButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];

        _teamLabel = [[UILabel alloc] init];
        [_teamLabel setBackgroundColor:[UIColor clearColor]];
        [_teamLabel setText:@"Team:"];
        [_teamLabel setTextColor:[UIColor whiteColor]];
        [_teamLabel setFont:[_appConstants getStandardFontWithSize:18.0]];
        [_teamLabel setTextAlignment:NSTextAlignmentLeft];
        [_teamLabel setNumberOfLines:2];
        [_teamLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        // create the textfields and set its delegates
        _teamTextField = [[UITextField alloc] init];
        _teamTextField.placeholder = @"";
        _teamTextField.backgroundColor = [UIColor grayColor];
        _teamTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _teamTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _teamTextField.font = [_appConstants getStandardFontWithSize:12.0];
        _teamTextField.borderStyle = UITextBorderStyleRoundedRect;
        _teamTextField.keyboardType = UIKeyboardTypeAlphabet;
        _teamTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _teamTextField.returnKeyType = UIReturnKeyDone;
        _teamTextField.textAlignment = NSTextAlignmentLeft;
        _teamTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _teamTextField.tag = teamTag;  // used to identify this text field in the delegate methods
        _teamTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _teamTextField.layer.borderWidth = 0.0;
        //[_emailTextField setDelegate: signInTextFieldDelegate]; // could not get code to work - use method created below

        //this button looks like a link
        _changeTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeTeamButton.backgroundColor = [UIColor clearColor];
        CALayer* teamLayer = [_changeTeamButton layer];
        [teamLayer setMasksToBounds:YES];
        [teamLayer setCornerRadius: 6.0];
        [teamLayer setBorderWidth: 0.0];// we want this button to look like a link, so no border
        [teamLayer setBorderColor:[UIColor clearColor].CGColor];
        // This button needs to look like a link - with underlined text - use NSAttributed String
        NSDictionary* teamUnderlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* teamAttStringNormal = [[NSAttributedString alloc] initWithString:@"Change Team" attributes:teamUnderlineAttributeNormal];
        [_changeTeamButton setAttributedTitle:teamAttStringNormal forState:UIControlStateNormal];
        
        NSDictionary* teamUnderlineAttributeHighlighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* teamAttStringHighlihgted = [[NSAttributedString alloc] initWithString:@"Change Team" attributes:teamUnderlineAttributeHighlighted];
        [_changeTeamButton setAttributedTitle:teamAttStringHighlihgted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_changeTeamButton addTarget: profileViewDelegate
                                  action:@selector(changeTeamButtonWasPressed)
                        forControlEvents:UIControlEventTouchDown];

        
        
        _passwordLabel = [[UILabel alloc] init];
        [_passwordLabel  setBackgroundColor:[UIColor clearColor]];
        [_passwordLabel  setText:@"Password:"];
        [_passwordLabel  setTextColor:[UIColor whiteColor]];
        [_passwordLabel  setFont:[_appConstants getStandardFontWithSize:18.0]];
        [_passwordLabel  setTextAlignment:NSTextAlignmentLeft];
        [_passwordLabel setNumberOfLines:2];
        [_passwordLabel  setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        
        // create the textfields and set its delegates
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"";
        _passwordTextField.backgroundColor = [UIColor grayColor];
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.font = [_appConstants getStandardFontWithSize:12.0];
        _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.textAlignment = NSTextAlignmentLeft;
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField.tag = passwordTag;  // used to identify this text field in the delegate methods
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.layer.borderWidth = 0.0;
        //[_emailTextField setDelegate: signInTextFieldDelegate]; // could not get code to work - use method created below
        
        
      
        //this button looks like a link
        _changePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changePasswordButton.backgroundColor = [UIColor clearColor];
        CALayer* passwordLayer = [_changeUserNameButton layer];
        [passwordLayer setMasksToBounds:YES];
        [passwordLayer setCornerRadius: 6.0];
        [passwordLayer setBorderWidth: 0.0];// we want this button to look like a link, so no border
        [passwordLayer setBorderColor:[UIColor clearColor].CGColor];
        // This button needs to look like a link - with underlined text - use NSAttributed String
        NSDictionary* passwordUnderlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* passwordAttStringNormal = [[NSAttributedString alloc] initWithString:@"Change Password" attributes:passwordUnderlineAttributeNormal];
        [_changePasswordButton setAttributedTitle:passwordAttStringNormal forState:UIControlStateNormal];
        
        NSDictionary* passwordUnderlineAttributeHighlighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* passwordAttStringHighlihgted = [[NSAttributedString alloc] initWithString:@"Change Password" attributes:passwordUnderlineAttributeHighlighted];
        [_changePasswordButton setAttributedTitle:passwordAttStringHighlihgted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_changePasswordButton addTarget: profileViewDelegate
                                  action:@selector(changePasswordButtonWasPressed)
                        forControlEvents:UIControlEventTouchDown];

        
        
        //add subviews to view
        [self addSubview:_userImageButton];
        [self addSubview:_userNameLabel];
        [self addSubview:_changeUserNameButton];
        [self addSubview:_teamLabel];
        [self addSubview:_teamTextField];
        [self addSubview:_changeTeamButton];
        [self addSubview:_passwordLabel];
        [self addSubview:_passwordTextField];
        [self addSubview:_changePasswordButton];
        

    }
    return self;
    
}//end Constructor


/**************************************************************************************************
 *
 *                          layout subviews
 *
 **************************************************************************************************/
#pragma - mark layoutSubviews
/***
 *  In the layout subviews, we need to access the original frame, and then do a bunch
 *  of math to properly create the frames for all of the subviews
 *
 */
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    
    
    // Get the bounds of the current view. We will use this to dynamically calculate the frames of our subviews
    CGRect bounds = [self bounds];
    
    // We want the background image to show up, so we need to adjust the width and height of the rectangles accordingly.
    // We can get a width adjustment immediately.
    //
    // The following notes are FYI to explain how CGRectInset works:
    // create the rectangles so that they are a bit smaller (showing more background) and
    // centered on the same point  (using CGRectInset)
    //  CGRectInsetParameters:
    //        rect:  The source CGRect structure.
    //          dx:  The x-coordinate value to use for adjusting the source rectangle.
    //               To create an inset rectangle, specify a positive value. To create a larger,
    //               encompassing rectangle, specify a negative value.
    //          dy:  The y-coordinate value to use for adjusting the source rectangle.
    //               To create an inset rectangle, specify a positive value. To create a larger,
    //               encompassing rectangle, specify a negative value.
    
    CGFloat boundsXInset = bounds.size.width * 0.10; // take off a percentage of the width
    CGFloat boundsYInset = bounds.size.height * 0.10; // take off a percentage of the width
    bounds = CGRectInset(bounds, boundsXInset, boundsYInset);
    
    // the specific rects that will be used for subviews
    CGRect topRect;      // to hold all the sub-rects for the username and image
    CGRect teamRect;     // to hold all the sub-rects for the teams
    CGRect teamTopRect;
    CGRect teamBottomRect;
    CGRect teamSpacerRect;
    CGRect passwordRect; // to hold all the sub-rects for the password
    CGRect passTopRect;
    CGRect passBottomRect;
    CGRect passSpacerRect;
    CGRect profileImageButtonRect;    // this will hold the profile image
    CGRect spacerRect;
    CGRect spacer2Rect;
    CGRect userNameLabelRect;
    CGRect changeUserNameButtonRect;
    CGRect teamLabelRect;
    CGRect teamTextFieldRect;
    CGRect changeTeamButtonRect;
    CGRect passwordLabelRect;
    CGRect passwordTextFieldRect;
    CGRect changePasswordButtonRect;
    
    // user profile image and name
    CGRectDivide(bounds, &topRect, &spacer2Rect,  bounds.size.height/2.0, CGRectMinYEdge);
    topRect = CGRectInset(topRect, 0.0, topRect.size.height * .15);
    CGRectDivide(topRect, &profileImageButtonRect, &spacerRect, topRect.size.width / 2.0, CGRectMinXEdge);
    CGRectDivide(spacerRect, &spacerRect, &userNameLabelRect, spacerRect.size.width / 10.0, CGRectMinXEdge);
    userNameLabelRect = CGRectInset(userNameLabelRect, 0, userNameLabelRect.size.height* .20);
    CGRectDivide(userNameLabelRect, &userNameLabelRect, &changeUserNameButtonRect, userNameLabelRect.size.height/ 2.0, CGRectMinYEdge);
    
    // user team info
    CGRectDivide(spacer2Rect, &spacer2Rect, &teamRect, spacer2Rect.size.height/6.0, CGRectMinYEdge);
    CGRectDivide(teamRect, &teamRect, &passwordRect, teamRect.size.height/2.0, CGRectMinYEdge);
    teamRect = CGRectInset(teamRect, 0.0, teamRect.size.height * .20);
    passwordRect = CGRectInset(passwordRect, 0.0, passwordRect.size.height * .20);
    CGRectDivide(teamRect, &teamTopRect, &teamBottomRect, teamRect.size.height/2.0, CGRectMinYEdge);
    teamTopRect = CGRectInset(teamTopRect, 0.0, teamTopRect.size.height * .10);
    CGRectDivide(teamTopRect, &teamLabelRect, &teamTextFieldRect, teamTopRect.size.width/3.0, CGRectMinXEdge);
    teamLabelRect = CGRectInset(teamLabelRect, teamLabelRect.size.width * .10, 0.0);
    CGRectDivide(teamBottomRect, &teamSpacerRect, &changeTeamButtonRect, teamBottomRect.size.width / 3.0, CGRectMinXEdge);
    
    
    // password team info
    CGRectDivide(passwordRect, &passTopRect, &passBottomRect, passwordRect.size.height/2.0, CGRectMinYEdge);
    passTopRect = CGRectInset(passTopRect, 0.0, passTopRect.size.height * .10);
    CGRectDivide(passTopRect, &passwordLabelRect, &passwordTextFieldRect, passTopRect.size.width/2.0, CGRectMinXEdge);
    passwordLabelRect = CGRectInset(passwordLabelRect, passwordLabelRect.size.width * .10, 0.0);
    CGRectDivide(passBottomRect, &passSpacerRect, &changePasswordButtonRect, passBottomRect.size.width/2.0, CGRectMinXEdge);
    

    

    NSLog(@"Profile width is %f and height is %f", profileImageButtonRect.size.width, profileImageButtonRect.size.height);
    
    
    // set the frames
    [_userImageButton       setFrame:profileImageButtonRect];
    [_userNameLabel         setFrame:userNameLabelRect];
    [_changeUserNameButton  setFrame:changeUserNameButtonRect];
    [_teamLabel             setFrame:teamLabelRect];
    [_teamTextField         setFrame:teamTextFieldRect];
    [_changeTeamButton      setFrame:changeTeamButtonRect];
    [_passwordLabel         setFrame:passwordLabelRect];
    [_passwordTextField     setFrame:passwordTextFieldRect];
    [_changePasswordButton  setFrame:changePasswordButtonRect];
  
    
    
    
}// end layout subviews


/**************************************************************************************************
 *
 *                          Updates from Controller
 *
 **************************************************************************************************/
- (void) updateUserName: (NSString*)userName
{
    [_userNameLabel setText:userName];
    [self setNeedsDisplay];

}

- (void) updateTeamName: (NSString*)teamName
{
    [_teamTextField setText:teamName];
    [self setNeedsDisplay];
    
}

- (void) updateUserImage: (UIImage*)newImage andSelectedImage:(UIImage*)selectedUserImage
{
    [_userImageButton setImage:newImage forState:UIControlStateNormal];
    [_userImageButton setImage:selectedUserImage forState:UIControlStateHighlighted];
    [self setNeedsDisplay];
}

- (void) updateUserPassword: (NSString*)maskedPassword
{
    [_passwordTextField setText:maskedPassword];
    [self setNeedsDisplay];
}



/**************************************************************************************************
 *
 *                          Set delegate for the text fields
 *
 **************************************************************************************************/
#pragma - mark setSubviewDelegates
/***
 *  This method is used for easy access to the subviews by the controller.
 *  The method is called by the controller in the 'view did load' method
 *
 */
-(void) setTextFieldDelegates:(id)delegate
{
    
    [_teamTextField setDelegate:delegate];
    [_passwordTextField  setDelegate:delegate];
    
    
}// end set delegates


/**************************************************************************************************
 *
 *                          Draw Rect
 *
 **************************************************************************************************/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
