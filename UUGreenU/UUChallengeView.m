//
//  UUChallengeView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUChallengeView.h"

@implementation UUChallengeView
{
    UILabel*      _challengeTopLabel;
    UIButton*     _takeChallengeButton;
    UIImage*      _challengeImage;
    UILabel*      _monthLabel;
    UILabel*      _topicLabel;
    UIButton*     _prevChallengesButton;
    
    //for pickerview
    UIView*       _pickerViewFrameView;
    UIPickerView* _pickerView;
 
    
    CGRect _pickerFrameShow;
    CGRect _pickerFrameHide;
    
    int _currentMonth;

    
    NSString* _topicString;
}

@synthesize challengeViewDelegate;

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
        _challengeTopLabel = [[UILabel alloc] init];
        [_challengeTopLabel setBackgroundColor:[UIColor clearColor]];
        [_challengeTopLabel setText:@"Take the Challenge"];
        [_challengeTopLabel setTextColor:[UIColor whiteColor]];
        [_challengeTopLabel setFont:[_appConstants getBoldFontWithSize:TOPLABELFONTSIZE]];
        [_challengeTopLabel setTextAlignment:NSTextAlignmentCenter];
        [_challengeTopLabel setNumberOfLines:1];
        [_challengeTopLabel setLineBreakMode:NSLineBreakByWordWrapping];
     
        
        //this button just looks like a picture
        //image will be set later
        _takeChallengeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        _takeChallengeButton.backgroundColor = [UIColor clearColor];
        [_takeChallengeButton setTitle:@"" forState:UIControlStateNormal];
        [_takeChallengeButton addTarget: challengeViewDelegate
                             action:@selector(takeChallengeButtonWasPressed)
                   forControlEvents:UIControlEventTouchDown];

        _monthLabel = [[UILabel alloc] init];
        [_monthLabel setBackgroundColor:[UIColor clearColor]];
        [_monthLabel setTextColor:[_appConstants mustardYellowColor]];
        [_monthLabel setFont:[_appConstants getStandardFontWithSize:25.0]];
        [_monthLabel setTextAlignment:NSTextAlignmentCenter];
        [_monthLabel setNumberOfLines:1];
        [_monthLabel setLineBreakMode:NSLineBreakByWordWrapping];

        
        
        _topicLabel = [[UILabel alloc] init];
        [_topicLabel setBackgroundColor:[UIColor clearColor]];
        [_topicLabel setTextColor:[_appConstants mustardYellowColor]];
        [_topicLabel setFont:[_appConstants getStandardFontWithSize:25.0]];
        [_topicLabel setTextAlignment:NSTextAlignmentCenter];
        [_topicLabel setNumberOfLines:2];
        [_topicLabel setLineBreakMode:NSLineBreakByWordWrapping];

        
        // rounded rect button
        _prevChallengesButton = [[UIButton alloc]init];
        _prevChallengesButton.layer.borderWidth = .06f; // these two lines
        _prevChallengesButton.layer.cornerRadius = 6;   // round the corners
        [_prevChallengesButton setTitle:@"Previous Challenges" forState:UIControlStateNormal];
        [_prevChallengesButton setBackgroundColor:[_appConstants cherryRedColor]];
        [_prevChallengesButton.titleLabel setFont:[_appConstants getBoldFontWithSize:18.0]];
        [_prevChallengesButton.titleLabel setTextColor:[UIColor whiteColor]];
        [_prevChallengesButton addTarget: challengeViewDelegate
                               action:@selector(previousChallengesButtonWasPressed)
                     forControlEvents:UIControlEventTouchDown];

        
        //_pickerViewFrameView holds all the needed components for the picker
        _pickerViewFrameView = [[UIView alloc]init];
        _pickerViewFrameView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.6]; //semi-transparent black
        
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
        [_pickerViewFrameView addSubview:_pickerView];
        
        [self addSubview: _challengeTopLabel];
        [self addSubview: _takeChallengeButton];
        [self addSubview: _monthLabel];
        [self addSubview: _topicLabel];
        [self addSubview: _pickerViewFrameView];
        [self addSubview: _prevChallengesButton];
        
        
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
    insetBounds.origin.y = insetBounds.origin.y + TOPLABELHEIGHT + 10.0;  // this can be adjusted as needed per frame
    insetBounds.size.height = insetBounds.size.height - TOPLABELHEIGHT;
    
    
    
    /***  REMAINING RECTS  ***/
    // the specific rects that will be used for subviews
    CGRect takeChallengeButtonRect;
    CGRect monthLabelRect;
    CGRect topicLabelRect;
    CGRect prevChallengesButtonRect;

    
    CGFloat spacer = 10.0;
    CGFloat takeChallengeSize = 160.0; //take challenge button needs to be square and centered
    takeChallengeButtonRect = CGRectMake(insetBounds.origin.x + ((insetBounds.size.width - takeChallengeSize) / 2.0), insetBounds.origin.y, takeChallengeSize, takeChallengeSize);
    
    CGFloat labelHeight = 30.0;
    monthLabelRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y + takeChallengeSize + spacer, insetBounds.size.width, labelHeight);
    topicLabelRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y + takeChallengeSize + labelHeight + (spacer/ 1.5), insetBounds.size.width, labelHeight);
    
    prevChallengesButtonRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y + 3.5*labelHeight + takeChallengeSize, insetBounds.size.width, labelHeight + 10.0);
    
    //shorten the width of the prevChallengeRect
    CGFloat shortenAmount = 20.0;
    prevChallengesButtonRect.origin.x = prevChallengesButtonRect.origin.x + (shortenAmount/2.0);
    prevChallengesButtonRect.size.width = prevChallengesButtonRect.size.width - shortenAmount;

    
    //set the frame for showing the picker
    CGFloat pickerFrameHeight = 162.0;
    CGFloat pickerFrameShowY  = prevChallengesButtonRect.origin.y + prevChallengesButtonRect.size.height - 20.0;
    CGFloat pickerFrameHideY  = bounds.origin.y + bounds.size.height + (TOPLABELHEIGHT * 1.5 + 10.0); //make sure it is completely off of the screen
    _pickerFrameShow = CGRectMake(prevChallengesButtonRect.origin.x, pickerFrameShowY, prevChallengesButtonRect.size.width, pickerFrameHeight);
    _pickerFrameHide = CGRectMake(prevChallengesButtonRect.origin.x, pickerFrameHideY, prevChallengesButtonRect.size.width, pickerFrameHeight);
    
    
    
    // set the frames
    [_challengeTopLabel    setFrame:topLabelRect];
    [_takeChallengeButton  setFrame:takeChallengeButtonRect];
    [_monthLabel           setFrame: monthLabelRect];
    [_topicLabel           setFrame:topicLabelRect];
    [_prevChallengesButton setFrame:prevChallengesButtonRect];
    [_pickerViewFrameView  setFrame:_pickerFrameHide];
    [_pickerView           setFrame:_pickerViewFrameView.frame];
    
    
    _pickerView.frame = CGRectMake(0,0, _pickerViewFrameView.frame.size.width, _pickerViewFrameView.frame.size.height);
    
    
    
}// end layout subviews

