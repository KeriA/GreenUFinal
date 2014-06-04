//
//  UUCalendarView.m
//  UUGreenU
//
//  Created by Keri Anderson on 5/15/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUCalendarView.h"

@implementation UUCalendarView
{
    //UILabel* _monthLabel;
    UILabel* _sunLabel;
    UILabel* _monLabel;
    UILabel* _tueLabel;
    UILabel* _wedLabel;
    UILabel* _thuLabel;
    UILabel* _friLabel;
    UILabel* _satLabel;
    
    //holds 35 buttons:  5 rows of 7 days
    NSMutableArray* _calendarButtonsArray;
    
    UIImage* _standardButtonImage;
    UIImage* _selectedButtonImage;
    UIImage* _userCompletedButtonImage;
    UIImage* _unavailableButtonIage;
    
    int _numCalendarButtons;
    //int _firstDay; // 0 = Sun, 1 = Mon, etc.. 6 = Sat
    //int _numDaysInMonth;
    //NSMutableArray* _userDaysCompleted;
    
}

@synthesize calendarViewDelegate;


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
        _numCalendarButtons = 5*7;  //5 rows, 7 days in a row
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[appConstants getBackgroundImage]]];
        //[self setBackgroundColor:[_appConstants burntOrangeColor]]; //for testing
        
        //_monthLabel = [[UILabel alloc] init];
        //[_monthLabel setBackgroundColor:[UIColor clearColor]];
        //[_monthLabel setText:@""];
        //[_monthLabel setTextColor:[_appConstants brightGreenColor]];
        //[_monthLabel setFont:[_appConstants getBoldFontWithSize:15.0]];
        //[_monthLabel setTextAlignment:NSTextAlignmentCenter];
        
        _sunLabel = [[UILabel alloc] init];
        [_sunLabel setBackgroundColor:[UIColor clearColor]];
        [_sunLabel setText:@"Su"];
        [_sunLabel setTextColor:[UIColor whiteColor]];
        [_sunLabel setFont:[_appConstants getBoldFontWithSize:13.0]];
        [_sunLabel setTextAlignment:NSTextAlignmentCenter];
        
        _monLabel = [[UILabel alloc] init];
        [_monLabel setBackgroundColor:[UIColor clearColor]];
        [_monLabel setText:@"M"];
        [_monLabel setTextColor:[UIColor whiteColor]];
        [_monLabel setFont:[_appConstants getBoldFontWithSize:13.0]];
        [_monLabel setTextAlignment:NSTextAlignmentCenter];
        
        _tueLabel = [[UILabel alloc] init];
        [_tueLabel setBackgroundColor:[UIColor clearColor]];
        [_tueLabel setText:@"Tu"];
        [_tueLabel setTextColor:[UIColor whiteColor]];
        [_tueLabel setFont:[_appConstants getBoldFontWithSize:13.0]];
        [_tueLabel setTextAlignment:NSTextAlignmentCenter];
        
        _wedLabel = [[UILabel alloc] init];
        [_wedLabel setBackgroundColor:[UIColor clearColor]];
        [_wedLabel setText:@"W"];
        [_wedLabel setTextColor:[UIColor whiteColor]];
        [_wedLabel setFont:[_appConstants getBoldFontWithSize:13.0]];
        [_wedLabel setTextAlignment:NSTextAlignmentCenter];
        
        _thuLabel = [[UILabel alloc] init];
        [_thuLabel setBackgroundColor:[UIColor clearColor]];
        [_thuLabel setText:@"Th"];
        [_thuLabel setTextColor:[UIColor whiteColor]];
        [_thuLabel setFont:[_appConstants getBoldFontWithSize:13.0]];
        [_thuLabel setTextAlignment:NSTextAlignmentCenter];
        
        _friLabel = [[UILabel alloc] init];
        [_friLabel setBackgroundColor:[UIColor clearColor]];
        [_friLabel setText:@"F"];
        [_friLabel setTextColor:[UIColor whiteColor]];
        [_friLabel setFont:[_appConstants getBoldFontWithSize:13.0]];
        [_friLabel setTextAlignment:NSTextAlignmentCenter];
        
        _satLabel = [[UILabel alloc] init];
        [_satLabel setBackgroundColor:[UIColor clearColor]];
        [_satLabel setText:@"Sa"];
        [_satLabel setTextColor:[UIColor whiteColor]];
        [_satLabel setFont:[_appConstants getBoldFontWithSize:13.0]];
        [_satLabel setTextAlignment:NSTextAlignmentCenter];

        //create the buttons
        _standardButtonImage      = [_appConstants getCalendarButtonStandardImage];
        _selectedButtonImage      = [_appConstants getCalendarButtonSelectedImage];
        _userCompletedButtonImage = [_appConstants getCalendarButtonUserCompletedImage];
        _unavailableButtonIage    = [_appConstants getCalendarButtonUnavailableImage];
        
        
        _calendarButtonsArray = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < _numCalendarButtons; i++)
        {
            // rounded rect button
            UIButton* calendarButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            
            
            [_calendarButtonsArray addObject:calendarButton];
            [self addSubview:calendarButton];
            
        }// end for i
       
        //[self addSubview:_monthLabel];
        [self addSubview:_sunLabel];
        [self addSubview:_monLabel];
        [self addSubview:_tueLabel];
        [self addSubview:_wedLabel];
        [self addSubview:_thuLabel];
        [self addSubview:_friLabel];
        [self addSubview:_satLabel];
        
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
    
    //CGFloat boundsInsetWidth  = bounds.size.width  * 0.15; // take off a percentage of the width
    //CGFloat boundsInsetHeight = bounds.size.height * 0.15; // take off a percentage of the height
    
    //CGRectrect, CGFloat dx, CGFloat dy
    //CGRect insetBounds = CGRectInset(bounds, boundsInsetWidth, boundsInsetHeight);
    //NSLog(@"\ninsetBounds width is %f and height is %f", insetBounds.size.width, insetBounds.size.height); //for testing
    
    
    // the specific rects that will be used for subviews
    CGRect calendarTitleRect;  //holds the month and day labels
    CGRect buttonsRect; //holds the actual buttons
    
    CGRect sunRect;
    CGRect monRect;
    CGRect tueRect;
    CGRect wedRect;
    CGRect thuRect;
    CGRect friRect;
    CGRect satRect;
    
    CGFloat sectionHeight = bounds.size.width / 7.0;
    CGFloat sectionWidth  = bounds.size.width / 7.0;
    
    //CGRectDivide(bounds, &calendarTitleRect, &buttonsRect, bounds.size.height - (sectionHeight * 6.0), CGRectMinYEdge);
    CGRectDivide(bounds, &calendarTitleRect, &buttonsRect, bounds.size.height - (sectionHeight * 5.0), CGRectMinYEdge);
    CGRectDivide(calendarTitleRect, &calendarTitleRect, &sunRect, 0.0, CGRectMinYEdge);
    //divide up the day labels
    CGFloat originalLabelX = sunRect.origin.x;
    CGFloat labelY = sunRect.origin.y;
    CGFloat labelHeight  = sunRect.size.height;
    sunRect = CGRectMake(originalLabelX, labelY, sectionWidth, labelHeight);
    monRect = CGRectMake(originalLabelX + (1.0 * sectionWidth), labelY, sectionWidth, labelHeight);
    tueRect = CGRectMake(originalLabelX + (2.0 * sectionWidth), labelY, sectionWidth, labelHeight);
    wedRect = CGRectMake(originalLabelX + (3.0 * sectionWidth), labelY, sectionWidth, labelHeight);
    thuRect = CGRectMake(originalLabelX + (4.0 * sectionWidth), labelY, sectionWidth, labelHeight);
    friRect = CGRectMake(originalLabelX + (5.0 * sectionWidth), labelY, sectionWidth, labelHeight);
    satRect = CGRectMake(originalLabelX + (6.0 * sectionWidth), labelY, sectionWidth, labelHeight);
   
   
    CGFloat originalX = buttonsRect.origin.x;
    CGFloat originalY = buttonsRect.origin.y;
    
  
    //divide up the buttons

    
    for (int i = 0; i < _numCalendarButtons; i++)
    {
    
        // mod % operator does not work with floats
        // use  B % A = B- (floor(B/A)*A)
        CGFloat buttonX = ((i - (floor(i*1.0 / 7.0) * 7.0))  * sectionWidth) + originalX;
        CGFloat buttonY = ((i/7) )* sectionHeight  + originalY;
        CGRect buttonRect = CGRectMake(buttonX, buttonY, sectionWidth, sectionHeight);
        
        [(UIButton*)[_calendarButtonsArray objectAtIndex:i] setFrame:buttonRect];
        
    }
    
    
    // set the frames
    //[_monthLabel  setFrame:calendarTitleRect];
    [_sunLabel    setFrame:sunRect];
    [_monLabel    setFrame:monRect];
    [_tueLabel    setFrame:tueRect];
    [_wedLabel    setFrame:wedRect];
    [_thuLabel    setFrame:thuRect];
    [_friLabel    setFrame:friRect];
    [_satLabel    setFrame:satRect];   
    

}// end layout subviews


