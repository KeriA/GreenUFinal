 //
//  UUModel.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUModel.h"


@implementation UUModel
{
    //for creating 'sessions' to make server calls
    UUSesson* _session;
    
    //user information
    
    int _userID;
    NSString* _userEmail;
    NSString* _userPassword;
    
    
    //data structures are created in the session object, and pointers sent to the model
    
    //This dictionary stores information about the user
    //#  userNameKey :  user display name
    //#  userEmailKey:  user email
    //#  userPassword:  user password
    //#  userIdKey   :  user server id
    //#  teamIDKey   :  ID of user's current team as string
    //#  userImageKey:  user's profile image
    //#  userRankMonthKey   : holds the rank as string  - not all teams will have these last 4 objects filled
    //#  userRankAllTimeKey : holds the rank as string
    //#  userMonthPointsKey : holds the team points as string
    //#  userAllTimePointsKey : holds the team points as string
    NSMutableDictionary* _userProfileDictionary;
    
    
    // path to the file stored on the iphone
    NSString* _modelDataFilePath;
    
    
    //holds an array of dictionaries, one dictionary for each available month topic
    //IMPORTANT:  the current topic will be the first (position 0) in the array
    // each dictionary will hold:
    //#   'month'      :  holds the month integer as [NSString stringWithFormat:@"%d", month];
    //#   'year'       :  holds the year integer as [NSString stringWithFormat:@"%d", year];
    //#   'topicID     :  holds the topic key integer as [NSString stringWithFormat:@"%d", topicKey];
    //#   'TopicTitle' :  holds the title string (to be used the 'title' on the take the challenge page)
    //#   'TopicURL'   :  holds the URL for the topic as a string
    //#   'ChallengesArray'  :  holds 3 dictionaries:  one for each challenge
    //#           Each Challenge Dictionary will hold:
    //#           'ChallengeDescr'    :  holds the description used on the "Take the Challenge" page
    //#           'ChallengeKey'      :  holds the unique integer as [NSString stringWithFormat:@"%d", challengekey];
    //#           'ChallengeNo'       :  holds the number 1, 2, or 3 as [NSString stringWithFormat:@"%d", challengeNo];
    //#           'DaysPossible'      :  holds the number of days possible a user can fulfill the challnge as [NSString stringWithFormat:@"%d", daysPossible];
    //#           'Difficulty'        :  holds the integer representing the challenge difficulty as [NSString stringWithFormat:@"%d", difficulty];
    //#           'Impact'            :  holds the integer representing the challenge impact as [NSString stringWithFormat:@"%d", impact];
    //#           'Teaser'            :  holds the 'teaser' string to be used on the buttons on the challenges page
    //#           'Type'              :  holds the type string:  either 'One time' or 'Repeat'
    //#           'UserStatus'        :  holds the user status integer as  [NSString stringWithFormat:@"%d", userStatus];
    //#           'DateInput'         :  holds an array of dates the user has completed the challenge
    //#           'UserPointsKey      :  holds total number of points the user has earned for this challenge, calculated by difficulty*Impact* number of times completed
    //#           'UserCompleteDates' : holds an array of dates (each a string) that a user completed the challenge
    NSMutableArray* _topicsArray;
    
    
    //Holds and array of an array of dictionaries
    // first array has three elements:  0: category schools, 1: category business, and 2: category other
    //For each dictionary:
    //#  teamNameKey        : holds team name as string
    //#  teamIDKey          : holds team id as string
    //#  teamRankMonthKey   : holds the rank as string  - not all teams will have these last 4 objects filled
    //#  teamRankAllTimeKey : holds the rank as string
    //#  teamMonthPointsKey : holds the team points as string
    //#  teamAllTimePointsKey : holds the team points as string
    NSArray* _teamsArray;
    
    
    //we will also keep a dictionary so that the teams can be looked up by id
    //#  teamIDKey:  points to the dictionary with this id
    NSMutableDictionary* _teamsByIdDict;
    
    //Holds an array of dictionaries:
    //#  topRankKey:  holds the rank as a number from 1 - 10 (note:  there CAN be ties, so 2 teams ranking '3' etc...
    //#  topNameKey:  holds the name  (either individual or team, depending on the array)
    //#  topPointsKey:  holds the points as string
    NSMutableArray* _topUsersMonthly;
    NSMutableArray* _topUsersAllTime;
    NSMutableArray* _topTeamsMonthly;
    NSMutableArray* _topTeamsAllTime;
    
}

