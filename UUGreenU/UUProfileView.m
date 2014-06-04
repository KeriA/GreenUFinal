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
    UILabel*     _profileLable;
    UIButton*    _userImageButton;
    UILabel*     _userNameLabel;
    UIButton*    _changeUserNameButton;
    
    UILabel*     _pointsLabel;
    UITextField* _pointsTextField;
    UILabel*     _rankLabel;
    UITextField*  _rankTextField;
    
    
    UILabel*     _teamNameLabel;
    UITextField* _teamTextField;
    UIButton*    _changeTeamButton;
    UILabel*     _passwordLabel;
    UITextField* _passwordTextField;
    UIButton*    _changePasswordButton;
    
    UIButton*    _takeMoreChallengesButton;
    
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
        
        
        _profileLable = [[UILabel alloc] init];
        [_profileLable setBackgroundColor:[UIColor clearColor]];
        [_profileLable setText:@"Profile"];
        [_profileLable setTextColor:[UIColor whiteColor]];
        [_profileLable setFont:[_appConstants getBoldFontWithSize:TOPLABELFONTSIZE]];
        [_profileLable setTextAlignment:NSTextAlignmentLeft];
        [_profileLable setNumberOfLines:2];
        [_profileLable setLineBreakMode:NSLineBreakByWordWrapping];

    
        //this button just looks like a picture
        _userImageButton= [UIButton buttonWithType:UIButtonTypeCustom];
        _userImageButton.backgroundColor = [UIColor clearColor];
        [_userImageButton setTitle:@"" forState:UIControlStateNormal];
        // set the delegate for the button to be the SignInViewController
        [_userImageButton addTarget: profileViewDelegate
                            action:@selector(userImageButtonWasPressed)
                  forControlEvents:UIControlEventTouchDown];
        
        
        _userNameLabel = [[UILabel alloc] init];
        [_userNameLabel setBackgroundColor:[UIColor clearColor]];
        [_userNameLabel setText:@""];
        [_userNameLabel setTextColor:[_appConstants mustardYellowColor]];
        [_userNameLabel setFont:[_appConstants getStandardFontWithSize:23.0]];
        [_userNameLabel setTextAlignment:NSTextAlignmentLeft];
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
        NSDictionary* underlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants mustardYellowColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* attStringNormal = [[NSAttributedString alloc] initWithString:@"Change username" attributes:underlineAttributeNormal];
        [_changeUserNameButton setAttributedTitle:attStringNormal forState:UIControlStateNormal];
        //_changeUserNameButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_changeUserNameButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        NSDictionary* underlineAttributeHighlighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* attStringHighlighted = [[NSAttributedString alloc] initWithString:@"Change username" attributes:underlineAttributeHighlighted];
        [_changeUserNameButton setAttributedTitle:attStringHighlighted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_changeUserNameButton addTarget: profileViewDelegate
                          action:@selector(changeUserNameButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];

        _pointsLabel = [[UILabel alloc] init];
        [_pointsLabel setBackgroundColor:[UIColor clearColor]];
        [_pointsLabel setText:@"Points"];
        [_pointsLabel setTextColor:[UIColor whiteColor]];
        [_pointsLabel setFont:[_appConstants getStandardFontWithSize:18.0]];
        [_pointsLabel setTextAlignment:NSTextAlignmentRight];
        [_pointsLabel setNumberOfLines:1];
        [_pointsLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        // create the textfields and set its delegates
        _pointsTextField = [[UITextField alloc] init];
        _pointsTextField.placeholder = @"";
        _pointsTextField.backgroundColor = [UIColor grayColor];
        _pointsTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _pointsTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _pointsTextField.font = [_appConstants getStandardFontWithSize:12.0];
        _pointsTextField.borderStyle = UITextBorderStyleRoundedRect;
        _pointsTextField.keyboardType = UIKeyboardTypeAlphabet;
        _pointsTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _pointsTextField.returnKeyType = UIReturnKeyDone;
        _pointsTextField.textAlignment = NSTextAlignmentLeft;
        _pointsTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _pointsTextField.tag = pointsTag;  // used to identify this text field in the delegate methods
        _pointsTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _pointsTextField.layer.borderWidth = 0.0;

        
        _rankLabel = [[UILabel alloc] init];
        [_rankLabel setBackgroundColor:[UIColor clearColor]];
        [_rankLabel setText:@"Rank"];
        [_rankLabel setTextColor:[UIColor whiteColor]];
        [_rankLabel setFont:[_appConstants getStandardFontWithSize:18.0]];
        [_rankLabel setTextAlignment:NSTextAlignmentRight];
        [_rankLabel setNumberOfLines:1];
        [_rankLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        // create the textfields and set its delegates
        _rankTextField = [[UITextField alloc] init];
        _rankTextField.placeholder = @"";
        _rankTextField.backgroundColor = [UIColor grayColor];
        _rankTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _rankTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _rankTextField.font = [_appConstants getStandardFontWithSize:12.0];
        _rankTextField.borderStyle = UITextBorderStyleRoundedRect;
        _rankTextField.keyboardType = UIKeyboardTypeAlphabet;
        _rankTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _rankTextField.returnKeyType = UIReturnKeyDone;
        _rankTextField.textAlignment = NSTextAlignmentLeft;
        _rankTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _rankTextField.tag = pointsTag;  // used to identify this text field in the delegate methods
        _rankTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _rankTextField.layer.borderWidth = 0.0;

        
        _teamNameLabel = [[UILabel alloc] init];
        [_teamNameLabel setBackgroundColor:[UIColor clearColor]];
        [_teamNameLabel setText:@"Team name"];
        [_teamNameLabel setTextColor:[UIColor whiteColor]];
        [_teamNameLabel setFont:[_appConstants getStandardFontWithSize:18.0]];
        [_teamNameLabel setTextAlignment:NSTextAlignmentRight];
        [_teamNameLabel setNumberOfLines:1];
    
        
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
        NSDictionary* teamUnderlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants mustardYellowColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* teamAttStringNormal = [[NSAttributedString alloc] initWithString:@"Change team" attributes:teamUnderlineAttributeNormal];
        [_changeTeamButton setAttributedTitle:teamAttStringNormal forState:UIControlStateNormal];
        _changeTeamButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        NSDictionary* teamUnderlineAttributeHighlighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* teamAttStringHighlihgted = [[NSAttributedString alloc] initWithString:@"Change team" attributes:teamUnderlineAttributeHighlighted];
        [_changeTeamButton setAttributedTitle:teamAttStringHighlihgted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_changeTeamButton addTarget: profileViewDelegate
                                  action:@selector(changeTeamButtonWasPressed)
                        forControlEvents:UIControlEventTouchDown];

        
        
        _passwordLabel = [[UILabel alloc] init];
        [_passwordLabel  setBackgroundColor:[UIColor clearColor]];
        [_passwordLabel  setText:@"Password"];
        [_passwordLabel  setTextColor:[UIColor whiteColor]];
        [_passwordLabel  setFont:[_appConstants getStandardFontWithSize:18.0]];
        [_passwordLabel  setTextAlignment:NSTextAlignmentRight];
        [_passwordLabel setNumberOfLines:1];
        
        
        
        
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
        NSDictionary* passwordUnderlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants mustardYellowColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* passwordAttStringNormal = [[NSAttributedString alloc] initWithString:@"Change password" attributes:passwordUnderlineAttributeNormal];
        [_changePasswordButton setAttributedTitle:passwordAttStringNormal forState:UIControlStateNormal];
        
        NSDictionary* passwordUnderlineAttributeHighlighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:12]};
        NSAttributedString* passwordAttStringHighlihgted = [[NSAttributedString alloc] initWithString:@"Change password" attributes:passwordUnderlineAttributeHighlighted];
        [_changePasswordButton setAttributedTitle:passwordAttStringHighlihgted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_changePasswordButton addTarget: profileViewDelegate
                                  action:@selector(changePasswordButtonWasPressed)
                        forControlEvents:UIControlEventTouchDown];

        
        // rounded rect button
        _takeMoreChallengesButton = [[UIButton alloc]init];
        _takeMoreChallengesButton.layer.borderWidth = .06f; // these two lines
        _takeMoreChallengesButton.layer.cornerRadius = 6;   // round the corners
        [_takeMoreChallengesButton setTitle:@"Take more challenges!" forState:UIControlStateNormal];
        [_takeMoreChallengesButton setBackgroundColor:[_appConstants cherryRedColor]];
        [_takeMoreChallengesButton.titleLabel setFont:[_appConstants getBoldFontWithSize:18.0]];
        [_takeMoreChallengesButton.titleLabel setTextColor:[UIColor whiteColor]];
        [_takeMoreChallengesButton addTarget: profileViewDelegate
                                  action:@selector(takeMoreChallengesButtonWasPressed)
                        forControlEvents:UIControlEventTouchDown];
        
        
        //add subviews to view
        [self addSubview:_profileLable];
        [self addSubview:_userImageButton];
        [self addSubview:_userNameLabel];
        [self addSubview:_changeUserNameButton];
        [self addSubview:_pointsLabel];
        [self addSubview:_pointsTextField];
        [self addSubview:_rankLabel];
        [self addSubview:_rankTextField];
        [self addSubview:_teamNameLabel];
        [self addSubview:_teamTextField];
        [self addSubview:_changeTeamButton];
        [self addSubview:_passwordLabel];
        [self addSubview:_passwordTextField];
        [self addSubview:_changePasswordButton];
        [self addSubview:_takeMoreChallengesButton];
        

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
    
    /*** TOP LABEL - FOR CONSISTENCY ACROSS FRAMES  ***/
    
    // Get the bounds of the current view. We will use this to dynamically calculate the frames of our subviews
    CGRect bounds = [self bounds];
    //NSLog(@"width is %f and height is %f", bounds.size.width, bounds.size.height);//for testing
    
    //first, remove a strip off of the top to make room for the navigation controller
    bounds.size.height = bounds.size.height - (TOPMARGIN * 1.5);  //1.5 x so we remove a strip off of the bottom as well
    bounds.origin.y = TOPMARGIN;
    
    // Next, create an inset off of the sides so that there is a bit of an edge
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
    CGRect insetBounds  = CGRectInset(bounds, bounds.size.width * PAGEINSETAMOUNT, 0.0);
    
    //create the top label margin  (for consistency across pages)
    CGRect topLabelRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y, insetBounds.size.width, TOPLABELHEIGHT);
    
    //now adjust the inset bounds
    insetBounds.origin.y = insetBounds.origin.y + TOPLABELHEIGHT;  // this can be adjusted as needed per frame
    insetBounds.size.height = insetBounds.size.height - TOPLABELHEIGHT;
    
    
    /***  REMAINING RECTS  ***/
    // the specific rects that will be used for subviews
    CGRect topRect;      // holds all the sub-rects for the username and image
    CGRect middleRect;   // holds all the sub-rects for team and password
    CGRect bottomRect;   // holds the take more challenges rect
    CGRect userImageRect;
    CGRect userNameRect;
    CGRect changeUserNameRect;
    CGRect pointsRect;
    CGRect pointsTextRect;
    CGRect rankRect;
    CGRect rankTextRect;
    CGRect teamNameRect;
    CGRect teamNameTextRect;
    CGRect changeTeamRect;
    CGRect passwordRect;
    CGRect passwordTextRect;
    CGRect changePasswordRect;
    CGRect takeMoreChallengesRect;
    
    CGRectDivide(insetBounds, &topRect, &middleRect, insetBounds.size.height / 2.0, CGRectMinYEdge);
    CGRectDivide(middleRect, &middleRect, &bottomRect, middleRect.size.height / 1.3, CGRectMinYEdge);
    
    
    
    //top rect
    //    shorten the length a bit
    topRect.size.height = topRect.size.height - (topRect.size.height * .20);
    CGRectDivide(topRect, &userImageRect, &userNameRect, topRect.size.width/ 2.0, CGRectMinXEdge);
    //   shorten the username rect a bit
    CGFloat shortenAmount = 5.0;
    userNameRect.origin.y = userNameRect.origin.y + shortenAmount;
    userNameRect.size.height = userNameRect.size.height - shortenAmount;
    //   move the username rect in a bit
    CGFloat inwardAmount = .08;
    userNameRect.origin.x = userNameRect.origin.x + (userNameRect.size.width * inwardAmount);
    userNameRect.size.width = userNameRect.size.width - (userNameRect.size.width * inwardAmount);
    
    CGRectDivide(userNameRect, &userNameRect, &pointsRect, userNameRect.size.height/2.0, CGRectMinYEdge);
    CGRectDivide(userNameRect, &userNameRect, &changeUserNameRect, userNameRect.size.height / 2.0, CGRectMinYEdge);
    CGRectDivide(pointsRect, &pointsRect, &pointsTextRect, pointsRect.size.width/2.0, CGRectMinXEdge);
    CGRectDivide(pointsRect, &pointsRect, &rankRect, pointsRect.size.height/ 2.0, CGRectMinYEdge);
    CGRectDivide(pointsTextRect, &pointsTextRect, &rankTextRect, pointsTextRect.size.height/2.0, CGRectMinYEdge);
    CGFloat pointsInsetAmount = .20;
    pointsRect     = CGRectInset(pointsRect, 0.0, pointsRect.size.height * pointsInsetAmount);
    pointsTextRect = CGRectInset(pointsTextRect, 0.0, pointsTextRect.size.height * pointsInsetAmount);
    rankRect       = CGRectInset(rankRect, 0.0, rankRect.size.height * pointsInsetAmount);
    rankTextRect   = CGRectInset(rankTextRect, 0.0, rankTextRect.size.height * pointsInsetAmount);
    
    
    //middle rect
    middleRect = CGRectInset(middleRect, 0.0, middleRect.size.height * .10);
    middleRect.origin.y = middleRect.origin.y - 15.0;
    CGRectDivide(middleRect, &teamNameRect, &passwordRect, middleRect.size.height/2.0, CGRectMinYEdge);
    
    CGRectDivide(teamNameRect, &teamNameRect,  &changeTeamRect, teamNameRect.size.height/2.0, CGRectMinYEdge);
    CGRectDivide(teamNameRect, &teamNameRect, &teamNameTextRect, teamNameRect.size.width / 2.5, CGRectMinXEdge);
    changeTeamRect.origin.x = teamNameTextRect.origin.x;
    changeTeamRect.size.width = teamNameTextRect.size.width;
    
    
    CGRectDivide(passwordRect, &passwordRect, &changePasswordRect, passwordRect.size.height / 2.0, CGRectMinYEdge);
    CGRectDivide(passwordRect, &passwordRect, &passwordTextRect, passwordRect.size.width/ 2.5, CGRectMinXEdge);
    changePasswordRect.origin.x = passwordTextRect.origin.x;
    changePasswordRect.size.width = passwordTextRect.size.width;
    
    
    
    //bottom rect
    takeMoreChallengesRect.origin.x = bottomRect.origin.x;
    takeMoreChallengesRect.origin.y = bottomRect.origin.y;
    takeMoreChallengesRect.size.width = bottomRect.size.width;
    takeMoreChallengesRect.size.height = bottomRect.size.height;
    takeMoreChallengesRect = CGRectInset(takeMoreChallengesRect, takeMoreChallengesRect.size.width * .05, takeMoreChallengesRect.size.height * .10);
    
    //move the labesl a bit left of their text fields
    CGFloat textLableLeftAmount = 10.0;
    teamNameRect.origin.x = teamNameRect.origin.x - textLableLeftAmount;
    passwordRect.origin.x = passwordRect.origin.x - textLableLeftAmount;
    pointsRect.origin.x = pointsRect.origin.x - textLableLeftAmount;
    rankRect.origin.x = rankRect.origin.x - textLableLeftAmount;
    
    
    //set the frames
    [_profileLable             setFrame:topLabelRect];
    [_userImageButton          setFrame:userImageRect];
    [_userNameLabel            setFrame:userNameRect];
    [_changeUserNameButton     setFrame:changeUserNameRect];
    [_pointsLabel              setFrame:pointsRect];
    [_pointsTextField          setFrame:pointsTextRect];
    [_rankLabel                setFrame:rankRect];
    [_rankTextField            setFrame:rankTextRect];
    [_teamNameLabel            setFrame:teamNameRect];
    [_teamTextField            setFrame:teamNameTextRect];
    [_changeTeamButton         setFrame:changeTeamRect];
    [_passwordLabel            setFrame:passwordRect];
    [_passwordTextField        setFrame:passwordTextRect];
    [_changePasswordButton     setFrame:changePasswordRect];
    [_takeMoreChallengesButton setFrame:takeMoreChallengesRect];
    
    
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

- (void) updateUserPoints:(int) points
{
    [_pointsTextField setText: [NSString stringWithFormat:@"%d", points]];
    [self setNeedsDisplay];
}

- (void) updateUserRank:(int) rank
{
    [_rankTextField setText: [NSString stringWithFormat:@"%d", rank]];
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
