//
//  UUSpecificChallengeView.h
//  UUGreenU
//
//  Created by Keri Anderson on 5/15/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUCalendarView.h"

// we will have the view controller handle all the events of this view
@protocol UUSpecificChallengeViewDelegate
@required
- (void) submitButtonWasPressed;
- (void) calendarButtonWasPressed;
- (void) oneTimeButtonWasPressed;
- (void) facebookButtonWasPressed;
- (void) twitterButtonWasPressed;
- (void) calendarDoneButtonWasPressed;
@end // end protocol


@interface UUSpecificChallengeView : UIView
{
    UUApplicationConstants* _appConstants;
    id<UUSpecificChallengeViewDelegate>specificChallengeViewDelegate;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id specificChallengeViewDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants andMonthNumber: (int) monthNumber andType: (int) challengeType;
- (void) setCalendarViewDelegate:(id)delegate;

- (void) setChallengeTeaser:(NSString*)teaser andDescription:(NSString*)description;
- (void) updatePointsForChallenge:(int)userPoints andChallengePoints:(int)challengePoints;
- (void) toggleCheckBox;
- (void) showCalendarView;
- (void) hideCalendarView;
- (void) setCalendar:(int)monthFirstDay numDays:(int)numDays daysCompleted:(NSMutableArray*)daysCompleted andMonthString:(NSString*)monthString;
- (void)setButtonToSelectedState:(int)buttonID;
- (void)setButtonToUnselectedState:(int)buttonID;
- (BOOL)oneTimeBoxIsSelected;

- (void) setComponentsToComplete;
- (void) setComponentsToInComplete;
- (void) setCalendarMonthAndYear:(NSString*)monthAndYearString;

@end