@synthesize modelForSplashScreenDelegate;
@synthesize modelForLoginScreenDelegate;
@synthesize modelforRegisterParticipantScreenDelegate;
@synthesize modelforNewTeamDelegate;
@synthesize modelForChallengePointsUpdatedDelegate;

/***
*
*      Constructor
*/
- (id)init
{
    self = [super init];
    if (self)
    {
        //create the server session object
        _session = [[UUSesson alloc] init];
        [_session setSessionDelegate:self];
        
        
        //First, make sure the "UserInfo.plist" files exists
        //The path to the NSDocuments directory in the user domain, ie this is our documents path (where things are stored locally to disc)
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
        //NSLog(@"Documents Path is: %@", documentsPath); // for testing
        
        _modelDataFilePath = [documentsPath stringByAppendingPathComponent:@"UserInfo.plist"];
        //NSLog(@"\nThe path is:  %@\n", _modelDataFilePath); //for testing
        
        // check and see if if the data file already exists in the documents directory
        if ([[NSFileManager defaultManager] fileExistsAtPath:_modelDataFilePath] == FALSE)
        {
            /***  We are creating a file called "UserInfo.plist".
             NSBundle mainBundle:  the stuff that gets copied in "copy Bundle resouces" under
             "Build Phases  >  Copy Bundle Resources"  (highlight the project (stuff) to see
             
             ** to create a new file, go to 'File > New File > Resourse > Property List
             Lorenzo then highlighted Data.plist under 'Resources' and changed it from a dictionary to
             an array. ***/
            
            // If the data file doesn't exist, copy it from the bundle.
            NSString* seedDataPath = [[NSBundle mainBundle] pathForResource:@"UserInfo" ofType:@"plist"];
            [[NSFileManager defaultManager] copyItemAtPath:seedDataPath toPath:_modelDataFilePath error:NULL];
            
        }//end if fileExists
        
        //now that we know the file exists, read in the user's email and password
        NSArray* temp = [NSArray arrayWithContentsOfFile:_modelDataFilePath];
        int tempCount = (int)[temp count];
    
        if (tempCount < 2) //just in case we have a corrupt file
        {
            _userEmail = needUserEmail;
            _userPassword = needUserPassword;
        }
        else
        {
            _userEmail = temp[0];    //will be "NeedUserEmail" if none has been stored
            _userPassword = temp[1]; //will be "NeedUserPassword" if none has been stored
        }
        
     }
    else //no object
    {
        return nil;
    }
    
    return self;
    
}//end constructor


/******************************************************************************************************
 *
 *                   Log In Functions & Startup Functions
 *
 ******************************************************************************************************/

 - (void) loginFromSplashScreen
{
    //first, check for viable user and password stored on device
    if ( ([_userEmail isEqualToString:needUserEmail]) || ([_userPassword isEqualToString:needUserPassword])){
        
        [[self modelForSplashScreenDelegate] loginFromSplashScreenServerDataReceived:LOGINFAILURE];
    }else{
        [_session loginWithEmail:_userEmail andPassword:_userPassword andType:LOGINFROMSPLASH];
    }
    
}//end loginFromSplashScreen

- (void) loginFromLoginScreenWithEmail:(NSString*)userEmail andPassword:(NSString*)password
{
    [_session loginWithEmail:userEmail andPassword:password andType:LOGINFROMLOGIN];
    
}//end loginFromLoginScreen

- (void) registerNewParticipantWithEmail:(NSString*)email andPassword:(NSString*)password andUserName:(NSString*)username
{
    [_session registerNewParticipantWithEmail:email andPassword:password andUserName:username];
    
}//end register NewParticipant



