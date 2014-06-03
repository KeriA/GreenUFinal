//
//  UUChallengeView.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

// we will have the view controller handle all the events of this view
@protocol UUChallengeViewDelegate
@required
- (void) takeChallengeButtonWasPressed;
- (void) previousChallengesButtonWasPressed;
@end // end protocol

@interface UUChallengeView : UIView
{
    UUApplicationConstants* _appConstants;
    id<UUChallengeViewDelegate>challengeViewDelegate;
    
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id challengeViewDelegate;
//@property (readwrite, nonatomic) id<UIPickerViewDataSource> pickerDataSource;
//@property (readwrite, nonatomic) id<UIPickerViewDelegate> pickerDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;
- (void) setCurrentMonth: (int) month;
- (void) setTopicString:(NSString*)topicString;

- (void) setPickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource;
- (void) setPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate;

- (void) showPickerView;
- (void) hidePickerView;



@end
