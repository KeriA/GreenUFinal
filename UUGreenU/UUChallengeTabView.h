//
//  UUChallengeTabView.h
//  UUGreenU
//
//  Created by Keri Anderson on 5/28/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

// we will have the view controller handle all the events of this view
@protocol UUChallengeTabViewDelegate
@required
- (void) informationButtonWasPressed;
- (void) challengesButtonWasPressed;
@end // end protocol

@interface UUChallengeTabView : UIView
{
    UUApplicationConstants* _appConstants;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id challengeTabViewDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;

- (void) setInformationButtonToSelected;
- (void) setInformationButtonToNotSelected;
- (void) setChallengesButtonToSelected;
- (void) setChallengesButtonToNotSelected;
- (void) setTableViewDelegates:(id)viewController;
- (void) setURl: (NSString*)urlString;
- (void) hideWebView;
- (void) showWebView;
- (void) reloadTableData;

@end