/******************************************************************************************************
 *
 *                     New Team Request
 *
 ******************************************************************************************************/

- (void) requestNemTeam:(NSString*)teamName andType:(NSString*)teamType
{
    [_session requestNemTeam:teamName andType:teamType andUserId:[_userProfileDictionary objectForKey:userIDKey]];
    
}//end requestNewTem

- (void) changeUserTeam:(NSString*)teamID
{
    [_session changeUserTeam:teamID withUserID:[_userProfileDictionary objectForKey:userIDKey]];
}//end changeUserTeam

/******************************************************************************************************
 *
 *                   Update UserPoints
 *
 ******************************************************************************************************/

- (void) updateUserPointsWithTopicsArrayLocation:(int)arrayLocation andChallengeNumber:(int)challengeNumber andDatesArray:(NSMutableArray*)datesArray
{
    NSString* challengeIDString = [self getChallengeIDasStringForChallengeMonth:arrayLocation andChallengeNumber:challengeNumber];
    [_session updateUserPointsWithTopicsArrayLocation:arrayLocation andChallengeNumber:challengeNumber andChallengeID:challengeIDString andDatesArray:datesArray andUserID:[_userProfileDictionary objectForKey:userIDKey]];
    
}//end updateUserPoints

/******************************************************************************************************
 *
 *                   Update UserProfile
 *
 ******************************************************************************************************/

/******************************************************************************************************
 *
 *                                   Session Callback Methods
 *
 ******************************************************************************************************/

- (void) loginResponseReceived:(int)responseCase andUserID:(int)userID andCallType:(int)callType
{
    if (responseCase == SUCCESS){
        _userID = userID;
        NSString* userIDasString = [NSString stringWithFormat:@"%d", _userID];
        
        //lauch startup functions  //'call type' determines whether the splash or login screen is
        //notified when the calls return.
        [_session launchServerStartupFunctionsWithUserID:userIDasString andCallType:callType];
        
    }else{
        if (callType == LOGINFROMLOGIN){
            [[self modelForLoginScreenDelegate] loginFromLoginScreenServerDataReceived:responseCase];
        }else{ //loginfromSplash
            //send the message to the modelSplashScreenDelegate
            [[self modelForSplashScreenDelegate] loginFromSplashScreenServerDataReceived:responseCase];
        }
    }
}//end loginFromSplashScreenResponseRecieved


- (void) registerParticipantResponseReceived:(int)responseCase andUserID:(int)userID
{
    if (responseCase == SUCCESS){
        _userID = userID;
        NSString* userIDasString = [NSString stringWithFormat:@"%d", _userID];
       
        [_session launchServerStartupFunctionsWithUserID:userIDasString andCallType:LOGINFROMREGISTERPARTICIPANT];
        
    }else{
        [[self modelforRegisterParticipantScreenDelegate] registerParticipantServerDataReceived:responseCase];
    }
    
}//end registerParticipantRepsonseReceived


- (void) startupCallsDataReceived:(int)responseCase withCallType:(int)callType{
    
    if (responseCase == SUCCESS){
        //get the data structures from the session
        
        _userProfileDictionary = [_session getUserProfileDictionary];
        _topicsArray = [_session getTopicsArray];
        _teamsArray = [_session getTeamsArray];
        _teamsByIdDict = [_session getTeamsByDict];
        _topUsersMonthly = [_session getTopUsersCurrentMonth];
        _topUsersAllTime = [_session getTopUsersAllTime];
        _topTeamsMonthly = [_session getTopTeamsCurrentMonth];
        _topTeamsAllTime = [_session getTopTeamsAllTime];
  
    }//end SUCCESS
    
    if (callType == LOGINFROMLOGIN){
        [[self modelForLoginScreenDelegate] startupDataReceived:responseCase];
    }else if (callType == LOGINFROMSPLASH){
        [[self modelForSplashScreenDelegate] startupDataReceived:responseCase];
    }else{ //LOGINFROMREGISTERPARTICIPANT
        [[self modelforRegisterParticipantScreenDelegate] startupDataReceived:responseCase];
    }
    
}//end startupCallsDataReceived