/**************************************************************************************************
 *
 *                          view accessor methods
 *
 **************************************************************************************************/
- (void) setCalendar:(int)monthFirstDay numDays:(int)numDays daysCompleted:(NSMutableArray*)daysCompleted andMonthString:(NSString*)monthString
{
    //_monthLabel.text = monthString;
    
    for (int i = 0; i < _numCalendarButtons + monthFirstDay; i++)
    {
        UIButton* button;
        //pull out the appropriate button - may have to wrap around since we only have 5 rows of buttons
        if (i < _numCalendarButtons)
            button = [_calendarButtonsArray objectAtIndex:i];
        else
            button = [_calendarButtonsArray objectAtIndex:i - _numCalendarButtons];
            
        NSString* buttonNumberString;
        UIColor* enabledColor  = [UIColor blackColor];
        UIColor* disabledColor = [UIColor grayColor];

        
        if ( (i < monthFirstDay) || (i > numDays  + monthFirstDay - 1) ){  // invalid days for the month
            buttonNumberString = @""; //empty string
            [button setBackgroundColor:[UIColor blackColor]];
            button.enabled = false;
            [button.titleLabel setTextColor:disabledColor];
            
        }else{ //valid month day
            //first check to see if this day is a day the user has already completed the challenge
            int dayNumber = i - monthFirstDay + 1;
            
            bool isADayCompleted = false;
            int numDaysCompleted = (int)[daysCompleted count];
            for (int j = 0; j < numDaysCompleted; j++)
            {
                int dayCompleted = [[daysCompleted objectAtIndex:j]intValue];
                if (dayNumber == dayCompleted){
                    isADayCompleted = true;
                    break;
                }
            }//end for j
            
            buttonNumberString = [NSString stringWithFormat:@"%d", dayNumber];
            
            if (isADayCompleted){
                [button setBackgroundImage: [_userCompletedButtonImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                button.enabled = false;
                [button.titleLabel setTextColor:disabledColor];
            }else{
                [button setBackgroundImage: [_standardButtonImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [button setBackgroundImage: [_selectedButtonImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateHighlighted];
                button.enabled = true;
                button.tag = dayNumber; //set the tag to the day number the button represents
                [button.titleLabel setTextColor:enabledColor];
            }
            
            
        }//end else if
        
        
        [button setTitle:buttonNumberString forState:UIControlStateNormal];
        [button.titleLabel setFont:[_appConstants getBoldFontWithSize:10]];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [button addTarget: calendarViewDelegate
                           action:@selector(calendarDayButtonWasPressed:)
                 forControlEvents:UIControlEventTouchDown];
    }//end for i
    
    
    [self setNeedsDisplay];
        
}//end setCalendar



- (void)setButtonToUnselectedState:(int)buttonID
{
    for (int i = 0; i < _numCalendarButtons; i++)
    {
        UIButton* button = [_calendarButtonsArray objectAtIndex:i];
        
        if ((int)button.tag == buttonID)
        {
            [button setBackgroundImage: [_standardButtonImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            break;
        }
    }//end for i
    
}//end setButtonToUnselectedState

- (void)setButtonToSelectedState:(int)buttonID
{
    for (int i = 0; i < _numCalendarButtons; i++)
    {
        UIButton* button = [_calendarButtonsArray objectAtIndex:i];
        
        if ((int)button.tag == buttonID)
        {
            [button setBackgroundImage: [_selectedButtonImage stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            break;
        }
    }//end for i
    
}//end setButtonToUnselectedState

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
