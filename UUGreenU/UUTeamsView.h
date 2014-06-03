//
//  UUTeamsView.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEAMTAG 1
#define NEWTEAMTAG 2

#define SCHOOLBUTTONTAG 1
#define BUSINESSBUTTONTAG 2
#define OTHERBUTTONTAG 3



// we will have the view controller handle all the events of this view
@protocol UUTeamsViewDelegate
@required
- (void) schoolButtonWasPressed;
- (void) businessButtonWasPressed;
- (void) otherButtonWasPressed;
- (void) newTeamCheckBoxButtonWasPressed:(id)Sender;
- (void) requestNewTeamButtonWasPressed;
- (void) pickerDoneButtonWasPressed;
- (void) joinTeamButtonWasPressed;
@end // end protocol

@interface UUTeamsView : UIView
{
    UUApplicationConstants* _appConstants;
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id teamsViewDelegate;

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;

-(void) setTextFieldDelegates:(id)delegate;
- (void) setPickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource;
- (void) setPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate;

- (void) setSchoolButtonPressedResults;
- (void) setBusinessButtonPressedResults;
- (void) setOtherButtonPressedResults;
- (void) setCurrentTeam:(NSString*)currentTeam;

- (void) enableTeamsButtons;
- (void) disableTeamsButtons;

- (void) resetTextFieldColor;

- (void) showPickerView: (int) atLocation;
- (void) hidePickerView;

- (void) liftTextField;
- (void) returnTextField;

- (bool) categorySelected;
- (int) teamNameLength;

-(NSString*) getNewTeamName;
-(NSString*) getNewTeamType;

-(void) setPickersForCategory:(int)category;


@end