- (void) newTeamRequestResponseReceived:(int)responseCase
{
    [[self modelforNewTeamDelegate] responseforRequestNewTeamReceived:responseCase];
    
}//end newTeamRequest

- (void) changeTeamFromTeamsPageResponseReceived:(int)responseCase andTeamID:(NSString *)teamID andAllTimeRank:(int)allTimeRank andMonthRank:(int)monthRank andAllTimePoint:(int)allTimepoint andMonthPoint:(int)monthPoint
{
    if (responseCase == SUCCESS){
        NSMutableDictionary* teamDict = [_teamsByIdDict objectForKey:teamID];
        [teamDict setObject:[NSString stringWithFormat:@"%d", allTimeRank]  forKey:teamAllTimeRankKey];
        [teamDict setObject:[NSString stringWithFormat:@"%d", allTimepoint] forKey:teamAllTimePointsKey];
        [teamDict setObject:[NSString stringWithFormat:@"%d", monthRank]    forKey:teamCurrentMonthRankKey];
        [teamDict setObject:[NSString stringWithFormat:@"%d", monthPoint]   forKey:teamCurrentMonthPointsKey];
        
        [_userProfileDictionary setObject:teamID forKey:teamIDKey];
    }//end success
    
    //send message back to the teams page
    [[self modelforNewTeamDelegate] responseForChangeTeamResponseReceived:responseCase];
    
}//end changeTeam

- (void) updateUserPointsForChallengeResponseReceivedWithDateArray:(NSArray *)dateArray andTopicsArrayLocation:(int)arrayLocation andChallengeNumber:(int)challengeNumber andNetworkError:(BOOL)networkError
{
     //add this array to the challenge dictionary
     NSMutableDictionary* topicDict = _topicsArray[arrayLocation];
     NSArray* challengesArray = [topicDict objectForKey:challengeArrayKey];
     NSMutableDictionary* challengeDict = challengesArray[challengeNumber - 1];
     
     [challengeDict setObject:dateArray forKey:dateInputKey];
    
     //update the user status here
     int daysUserCompleted = (int)[dateArray count];
     int daysPossible = [[challengeDict objectForKey:daysPossibleKey]intValue];
     
     NSString* userStatus;
     if (daysUserCompleted >= daysPossible){
         userStatus = @"2"; //done
     }else if (daysUserCompleted == 0){
         userStatus = @"0";  //not started
     }else{
         userStatus = @"1"; //in progress
     }
     
     [challengeDict setObject:userStatus forKey:userStatusKey];
     
     //inform the specific challenge View controller that the operation is complete
    [[self modelForChallengePointsUpdatedDelegate] userChallengePointsUpdatedwithError:networkError];
    
}//end updateUserPointsForChallenge

/******************************************************************************************************
 *
 *                                   Getters
 *
 ******************************************************************************************************/

//##############################################
//######  Getters/Setters for User Info  #######
//##############################################
- (NSString*) getUserName
{    return [_userProfileDictionary objectForKey:userNameKey]; }

- (NSString*) getUserPassword
{    return [_userProfileDictionary objectForKey:userPasswordKey]; }

- (NSString*) getUserIdAsString
{    return [_userProfileDictionary objectForKey:userIDKey]; }

- (NSString*) getUserEmail
{    return [_userProfileDictionary objectForKey:userEmailKey]; }

- (UIImage*) getUserImage
{    return [_userProfileDictionary objectForKey:userImageKey]; }

- (NSString*) getUserTeamIDasString
{   return [_userProfileDictionary objectForKey:teamIDKey]; }

- (NSString*) getUserTeamName
{
    NSString* teamIDString = [_userProfileDictionary objectForKey:teamIDKey];
    if ([teamIDString isEqualToString:noTeamSelectedID])
    {   return @"No Team Selected";    }
    return [self getTeamNameByTeamID:teamIDString];
}//end getUserTeamName

