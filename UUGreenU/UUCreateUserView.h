//
//  UUCreateUserView.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/12/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>  // used so that CALayer properties of textfields will be visible

// for ease of use and clarification
#define displayNameTFTag 1
#define emailTFTag 2
#define passwordTFTag 3


// we will have the view controller handle all the events of this view
@protocol UUCreateUserViewDelegate
@required
- (void) signUpButtonWasPressed;
- (void) faceBookButtonWasPressed;
- (void) twitterButtonWasPressed;
@end // end protocol

@interface UUCreateUserView : UIView
{
    UUApplicationConstants* _appConstants;
    id<UUCreateUserViewDelegate>createUserViewDelegate;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id createUserViewDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;
-(void) setTextFieldDelegates:(id)delegate;
-(void) updateErrorMessage:(NSString*)message;

@end
