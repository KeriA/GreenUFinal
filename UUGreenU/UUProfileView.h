//
//  UUProfileView.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

// for ease of use and clarification - used by both controller and view, so leave in .h file
#define teamTag 1
#define passwordTag 2
#define pointsTag 3
#define rankTag 4

// we will have the view controller handle all the events of this view
@protocol UUProfileViewDelegate
@required
- (void) userImageButtonWasPressed;
- (void) changeUserNameButtonWasPressed;
- (void) changeTeamButtonWasPressed;
- (void) changePasswordButtonWasPressed;
- (void) takeMoreChallengesButtonWasPressed;
@end // end protocol

@interface UUProfileView : UIView
{
    UUApplicationConstants* _appConstants;
    id<UUProfileViewDelegate>profileViewDelegate;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id profileViewDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;
- (void) updateUserName: (NSString*)userName;
- (void) updateTeamName: (NSString*)teamName;
- (void) setTextFieldDelegates:(id)delegate;
- (void) updateUserImage: (UIImage*)newImage andSelectedImage:(UIImage*)selectedUserImage;
- (void) updateUserPassword: (NSString*)maskedPassword;
- (void) updateUserPoints:(int) points;
- (void) updateUserRank:(int) rank;

@end