- (int) getUserRank:(int)monthlyORAllTime
{
    int rank;
    if (monthlyORAllTime == ALLTIME){
        rank = [[_userProfileDictionary objectForKey:userAllTimeRankKey]intValue];
    }else{  //current month
        rank = [[_userProfileDictionary objectForKey:userCurrentMonthRankKey]intValue];
    }
    return rank;
}//end getUSerRank

- (int) getUserPoints:(int)monthlyOrAllTime
{
    int points;
    if (monthlyOrAllTime == ALLTIME){
        points = [[_userProfileDictionary objectForKey:userAllTimePointsKey]intValue];
    }else{  //current month
        points = [[_userProfileDictionary objectForKey:userCurrentMonthPointsKey]intValue];
    }
    return points;
    
}//end getUserPoints

/***
 *
 * This method is called when getUserProfile is successfully called from the session object
 * and upon first load for successful login or register participant
 */
- (void) storeEmail:(NSString*)email andPassword: (NSString*)password
{
    _userEmail = email;
    _userPassword = password;
    
    //write values to disc
    NSArray* userInfoArray = [[NSArray alloc] initWithObjects:_userEmail, _userPassword, nil];
    [userInfoArray writeToFile:_modelDataFilePath atomically:TRUE];
    
}//end storeEmailAndPassword


//#############################################################
//######  Getters for Topic Info                        #######
//#############################################################
- (int) getMonthNumAsInt:(int)topicsArrayLocation
{
    NSMutableDictionary* temp  = _topicsArray[topicsArrayLocation];
    return [[temp objectForKey:monthKey]intValue];
    
}//end getMonthNumAsInt

- (int) getYearNumAsInt:(int)topicsArrayLocation
{
    NSMutableDictionary* temp  = _topicsArray[topicsArrayLocation];
    return [[temp objectForKey:yearKey]intValue];
    
} //end getYearNumAsInt

- (NSString*) getTopicIDAsString:(int) topicArrayLocation
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    
    int topicId = [[temp objectForKey:topicIDKey]intValue];
    NSString* topicString = [NSString stringWithFormat:@"%d", topicId];
    return topicString;
    
}//end getTopicIDAsString

- (NSString*) getMonthTopicTitle:(int)topicArrayLocation
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    return [temp objectForKey:topicTitleKey];
    
}//end getMonthTopicTitle

-  (int) getNumberOfPreviousTopics
{    return (int)([_topicsArray count] -1); }

- (NSString*) getMonthURLString:(int)topicArrayLocation
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    return [temp objectForKey: topicURLKey];
    
}//end getMonthURLString


//#############################################################
//######  Getters for Challenge Info                    #######
//#############################################################
- (NSString*) getChallengeIDasStringForChallengeMonth:(int) topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSMutableArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* challengeDict = tempArray[challengeNumber - 1];  //-1 because 1st challenge is in spot '0', etc
    
    int challengeNum = [[challengeDict objectForKey:challengeIDKey]intValue];
    NSString* challengeIDString = [NSString stringWithFormat:@"%d", challengeNum];
    return challengeIDString;
    
}//end getChallengeIDasStringForChallengeMonth

- (NSString*) getChallengeTeaser:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    
    return [tempChallengeDict objectForKey:teaserKey];
    
}//end getChallengeTeaser

- (NSString*) getChallengeDescr:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    
    return [tempChallengeDict objectForKey:challengeDescKey];
    
}//end getChallengeDesc

- (int) getChallengeNumDaysPossible:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    
    return [[tempChallengeDict objectForKey:daysPossibleKey]intValue];
    
}//end getChallengeNumberDaysPossible

- (int) getChallengeDifficulty:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    
    return [[tempChallengeDict objectForKey:difficultyKey]intValue];
    
}//end getChallengeDifficulty

- (int) getChallengeImpact:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    
    return [[tempChallengeDict objectForKey:impactKey]intValue];
    
}//end getChallengeImpact

- (int) getChallengePointsForUser:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    
    int impact = [[tempChallengeDict objectForKey:impactKey]intValue];
    int difficulty = [[tempChallengeDict objectForKey:difficultyKey]intValue];
    int userNumTimesComplete = (int)[[tempChallengeDict objectForKey:dateInputKey] count];
    
    return userNumTimesComplete*difficulty*impact;
    
}//end getChallengePointsForUser

