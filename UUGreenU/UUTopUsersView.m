//
//  UUTopUsersView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUTopUsersView.h"

@implementation UUTopUsersView

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
    
    CGFloat boundsInset = bounds.size.width * 0.10; // take off a percentage of the width
    bounds = CGRectInset(bounds, boundsInset, boundsInset);
    
    // the specific rects that will be used for subviews
    CGRect profileImageViewRect;    // this will hold the profile image
    CGRect updateProfileButtonRect; // holds the updateProfile button
    
    
    
    CGRectDivide(bounds, &profileImageViewRect, &updateProfileButtonRect, bounds.size.height/ 2.0, CGRectMinYEdge);
    
    
    
    
    
    // set the frames
    //[_profileImageView    setFrame:profileImageViewRect];
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
