//
//  UUMainView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUMainView.h"

@implementation UUMainView
{
    UILabel* _greenULabel;
    UIImage* _greenUImage;
    UITableView* _mainTableView;
    UIButton* _changeUserButton;
    UILabel* _userNameLabel;
    NSString* _userName;
}

@synthesize mainViewDelegate;


/***
 *
 *      Constructor
 */
- (id)initWithAppConstants:(UUApplicationConstants*)appConstants andModel:(UUModel*)model
{
    self = [super init];
    if (self) {
        // Initialization code
        
        _appConstants = appConstants;
        _model = model;  //needed to get the user name
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[appConstants getBackgroundImage]]];
        
        
        _greenULabel = [[UILabel alloc] init];
        [_greenULabel setText:@""];
        _greenUImage = [UIImage imageNamed:@"logo_greenu_final.png"];
        [_greenULabel setBackgroundColor:[UIColor colorWithPatternImage:_greenUImage]];
        
        
        //get the user name from the appConstants
        _userName = [_model getUserName];
        
        _userNameLabel = [[UILabel alloc] init];
        [_userNameLabel setBackgroundColor:[UIColor clearColor]];
        NSString* welcomeString = [NSString stringWithFormat:@"Welcome %@!", _userName];
        [_userNameLabel setText:welcomeString];
        [_userNameLabel setTextColor:[_appConstants mustardYellowColor]];
        [_userNameLabel setFont:[_appConstants getStandardFontWithSize:15.0]];
        //[_userNameLabel setTextAlignment:NSTextAlignmentCenter];
        [_userNameLabel setTextAlignment:NSTextAlignmentLeft];
        
        
        
        
        //create subviews
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.rowHeight = 90;
        _mainTableView.scrollEnabled = NO;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
        
        
        
        _changeUserButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        _changeUserButton.backgroundColor = [UIColor clearColor];
        CALayer* theLayer = [_changeUserButton layer];
        [theLayer setMasksToBounds:YES];
        [theLayer setCornerRadius: 6.0];
        [theLayer setBorderWidth: 0.0];// we want this button to look like a link, so no border
        [theLayer setBorderColor:[UIColor clearColor].CGColor];
        // This button needs to look like a link - with underlined text - use NSAttributed String
        NSDictionary* underlineAttributeNormal = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants mustardYellowColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:10]};
        
        NSDictionary* underlineAttributeHighLighted = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: [_appConstants brightGreenColor], NSFontAttributeName: [_appConstants getStandardFontWithSize:10]};
        NSString* userString = @"Not ";
        userString = [userString stringByAppendingString:_userName];
        userString = [userString stringByAppendingString:@"?  Sign in as a different user"];
        
        NSAttributedString* attStringNormal = [[NSAttributedString alloc] initWithString:userString attributes:underlineAttributeNormal];
        [_changeUserButton setAttributedTitle:attStringNormal forState:UIControlStateNormal];
        
        NSAttributedString* attStringHighlighted = [[NSAttributedString alloc] initWithString:userString attributes:underlineAttributeHighLighted];
        [_changeUserButton setAttributedTitle:attStringHighlighted forState:UIControlStateHighlighted];
        // set the delegate for the button to be the SignInViewControllers
        [_changeUserButton addTarget: mainViewDelegate
                          action:@selector(changeUserButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];

        
        [self addSubview:_greenULabel];
        [self addSubview:_userNameLabel];
        [self addSubview:_mainTableView];
        [self addSubview:_changeUserButton];
        
    }
    return self;
    
}//end Constructor

-(void) setTableViewDelegates:(id)viewController
{
    [_mainTableView setDataSource:viewController];
    [_mainTableView setDelegate:viewController];
    
}


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
    //NSLog(@"width is %f and height is %f", bounds.size.width, bounds.size.height);//for testing
    
    
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
    
    CGFloat boundsInsetWidth  = bounds.size.width  * 0.08; // take off a percentage of the width
    CGFloat boundsInsetHeight = bounds.size.height * 0.00; // take off a percentage of the width
    
                   //CGRectrect, CGFloat dx, CGFloat dy
    bounds = CGRectInset(bounds, boundsInsetWidth, boundsInsetHeight);
    
    // the specific rects that will be used for subviews
    CGRect greenULabelRect;  // holds logo
    //CGRect spacerRect;
    CGRect welcomeRect;      // holds the user's welcome label
    CGRect tableViewRect;    // this will hold the table view
    CGRect notUserRect;      // this will hold the link to the login page
    
    CGRectDivide(bounds, &greenULabelRect, &welcomeRect,  bounds.size.height / 10.8, CGRectMinYEdge);
    //make the width of the greenUlabel smaller
    greenULabelRect.size.width = (7.0/12.0) * greenULabelRect.size.width;
    
    //CGRectDivide(greenULabelRect, &greenULabelRect, &spacerRect, (7.0* greenULabelRect.size.width) / 12.0, CGRectMinXEdge);
    //CGFloat greenUInsetWidth = greenULabelRect.size.width * .5;
    //greenULabelRect = CGRectInset(greenULabelRect, greenUInsetWidth, 0.0);
    CGRectDivide(welcomeRect, &welcomeRect, &tableViewRect,  welcomeRect.size.height / 11.0, CGRectMinYEdge);
    CGRectDivide(tableViewRect, &tableViewRect, &notUserRect, 2.0*(bounds.size.height/3.0), CGRectMinYEdge);
    
    
    //create a new image to fit in the greenUlabelRect
    CGSize labelSize = greenULabelRect.size;
    
    UIGraphicsBeginImageContext(labelSize);
    [_greenUImage drawInRect:CGRectMake(0,0, labelSize.width, labelSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _greenULabel.backgroundColor = [UIColor colorWithPatternImage:newImage];
     
    
    
    // set the frames
    [_greenULabel      setFrame:greenULabelRect];
    [_userNameLabel    setFrame:welcomeRect];
    [_mainTableView    setFrame:tableViewRect];
    [_changeUserButton setFrame:notUserRect];
   
    //[_updateProfileButton setFrame:updateProfileButtonRect];
    
    
    
}// end layout subviews

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
