//
//  UUCalendarView.h
//  UUGreenU
//
//  Created by Keri Anderson on 5/15/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

// we will have the view controller handle all the events of this view
@protocol UUCalendarViewDelegate
    - (void) calendarDayButtonWasPressed:(id)sender;
@required
//- (void) submitButtonWasPressed;

@end // end protocol

@interface UUCalendarView : UIView
{
    UUApplicationConstants* _appConstants;
    id<UUCalendarViewDelegate>calendarViewDelegate;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id calendarViewDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;
- (void) setCalendar:(int)monthFirstDay numDays:(int)numDays daysCompleted:(NSMutableArray*)daysCompleted andMonthString:(NSString*)monthString;
- (void)setButtonToSelectedState:(int)buttonID;
- (void)setButtonToUnselectedState:(int)buttonID;


@end
