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
    UILabel*      _challengeTopLable;
    UIButton*     _takeChallengeButton;
    UIImage*      _challengeImage;
    UILabel*      _topicLable;
    UIButton*     _prevChallengesButton;
    UIPickerView* _pickerView;
    
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
        _challengeTopLable = [[UILabel alloc] init];
        [_challengeTopLable setBackgroundColor:[UIColor clearColor]];
        [_challengeTopLable setText:@"Take the Challenge"];
        [_challengeTopLable setTextColor:[UIColor whiteColor]];
        [_challengeTopLable setFont:[_appConstants getBoldFontWithSize:28.0]];
        [_challengeTopLable setTextAlignment:NSTextAlignmentCenter];
        [_challengeTopLable setNumberOfLines:1];
        [_challengeTopLable setLineBreakMode:NSLineBreakByWordWrapping];
     
        
        //this button just looks like a picture
        //image will be set later
        _takeChallengeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // set the text properties
        _takeChallengeButton.backgroundColor = [UIColor clearColor];
        [_takeChallengeButton setTitle:@"" forState:UIControlStateNormal];
        [_takeChallengeButton addTarget: challengeViewDelegate
                             action:@selector(takeChallengeButtonWasPressed)
                   forControlEvents:UIControlEventTouchDown];

        
        _topicLable = [[UILabel alloc] init];
        [_topicLable setBackgroundColor:[UIColor clearColor]];
        [_topicLable setTextColor:[_appConstants mustardYellowColor]];
        [_topicLable setFont:[_appConstants getStandardFontWithSize:21.0]];
        [_topicLable setTextAlignment:NSTextAlignmentCenter];
        [_topicLable setNumberOfLines:2];
        [_topicLable setLineBreakMode:NSLineBreakByWordWrapping];

        
        // rounded rect button
        _prevChallengesButton = [[UIButton alloc]init];
        _prevChallengesButton.layer.borderWidth = .06f; // these two lines
        _prevChallengesButton.layer.cornerRadius = 6;   // round the corners
        [_prevChallengesButton setTitle:@"Previous Challenges" forState:UIControlStateNormal];
        [_prevChallengesButton setBackgroundColor:[_appConstants cherryRedColor]];
        [_prevChallengesButton.titleLabel setFont:[_appConstants getBoldFontWithSize:20]];
        [_prevChallengesButton.titleLabel setTextColor:[UIColor whiteColor]];
        [_prevChallengesButton addTarget: challengeViewDelegate
                               action:@selector(previousChallengesButtonWasPressed)
                     forControlEvents:UIControlEventTouchDown];

        _pickerView = [[UIPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview: _challengeTopLable];
        [self addSubview: _takeChallengeButton];
        [self addSubview: _topicLable];
        [self addSubview: _prevChallengesButton];
        [self addSubview: _pickerView];

        
        
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
    CGRect originalbounds = [self bounds];
    CGRect bounds = [self bounds];
    
    // the specific rects that will be used for subviews
    CGRect challengeTopLableRect;
    CGRect takeChallengeButtonRect;
    CGRect topicLabelRect;
    CGRect prevChallengesButtonRect;
    CGRect spacerRect;
    
    
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
    
    CGFloat widthInset  = bounds.size.width * 0.05; // take off a percentage of the width
    CGFloat heightInset = bounds.size.height * 0.10; // take off a percentage of the width
    bounds = CGRectInset(bounds, widthInset, heightInset);
    
    
    CGRectDivide(bounds, &challengeTopLableRect, &takeChallengeButtonRect, bounds.size.height/ 6.0, CGRectMinYEdge);
    CGRectDivide(takeChallengeButtonRect, &takeChallengeButtonRect, &topicLabelRect, takeChallengeButtonRect.size.height/ 2.2, CGRectMinYEdge);
    CGRectDivide(topicLabelRect, &topicLabelRect, &spacerRect, topicLabelRect.size.height/3.0, CGRectMinYEdge);
    CGRectDivide(spacerRect, &spacerRect, &prevChallengesButtonRect, spacerRect.size.height/3.0, CGRectMinYEdge);
    //             prevChallengesButtonRect, topicLabelRect.size.height/ 3.0, CGRectMinYEdge);
    
    // make sure that the challenge button frame is square so that the image will show nicely
    if (takeChallengeButtonRect.size.width > takeChallengeButtonRect.size.height)
    {
        takeChallengeButtonRect.size.width = takeChallengeButtonRect.size.height;
    }
    else
    {
        takeChallengeButtonRect.size.height = takeChallengeButtonRect.size.width;
    }
    // and re-center
    float difference = originalbounds.size.width - takeChallengeButtonRect.size.width;
    difference = difference/2.0;
    takeChallengeButtonRect.origin.x = difference;

    //shrink the previous Challenges button height
    CGFloat challengeHeightInset = prevChallengesButtonRect.size.height * 0.30; // take off a percentage of the width
    CGFloat challengeWidthInset  = prevChallengesButtonRect.size.width * .10;
    prevChallengesButtonRect = CGRectInset(prevChallengesButtonRect, challengeWidthInset, challengeHeightInset);

    
    
    
    
    // set the frames
    [_challengeTopLable    setFrame:challengeTopLableRect];
    [_takeChallengeButton  setFrame:takeChallengeButtonRect];
    [_topicLable           setFrame:topicLabelRect];
    [_prevChallengesButton setFrame:prevChallengesButtonRect];
    
    
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
    
    [self setNeedsDisplay];
    
}//end setCurrentDay

- (void) setTopicString:(NSString*)topicString
{
    _topicLable.text = topicString;
    [self setNeedsDisplay];
    
}//end set Topic String


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
