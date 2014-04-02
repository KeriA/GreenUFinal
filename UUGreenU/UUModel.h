//
//  UUModel.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUNetworkConstants.h"

/****
 *  call back methods for when the app received server response
 */

// Register Participant
@protocol UURegisterParticipantDataReceivedDelegate
@required
-(void) registerParticipantServerDataReceived:(int)responseCase;
@end

// Participant Login
@protocol UUParticipantLoginDataReceivedDelegate
@required
-(void) ParticipantLoginServerDataReceived:(int)responseCase;
@end

@interface UUModel : NSObject
{
    
}

@property (nonatomic, weak) id registerParticipantDataReceivedDelegate;
@property (nonatomic, weak) id participantLoginDataReceivedDelegate;




- (void) sendMessageToServer:(int)serverMethod withDataDictionary:(NSMutableDictionary*)dataDictionary;
- (void) storeUserName: (NSString*)userName;
- (void) storeEmail:(NSString*)email andPassword: (NSString*)password;

- (NSString*) getUserName;
- (NSString*) getUserTeamName;
- (BOOL) hasUserKey;
- (void) setUserProfileImage:(UIImage*)newImage;
- (UIImage*) getUserImage;
- (void) setUserPassword: (NSString*)newPassword;
- (NSString*) getUserPassword;

- (int) getCurrentMonth;
- (int) getCurrentYear;
- (NSString*) getCurrentChallengeTopic;
- (int) getTopicIDForCurrentMonth: (int) month;
- (NSString*) getCurrentMonthURL: (int) month;


@end
