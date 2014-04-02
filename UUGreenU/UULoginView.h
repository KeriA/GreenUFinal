//
//  UULoginView.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

// for ease of use and clarification - used by both controller and view, so leave in .h file
#define emailTag 1
#define passwordTag 2

// we will have the view controller handle all the events of this view
@protocol UULoginViewDelegate
@required
-(void) loginButtonWasPressed;
-(void) faceBookLoginButtonWasPressed;
-(void) signUpButtonWasPressed;
@end // end protocol

@interface UULoginView : UIView
{
    UUApplicationConstants* _appConstants;
    
    id<UULoginViewDelegate>loginViewDelegate;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id loginViewDelegate;


- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;
-(void) setTextFieldDelegates:(id)delegate;

@end
