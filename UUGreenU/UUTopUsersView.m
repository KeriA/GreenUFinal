//
//  UUTopUsersView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUTopUsersView.h"

@implementation UUTopUsersView
{
    UILabel* _topUsersLabel;
    UILabel* _indAndTeamLabel;
    UITableView* _monthlyAllTimeTableView;
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
         _topUsersLabel = [[UILabel alloc] init];
        [_topUsersLabel setBackgroundColor:[UIColor clearColor]];
        [_topUsersLabel setText:@"Top Users"];
        [_topUsersLabel setTextColor:[UIColor whiteColor]];
        [_topUsersLabel setFont:[_appConstants getBoldFontWithSize:TOPLABELFONTSIZE]];
        [_topUsersLabel setTextAlignment:NSTextAlignmentLeft];
        
        _indAndTeamLabel = [[UILabel alloc] init];
        [_indAndTeamLabel setBackgroundColor:[UIColor clearColor]];
        [_indAndTeamLabel setText:@"Individual & Team"];
        [_indAndTeamLabel setTextColor:[UIColor whiteColor]];
        [_indAndTeamLabel setFont:[_appConstants getItalicsFontWithSize:15.0]];
        [_indAndTeamLabel setTextAlignment:NSTextAlignmentLeft];
        
        _monthlyAllTimeTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _monthlyAllTimeTableView.rowHeight = 100;
        _monthlyAllTimeTableView.scrollEnabled = NO;
        _monthlyAllTimeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _monthlyAllTimeTableView.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:_topUsersLabel];
        [self addSubview:_indAndTeamLabel];
        [self addSubview:_monthlyAllTimeTableView];
        

    }
    return self;
    
}//end Constructor

/**
 *  Allows the View controller to set itself as delegate
 *
 */
-(void) setTableViewDelegates:(id)viewController
{
    [_monthlyAllTimeTableView setDataSource:viewController];
    [_monthlyAllTimeTableView setDelegate:viewController];
    
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
    CGRect indAndTeamRect;
    CGRect tableViewRect;
    
    indAndTeamRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y, insetBounds.size.width, 20.0);
    tableViewRect  = CGRectMake(insetBounds.origin.x, insetBounds.origin.y + 80.0, insetBounds.size.width, 400.0);
    
    
    
    // set the frames
    [_topUsersLabel             setFrame:topLabelRect];
    [_indAndTeamLabel           setFrame:indAndTeamRect];
    [_monthlyAllTimeTableView   setFrame:tableViewRect];
    
    
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
