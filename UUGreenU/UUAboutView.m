//
//  UUAboutView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUAboutView.h"

@implementation UUAboutView
{
    UILabel* _aboutLabel;
    UILabel* _textLabel;
    UIImageView* _sustainImageView;
    UIImageView* _SLCImageView;
    UIImageView* _VerizonImageView;
}

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
        _aboutLabel = [[UILabel alloc] init];
        [_aboutLabel setBackgroundColor:[UIColor clearColor]];
        [_aboutLabel setText:@"About"];
        [_aboutLabel setTextColor:[UIColor whiteColor]];
        [_aboutLabel setFont:[_appConstants getBoldFontWithSize:TOPLABELFONTSIZE]];
        [_aboutLabel setTextAlignment:NSTextAlignmentLeft];
        
        _textLabel = [[UILabel alloc] init];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel setText:@"GreenU takes the idea of making environmentally-conscious choices and turns it into a mobile game to encourage people to change their behavior and make responsible choices, all the while having fun.  The app was created by students and staff at the University of Utah Sustainability Resource Center and staff from Salt Lake City's Sustainability and Information Management departments.\n\nStudent creators include Keri Anderson, mobile app designer, and Brooke Gardner and Michelle Hogan, graphic artists.  The creation of GreenU was made possible by a grant from the Verizon Foundation."];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setFont:[_appConstants getBoldFontWithSize:12.0]];
        [_textLabel setNumberOfLines:0];  //0 = multiple lines
        [_textLabel setTextAlignment:NSTextAlignmentLeft];


        
        
        _sustainImageView = [[UIImageView alloc]initWithImage:[_appConstants getAboutImage:1]];
        _SLCImageView     = [[UIImageView alloc]initWithImage:[_appConstants getAboutImage:2]];
        _VerizonImageView = [[UIImageView alloc]initWithImage:[_appConstants getAboutImage:3]];
        
        [self addSubview:_aboutLabel];
        [self addSubview:_textLabel];
        [self addSubview:_sustainImageView];
        [self addSubview:_SLCImageView];
        [self addSubview:_VerizonImageView];
        
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
    //CGRect insetBounds  = CGRectInset(bounds, bounds.size.width * 0.0, 0.0);
    
    //create the top label margin  (for consistency across pages)
    CGRect topLabelRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y, insetBounds.size.width, TOPLABELHEIGHT);
    
    //now adjust the inset bounds
    insetBounds.origin.y = insetBounds.origin.y + TOPLABELHEIGHT / 2.0;  // this can be adjusted as needed per frame
    insetBounds.size.height = insetBounds.size.height - TOPLABELHEIGHT;
    
    
    
    /***  REMAINING RECTS  ***/
    
    // the specific rects that will be used for subviews
    CGRect textRect;
    CGRect iconRect;
    CGRect sustainRect;
    CGRect spacerRect;  //for a bit of space between the logos
    CGRect SLCRect;
    CGRect VerizonRect;
    
    textRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y, insetBounds.size.width, insetBounds.size.height * (2.0 / 3.0));
    iconRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y + textRect.size.height, insetBounds.size.width, insetBounds.size.height - textRect.size.height);
    
    //CGRectDivide(insetBounds, &aboutRect, &textRect,  insetBounds.size.height / 18.0, CGRectMinYEdge);
    //CGRectDivide(insetBounds, &textRect, &iconRect,  insetBounds.size.height / 1.5, CGRectMinYEdge);
    
    //shorten the width of the image rects a bit
    //iconRect = CGRectInset(iconRect, iconRect.size.width * .12, 0.0);
    CGRectDivide(iconRect, &sustainRect, &spacerRect,  iconRect.size.height / 3.0, CGRectMinYEdge);
    CGRectDivide(spacerRect, &spacerRect, &SLCRect,  spacerRect.size.height / 6.0, CGRectMinYEdge);

    
    //SLC rect needs to be square
    //now that we have the height, establish the width
    SLCRect.size.width =  SLCRect.size.height;
    SLCRect.origin.x = SLCRect.origin.x - 8.0;  //move back over a bit
  
    
    //Verizon rect needs to be a ration of 500 width to 300 height
    //we have the width, establish the height
    VerizonRect.origin.y = SLCRect.origin.y;
    VerizonRect.origin.x = SLCRect.origin.x + SLCRect.size.width+ 15.0;
    VerizonRect.size.width = sustainRect.size.width - SLCRect.size.width - 50.0;
    VerizonRect.size.height = (3.0 / 5.0) * VerizonRect.size.width;
    
    
    //the sustain rect needs to be a ratio of 193 wide to 45 high - we have the height
    sustainRect.size.width = (193.0 / 45.0) * sustainRect.size.height;
    
    
    // set the frames
    [_aboutLabel        setFrame: topLabelRect];
    [_textLabel         setFrame: textRect];
    [_sustainImageView  setFrame:sustainRect];
    [_SLCImageView      setFrame:SLCRect];
    [_VerizonImageView  setFrame:VerizonRect];
    
    
    
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
