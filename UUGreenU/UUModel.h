//
//  UUModel.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UUNetworkConstants.h"
#include "NSStrinAdditions.h"
#include "UUSesson.h"


/*
//for ease and consistency in accessing functions
#define SUCCESS 1000
#define NETWORKERROR 9999




#define SERVERCALLOBJECTKEY @"callObject"
#define ADD 1
#define REMOVE 0

 

// for ease and consistency in accessing Topic dictionaries
#define CURRENTMONTHLOCATION 0

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

//for teams
#define SCHOOL                    @"SCHOOL"
#define BUSINESS                  @"BUSINESS"
#define OTHER                     @"OTHER"

#define teamCategoryKey           @"Category"
#define teamNameKey               @"Description"  //this is how it is named on the server
#define teamIDKey                 @"TeamKey"
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



#define startUpOrUpdateKey @"startupOrUpdate"


//for top users page
#define topRankKey   @"topRankKey"
#define topNameKey   @"topNameKey"
#define topPointsKey @"topPointsKey"
#define MONTHLY 1
#define ALLTIME 2
#define INDIVIDUAL 3
#define TEAMS 4

 
 */
#define ONETIME 1
#define REPEAT 2
#define oneTimeString @"One time"
#define repeatString  @"Repeat"

#define STARTUP 1
#define UPDATE 2

#define SUN 0
#define MON 1
#define TUE 2
#define WED 3
#define THU 4
#define FRI 5
#define SAT 6

//This app will cycle through a year, beginning
// in August.  This number is important because
// it will be used to determine if there
// are previous month challenges or not
//#define BEGINNINGMONTH 8




/****
 *  call back methods for when the app received server response
 */

//participant login from splash screen
@protocol UUModelForSplashScreenDelegate
@required
-(void) loginFromSplashScreenServerDataReceived:(int)responseCase;
-(void) startupDataReceived:(int)responseCase;
@end

//participant login from login screen
@protocol UUModelForLoginScreenDelegate
@required
-(void) loginFromLoginScreenServerDataReceived:(int)responseCase;
-(void) startupDataReceived:(int)responseCase;
-(void) responseForRequestPasswordReceived:(int)responseCase;
@end

// Register Participant
@protocol UUModelForRegisterParticipantScreenDelegate
@required
-(void) registerParticipantServerDataReceived:(int)responseCase;
-(void) startupDataReceived:(int)responseCase;
@end

// responseforRequestNewTeam
@protocol UUModelForNewTeamDelegate
@required
- (void) responseforRequestNewTeamReceived:(int)responseCase;
- (void) responseForChangeTeamResponseReceived:(int)responseCase;
@end

//user points updated
@protocol UUModelForChallengePointsUpdatedDelegate
@required
- (void) userChallengePointsUpdatedwithError:(bool)error;
@end

@interface UUModel : NSObject <UUSessionDelegate>
{
    //id<UUStartupDataReceivedDelegate>startupDataReceivedDelegate;
    //id<UURegisterParticipantDataReceivedDelegate>registerParticipantDataReceivedDelegate;
    //id<UUParticipantLoginDataReceivedDelegate>participantLoginReceivedDelegate;
}

@property (nonatomic, weak) id modelForSplashScreenDelegate;
@property (nonatomic, weak) id modelForLoginScreenDelegate;
@property (nonatomic, weak) id modelforRegisterParticipantScreenDelegate;
@property (nonatomic, weak) id modelforNewTeamDelegate;
@property (nonatomic, weak) id modelForChallengePointsUpdatedDelegate;



//login functions
- (void) loginFromSplashScreen;
- (void) loginFromLoginScreenWithEmail:(NSString*)userEmail andPassword:(NSString*)password;
- (void) registerNewParticipantWithEmail:(NSString*)email andPassword:(NSString*)password andUserName:(NSString*)username;
- (void) userRequestsPassword:(NSString*)email;

//new team
- (void) requestNemTeam:(NSString*)teamName andType:(NSString*)teamType;
- (void) changeUserTeam:(NSString*)teamID;

//update challenge points
- (void) updateUserPointsWithTopicsArrayLocation:(int)arrayLocation andChallengeNumber:(int)challengeNumber andDatesArray:(NSMutableArray*)datesArray;


//getters for user info
- (NSString*) getUserName;
- (NSString*) getUserPassword;
- (NSString*) getUserIdAsString;
- (NSString*) getUserEmail;
- (UIImage*) getUserImage;
- (NSString*) getUserTeamIDasString;
- (NSString*) getUserTeamName;
- (int) getUserRank:(int)monthlyORAllTime;
- (int) getUserPoints:(int)monthlyOrAllTime;


//getters for topic info
- (int) getMonthNumAsInt:(int)topicsArrayLocation;
- (int) getYearNumAsInt:(int)topicsArrayLocation;
- (NSString*) getTopicIDAsString:(int) topicArrayLocation;
- (NSString*) getMonthTopicTitle:(int)topicArrayLocation;
-  (int) getNumberOfPreviousTopics;
- (NSString*) getMonthURLString:(int)topicArrayLocation;


//getters for challenge info
- (NSString*) getChallengeIDasStringForChallengeMonth:(int) topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (NSString*) getChallengeTeaser:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (NSString*) getChallengeDescr:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (int) getChallengeNumDaysPossible:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (int) getChallengeDifficulty:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (int) getChallengeImpact:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (int) getChallengePointsForUser:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (int) getChallengePointsTotalPossible:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (NSString*) getUserStatusForChallenge:(int)topicArrayLocation andChallengeNumber: (int)challengeNumber;
- (NSArray*) getUserCompletionArrayChallengeMonth:(int) topicArrayLocation andChallengeNumber:(int)challengeNumber;
- (int) getChallengeType:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber;


//getters for teams info
- (int) getUserTeamRank:(int)monthlyORAllTime;
- (int) getUserTeamPoints:(int)monthlyORAllTime;
- (int) getNumberOfTeamsForCategory:(NSString*)category;
- (NSString*)getTeamNameforCategory:(NSString*)category andRowNumber:(int)row;
- (NSString*)getTeamIdAsStringForCategory:(NSString*)category andRowNumber:(int)row;
- (NSString*)getTeamNameByTeamID:(NSString*)teamID;
- (NSMutableDictionary*)getTeamDictionaryByTeamID:(NSString*)teamID;


//getters for top teams/users
- (int) getTopIndividualsCount:(int)monthlyORAllTime;
- (int) getTopTeamsCount:(int)monthlyORAllTime;
- (NSString*) getTopNames:(int)individualORTeam monthORAllTime:(int)monthORAllTime arrayPosition:(int)arrayPosition;
- (NSString*) getTopPoints:(int)individualORTeam monthORAllTime:(int)monthORAllTime arrayPosition:(int)arrayPosition;


@end
