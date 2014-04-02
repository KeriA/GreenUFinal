//
//  UULoginView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UULoginView.h"


@implementation UULoginView
{
    UIImageView* _greenUImageView;
    UILabel*     _orLabel;
    UITextField* _emailTextField;
    UITextField* _passwordTextField;
    UIButton*    _loginButton;
    UIButton*    _loginWithFBButton;
    UIButton*    _signUpButton;

}

@synthesize loginViewDelegate;

/***
 *
 *      Constructor
 */
- (id)initWithAppConstants:(UUApplicationConstants*)appConstants
{
    self = [super init];
    if (self) {
        // Initialization code
        
        _appConstants = appConstants;
        [self setBackgroundColor:[UIColor colorWithPatternImage:[appConstants getBackgroundImage]]];
        
        
        // create the subviews
        
        // create the buttons and labels
        // _greenULabel = [[UILabel alloc] init];
        // [_greenULabel setBackgroundColor:[UIColor clearColor]];
        // [_greenULabel setText:@"GreenU"];
        // [_greenULabel setTextColor:[_programConstants brightGreenColor]];
        // [_greenULabel setFont:[_programConstants getBoldFontWithSize:50.0]];
        // [_greenULabel setTextAlignment:NSTextAlignmentCenter];
        _greenUImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"logo_greenu_final.png"]];
        
        _orLabel = [[UILabel alloc] init];
        [_orLabel setBackgroundColor:[UIColor clearColor]];
        [_orLabel setText:@"- or -"];
        [_orLabel setTextColor:[UIColor whiteColor]];
        [_orLabel setFont:[_appConstants getStandardFontWithSize:20.0]];
        [_orLabel setTextAlignment:NSTextAlignmentCenter];
        
        
        
        // create the textfields and set its delegates
        _emailTextField = [[UITextField alloc] init];
        _emailTextField.placeholder = @"Email";
        _emailTextField.backgroundColor = [UIColor whiteColor];
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.font = [_appConstants getStandardFontWithSize:20.0];
        _emailTextField.borderStyle = UITextBorderStyleRoundedRect;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.returnKeyType = UIReturnKeyDone;
        _emailTextField.textAlignment = NSTextAlignmentLeft;
        _emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _emailTextField.tag = emailTag;  // used to identify this text field in the delegate methods
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.layer.borderWidth = 0.0;
        //[_emailTextField setDelegate: signInTextFieldDelegate]; // could not get code to work - use method created below
        
        _passwordTextField = [[UITextField alloc] init];
        _passwordTextField.placeholder = @"Password";
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.font = [_appConstants getStandardFontWithSize:20.0];
        _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.textAlignment = NSTextAlignmentLeft;
        _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordTextField.tag = passwordTag; // used to identify this text field in the delegate methods
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.layer.borderWidth = 0.0;
        //[_passwordTextField setDelegate:signInTextFieldDelegate]; // could not get code to work
        
        
        // create the buttons and their methods
        // important note:  When using custom fonts, it turns out that often these fonts do not have
        //                  what is called the 'ascender property' set correctly, resulting in
        //                  text being displayed too high, or off vertical center.
        //                  Rather than mess with the font file directly (which can be done, but I'll
        //                  dodge that bullet if I can), a quick and dirty fix is to play around
        //                  with the 'contentEdgeInsets' settings, and just shove the whole text down
        //                  a bit.  This seemed to work well.
        //   UPdate:  switched back to system font - it just looked better.
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        [_loginButton setTitle:@"Log In" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        //[_loginButton setEnabled:FALSE];
        [_loginButton.titleLabel setFont:[_appConstants getBoldFontWithSize:20.0]];
        //_loginButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);  // see 'important note' above
        // set the delegate for the button to be the SignInViewController
        [_loginButton addTarget: loginViewDelegate
                         action:@selector(loginButtonWasPressed)
               forControlEvents:UIControlEventTouchDown];
        
        _loginWithFBButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        [_loginWithFBButton setTitle:@"Log In with FB" forState:UIControlStateNormal];
        [_loginWithFBButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginWithFBButton.titleLabel setFont:[_appConstants getBoldFontWithSize:20.0]];
        //_loginWithFBButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);  // see 'important note' above
        // set the delegate for the button to be the SignInViewController
        [_loginWithFBButton addTarget: loginViewDelegate
                               action:@selector(faceBookLoginButtonWasPressed)
                     forControlEvents:UIControlEventTouchDown];
        
        _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        _signUpButton.backgroundColor = [UIColor clearColor];
        CALayer* theLayer = [_signUpButton layer];
        [theLayer setMasksToBounds:YES];
        [theLayer setCornerRadius: 6.0];
        [theLayer setBorderWidth: 0.0];// we want this button to look like a link, so no border
        [theLayer setBorderColor:[UIColor clearColor].CGColor];
        // This button needs to look like a link - with underlined text - use NSAttributed String
        NSDictionary* underlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:16]};
        NSAttributedString* attStringNormal = [[NSAttributedString alloc] initWithString:@"Sign Up for greenU" attributes:underlineAttributeNormal];
        [_signUpButton setAttributedTitle:attStringNormal forState:UIControlStateNormal];
        
        NSDictionary* underlineAttributeHighlighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:16]};
        NSAttributedString* attStringHighlihgted = [[NSAttributedString alloc] initWithString:@"Sign Up for greenU" attributes:underlineAttributeHighlighted];
        [_signUpButton setAttributedTitle:attStringHighlihgted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_signUpButton addTarget: loginViewDelegate
                          action:@selector(signUpButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];
        
        // add the subviews
        //[self addSubview:_greenULabel];
        [self addSubview:_greenUImageView];
        [self addSubview:_orLabel];
        [self addSubview:_emailTextField];
        [self addSubview:_passwordTextField];
        [self addSubview:_loginButton];
        [self addSubview:_loginWithFBButton];
        [self addSubview:_signUpButton];

        
    }
    return self;
    
}//end Constructor