- (int) getChallengePointsTotalPossible:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    
    int impact = [[tempChallengeDict objectForKey:impactKey]intValue];
    int difficulty = [[tempChallengeDict objectForKey:difficultyKey]intValue];
    int numTimesPossible = [[tempChallengeDict objectForKey:daysPossibleKey]intValue];
    
    return numTimesPossible*difficulty*impact;
    
}//end getChallengePointsTotalPossible

- (NSString*) getUserStatusForChallenge:(int)topicArrayLocation andChallengeNumber: (int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    int status = [[tempChallengeDict objectForKey:userStatusKey]intValue];
    
    NSString* statusString;
    if (status == 1)
        statusString = @"In progress!";
    else if (status == 2)
        statusString = @"Complete!";
    else //0
        statusString = @"Take Challenge!";
    
    return statusString;
    
}//end getUserStatusForChallenge

- (NSArray*) getUserCompletionArrayChallengeMonth:(int) topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSMutableArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* challengeDict = tempArray[challengeNumber - 1];  //-1 because 1st challenge is in spot '0', etc
    
    //int challengeNum = [[challengeDict objectForKey:challengeIDKey]intValue];
    //NSString* challengeIDString = [NSString stringWithFormat:@"%d", challengeNum];
    return [challengeDict objectForKey:dateInputKey];
    
}//end getChallengeIDasStringForChallengeMonth

- (int) getChallengeType:(int)topicArrayLocation andChallengeNumber:(int)challengeNumber
{
    int type;
    NSMutableDictionary* temp = _topicsArray[topicArrayLocation];
    NSArray* tempArray = [temp objectForKey:challengeArrayKey];
    NSMutableDictionary* tempChallengeDict = tempArray[challengeNumber - 1];
    NSString* typeString = [tempChallengeDict objectForKey:typeKey];
    
    if ([typeString isEqualToString:oneTimeString]){
        type = ONETIME;
    }else{
        type = REPEAT;
    }
    
    return type;
}


//#############################################################
//######  Getters for Teams Info                        #######
//#############################################################

- (int) getUserTeamRank:(int)monthlyORAllTime
{
    int teamRank;
    
    NSString* teamIDString = [_userProfileDictionary objectForKey:teamIDKey];
    NSMutableDictionary* dict = [_teamsByIdDict objectForKey:teamIDString];
    if (monthlyORAllTime == ALLTIME){
        teamRank = [[dict objectForKey:teamAllTimeRankKey]intValue];
    }else{ //current month
        teamRank = [[dict objectForKey:teamCurrentMonthRankKey]intValue];
    }
    return teamRank;
    
}//end getUSerTeamRank

- (int) getUserTeamPoints:(int)monthlyORAllTime
{
    int teamPoints;
    
    NSString* teamIDString = [_userProfileDictionary objectForKey:teamIDKey];
    NSMutableDictionary* dict = [_teamsByIdDict objectForKey:teamIDString];
    if (monthlyORAllTime == ALLTIME){
        teamPoints = [[dict objectForKey:teamAllTimePointsKey]intValue];
    }else{ //current month
        teamPoints = [[dict objectForKey:teamCurrentMonthPointsKey]intValue];
    }
    return teamPoints;
    
}//end getUSerTeamRank

- (int) getNumberOfTeamsForCategory:(NSString*)category
{
    NSMutableArray* teamsArray;
    
    if ([category isEqualToString:SCHOOL]){
        teamsArray = [_teamsArray objectAtIndex:0];
    }else if ([category isEqualToString:BUSINESS]){
        teamsArray = [_teamsArray objectAtIndex:1];
    }else{//other
        teamsArray = [_teamsArray objectAtIndex:2];
    }
    
    return (int)[teamsArray count];
}

