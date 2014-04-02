//
//  UUCreateUserView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/12/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUCreateUserView.h"

@implementation UUCreateUserView
{
    UILabel*     _errorMessageLabel;
    UITextField* _displayNameTextField;
    UITextField* _emailTextField;
    UITextField* _passwordTextField;
    UIButton*    _signUpButton;
    UILabel*     _agreementLabel;
    UIButton*    _faceBookButton;
    UIButton*    _twitterButton;
    UIImageView* _fbImageView;
    UIImageView* _twitterImageView;

}

@synthesize createUserViewDelegate;

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
        
        
        //create subviews
        // create the buttons and labels
        _errorMessageLabel = [[UILabel alloc] init];
        [_errorMessageLabel setBackgroundColor:[UIColor clearColor]];
        [_errorMessageLabel setText:@""];
        [_errorMessageLabel setTextColor:[_appConstants cherryRedColor]];
        [_errorMessageLabel setFont:[_appConstants getStandardFontWithSize:15.0]];
        [_errorMessageLabel setTextAlignment:NSTextAlignmentLeft];
        [_errorMessageLabel setNumberOfLines:2];
        [_errorMessageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        // important note:  When using custom fonts, it turns out that often these fonts do not have
        //                  what is called the 'ascender property' set correctly, resulting in
        //                  text being displayed too high, or off vertical center.
        //                  Rather than mess with the font file directly (which can be done, but I'll
        //                  dodge that bullet if I can), a quick and dirty fix is to play around
        //                  with the 'contentEdgeInsets' settings, and just shove the whole text down
        //                  a bit.  This seemed to work well.
        //
        //  update:  switched back to system font - just looked better
        
        _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        [_signUpButton  setTitle:@"Sign Up" forState:UIControlStateNormal];
        [_signUpButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_signUpButton  setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_signUpButton.titleLabel setFont:[_appConstants getBoldFontWithSize:25.0]];
        _signUpButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0);  // see 'important note' above
        [_signUpButton setBackgroundImage:[[UIImage imageNamed:@"grayButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [_signUpButton setBackgroundImage:[[UIImage imageNamed:@"blueButton.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
        // set the delegate for the button to be the CreateUserViewController - we want the controller to
        // handle events
        [_signUpButton addTarget: createUserViewDelegate
                          action:@selector(signUpButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];
        
        
        // create the textfields and set its delegates
        _displayNameTextField = [[UITextField alloc] init];
        _displayNameTextField.placeholder = @"Display Name";
        _displayNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _displayNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _displayNameTextField.backgroundColor = [UIColor whiteColor];
        _displayNameTextField.font = [_appConstants getStandardFontWithSize:20.0];
        _displayNameTextField.borderStyle = UITextBorderStyleRoundedRect;
        _displayNameTextField.keyboardType = UIKeyboardTypeDefault;
        _displayNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _displayNameTextField.returnKeyType = UIReturnKeyDone;
        _displayNameTextField.textAlignment = NSTextAlignmentLeft;
        _displayNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _displayNameTextField.tag = displayNameTFTag; // used to identify this text field in the delegate methods
        _displayNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //Note:  must import <QuartzCore/QuartzCore.h> so that the layer property is visible
        _displayNameTextField.layer.borderWidth = 0.0;
        
        
        _emailTextField = [[UITextField alloc] init];
        _emailTextField.placeholder = @"Email";
        _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _emailTextField.backgroundColor = [UIColor whiteColor];
        _emailTextField.font = [_appConstants getStandardFontWithSize:20.0];
        _emailTextField.borderStyle = UITextBorderStyleRoundedRect;
        _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _emailTextField.returnKeyType = UIReturnKeyDone;
        _emailTextField.textAlignment = NSTextAlignmentLeft;
        _emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _emailTextField.tag = emailTFTag;  // used to identify this text field in the delegate methods
        _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //Note:  must import <QuartzCore/QuartzCore.h> so that the layer property is visible
        _emailTextField.layer.borderWidth = 0.0;
        
        
        
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
        _passwordTextField.tag = passwordTFTag; // used to identify this text field in the delegate methods
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        //Note:  must import <QuartzCore/QuartzCore.h> so that the layer property is visible
        _passwordTextField.layer.borderWidth = 0.0;
        
        
        _agreementLabel = [[UILabel alloc] init];
        [_agreementLabel setBackgroundColor:[UIColor clearColor]];
        [_agreementLabel setText:@"Agreement text goes here"];
        [_agreementLabel setTextColor:[UIColor whiteColor]];
        [_agreementLabel setFont:[_appConstants getStandardFontWithSize:13.0]];
        [_agreementLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        
        _faceBookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        _faceBookButton.backgroundColor = [UIColor clearColor];
        [_faceBookButton setTitle:@"" forState:UIControlStateNormal];
        [_faceBookButton setImage:[UIImage imageNamed:@"fbLargeIcon"] forState:UIControlStateNormal];
        [_faceBookButton setImage:[UIImage imageNamed:@"fbLargeIconPressed"] forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewController
        [_faceBookButton addTarget: createUserViewDelegate
                            action:@selector(faceBookButtonWasPressed)
                  forControlEvents:UIControlEventTouchDown];

        
        
        _twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        _twitterButton.backgroundColor = [UIColor clearColor];
        [_twitterButton setTitle:@"" forState:UIControlStateNormal];
        [_twitterButton setImage:[UIImage imageNamed:@"twitterLargeIcon"] forState:UIControlStateNormal];
        [_twitterButton setImage:[UIImage imageNamed:@"twitterLargeIconPressed"] forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewController
        [_twitterButton addTarget: createUserViewDelegate
                           action:@selector(twitterButtonWasPressed)
                 forControlEvents:UIControlEventTouchDown];
        
        
        
        
        // add the subviews
        [self addSubview:_errorMessageLabel];
        [self addSubview:_displayNameTextField];
        [self addSubview:_emailTextField];
        [self addSubview:_passwordTextField];
        [self addSubview:_signUpButton];
        [self addSubview:_agreementLabel];
        [self addSubview:_faceBookButton];
        [self addSubview:_twitterButton];
        
        
        
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
    
    CGFloat boundsInsetWidth  = bounds.size.width * 0.10; // take off a percentage of the width
    CGFloat boundsInsetHeight = bounds.size.height * 0.10; // take off a percentage of the width
    bounds = CGRectInset(bounds, boundsInsetWidth, boundsInsetHeight);
    bounds.origin.y = bounds.origin.y + 10;
    
    // the specific rects that will be used for subviews
    CGRect errorMessageRect;    // this will hold the error message rect
    CGRect displayNameRect;     // holds the display name text field
    CGRect emailRect;           // holds the email text field
    CGRect passwordRect;        // holds the password text field
    CGRect agreementLabelRect;  // holds the agreement text label
    CGRect signUpButtonRect;    // holds the signup button
    CGRect fbButtonRect;        // holds the facebook button
    CGRect fbImageRect;         // holds the facebook button image
    CGRect twitterButtonRect;   // holds the twitter button
    CGRect twitterImageRect;    // holds the twitter button image
    
    // temporary helper rects
    CGRect textfieldsRect;  // hols all the text fields
    //Now divide the bounds rect amongst all of the sub-rects
    // Notes on using CGRectDivide
    //    Parameters:
    //               rect:        the original rect to divide up
    //               slice:       the first slice that will be created - needs ADDRESS of rect
    //               remainder:   the remainder of the original rect will be placed in this rect  (use ADDRESS of rect)
    //               amount:      the float amount of how much to put in the first rect
    //               edge:        which edge to measure from
    //                           CGRectMinYEdge  :  will measuer from the top
    //                           CGRectMinXEdge  :  will measure from the left
    //                           CGRectMaxYedge  :  will measure from the bottom
    //                           CGRectMaxXedge  :  will measure from the right
    //
    // original rect, 1st slice,      remainder,   how much to put in slice, which edge to measure from
    CGRectDivide(bounds, &errorMessageRect, &textfieldsRect, bounds.size.height/ 7.0, CGRectMinYEdge);
    CGRectDivide(textfieldsRect, &textfieldsRect, &agreementLabelRect, textfieldsRect.size.height/ 2.5, CGRectMinYEdge);
    // now that we have the textfields rect, divide it amongst the fields
    CGRectDivide(textfieldsRect, &displayNameRect, &emailRect, textfieldsRect.size.height/3.0, CGRectMinYEdge);
    CGRectDivide(emailRect, &emailRect, &passwordRect, emailRect.size.height/2.0, CGRectMinYEdge);
    
    CGRectDivide(agreementLabelRect, &agreementLabelRect, &signUpButtonRect, agreementLabelRect.size.height/2.5, CGRectMinYEdge);
    CGRectDivide(signUpButtonRect, &signUpButtonRect, &fbButtonRect, signUpButtonRect.size.height/2.5, CGRectMinYEdge);
    // we want the fb and twitter buttons to be square.  Make sure that the original rectangle that holds
    // both of these buttons (currently what is in the fbButtonRect) is a length and width that can be
    // divided nicely into two square buttons
    //                    ***********************
    //                    *          *          *
    //                    *          *          *
    //                    *          *          *
    //                    *          *          *
    //                    ***********************
    
    float fbButtonHeight = fbButtonRect.size.height;
    float fbButtonWidth  = fbButtonRect.size.width;
    
    if (fbButtonHeight > (fbButtonWidth / 2.0))
    {
        // set the height of the rectangle so that it divides nicely into 2 squares
        fbButtonRect.size.height = (fbButtonWidth / 2.0);
        
    }
    else //if ((fbButtonWidth / 2.0) > fbButtonHeight)
    {
        // this is the more complicated (and more likely) case.  We need to reduce the button width
        // and then adjust the origin x so that the whole rectangle is centered again
        
        // find the new origin
        float difference = (fbButtonWidth / 2.0) - fbButtonHeight;
        fbButtonRect.origin.x = fbButtonRect.origin.x + difference;
        // set the new width
        fbButtonRect.size.width = fbButtonHeight * 2.0;
        
    }
    
    // now split this newly sized rectangle into the fb and twitter button rects
    CGRectDivide(fbButtonRect, &fbButtonRect, &twitterButtonRect, fbButtonRect.size.width/2.0, CGRectMinXEdge); // from x edge
    
    
    //use the buttons Rects to create the size of their image rects:
    CGFloat inset = fbButtonRect.size.width * 0.05; // take off a percentage of the width
    fbImageRect = CGRectInset(fbButtonRect, inset, inset);
    twitterImageRect = CGRectInset(twitterButtonRect, inset, inset);
    
    // NSLog(@"KERI!!! the dimensions are height:  %f and width:  %f", fbImageRect.size.height, fbImageRect.size.width);
    
    
    
    
    
    
    // set the frames
    [_errorMessageLabel    setFrame:errorMessageRect];
    [_displayNameTextField setFrame:displayNameRect];
    [_emailTextField       setFrame:emailRect];
    [_passwordTextField    setFrame:passwordRect];
    [_agreementLabel       setFrame:agreementLabelRect];
    [_signUpButton         setFrame:signUpButtonRect];
    [_faceBookButton       setFrame:fbButtonRect];
    [_fbImageView          setFrame:fbImageRect];
    [_twitterButton        setFrame:twitterButtonRect];
    [_twitterImageView     setFrame:twitterImageRect];
    
    
}// end layout subviews


/**************************************************************************************************
 *
 *                          Set delegate for the Text fields
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
    
    [_displayNameTextField setDelegate:delegate];
    [_emailTextField setDelegate:delegate];
    [_passwordTextField  setDelegate:delegate];
    
    
}// end set delegates

/**************************************************************************************************
 *
 *                          Update Error Message
 *
 **************************************************************************************************/
-(void) updateErrorMessage:(NSString*)message
{
    _errorMessageLabel.text = message;
    [self setNeedsDisplay]; //refresh
    
}//end update error message


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
