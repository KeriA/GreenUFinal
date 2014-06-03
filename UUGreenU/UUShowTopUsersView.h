//
//  UUShowTopUsersView.h
//  UUGreenU
//
//  Created by Keri Anderson on 5/26/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define nameKey @"nameKey"
#define pointsKey @"pointsKey"

// we will have the view controller handle all the events of this view
@protocol UUShowTopUsersViewDelegate
@required
- (void) individualButtonWasPressed;
- (void) teamsButtonWasPressed;
@end // end protocol

@interface UUShowTopUsersView : UIView
{
    UUApplicationConstants* _appConstants;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id showTopUsersViewDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;

- (void) setViewComponents:(NSMutableArray*)elementsArray andIndividualOrTeam:(int)individualORTeam;
- (void) setTopLabels:(NSArray*)array;

- (void) setIndividualButtonBackgroundToSelected;
- (void) setIndividualButtonBackgroundToNotSelected;
- (void) setTeamButtonBackgroundToSelected;
- (void) setTeamButtonBackgroundToNotSelected;


@end
