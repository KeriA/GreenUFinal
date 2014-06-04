//
//  UUSesson.h
//  UUGreenU
//
//  Created by Keri Anderson on 6/1/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "UUNetworkConstants.h"
//for ease and consistency in accessing functions
#define SUCCESS 1000
#define NETWORKERROR 9999
#define LOGINFAILURE 1005

#define LOGINFROMSPLASH 1
#define LOGINFROMLOGIN 2
#define LOGINFROMREGISTERPARTICIPANT 3
#define loginTypeKey @"typeKey"

//for updating the user's team
#define UPDATEFROMLOGIN 4
#define UPDATEFROMPROFILEPAGE 5
#define UPDATEFROMTEAMSPAGE 6
#define updateFromKey @"updateFrom"

// for ease and consistency in accessing Topic dictionaries
#define CURRENTMONTHLOCATION 0
//This app will cycle through a year, beginning
// in August.  This number is important because
// it will be used to determine if there
// are previous month challenges or not
#define BEGINNINGMONTH 8


#define SERVERCALLOBJECTKEY @"callObject"
#define ADD 1
#define REMOVE 0

//for user
#define needUserEmail      @"NeedUserEmail"
#define needUserPassword    @"NeedUserPassword"
#define userNameKey        @"UserName"
#define userEmailKey       @"Email"
#define userPasswordKey    @"Password"
#define userIDKey          @"UserKey"
#define userImageKey       @"userImage"
#define withImageKey       @"withImage"  //whether or not we are requesting the image at that time or not
#define userAllTimePointsKey      @"AllTimePoint"   //last 4 are used for the teams page
#define userAllTimeRankKey        @"AllTimeRank"
#define userCurrentMonthRankKey   @"CurrentMonthRank"
#define userCurrentMonthPointsKey @"CurrentMonthPoint"
#define noTeamSelectedID @"0"  //when the user has not joined a team

//for teams
#define SCHOOL                    @"SCHOOL"
#define BUSINESS                  @"BUSINESS"
#define OTHER                     @"OTHER"

#define teamCategoryKey           @"Category"
#define teamNameKey               @"Description"  //this is how it is named on the server
#define teamIDKey                 @"TeamKey"
#define teamTypeKey               @"TeamType"
#define teamAllTimePointsKey      @"AllTimePoint"
#define teamAllTimeRankKey        @"AllTimeRank"
#define teamCurrentMonthRankKey   @"CurrentMonthRank"
#define teamCurrentMonthPointsKey @"CurrentMonthPoint"


#define TOPICARRAYLOCATIONKEY  @"topicArrayLocation"  //used to access the _topicsArray
#define monthKey          @"Month"
#define yearKey           @"Year"
#define topicIDKey        @"TopicKey"
#define topicTitleKey     @"TopicTitle"
#define topicURLKey       @"TopicPage"
#define challengeArrayKey @"ChallengeArray"

//for ease in accessing challenges
#define challengeDescKey  @"ChallengeDescr"
#define challengeIDKey    @"ChallengeKey"
#define challengeNoKey    @"ChallengeNo"
#define daysPossibleKey   @"DaysPossible"
#define difficultyKey     @"Difficulty"
#define impactKey         @"Impact"
#define teaserKey         @"Teaser"
#define typeKey           @"Type"
#define userStatusKey     @"UserStatus"
#define dateInputKey      @"DateInput"  // this is an array of dates the user has completed the challenge
#define userPointsKey     @"UserPointsKey"  //total number of points the user has earned for this challenge
#define dateKey           @"dateKey"  //for an individual date string

#define oneTimeString @"One time"
#define repeatString  @"Repeat"

#define startUpOrUpdateKey @"startupOrUpdate"


//for top users page
#define topRankKey             @"Rank"
#define topIndividualNameKey   @"UserName"
#define topTeamNameKey         @"TeamName"
#define topPointsKey           @"Point"
#define periodKey              @"periodKey"  //used to determine if all time or current
#define MONTHLY 1
#define ALLTIME 2
#define INDIVIDUAL 3
#define TEAMS 4
#define currentString @"CURRENT"
#define allTimeString @"ALLTIME"

#define ONETIME 1
#define REPEAT 2

#define STARTUP 1
#define UPDATE 2


#define SUN 0
#define MON 1
#define TUE 2
#define WED 3
#define THU 4
#define FRI 5
#define SAT 6








/****
 *  call back methods for when the app received server response
 */

// UUModel listens to these calls
@protocol UUSessionDelegate
@required
- (void) loginResponseReceived:(int)responseCase andUserID:(int)userID andCallType:(int)callType;
- (void) registerParticipantResponseReceived:(int)responseCase andUserID:(int)userID;
- (void) startupCallsDataReceived:(int)responseCase withCallType:(int)callType;
- (void) newTeamRequestResponseReceived:(int)responseCase;
- (void) changeTeamFromTeamsPageResponseReceived:(int)responseCase andTeamID:(NSString*)teamID andAllTimeRank:(int)allTimeRank andMonthRank:(int)monthRank andAllTimePoint:(int)allTimepoint andMonthPoint:(int)monthPoint;
//for updating points for the app
- (void) updateUserPointsForChallengeWithDateArray:(NSArray*)dateArray andTopicsArrayLocation:(int)arrayLocation andChallengeNumber:(int)challengeNumber;
- (void) updateUserPoints:(int)points andRank:(int)rank;
- (void) updateTopTeamsCurrentMonth:(NSMutableArray*)monthTeams;
- (void) updateTopTeamsAllTime:(NSMutableArray*)allTimeTeams;
- (void) updateTopIndividualsCurrentMonth:(NSMutableArray*)monthIndividuals;
- (void) updateTopIndividualsAllTime:(NSMutableArray*)allTimeIndividuals;
- (void) updateCallsCompleteWithError:(BOOL)error;

- (void) requestPasswordResponseReceived:(int)responseCase;
@end


@interface UUSesson : NSObject
{
    
}
@property (nonatomic, weak) id sessionDelegate;

- (void) loginWithEmail:(NSString*)email andPassword:(NSString*)password andType:(int)type;
- (void) launchServerStartupFunctionsWithUserID:(NSString*)userID andCallType:(int)type;
- (void) registerNewParticipantWithEmail:(NSString*)email andPassword:(NSString*)password andUserName:(NSString*)username;
- (void) requestUserPassword:(NSString*)userEmail;

//new Team Request
- (void) requestNemTeam:(NSString*)teamName andType:(NSString*)teamType andUserId:(NSString*)userID;
- (void) changeUserTeam:(NSString*)teamID withUserID:(NSString*)userID;

//update user points for challenge
- (void) updateUserPointsWithTopicsArrayLocation:(int)arrayLocation andChallengeNumber:(int)challengeNumber andChallengeID:(NSString*)challengeID andDatesArray:(NSMutableArray*)datesArray andUserID:(NSString*)userID;


- (NSMutableDictionary*) getUserProfileDictionary;
- (NSMutableArray*) getTopicsArray;
- (NSArray*) getTeamsArray;
- (NSMutableDictionary*) getTeamsByDict;
- (NSMutableArray*) getTopUsersCurrentMonth;
- (NSMutableArray*) getTopUsersAllTime;
- (NSMutableArray*) getTopTeamsCurrentMonth;
- (NSMutableArray*) getTopTeamsAllTime;


@end