- (NSString*)getTeamNameforCategory:(NSString*)category andRowNumber:(int)row
{
    
    NSMutableArray* teamsArray;
    
    if ([category isEqualToString:SCHOOL]){
        teamsArray = [_teamsArray objectAtIndex:0];
    }else if ([category isEqualToString:BUSINESS]){
        teamsArray = [_teamsArray objectAtIndex:1];
    }else{//other
        teamsArray = [_teamsArray objectAtIndex:2];
    }
    
    NSMutableDictionary* dict = [teamsArray objectAtIndex:row];
    return [dict objectForKey:teamNameKey];
    
}//end getTeamNameForCategory

- (NSString*)getTeamIdAsStringForCategory:(NSString*)category andRowNumber:(int)row
{
    NSMutableArray* teamsArray;
    
    if ([category isEqualToString:SCHOOL]){
        teamsArray = [_teamsArray objectAtIndex:0];
    }else if ([category isEqualToString:BUSINESS]){
        teamsArray = [_teamsArray objectAtIndex:1];
    }else{//other
        teamsArray = [_teamsArray objectAtIndex:2];
    }
    
    NSMutableDictionary* dict = [teamsArray objectAtIndex:row];
    
    return [dict objectForKey:teamIDKey];
}//end getTeamIDAsString

- (NSString*)getTeamNameByTeamID:(NSString*)teamID
{
    NSMutableDictionary* dict = [_teamsByIdDict objectForKey:teamID];
    return [dict objectForKey:teamNameKey];
}//end getTeamNameByTeamId

- (NSMutableDictionary*)getTeamDictionaryByTeamID:(NSString*)teamID
{    return [_teamsByIdDict objectForKey:teamID];}


//#############################################################
//######  Getters for Top Teams/Individuals             #######
//#############################################################

- (int) getTopIndividualsCount:(int)monthlyORAllTime
{
    int count;
    
    if (monthlyORAllTime == MONTHLY){
        count = (int)[_topUsersMonthly count];
    }else{
        count = (int)[_topUsersAllTime count];
    }
    return count;
}

- (int) getTopTeamsCount:(int)monthlyORAllTime
{
    int count;
    
    if (monthlyORAllTime == MONTHLY){
        count = (int)[_topTeamsMonthly count];
    }else{
        count = (int)[_topTeamsAllTime count];
    }
    return count;
}

- (NSString*) getTopNames:(int)individualORTeam monthORAllTime:(int)monthORAllTime arrayPosition:(int)arrayPosition
{
    NSMutableDictionary* dict;
    NSString* keyString;
    
    if (individualORTeam == INDIVIDUAL)
    {
        keyString = topIndividualNameKey;
        
        if (monthORAllTime == MONTHLY){
            dict = [_topUsersMonthly objectAtIndex:arrayPosition];
        }else{//monthORAllTime = ALLTIME
            dict = [_topUsersAllTime objectAtIndex:arrayPosition];
        }
        
    }else{ //individualORTeam = TEAM
        
        keyString = topTeamNameKey;
        
        if (monthORAllTime == MONTHLY){
            dict = [_topTeamsMonthly objectAtIndex:arrayPosition];
            
        }else{//monthORAllTime = ALLTIME
            dict = [_topTeamsAllTime objectAtIndex:arrayPosition];
        }
    }//end if
    
    return [dict objectForKey:keyString];
    
}//end getTopNames

- (NSString*) getTopPoints:(int)individualORTeam monthORAllTime:(int)monthORAllTime arrayPosition:(int)arrayPosition
{
    NSMutableDictionary* dict;
    
    if (individualORTeam == INDIVIDUAL)
    {
        if (monthORAllTime == MONTHLY){
            dict = [_topUsersMonthly objectAtIndex:arrayPosition];
        }else{//monthORAllTime = ALLTIME
            dict = [_topUsersAllTime objectAtIndex:arrayPosition];
        }
        
    }else{ //individualORTeam = TEAM
        if (monthORAllTime == MONTHLY){
            dict = [_topTeamsMonthly objectAtIndex:arrayPosition];
            
        }else{//monthORAllTime = ALLTIME
            dict = [_topTeamsAllTime objectAtIndex:arrayPosition];
        }
    }//end if
    
    return [dict objectForKey:topPointsKey];
    
}//end getTopPoints




@end