/***
 *
 *  layoutSubviews
 *
 */
- (void) layoutSubviews
{
    //list the rects that will contain the subviews
    // these are ultimately the rects we will use and fill
    CGRect greenUImageRect;
    CGRect orLabelRect;
    CGRect emailTextFieldRect;
    CGRect passwordTextFieldRect;
    CGRect logInButtonRect;
    CGRect logInWithFBButtonRect;
    CGRect signUpButtonRect;

    
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
    
    CGFloat widthInset = bounds.size.width * 0.10; // take off a percentage of the width
    CGFloat heightInset = bounds.size.height * 0.10;
    bounds = CGRectInset(bounds, widthInset, heightInset);
    
    // divide the screen into 4 sections
    CGRect toplabelRect;    // this will hold the greenU label
    CGRect textFieldsRect;   // hold the text fields
    CGRect buttonsRect;      // holds the login and FB buttons
    CGRect signUpRect; // this will hold the sign up button
    
    
    // original rect, 1st slice,      remainder,   how much to put in slice, which edge to measure from
    CGRectDivide(bounds, &toplabelRect, &textFieldsRect, bounds.size.height/ 4.0, CGRectMinYEdge);
    
    CGRectDivide(textFieldsRect, &textFieldsRect, &buttonsRect, textFieldsRect.size.height / 4.0, CGRectMinYEdge);
    CGRectDivide(buttonsRect, &signUpRect, &buttonsRect, buttonsRect.size.height / 4.0, CGRectMaxYEdge);
    
    
    // divide the textfields and buttons rects
    CGRectDivide(textFieldsRect, &emailTextFieldRect, &passwordTextFieldRect, textFieldsRect.size.height/2.0, CGRectMinYEdge);
    // first, inset the buttons rect to give a bit of distance from the text fields
    buttonsRect = CGRectInset(buttonsRect, 0, buttonsRect.size.height * 0.15);
    // divide the buttons rect into a top log in button, a small 'or' label, and a bottom fBLoginbutton
    CGRectDivide(buttonsRect, &logInButtonRect, &orLabelRect, (buttonsRect.size.height/7.0)*3.0, CGRectMinYEdge);
    CGRectDivide(orLabelRect, &orLabelRect, &logInWithFBButtonRect, orLabelRect.size.height/4.0, CGRectMinYEdge);
    
    
    //NSLog(@"KERI!!! the dimensions are height:  %f and width:  %f", logInWithFBButtonRect.size.height, logInWithFBButtonRect.size.width);
    // now give a bit more vertical inset to separate the buttons from each other
    logInButtonRect = CGRectInset(logInButtonRect, 0, logInButtonRect.size.height * 0.10);
    logInWithFBButtonRect = CGRectInset(logInWithFBButtonRect, 0, logInWithFBButtonRect.size.height * 0.10);
    
    // we want the the greenU logo to sit right above the email field.
    float logoWidth = emailTextFieldRect.size.width - 10.0; // inset it just a bit
    float logoHeight = 80.0; // just assign the height
    // find the y value of the
    float logoY = emailTextFieldRect.origin.y - logoHeight;
    float logoX = emailTextFieldRect.origin.x + 5.0;
    greenUImageRect = CGRectMake(logoX, logoY, logoWidth, logoHeight);
    
    signUpButtonRect = signUpRect;
    
    signUpButtonRect = CGRectInset(signUpButtonRect, widthInset * 1.5, signUpButtonRect.size.height * .30);
    
    // set the frames
    [_greenUImageView setFrame:greenUImageRect];
    [_orLabel setFrame: orLabelRect];
    [_emailTextField setFrame:emailTextFieldRect];
    [_passwordTextField setFrame:passwordTextFieldRect];
    [_loginButton setFrame:logInButtonRect];
    [_loginWithFBButton setFrame:logInWithFBButtonRect];
    [_signUpButton setFrame:signUpButtonRect];
    
    
    // now that we have the frames, we need to customize the button background colors
    UIImageView* fbIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FacebookIconSmall.png"]];
    // do a bit of math to center the facebook icon on the button
    CGFloat fbButtonHeight = logInWithFBButtonRect.size.height;
    // take a percentage of this height
    CGFloat fbIconHeight = fbButtonHeight * .85;
    // indent to the left just a bit (the x value), and center vertically (the y value)
    CGRect fbIconRect = CGRectMake(5, (fbButtonHeight - fbIconHeight) / 2.0, fbIconHeight, fbIconHeight);
    [fbIconImageView setFrame:fbIconRect];
    
    
    [_loginWithFBButton setBackgroundImage:[[UIImage imageNamed:@"grayButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [_loginWithFBButton setBackgroundImage:[[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    [_loginWithFBButton addSubview:fbIconImageView];
    
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"grayButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
    
    
    /*
     [_loginWithFBButton setBackgroundImage:[UIImage imageNamed:"grayButton.png"]   forState:UIControlStateNormal];
     [_loginWithFBButton setBackgroundImage:buttonBackgroundPressed forState:UIControlStateSelected];
     
     [_loginWithFBButton addSubview:fbIconImageView];*/
    
    //[_loginWithFBButton setImage:[UIImage imageNamed:@"FacebookIconSmall.png"] forState:UIControlStateNormal];
    // [_loginWithFBButton setTitleEdgeInsets:UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)];
    
    
    // log in button
    
    /*
     UIImage* _loginImageNormal = [self imageFromColor:[UIColor greenColor] andCGRect:logInButtonRect];
     UIImage* _loginImageSelected = [self imageFromColor:[UIColor blueColor] andCGRect:logInButtonRect];
     [_loginButton setBackgroundImage:_loginImageNormal forState:UIControlStateNormal];
     [_loginButton setBackgroundImage:_loginImageSelected forState:UIControlStateSelected];*/
    
    
}// end layoutSubviews


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
    
    [_emailTextField setDelegate:delegate];
    [_passwordTextField  setDelegate:delegate];
    
    
}// end set delegates




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