/**************************************************************************************************
 *
 *                          Update parameters from view controller
 *
 **************************************************************************************************/
- (void) setCurrentMonth: (int) month
{
    _currentMonth = month;
    
    //now that the date has been set, set the current month image
    _challengeImage = [_appConstants getChallengeMonthImage:month];
    [_takeChallengeButton setImage: _challengeImage forState:UIControlStateNormal];
    
    //get the currentmonth text
    _monthLabel.text = [_appConstants getMonthText:month];
    
    [self setNeedsDisplay];
    
}//end setCurrentDay


- (void) setTopicString:(NSString*)topicString
{
    _topicLabel.text = topicString;
    [self setNeedsDisplay];
    
}//end set Topic String

- (void) showPickerView
{

    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    _pickerViewFrameView.frame = _pickerFrameShow;
    
    [UIView commitAnimations];
    
}//end showORHidePickerView

- (void) hidePickerView
{
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _pickerViewFrameView.frame = _pickerFrameHide;
    
    [UIView commitAnimations];
    
}



/*****************************************************************************************************************
 *
 *                              Set Delegates
 *
 *****************************************************************************************************************/

- (void) setPickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource
{
    [_pickerView setDataSource:pickerDataSource];
}


- (void) setPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate
{
    [_pickerView setDelegate:pickerDelegate];
}


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
