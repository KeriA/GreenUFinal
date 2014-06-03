//
//  UUSesson.m
//  UUGreenU
//
//  Created by Keri Anderson on 6/1/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//
//  This file controls the calls to the server and informs the model when done
//
#import "UUSesson.h"




@implementation UUSesson
{
    //holds objects created for each call to the server
    // and informs when all objects (calls) have returned
    NSMutableArray* _serverCallObjectArray;
    
    BOOL _netWorkErrorOccurred;
    
    int _loginCallType;
    
    //data structures will be created here, and then pointer sent to the model
    
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
    NSMutableArray* _schoolArray;
    NSMutableArray* _businessArray;
    NSMutableArray* _otherArray;
    
    
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
    
    
}//end implementation


@synthesize sessionDelegate;

/***
 *
 *      Constructor
 */
- (id)init
{
    self = [super init];
    if (self)
    {
        _serverCallObjectArray = [[NSMutableArray alloc]init];
        _netWorkErrorOccurred = false;
        
        //**data structures are initialized here, and then the pointers are sent to the model
        
        //initialize user dictionary
        _userProfileDictionary = [[NSMutableDictionary alloc]init];
        
        //initialize the topics Data Structure
        _topicsArray  = [[NSMutableArray alloc] init];
        
        //initialize the teams data structures
        _schoolArray   = [[NSMutableArray alloc] init];
        _businessArray = [[NSMutableArray alloc] init];
        _otherArray    = [[NSMutableArray alloc]init];
        _teamsArray    = [[NSArray alloc] initWithObjects:_schoolArray, _businessArray, _otherArray, nil];
        _teamsByIdDict = [[NSMutableDictionary alloc] init];
        
        //initialize top users Data Structures
        _topUsersMonthly = [[NSMutableArray alloc]init];
        _topUsersAllTime = [[NSMutableArray alloc]init];
        _topTeamsMonthly = [[NSMutableArray alloc]init];
        _topTeamsAllTime = [[NSMutableArray alloc]init];
        
    }
    else //no object
    {
        return nil;
    }
    
    return self;
    
}//end constructor


/******************************************************************************************************
 *
 *                                   Methods Called From Model
 *
 ******************************************************************************************************/
/***
 * The "type" variable is used to determine whether the call is made
 * from the SplashScreen or the LoginScreen, so the callback features
 * can be set appropriately
 *
 */
- (void) loginWithEmail:(NSString*)email andPassword:(NSString*)password andType:(int)type
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:email forKey:userEmailKey];
    [dict setObject:password forKey:userPasswordKey];
    NSString* typeString = [NSString stringWithFormat:@"%d", type];
    [dict setObject:typeString forKey:loginTypeKey];
    
    [self sendMessageToServer: participantLogin withDataDictionary:dict];
    
}//end login

- (void) registerNewParticipantWithEmail:(NSString*)email andPassword:(NSString*)password andUserName:(NSString*)username
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:email forKey:userEmailKey];
    [dict setObject:password forKey:userPasswordKey];
    [dict setObject:username forKey:userNameKey];
 
    [self sendMessageToServer:registerParticipant withDataDictionary:dict];
    
}//end registerNewParticipant

/***
 * The "type" variable is used to determine whether the call is made
 * from the SplashScreen, the LoginScreen, or the registerParticiapntScren so 
 * the callback features can be set appropriately.
 *
 *                            Functions that will be launched:
 *
 *                   Topic For Current Month                                        UserProfile                       Get Top 10 Teams by month & alltime
 *                    /                  \                                           /         \                      Get Top 10 Individuals by month & allTime
 *  topics for past month                challengesforcurrentTopic        UserRank&Points      teamsByCategory
 *            |                                  |
 *  challenges for past months           user points for current topic
 *            |
 *  user poinst for past challenges
 *
 *
 *
 *  when all of these functions have returned (successfully), one
 *  last call to make:  getUsersTeamPointsAndRank
 *
 *
 *
 *
 *  Each of these calls will create a 'serverCallObject' to be added to the 'serverCallArray'.  When 
 *  the call is complete, the object is removed from the array.  If there are no more objects in the 
 *  array, the model is informed that the calls are complete.
 */
- (void) launchServerStartupFunctionsWithUserID:(NSString*)userID andCallType:(int)type
{
    NSLog(@"Server Functions Now being called\n");
    
    _loginCallType = type; //used to determine where to send the response to when finished:  login/splash/registerparticipant
    
    //1)  get User Profile information
    NSMutableDictionary* userProfileDict = [[NSMutableDictionary alloc] init];
    NSObject* userProfileCallObject = [[NSObject alloc]init];
    [userProfileDict setObject:userID forKey:userIDKey];
    [userProfileDict setObject:userProfileCallObject forKey:SERVERCALLOBJECTKEY];
    [userProfileDict setObject:@"YES" forKey:withImageKey];
    [self addOrRemoveCountToStartupList:ADD withObject:userProfileCallObject];
    [self sendMessageToServer:getUserProfile withDataDictionary: userProfileDict];
    
    //2) get current month topics - the return function will call for previous month topics
    NSMutableDictionary* currentMonthDict = [[NSMutableDictionary alloc] init];
    NSObject* currentMonthCallObject = [[NSObject alloc] init];
    [currentMonthDict setObject:currentMonthCallObject forKey: SERVERCALLOBJECTKEY];
    [self addOrRemoveCountToStartupList:ADD withObject:currentMonthCallObject];
    [self sendMessageToServer:getCurrentMonthTopic withDataDictionary:currentMonthDict];
    
   //3) get top teams and top individuals
    NSMutableDictionary* topTeamsMonthDict = [[NSMutableDictionary alloc] init];
    NSObject* topTeamsMonthCallObject = [[NSObject alloc] init];
    NSString* periodString = currentString;
    [topTeamsMonthDict setObject:periodString forKey:periodKey];
    [topTeamsMonthDict setObject:topTeamsMonthCallObject forKey: SERVERCALLOBJECTKEY];
    [self addOrRemoveCountToStartupList:ADD withObject:topTeamsMonthCallObject];
    [self sendMessageToServer:getTopTenTeams withDataDictionary:topTeamsMonthDict];
    
    NSMutableDictionary* topTeamsAllTimeDict = [[NSMutableDictionary alloc] init];
    NSObject* topTeamsAllTimeCallObject = [[NSObject alloc] init];
    periodString = allTimeString;
    [topTeamsAllTimeDict setObject:periodString forKey:periodKey];
    [topTeamsAllTimeDict setObject:topTeamsAllTimeCallObject forKey: SERVERCALLOBJECTKEY];
    [self addOrRemoveCountToStartupList:ADD withObject:topTeamsAllTimeCallObject];
    [self sendMessageToServer:getTopTenTeams withDataDictionary:topTeamsAllTimeDict];
    
    NSMutableDictionary* topIndMonthDict = [[NSMutableDictionary alloc] init];
    NSObject* topIndMonthCallObject = [[NSObject alloc] init];
    periodString = currentString;
    [topIndMonthDict setObject:periodString forKey:periodKey];
    [topIndMonthDict setObject:topIndMonthCallObject forKey: SERVERCALLOBJECTKEY];
    [self addOrRemoveCountToStartupList:ADD withObject:topIndMonthCallObject];
    [self sendMessageToServer:getTopTenIndividuals withDataDictionary:topIndMonthDict];
    
    NSMutableDictionary* topIndAllTimeDict = [[NSMutableDictionary alloc] init];
    NSObject* topIndAllTimeCallObject = [[NSObject alloc] init];
    periodString = allTimeString;
    [topIndAllTimeDict setObject:periodString forKey:periodKey];
    [topIndAllTimeDict setObject:topIndAllTimeCallObject forKey: SERVERCALLOBJECTKEY];
    [self addOrRemoveCountToStartupList:ADD withObject:topIndAllTimeCallObject];
    [self sendMessageToServer:getTopTenIndividuals withDataDictionary:topIndAllTimeDict];

    
}//end launchServerStartupFunctions

- (void) requestNemTeam:(NSString*)teamName andType:(NSString*)teamType andUserId:(NSString*)userID
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:userID forKey:userIDKey];
    [dict setObject:teamName forKey:teamNameKey];
    [dict setObject:teamType forKey:teamTypeKey];
    
    [self sendMessageToServer:requestNewTeam withDataDictionary:dict];
    
}//end requestNewTem

- (void) changeUserTeam:(NSString*)teamID withUserID:(NSString*)userID
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    //: '%@', 'UserName' : '%@', 'TeamKey' : '%@', 'Password' : '%@', 'UserImage' : '%@' }"
    NSString* userNameString  = @""; //empty string
    NSString* userPassword    = @""; //empty string
    NSString* userImageString = @""; //empty string
    NSString* updateFromString = [NSString stringWithFormat:@"%d", UPDATEFROMTEAMSPAGE];

    [dict setObject:userID forKey:userIDKey];
    [dict setObject:userNameString forKey:userNameKey];
    [dict setObject:teamID forKey:teamIDKey];
    [dict setObject:userPassword forKey:userPasswordKey];
    [dict setObject:userImageString forKey:userImageKey];
    [dict setObject:updateFromString forKey:updateFromKey];
    
    [self sendMessageToServer:updateUserProfile withDataDictionary:dict];
    
}//end changeUserTeam

- (void) updateUserPointsWithTopicsArrayLocation:(int)arrayLocation andChallengeNumber:(int)challengeNumber andChallengeID:(NSString*)challengeID andDatesArray:(NSMutableArray*)datesArray andUserID:(NSString*)userID
{
    [_serverCallObjectArray removeAllObjects];  //make sure it is empty
    _netWorkErrorOccurred = false;
    
    NSString* arrayLocationString = [NSString stringWithFormat:@"%d", arrayLocation];
    NSString* challengeNumberString = [NSString stringWithFormat:@"%d", challengeNumber];
    
    //we will need to make this call for each entry in the dates array
    int count = (int)[datesArray count];
    for (int i = 0; i < count; i++){
        
        NSObject* serverCallObject = [[NSObject alloc]init];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        NSString* dateString = [datesArray objectAtIndex:i];
        
        [dict setObject:userID forKey:userIDKey];
        [dict setObject:challengeID forKey:challengeIDKey];
        [dict setObject:dateString forKey:dateKey];
        [dict setObject:serverCallObject forKey:SERVERCALLOBJECTKEY];
        [dict setObject:challengeNumberString forKey:challengeNoKey];
        [dict setObject:arrayLocationString forKey:TOPICARRAYLOCATIONKEY];
        
        [self addOrRemoveFromDateList:ADD withObject:serverCallObject andArrayLocation:arrayLocation andChallengeNumber:challengeNumber andUserID:userID andChallengeID:challengeID];
        
        [self sendMessageToServer:setUserPointsForChallenge withDataDictionary:dict];
        
    }//end for i
    
}//end updateUserPoints


/******************************************************************************************************
 *
 *                                   Methods Called Internally
 *
 ******************************************************************************************************/

/**
 * This function keeps an array list of
 * startup function calls.  When the array is
 * is '0', all function calls have been complete
 * and this function informs the model
 *
 */
- (void) addOrRemoveCountToStartupList:(int)addOrRemove withObject:(NSObject*)object
{
    @synchronized(_serverCallObjectArray)
    {
        //we can safely modify this array one thread at a time
        
        if (addOrRemove == ADD){
            
            [_serverCallObjectArray addObject:object];
            
        }else{ //remove
            [_serverCallObjectArray removeObject:object];
            
            if ([_serverCallObjectArray count] <= 0){ //all starup calls complete
                
                if (_netWorkErrorOccurred)
                {
                    _netWorkErrorOccurred = false;
                    [[self sessionDelegate] startupCallsDataReceived:NETWORKERROR withCallType:_loginCallType];
                    
                }else{ //all good - one last call for user's team points and rank
                    
                    NSString* teamIdString = [_userProfileDictionary objectForKey:teamIDKey];
                    
                    if (![teamIdString isEqualToString:noTeamSelectedID]){
                        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:teamIdString forKey:teamIDKey];
                        [dict setObject:[NSString stringWithFormat:@"%d", UPDATEFROMLOGIN] forKey:updateFromKey];
                        [self sendMessageToServer:getTeamPointAndRank withDataDictionary:dict];
                    }else{
                        [[self sessionDelegate] startupCallsDataReceived:SUCCESS withCallType:_loginCallType];
                        
                    }
                }//end else _networkErrorOccurred
                
            }//end if
        }
    }//end synchronized
    
}//end addorRemoveStartupList

/***
 * The last function called for startup functions
 *
 */
- (void) userTeamPointsServerCallCompleted
{
    if (!_netWorkErrorOccurred){
        [[self sessionDelegate] startupCallsDataReceived:SUCCESS withCallType:_loginCallType];
    }else{
        _netWorkErrorOccurred = false;
        [[self sessionDelegate] startupCallsDataReceived:NETWORKERROR withCallType:_loginCallType];
    }
    
}//end userTeamPointsServerCallCompleted


/**
 * This function keeps an array list
 *  update points calls to the server
 *  - for updating user points for challenges
 *
 */
- (void) addOrRemoveFromDateList:(int)addOrRemove withObject:(NSObject*)object andArrayLocation:(int)arrayLocation andChallengeNumber:(int)challengeNumber andUserID:(NSString*)userID andChallengeID:(NSString*)challengeID
 {
     @synchronized(_serverCallObjectArray)
     {
         //we can safely modify this array one thread at a time
         if (addOrRemove == ADD){
             [_serverCallObjectArray addObject:object];
         }else{ //remove
             [_serverCallObjectArray removeObject:object];
        
             if ([_serverCallObjectArray count] <= 0){ //all starup calls complete
                 
                 //error or not get updated points data from the server
                 //now we can get the user points for the challenges
                 NSString* arrayLocationString = [NSString stringWithFormat:@"%d", arrayLocation];
                 NSString* challengeNumberString = [NSString stringWithFormat:@"%d", challengeNumber];
                 NSObject* challengeCallObject = [[NSObject alloc]init];  //not needed in this case
                 //the behavior of the return function is different depending on whether being called from startup or update
                 NSString* startupString = [NSString stringWithFormat:@"%d", UPDATE];
 
                 NSMutableDictionary* challengeDict = [[NSMutableDictionary alloc] init];
 
                 [challengeDict setObject:userID forKey:userIDKey];
                 [challengeDict setObject:challengeID forKey:challengeIDKey];
                 [challengeDict setObject:arrayLocationString forKey:TOPICARRAYLOCATIONKEY];
                 [challengeDict setObject:challengeNumberString forKey:challengeNoKey];
                 [challengeDict setObject:challengeCallObject forKey:SERVERCALLOBJECTKEY];
                 [challengeDict setObject:startupString forKey:startUpOrUpdateKey];
 
                 [self sendMessageToServer:getUserPointsForChallenge withDataDictionary:challengeDict];
                 
             }//end if
         }
     }//end synchronized
 
 }//end addorRemoveStartupList


/******************************************************************************************************
 *
 *                                   Server Methods
 *
 ******************************************************************************************************/
/**
 *  This method sends both GET and POST messages to the server.
 *
 *  Parameters:  serverMethod:   (int) this is an int that is #defined in the .h file for consistency
 *                               each method will need its own unique int
 *               action:  (int)  0 = POST, 1 = GET
 *
 *               dataDictionary:  the data that will be sent to the server
 *
 *       Note:  each method that calls this will have a specified call back function in the code
 *
 */
- (void) sendMessageToServer:(int)serverMethod withDataDictionary:(NSMutableDictionary*)dataDictionary
{
    // step 1:  create the url and url request - adding the index at the end specifies to the server what index we are accessing
    NSString* methodString = @"";
    NSString* dataString = @"";
    
    
    int action = POST; // default
    
    
    // set the request string
    switch (serverMethod)  //serverMethod constants declared in NetworkConstants.h
    {
        case (registerParticipant):
        {
            
            methodString = [NSString stringWithFormat:@"%@", registerParticipantRequest];
            action = POST;
            
            // set up the data to use
            NSString* username = [dataDictionary objectForKey:userNameKey];
            NSString* email = [dataDictionary objectForKey:userEmailKey];
            NSString* password = [dataDictionary objectForKey:userPasswordKey];
            
            dataString = [NSString stringWithFormat:@"{ 'UserName' : '%@', 'Email' : '%@', 'Password' : '%@' }", username, email, password];
            
            break;
        }
        case (participantLogin):
        {
            methodString = [NSString stringWithFormat:@"%@", participantLoginRequest];
            action = POST;
            
            // set up the data to use
            NSString* email = [dataDictionary objectForKey:userEmailKey];
            NSString* password = [dataDictionary objectForKey:userPasswordKey];
            
            dataString = [NSString stringWithFormat:@"{ 'Email' : '%@', 'Password' : '%@' }", email, password];
            
            break;
        }
        case (updateUserProfile):
        {
            //NOTE:  to update the user profile image, the image needs to be converted
            // to Base64 to be sent as JSON String  BEFORE Reaching this method call:
            //code something like this:
            //UIImage* userImage = [_userProfileDictionary objectForKey:userImageKey];
            //NSData* dataImage = UIImagePNGRepresentation(userImage);
            //NSString* imageString = [NSString base64StringFromData:dataImage length:(int)[dataImage length]];
            
            methodString = [NSString stringWithFormat:@"%@", updateUserProfileRequest];
            action = POST;
            
            NSString* userKeyString = [dataDictionary objectForKey:userIDKey];
            NSString* username      = [dataDictionary objectForKey:userNameKey];
            NSString* teamKeyString = [dataDictionary objectForKey:teamIDKey];
            NSString* password      = [dataDictionary objectForKey:userPasswordKey];
            NSString* imageString   = [dataDictionary objectForKey:userImageKey];
            
            dataString = [NSString stringWithFormat:@"{ 'UserKey' : '%@', 'UserName' : '%@', 'TeamKey' : '%@', 'Password' : '%@', 'UserImage' : '%@' }",
                          userKeyString, username, teamKeyString, password, imageString];
            
            //NSLog(@"%@", dataString); //for testing
            
            break;
            
        }
        case (getUserProfile):
        {
              /*how to encode decode an image into base64 string
             // This will load NeonSpark image &amp; *data* variable is holding data of image
             NSData *data = [NSData dataWithContentsOfFile:
             [[NSBundle mainBundle] pathForResource:@"Neon Spark" ofType:@"png"]
             ];
             // using base64StringFromData method, we are able to convert data to string
             NSString *str = [NSString base64StringFromData:data length:[data length]];
             
             // log the base64 encoded string
             NSLog(@"Base64 Encoded string is %@",str);
             
             // using base64DataFromString
             NSData *dataFromBase64=[NSData base64DataFromString:str];
             
             // log the decoded NSData length
             NSLog(@"Data length is %i",[dataFromBase64 length]);
             *///end comments
            
            methodString = [NSString stringWithFormat:@"%@", getUserProfileRequest];
            action = GET;
            
            NSString* userID = [dataDictionary objectForKey:userIDKey];
            NSString* withImageString = [dataDictionary objectForKey:withImageKey]; //'Yes' or 'No' whether to pull user image from server
            NSString* temp = [NSString stringWithFormat:@"?userkey=%@&withimage=%@", userID, withImageString];
            methodString = [methodString stringByAppendingString:temp];
            
            dataString = @"";
            break;
        }
        /*case (forgotPassword):
        {
            methodString = [NSString stringWithFormat:@"%@", forgotPasswordRequest];
            action = POST;
            
            NSString* userEmailString = [dataDictionary objectForKey:userEmailKey];
            dataString = [NSString stringWithFormat:@"{ 'Email' : '%@' }", userEmailString];
            
            break;
        }*/
        case (getAllTeams): //not used
        {
            break;
        }
        case (getTeamsByCategory):
        {
            
            methodString = [NSString stringWithFormat:@"%@", getTeamsByCategoryRequest];
            action = GET;
            
            NSString* teamType = [dataDictionary objectForKey:teamCategoryKey];
            NSString* temp = [NSString stringWithFormat:@"?category=%@", teamType];
            methodString = [methodString stringByAppendingString:temp];
            
            dataString = @"";
            break;
        }
        case (requestNewTeam):
        {
            methodString = [NSString stringWithFormat:@"%@", requestNewTeamRequest];
            action = POST;
            
            // set up the data to use
            NSString* userKeyString = [dataDictionary objectForKey:userIDKey];
            NSString* teamName = [dataDictionary objectForKey:teamNameKey];
            NSString* teamCategory = [dataDictionary objectForKey:teamTypeKey];
            
            dataString = [NSString stringWithFormat:@"{ 'UserKey' : '%@', 'TeamName' : '%@', 'TeamCategory' : '%@' }", userKeyString, teamName, teamCategory];
            
            break;
        }
        case (getCurrentMonthTopic):
        {
            methodString = [NSString stringWithFormat:@"%@", getCurrentMonthTopicRequest];
            action = GET;
            
            //This function requires no parameters
            dataString = @"";
            
            break;
            
        }
        case (getPastMonthTopics):
        {
            methodString = [NSString stringWithFormat:@"%@", getPastMonthTopicsRequest];
            action = GET;
            
            // set up the data to use
            NSString* monthNumString = [dataDictionary objectForKey:monthKey];
            NSString* temp = [NSString stringWithFormat:@"?monthnum=%@", monthNumString];
            methodString = [methodString stringByAppendingString:temp];
            
            dataString = @"";
            break;
        }
        case (getChallengesForTopic):
        {
            methodString = [NSString stringWithFormat:@"%@", getChallengesForTopicRequest];
            action = GET;
            
            // set up the data to use
            NSString* topicIDString = [dataDictionary objectForKey:topicIDKey];
            NSString* userIDString  = [dataDictionary objectForKey:userIDKey];
            NSString* temp = [NSString stringWithFormat:@"?topicid=%@&userid=%@", topicIDString, userIDString];
            methodString = [methodString stringByAppendingString:temp];
            
            break;
        }
        case (getUserPointsForChallenge):
        {
            methodString = [NSString stringWithFormat:@"%@", getUserPointForChallengeRequest];
            action = GET;
            
            //set up the data to use
            NSString* userIDString = [dataDictionary objectForKey: userIDKey];
            NSString* challengeIDString = [dataDictionary objectForKey:challengeIDKey];
            NSString* temp = [NSString stringWithFormat:@"?userid=%@&challengeId=%@", userIDString, challengeIDString];
            methodString = [methodString stringByAppendingString:temp];
            
            break;
        }
        case (setUserPointsForChallenge):
        {
            methodString = [NSString stringWithFormat:@"%@", setUserPointForChallengeRequest];
            action = POST;
            
            // set up the data to use
            NSString* userKeyString = [dataDictionary objectForKey:userIDKey];
            NSString* challengeIDString   = [dataDictionary objectForKey:challengeIDKey];
            NSString* dateString           = [dataDictionary objectForKey:dateKey];
            
            dataString = [NSString stringWithFormat:@"{ 'UserKey' : '%@', 'ChallengeKey' : '%@', 'DateInput' : '%@'  }", userKeyString, challengeIDString, dateString];
            
            break;
        }
        case (getTeamPointAndRank):
        {
            methodString = [NSString stringWithFormat:@"%@", getTeamPointAndRankRequest];
            action = GET;
            
            //set up the data to use
            NSString* teamIDString = [dataDictionary objectForKey: teamIDKey];
            NSString* temp = [NSString stringWithFormat:@"?teamkey=%@&", teamIDString];
            methodString = [methodString stringByAppendingString:temp];
            
            
            break;
        }
        case (getParticipantPointAndRank):
        {
            methodString = [NSString stringWithFormat:@"%@", getParticipantPointAndRankRequest];
            action = GET;
            
            //set up the data to use
            NSString* userIDString = [dataDictionary objectForKey: userIDKey];
            NSString* temp = [NSString stringWithFormat:@"?userkey=%@", userIDString];
            methodString = [methodString stringByAppendingString:temp];
            
            
            break;
        }
        case (getTopTenTeams):
        {
            methodString = [NSString stringWithFormat:@"%@", getTopTenTeamsRequest];
            action = GET;
            
            //set up the data to use
            NSString* periodString = [dataDictionary objectForKey: periodKey];
            NSString* temp = [NSString stringWithFormat:@"?period=%@", periodString];
            methodString = [methodString stringByAppendingString:temp];

            break;
        }
        case (getTopTenIndividuals):
        {
            methodString = [NSString stringWithFormat:@"%@", getTopTenIndividualsRequest];
            action = GET;
            
            //set up the data to use
            NSString* periodString = [dataDictionary objectForKey: periodKey];
            NSString* temp = [NSString stringWithFormat:@"?period=%@", periodString];
            methodString = [methodString stringByAppendingString:temp];

        }
        default:
        {}
    }// end switch
    
    
    // we are using a mutable request so we can make changes to our request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[UUNetworkBaseUrl stringByAppendingString:methodString]]];
    
    // set the request method
    switch (action)
    {
        case (POST):
        {
            [request setHTTPMethod:@"POST"];
            break;
        }
        case (GET):
        {
            [request setHTTPMethod:@"GET"];
            break;
        }
            
        default:
        {}
    }// end switch
    
    
    
    // step 2:  encode thet data to send
    NSData* requestData = [NSData dataWithBytes:[dataString UTF8String] length:[dataString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    
    
    // STEP 2)  Create  PList Data so we can make a request with data
    // In order to send the dictionary, we have to encode it as well.  This server accepts PList data.
    // In order to turn the dictionary into a PLIST, use the class NSPropertyListSerialization,
    // and its static method that will turn data from a property list into an XML format property
    // list  (ignore errors)
    // This call returns NSData.
    // NSData* requestData = [NSPropertyListSerialization dataFromPropertyList:dataDictionary format:NSPropertyListXMLFormat_v1_0 errorDescription:NULL];
    
    // often times when we are making requests for server data, we need to specify the type of data
    // we are sending, because the server needs to interpret that data.  Without this next line of
    // code, the server gave an error "Invalid content type".  We specified JSON.
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:requestData];
    
    
    // STEP 3)  - make a connection - send the request asynchronously
    // This is where we actually make the request.
    // By default, the request made will be a 'GET' request (should get "This server...POST requests" as shown
    // in the browser.
    // the "NSData* responseData gets the data out of the URL connection - Note: it is returned as "NSData"
    
    [request setTimeoutInterval:30.0f]; // if no interaction after 30 seconds, connection dies
    
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         // set the callback method
         switch (serverMethod)
         {
             case (registerParticipant):
             {
                 [self responseForRegisterParticipantReceived:data withError:error];
                 break;
             }
             case (participantLogin):
             {
                 int type = [[dataDictionary objectForKey:loginTypeKey]intValue];
                 [self responseForLoginParticipantReceived:data withError:error andType:type];
                 break;
             }
             case (updateUserProfile):
             {
                 int updateFrom = [[dataDictionary objectForKey:updateFromKey]intValue];
                 NSString* userID = [dataDictionary objectForKey:userIDKey];
                 NSString* teamID = [dataDictionary objectForKey:teamIDKey];
                 [self responseForUpdateUserProfileRecieved:data withError:error andUpdateFrom:updateFrom andUserID:userID andTeamID:teamID];
                 break;
             }
             case (getUserProfile):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 NSString* withImageString = [dataDictionary objectForKey:withImageKey];
                 [self responseForGetProfileReceived:data withError:error  andWithImage:withImageString andServerCallObject:serverCallObject];
                 break;
             }/*
             case (forgotPassword):
             {
                 [self responseForForgotPasswordReceived:data withError:error];
                 break;
             }
             case (getAllTeams):  //not used
             {
                 //[self responseForGetAllTeamsReceived:data withError:error];
                 break;
             }*/
             case (getTeamsByCategory):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 NSString* typeString = [dataDictionary objectForKey:teamCategoryKey];
                 [self responseForGetTeamsByTypeReceived:data withError:error andType:typeString andServerCallObject:serverCallObject];
                 break;
             }
             case (requestNewTeam):
             {
                 [self responseForRequestNewTeamReceived:data withError:error];
                 break;
             }
             case (getCurrentMonthTopic):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 [self responseForGetCurrentMonthTopicReceived:data withError:error andServerCallObjec:serverCallObject];
                 break;
             }
             case (getPastMonthTopics):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 [self responseForGetPastMonthTopicsReceived:data withError:error andServerCallObject:serverCallObject];
                 break;
             }
             case (getChallengesForTopic):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 int topicArrayLocation = [[dataDictionary objectForKey:TOPICARRAYLOCATIONKEY]intValue];
                 [self responseForGetChallengesForTopicReceived:data withError:error andArrayLocation:topicArrayLocation andServerCallObject:serverCallObject];
                 break;
             }
             case (getUserPointsForChallenge):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 int topicArrayLocation = [[dataDictionary objectForKey:TOPICARRAYLOCATIONKEY]intValue];
                 int challengeNumber = [[dataDictionary objectForKey:challengeNoKey]intValue];
                 int startupOrUpdate = [[dataDictionary objectForKey:startUpOrUpdateKey]intValue];
                 [self responseForGetUserPointsForChallengeReceived:data withError:error andArrayLocation:topicArrayLocation andChallengeNumber:challengeNumber andServerCallObject:serverCallObject andStartupOrUpdate:startupOrUpdate];
                 break;
             }
             case (setUserPointsForChallenge):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 int challengeNumber = [[dataDictionary objectForKey:challengeNoKey]intValue];
                 int topicLocation = [[dataDictionary objectForKey:TOPICARRAYLOCATIONKEY]intValue];
                 NSString* userID = [dataDictionary objectForKey:userIDKey];
                 NSString* challengeID = [dataDictionary objectForKey:challengeIDKey];
                 [self responseForSetUserPointsForChallengeReceived:data withError:error andServerCallObject:serverCallObject andArrayLocation:topicLocation andChallengeNumber:challengeNumber andUserID:userID andChallengeID:challengeID];
                 break;
             }
             case (getTeamPointAndRank):
             {
                 NSString* teamID = [dataDictionary objectForKey:teamIDKey];
                 int updateFrom = [[dataDictionary objectForKey:updateFromKey]intValue];
                 [self responseForGetTeamPointAndRankReceived:data withError:error andTeamID:teamID andCalledFromPage:updateFrom];
                 break;
             }
             case (getParticipantPointAndRank):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 [self responseForGetParticipantPointAndRankReceived:data withError:error andServerCallObject:serverCallObject];
                 break;
             }
             case (getTopTenTeams):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 NSString* periodString = [dataDictionary objectForKey:periodKey];
                 [self responseforGetTopTenTeamsReceived:data withError:error andPeriod:periodString andServerCallObject:serverCallObject];
                 break;
             }
             case (getTopTenIndividuals):
             {
                 NSObject* serverCallObject = [dataDictionary objectForKey:SERVERCALLOBJECTKEY];
                 NSString* periodString = [dataDictionary objectForKey:periodKey];
                 [self responseforGetTopTenIndividualsReceived:data withError:error andPeriod:periodString andServerCallObject:serverCallObject];
                 break;
             }
                 
             default:
             {}
         }
         
     } // end completion handler
     ];
    
    
}// end sendMessageToServer

/******************************************************************************************************
 *
 *                              server response callback methods
 *
 ******************************************************************************************************/

- (void) responseForRegisterParticipantReceived: (NSData*)responseData withError:(NSError*)error
{
    int responseMessage = 0;
    int userKey;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        userKey         = [[responseDictionary objectForKey:(@"UserKey")]intValue];
        
        // notes:
        //   message values:
        //  1000:  success:  participant successfully logged in
        //  1001:  failure:  invalid email format
        //  1002:  failure:  invalid password format
        //  1003:  failure:  invalid username format
        //  1004:  failure:  email already exists in database≈ß
        //  9999:  failure:  general failure
        //   userkey values:
        //  100001:   some user key starting with 100001 if successful
        //  0:        0 upon failure
        
        if (!responseMessage == SUCCESS)//successful register  ??????? is this supposed to be responsemesage?
        {
            userKey = 0;
        }
    }
    else // error not null
    {
        userKey = 0;
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    // inform the CreateUserViewController that server has replied back
    [[self sessionDelegate] registerParticipantResponseReceived:responseMessage andUserID:userKey];
    
}// end responseForRegisterParticipantReceived

-(void) responseForLoginParticipantReceived:(NSData*)responseData withError:(NSError*)error andType:(int)type
{
    int responseMessage = 0;
    int userKey;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        userKey         = [[responseDictionary objectForKey:(@"UserKey")]intValue];
        
        // notes:
        //   message values:
        //  1000:  success:  participant successfully logged in
        //  1001:  failure:  invalid email format
        //  1005:  failure:  login failure
        //  9999:  failure:  general failure
        if (!responseMessage == SUCCESS)//successful login
        {
            userKey = 0;
            responseMessage = LOGINFAILURE;
        }
        
    }
    else // error not null
    {
        userKey = 0;
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    //inform the Model that the server has sent a response
    [[self sessionDelegate] loginResponseReceived:responseMessage andUserID:userKey andCallType:type];
    
}// end responseForLoginParticipantReceived

- (void) responseForUpdateUserProfileRecieved:(NSData*)responseData withError:error andUpdateFrom:(int)updateFromPage andUserID:(NSString*)userID andTeamID:(NSString*)teamID
{
    int responseMessage = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary for update profile is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
        // notes:
        //   message values:
        //  1000:  success:  update successful
        //  9999:  failure:  general failure
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    if (updateFromPage == UPDATEFROMTEAMSPAGE){
        if (responseMessage == SUCCESS){
            //get the team points and rank for this team
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setObject:teamID forKey:teamIDKey];
            [dict setObject:[NSString stringWithFormat:@"%d", UPDATEFROMTEAMSPAGE] forKey:updateFromKey];
            [self sendMessageToServer:getTeamPointAndRank withDataDictionary:dict];
            
        }else{ //inform the page of failure
            [[self sessionDelegate] changeTeamFromTeamsPageResponseReceived:responseMessage andTeamID:teamID andAllTimeRank:0 andMonthRank:0 andAllTimePoint:0 andMonthPoint:0];
        }
    }//end updateFromTeamsPage
    
    
}//end responseForUpdateUserProfile

- (void) responseForGetProfileReceived:(NSData*)responseData withError:error andWithImage:(NSString*)withImage andServerCallObject:(NSObject*)serverCallObject
{
    int responseMessage = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        //NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
        if (responseMessage == SUCCESS)
        {
            NSString* email       = [responseDictionary objectForKey:userEmailKey];
            NSString* password    = [responseDictionary objectForKey:userPasswordKey];
            int team  = [[responseDictionary objectForKey:teamIDKey]intValue];
            NSString* teamIDString = [NSString stringWithFormat:@"%d", team];
            NSString* userImageString = [responseDictionary objectForKey:userImageKey];
            int userID = [[responseDictionary objectForKey:userIDKey]intValue];
            NSString* userIDString = [NSString stringWithFormat:@"%d", userID];
            NSString* userName = [responseDictionary objectForKey:userNameKey];
            
            //set the objects in the user profile dictionary
            [_userProfileDictionary setObject:email forKey:userEmailKey];
            [_userProfileDictionary setObject:password forKey:userPasswordKey];
            [_userProfileDictionary setObject:teamIDString forKey:teamIDKey];
            [_userProfileDictionary setObject:userIDString forKey:userIDKey];
            [_userProfileDictionary setObject:userName forKey:userNameKey];
            
            
            if ([withImage isEqualToString:@"YES"])
            {
                UIImage* userImage;
                if (userImageString == nil)
                {
                    userImageString = @"";
                    userImage = [UIImage imageNamed:@"genericUserImage.png"];
                    
                }else{
                    //THIS NEEDS TO BE FIXED  - CREATE AN IMAGE OUT OF THE DATA STRING
                    //temporary code
                    userImage = [UIImage imageNamed:@"genericUserImage.png"];
                }
                
                [_userProfileDictionary setObject:userImage forKey:userImageKey];
                
            }//end if
            
            
        }//end success
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    if (responseMessage != SUCCESS)
    {
        _netWorkErrorOccurred = true;
        
    }else {
        //get teams information
        NSMutableDictionary* teamsSchoolDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* teamsBusinessDict = [[NSMutableDictionary alloc] init];
        NSMutableDictionary* teamsOtherDict = [[NSMutableDictionary alloc] init];
        NSObject* schoolCatObject = [[NSObject alloc]init];
        NSObject* businessCatObject = [[NSObject alloc]init];
        NSObject* otherCatObject = [[NSObject alloc]init];
        
        [self addOrRemoveCountToStartupList:ADD withObject:schoolCatObject];
        [self addOrRemoveCountToStartupList:ADD withObject:businessCatObject];
        [self addOrRemoveCountToStartupList:ADD withObject:otherCatObject];
        
        [teamsSchoolDict setObject:schoolCatObject forKey:SERVERCALLOBJECTKEY];
        [teamsSchoolDict setObject:SCHOOL forKey:teamCategoryKey];
        
        [teamsBusinessDict setObject:businessCatObject forKey:SERVERCALLOBJECTKEY];
        [teamsBusinessDict setObject:BUSINESS forKey:teamCategoryKey];
        
        [teamsOtherDict setObject:otherCatObject forKey:SERVERCALLOBJECTKEY];
        [teamsOtherDict setObject:OTHER forKey:teamCategoryKey];
        
        [self sendMessageToServer:getTeamsByCategory withDataDictionary:teamsSchoolDict];
        [self sendMessageToServer:getTeamsByCategory withDataDictionary:teamsBusinessDict];
        [self sendMessageToServer:getTeamsByCategory withDataDictionary:teamsOtherDict];
        
        
        //get user rank and points
        NSString* userKeyString = [_userProfileDictionary objectForKey:userIDKey];
        NSObject* userKeyServerObject = [[NSObject alloc]init];
        [self addOrRemoveCountToStartupList:ADD withObject:userKeyServerObject];
        NSMutableDictionary* userDict = [[NSMutableDictionary alloc] init];
        [userDict setObject:userKeyString forKey:userIDKey];
        [userDict setObject:userKeyServerObject forKey:SERVERCALLOBJECTKEY];
        [self sendMessageToServer:getParticipantPointAndRank withDataDictionary:userDict];
        
    }
    
    //take this call out of the startup data structure _serverCallArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];
    
}//end get profile
/*
- (void) responseForForgotPasswordReceived:(NSData*)responseData withError:(NSError*)error
{
    int responseType = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        //NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        int responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
        //possibilities can only be
        // SUCCESS  - 1000
        // FAILURE:  invalid email format
        // FAILURE:  email not registered in database
        // NETWORKERROR - 9999 / General Error
        
        // response type can be 1000 for success or 9999 for general failure
        responseType = responseMessage;
        
    }
    else // error not null
    {
        responseType = NETWORKERROR; // just set to general server error
    }
    
    //inform the delegate
    //[[self teamPageResponseReceivedDelegate] responseforRequestNewTeamReceived:responseType];
    
}//end forgotPassword
*/
- (void) responseForRequestNewTeamReceived:(NSData*)responseData withError:(NSError*)error
{
    int responseMessage = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        //NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
        //possibilities can be
        // SUCCESS  - 1000
        // NETWORKERROR - 9999
        // Duplicate TeamName and TeamCategory 1011
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    //inform the delegate
    [[self sessionDelegate] newTeamRequestResponseReceived:responseMessage];
    
}//end responseForRequestNewTeamReceived

- (void) responseForGetTeamsByTypeReceived:(NSData*)responseData withError:(NSError*)error andType:(NSString*)type andServerCallObject:(NSObject*)serverCallObject
{
    int responseMessage = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        //NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
        if (responseMessage == SUCCESS)
        {
            NSArray* teamsList = [responseDictionary objectForKey:@"TeamList"];  //array of dictionaries from the server
            NSMutableArray* teamTypeArray;
            
            if ([type isEqualToString:SCHOOL]){
                teamTypeArray = [_teamsArray objectAtIndex:0];
            }else if ([type isEqualToString:BUSINESS]){
                teamTypeArray = [_teamsArray objectAtIndex:1];
            }else{ //OTHER
                teamTypeArray = [_teamsArray objectAtIndex:2];
            }
            
            for (int i = 0; i < [teamsList count]; i++){
                
                NSDictionary* currentDict = [teamsList objectAtIndex:i];
                
                int teamID = [[currentDict objectForKey:teamIDKey]intValue];
                NSString* teamIdString = [NSString stringWithFormat:@"%d",teamID];
                NSString* teamName = [currentDict objectForKey:teamNameKey];
                
                NSMutableDictionary* newTeamDictionary = [[NSMutableDictionary alloc]init];
                [newTeamDictionary setObject:teamIdString forKey:teamIDKey];
                [newTeamDictionary setObject:teamName forKey:teamNameKey];
                
                //so we can look this dictionary up by id
                [_teamsByIdDict setObject:newTeamDictionary forKey:teamIdString];
                [teamTypeArray addObject:newTeamDictionary];
                
            }
        }
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    
    //if this startup function did not successfully complete, inform the model
    if (responseMessage != SUCCESS)
    {
        _netWorkErrorOccurred = true;
    }
    
    //remove this call from the _serverCallArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];
    
}//end responseForGetTeamsByType

/***
 * The serverCallObject is used to access the serverSession array.  This is an array that keeps
 * track of what calls have been made and what calls have completed
 *
 */
- (void) responseForGetCurrentMonthTopicReceived:(NSData*)responseData withError:(NSError*)error andServerCallObjec:(NSObject*)serverCallObject
{
    int responseType = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        //NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        int responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
        if (responseMessage == SUCCESS)
        {
            NSArray* topicsListArray = [responseDictionary objectForKey:(@"TopicsList")]; //array with 1 dictionary element
            NSDictionary* tempDict = [topicsListArray objectAtIndex:CURRENTMONTHLOCATION];
            
            //create a dictionary that will be the first object in the topics array
            //we want this dictionary to be mutable because we will be adding to it later
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[tempDict objectForKey:monthKey]      forKey:monthKey];
            [dict setObject:[tempDict objectForKey:yearKey]       forKey:yearKey];
            [dict setObject:[tempDict objectForKey:topicIDKey]    forKey:topicIDKey];
            [dict setObject:[tempDict objectForKey:topicURLKey]   forKey:topicURLKey];
            [dict setObject:[tempDict objectForKey:topicTitleKey] forKey:topicTitleKey];
            
            [_topicsArray addObject:dict];
            
            
            //now that current month call was successful, get the challenges for the current month
            NSMutableDictionary* dictCurrentChallenges = [[NSMutableDictionary alloc] init];
            NSString* userIDString = [_userProfileDictionary objectForKey:userIDKey];
            NSString* topicIDString = [tempDict objectForKey:topicIDKey];
            NSString* arrayLocationString = [NSString stringWithFormat:@"%d", CURRENTMONTHLOCATION];
            NSObject* currentChallengeObject = [[NSObject alloc]init];
            [dictCurrentChallenges setObject:userIDString forKey:userIDKey];
            [dictCurrentChallenges setObject:topicIDString forKey:topicIDKey];
            [dictCurrentChallenges setObject:arrayLocationString forKey:TOPICARRAYLOCATIONKEY];
            [dictCurrentChallenges setObject:currentChallengeObject forKey:SERVERCALLOBJECTKEY];
            [self addOrRemoveCountToStartupList:ADD withObject:currentChallengeObject];
            [self sendMessageToServer:getChallengesForTopic withDataDictionary:dictCurrentChallenges];
            
            
            
            //get the available previous topics
            NSMutableDictionary* dictPastTopics = [[NSMutableDictionary alloc] init];
            int currentMonth = [[tempDict objectForKey:monthKey]intValue];
            int numMonths = [self getNumberOfPreviousTopicsToRequest:currentMonth];
            NSObject* previousTopicsObject = [[NSObject alloc]init];
            NSString* monthnumString = [NSString stringWithFormat:@"%d", numMonths];
            [dictPastTopics setObject:monthnumString forKey:monthKey];
            [dictPastTopics setObject:previousTopicsObject forKey:SERVERCALLOBJECTKEY];
            [self addOrRemoveCountToStartupList:ADD withObject:previousTopicsObject];
            [self sendMessageToServer:getPastMonthTopics withDataDictionary:dictPastTopics];
            
            
        }// end success
        
        
        // response type can be 1000 for success or 9999 for general failure
        responseType = responseMessage;
        
    }
    else // error not null
    {
        responseType = NETWORKERROR; // just set to general server error
    }
    
    
    //if this startup function did not successfully complete, inform the model
    if (responseType != SUCCESS)
    {
        _netWorkErrorOccurred = true;
        
    }//end !SUCCESS
    
    //remove this call from the _serverCallArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];
    
}// end responseForGetCurrentMonthTopicReceived

-(void) responseForGetPastMonthTopicsReceived:(NSData*)responseData withError:(NSError*)error andServerCallObject:(NSObject*)serverCallObject
{
    int responseType = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        int responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
        if (responseMessage == SUCCESS)//successful
        {
            //first get the array and dictionary from the server - sent as an array with one element
            NSArray* topicsListArray = [responseDictionary objectForKey:(@"TopicsList")];
            int count = (int)[topicsListArray count];
            
            for (int i = 0; i < count; i++){
                NSDictionary* tempDict = [topicsListArray objectAtIndex:i];
                
                //create a dictionary that will be the first object in the topics array
                //we want this dictionary to be mutable because we will be adding to it later
                NSMutableDictionary* topicDict = [[NSMutableDictionary alloc] init];
                [topicDict setObject:[tempDict objectForKey:monthKey]      forKey:monthKey];
                [topicDict setObject:[tempDict objectForKey:yearKey]       forKey:yearKey];
                [topicDict setObject:[tempDict objectForKey:topicIDKey]    forKey:topicIDKey];
                [topicDict setObject:[tempDict objectForKey:topicURLKey]   forKey:topicURLKey];
                [topicDict setObject:[tempDict objectForKey:topicTitleKey] forKey:topicTitleKey];
                
                //this will be in location i+1 in the _topicsArray
                [_topicsArray addObject:topicDict];
                
                //get the challenges for this topic
                NSMutableDictionary* challengesDict = [[NSMutableDictionary alloc] init];
                NSString* userIDString = [_userProfileDictionary objectForKey:userIDKey];
                NSMutableDictionary* previousTopicDict = [_topicsArray objectAtIndex:i+1];
                NSString* topicIDString = [previousTopicDict objectForKey:topicIDKey];
                NSString* arrayLocationString = [NSString stringWithFormat:@"%d", i+1];
                NSObject* challengesCallObject = [[NSObject alloc]init];
                [challengesDict setObject:userIDString forKey:userIDKey];
                [challengesDict setObject:topicIDString forKey:topicIDKey];
                [challengesDict setObject:arrayLocationString forKey:TOPICARRAYLOCATIONKEY];
                [challengesDict setObject:challengesCallObject forKey:SERVERCALLOBJECTKEY];
                [self addOrRemoveCountToStartupList:ADD withObject:challengesCallObject];
                [self sendMessageToServer:getChallengesForTopic withDataDictionary:challengesDict];
                
                
            }// end for i
            
            
        }//end success
        
        // response type can be 1000 for success or 9999 for general failure
        responseType = responseMessage;
        
    }
    else // error not null
    {
        responseType = NETWORKERROR; // just set to general server error
    }
    
    if (responseType != SUCCESS){//need to indicate an error has occurred
        _netWorkErrorOccurred = true;
    }
    
    //remove this call from the startupCallArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];
    
}//end responseForGetPastMonthTopicsReceived

-(void) responseForGetChallengesForTopicReceived:(NSData*)responseData withError:(NSError*)error andArrayLocation:(int)topicArrayLocation andServerCallObject:(NSObject*)serverCallObject
{
    int responseType = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        int responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        if (responseMessage == SUCCESS)
        {
            NSArray* challengesArray = [responseDictionary objectForKey:(@"ChallengesList")];
            NSMutableDictionary* topicDict = _topicsArray[topicArrayLocation];
            // we need a mutable Dictionary because we will be adding to it later
            
            NSString* userStatusString;
            
            
            NSMutableDictionary* challenge1 = [[NSMutableDictionary alloc]init];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:challengeDescKey] forKey:challengeDescKey];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:challengeIDKey] forKey:challengeIDKey];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:challengeNoKey] forKey:challengeNoKey];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:daysPossibleKey] forKey:daysPossibleKey];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:difficultyKey] forKey:difficultyKey];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:impactKey] forKey:impactKey];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:teaserKey] forKey:teaserKey];
            [challenge1 setObject:[[challengesArray objectAtIndex:0] objectForKey:typeKey] forKey:typeKey];
            int userStatus = [[[challengesArray objectAtIndex:0] objectForKey:userStatusKey]intValue];
            userStatusString = [NSString stringWithFormat:@"%d", userStatus];
            [challenge1 setObject:userStatusString forKey:userStatusKey];
            
            NSMutableDictionary* challenge2 = [[NSMutableDictionary alloc]init];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:challengeDescKey] forKey:challengeDescKey];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:challengeIDKey] forKey:challengeIDKey];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:challengeNoKey] forKey:challengeNoKey];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:daysPossibleKey] forKey:daysPossibleKey];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:difficultyKey] forKey:difficultyKey];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:impactKey] forKey:impactKey];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:teaserKey] forKey:teaserKey];
            [challenge2 setObject:[[challengesArray objectAtIndex:1] objectForKey:typeKey] forKey:typeKey];
            userStatus = [[[challengesArray objectAtIndex:1] objectForKey:userStatusKey]intValue];
            userStatusString = [NSString stringWithFormat:@"%d", userStatus];
            [challenge2 setObject:userStatusString forKey:userStatusKey];
            
            NSMutableDictionary* challenge3 = [[NSMutableDictionary alloc]init];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:challengeDescKey] forKey:challengeDescKey];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:challengeIDKey] forKey:challengeIDKey];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:challengeNoKey] forKey:challengeNoKey];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:daysPossibleKey] forKey:daysPossibleKey];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:difficultyKey] forKey:difficultyKey];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:impactKey] forKey:impactKey];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:teaserKey] forKey:teaserKey];
            [challenge3 setObject:[[challengesArray objectAtIndex:2] objectForKey:typeKey] forKey:typeKey];
            userStatus = [[[challengesArray objectAtIndex:2] objectForKey:userStatusKey]intValue];
            userStatusString = [NSString stringWithFormat:@"%d", userStatus];
            [challenge3 setObject:userStatusString forKey:userStatusKey];
            
            //create an array and add the dictionaries to it
            NSArray* newChallengesArray = [[NSArray alloc] initWithObjects:challenge1, challenge2, challenge3, nil];
            [topicDict setObject:newChallengesArray forKey:challengeArrayKey];
            
            
            //now we can get the user points for the challenges
            NSString* userIdString = [_userProfileDictionary objectForKey:userIDKey];
            NSString* challenge1IDString = [[newChallengesArray objectAtIndex:0] objectForKey:challengeIDKey];
            NSString* challenge2IDString = [[newChallengesArray objectAtIndex:1] objectForKey:challengeIDKey];
            NSString* challenge3IDString = [[newChallengesArray objectAtIndex:2] objectForKey:challengeIDKey];
            NSString* arrayLocationString = [NSString stringWithFormat:@"%d", topicArrayLocation];
            NSString* challenge1NumberString = [NSString stringWithFormat:@"1"];
            NSString* challenge2NumberString = [NSString stringWithFormat:@"2"];
            NSString* challenge3NumberString = [NSString stringWithFormat:@"3"];
            NSObject* challenge1CallObject = [[NSObject alloc] init];
            NSObject* challenge2CallObject = [[NSObject alloc] init];
            NSObject* challenge3CallObject = [[NSObject alloc] init];
            //the behavior of the return function is different depending on whether being called from startup or update
            NSString* startupString = [NSString stringWithFormat:@"%d", STARTUP];
            
            
            NSMutableDictionary* challenge1Dict = [[NSMutableDictionary alloc] init];
            NSMutableDictionary* challenge2Dict = [[NSMutableDictionary alloc] init];
            NSMutableDictionary* challenge3Dict = [[NSMutableDictionary alloc] init];
            
            [challenge1Dict setObject:userIdString forKey:userIDKey];
            [challenge1Dict setObject:challenge1IDString forKey:challengeIDKey];
            [challenge1Dict setObject:arrayLocationString forKey:TOPICARRAYLOCATIONKEY];
            [challenge1Dict setObject:challenge1NumberString forKey:challengeNoKey];
            [challenge1Dict setObject:challenge1CallObject forKey:SERVERCALLOBJECTKEY];
            [challenge1Dict setObject:startupString forKey:startUpOrUpdateKey];
            
            [challenge2Dict setObject:userIdString forKey:userIDKey];
            [challenge2Dict setObject:challenge2IDString forKey:challengeIDKey];
            [challenge2Dict setObject:arrayLocationString forKey:TOPICARRAYLOCATIONKEY];
            [challenge2Dict setObject:challenge2NumberString forKey:challengeNoKey];
            [challenge2Dict setObject:challenge2CallObject forKey:SERVERCALLOBJECTKEY];
            [challenge2Dict setObject:startupString forKey:startUpOrUpdateKey];
            
            [challenge3Dict setObject:userIdString forKey:userIDKey];
            [challenge3Dict setObject:challenge3IDString forKey:challengeIDKey];
            [challenge3Dict setObject:arrayLocationString forKey:TOPICARRAYLOCATIONKEY];
            [challenge3Dict setObject:challenge3NumberString forKey:challengeNoKey];
            [challenge3Dict setObject:challenge3CallObject forKey:SERVERCALLOBJECTKEY];
            [challenge3Dict setObject:startupString forKey:startUpOrUpdateKey];
            
            [self addOrRemoveCountToStartupList:ADD withObject: challenge1CallObject];
            [self sendMessageToServer:getUserPointsForChallenge withDataDictionary:challenge1Dict];
            
            [self addOrRemoveCountToStartupList:ADD withObject: challenge2CallObject];
            [self sendMessageToServer:getUserPointsForChallenge withDataDictionary:challenge2Dict];
            
            [self addOrRemoveCountToStartupList:ADD withObject: challenge3CallObject];
            [self sendMessageToServer:getUserPointsForChallenge withDataDictionary:challenge3Dict];
            
        }//end success
        
        // response type can be 1000 for success or 9999 for general failure
        responseType = responseMessage;
        
    }
    else // error not null
    {
        responseType = NETWORKERROR; // just set to general server error
    }
    
    
    //if this startup function did not successfully complete, inform the model
    if (responseType != SUCCESS)
    {
        _netWorkErrorOccurred = true;
        
    }//end !SUCCESS
    
    //remove this call from the serverStartupCallsArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];
    
}//end responseForGetChallengesForTopicReceived

-(void) responseForGetUserPointsForChallengeReceived:(NSData*)responseData withError:(NSError*)error andArrayLocation:(int) topicArrayLocation andChallengeNumber:(int) challengeNumber andServerCallObject:(NSObject*) serverCallObject andStartupOrUpdate:(int) startupOrUpdate
{
    int responseMessage = 0;
    NSArray* dateArray;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        if (responseMessage == SUCCESS)
        {
            dateArray = [responseDictionary objectForKey:dateInputKey];
            
            if (startupOrUpdate == STARTUP){
                //add this array to the challenge dictionary
                NSMutableDictionary* topicDict = _topicsArray[topicArrayLocation];
                NSArray* challengesArray = [topicDict objectForKey:challengeArrayKey];
                NSMutableDictionary* challengeDict = challengesArray[challengeNumber - 1];
            
                [challengeDict setObject:dateArray forKey:dateInputKey];
            }
            
        }//end success
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    
    //if this startup function did not successfully complete, set the flag
    if (responseMessage != SUCCESS)
    {
        _netWorkErrorOccurred = true;
    }//end !SUCCESS
    
    if (startupOrUpdate == STARTUP){
        //remove this call from the serverCallArray
        [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];
    }else{ //UPDATE
        [[self sessionDelegate] updateUserPointsForChallengeResponseReceivedWithDateArray:dateArray andTopicsArrayLocation:topicArrayLocation andChallengeNumber:challengeNumber andNetworkError:_netWorkErrorOccurred];
        _netWorkErrorOccurred = false;
    }
    
}//end responseFor GetUserPointsForCurrentChallengeReceived

-(void) responseForSetUserPointsForChallengeReceived:(NSData*)responseData withError:(NSError*)error andServerCallObject:(NSObject*)serverCallObject andArrayLocation:(int) arrayLocation andChallengeNumber:(int) challengeNumber andUserID:(NSString*)userID andChallengeID:(NSString*)challengeID
{
    int responseMessage = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    //if this startup function did not successfully complete, inform the model
    if (responseMessage != SUCCESS)
    {
        _netWorkErrorOccurred = true;
        
    }//end !SUCCESS
    
    //remove this call from the serverCallArray
    [self addOrRemoveFromDateList:REMOVE withObject:serverCallObject andArrayLocation:arrayLocation andChallengeNumber:challengeNumber andUserID:userID andChallengeID:challengeID];
    
    
}//end responseFor setUserPointsForChallengeReceived

-(void) responseForGetTeamPointAndRankReceived:(NSData*)responseData withError:(NSError*)error andTeamID:(NSString*)teamID andCalledFromPage:(int)calledFromPage
{
    int responseMessage = 0;
    
    int allTimePoint = 0;
    int allTimeRank  = 0;
    int monthPoint   = 0;
    int monthRank    = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        if (responseMessage == SUCCESS)
        {
 
            allTimePoint = [[responseDictionary objectForKey:teamAllTimePointsKey]intValue];
            allTimeRank  = [[responseDictionary objectForKey:teamAllTimeRankKey]intValue];
            monthPoint   = [[responseDictionary objectForKey:teamCurrentMonthPointsKey]intValue];
            monthRank    =  [[responseDictionary objectForKey:teamCurrentMonthRankKey]intValue];
            
            if (calledFromPage == UPDATEFROMLOGIN){
            //get the dictionary by teamID
                NSMutableDictionary* teamDict = [_teamsByIdDict objectForKey:teamID];
            
                NSString* allTimePointString = [NSString stringWithFormat:@"%d", allTimePoint];
                NSString* allTimeRankString  = [NSString stringWithFormat:@"%d", allTimeRank];
                NSString* currentPointString = [NSString stringWithFormat:@"%d", monthPoint];
                NSString* currentRankString  = [NSString stringWithFormat:@"%d", monthRank];
            
                [teamDict setObject:allTimePointString forKey:teamAllTimePointsKey];
                [teamDict setObject:allTimeRankString  forKey:teamAllTimeRankKey];
                [teamDict setObject:currentPointString forKey:teamCurrentMonthPointsKey];
                [teamDict setObject:currentRankString  forKey:teamCurrentMonthRankKey];
            }
            
        }//end success
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    if (calledFromPage == UPDATEFROMLOGIN){
        //if this startup function did not successfully complete, inform the model
        if (responseMessage != SUCCESS)
        {
            _netWorkErrorOccurred = true;
        }//end !SUCCESS
        [self userTeamPointsServerCallCompleted];
        
    }else{ //update from teams page
    
        [[self sessionDelegate] changeTeamFromTeamsPageResponseReceived:responseMessage andTeamID: teamID andAllTimeRank:allTimeRank andMonthRank:monthRank andAllTimePoint:allTimePoint andMonthPoint:monthPoint];
    }//end else
    
    
}//end getTeamPointAndRank

-(void) responseForGetParticipantPointAndRankReceived:(NSData*)responseData withError:(NSError*)error andServerCallObject:(NSObject*)serverCallObject
{
    int responseMessage;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        if (responseMessage == SUCCESS)
        {
            
            int allTimePoint = [[responseDictionary objectForKey:userAllTimePointsKey]intValue];
            int allTimeRank  = [[responseDictionary objectForKey:userAllTimeRankKey]intValue];
            int monthPoint   = [[responseDictionary objectForKey:userCurrentMonthPointsKey]intValue];
            int monthRank    = [[responseDictionary objectForKey:userCurrentMonthRankKey]intValue];
            
            NSString* allTimePointString = [NSString stringWithFormat:@"%d", allTimePoint];
            NSString* allTimeRankString  = [NSString stringWithFormat:@"%d", allTimeRank];
            NSString* currentPointString = [NSString stringWithFormat:@"%d", monthPoint];
            NSString* currentRankString  = [NSString stringWithFormat:@"%d", monthRank];
            
            [_userProfileDictionary setObject:allTimePointString forKey:userAllTimePointsKey];
            [_userProfileDictionary setObject:allTimeRankString  forKey:userAllTimeRankKey];
            [_userProfileDictionary setObject:currentPointString forKey:userCurrentMonthPointsKey];
            [_userProfileDictionary setObject:currentRankString  forKey:userCurrentMonthRankKey];
            
            
        }//end success
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    
    //if this startup function did not successfully complete, inform the model
    if (responseMessage != SUCCESS)
    {
        _netWorkErrorOccurred = true;
        
    }
    
    //take this call out of the startup data structure _serverCallArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];
    
}//end userPointAndRank

- (void) responseforGetTopTenTeamsReceived:(NSData*)responseData withError:(NSError*)error andPeriod:(NSString*)periodString andServerCallObject:(NSObject*)serverCallObject
{
    int responseMessage;
    NSMutableArray* teamsArray;
    
    if ([periodString isEqualToString:allTimeString]){
        teamsArray = _topTeamsAllTime;
    }else{//current month
        teamsArray = _topTeamsMonthly;
    }
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        if (responseMessage == SUCCESS)
        {
            NSArray* teamList = [responseDictionary objectForKey:@"TeamList"];
            int count = (int)[teamList count];
            
            for (int i = 0; i < count; i++)
            {
                NSDictionary* currentDict = [teamList objectAtIndex:i];
                NSString* teamName = [currentDict objectForKey:topTeamNameKey];
                int points = [[currentDict objectForKey:topPointsKey]intValue];
                NSString* pointsString = [NSString stringWithFormat:@"%d", points];
                int rank = [[currentDict objectForKey:topRankKey]intValue];
                NSString* rankString = [NSString stringWithFormat:@"%d", rank];
                int teamID = [[currentDict objectForKey:teamIDKey]intValue];
                NSString* teamIDString = [NSString stringWithFormat:@"%d", teamID];
                
                //set the elmenets in a dictiionary, and add to the individuals array
                NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                [dict setObject:teamName forKey:topTeamNameKey];
                [dict setObject:pointsString forKey:topPointsKey];
                [dict setObject:rankString forKey:topRankKey];
                [dict setObject:teamIDString forKey:teamIDKey];
                
                [teamsArray addObject:dict];
                
            }//end for i
            
            
        }//end success
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    
    //if this startup function did not successfully complete, inform the model
    if (responseMessage != SUCCESS)
    {
        _netWorkErrorOccurred = true;
        
    }
    
    //take this call out of the startup data structure _serverCallArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];

}//end responseForGetTopTenTeams

- (void) responseforGetTopTenIndividualsReceived:(NSData*)responseData withError:(NSError*)error andPeriod:(NSString*)periodString andServerCallObject:(NSObject*)serverCallObject
{
    int responseMessage;
    NSMutableArray* individualsArray;
    
    if ([periodString isEqualToString:allTimeString]){
        individualsArray = _topUsersAllTime;
    }else{//current month
        individualsArray = _topUsersMonthly;
    }
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        if (responseMessage == SUCCESS)
        {
            NSArray* individualList = [responseDictionary objectForKey:@"IndividualList"];
            int count = (int)[individualList count];
            
            for (int i = 0; i < count; i++)
            {
                NSDictionary* currentDict = [individualList objectAtIndex:i];
                NSString* userName = [currentDict objectForKey:topIndividualNameKey];
                int points = [[currentDict objectForKey:topPointsKey]intValue];
                NSString* pointsString = [NSString stringWithFormat:@"%d", points];
                int rank = [[currentDict objectForKey:topRankKey]intValue];
                NSString* rankString = [NSString stringWithFormat:@"%d", rank];
                int userID = [[currentDict objectForKey:userIDKey]intValue];
                NSString* userIDString = [NSString stringWithFormat:@"%d", userID];
                
                //set the elmenets in a dictiionary, and add to the individuals array
                NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
                [dict setObject:userName forKey:topIndividualNameKey];
                [dict setObject:pointsString forKey:topPointsKey];
                [dict setObject:rankString forKey:topRankKey];
                [dict setObject:userIDString forKey:userIDKey];
                
                [individualsArray addObject:dict];
                
            }//end for i
            
            
        }//end success
        
    }
    else // error not null
    {
        responseMessage = NETWORKERROR; // just set to general server error
    }
    
    
    //if this startup function did not successfully complete, inform the model
    if (responseMessage != SUCCESS)
    {
        _netWorkErrorOccurred = true;
        
    }
    
    //take this call out of the startup data structure _serverCallArray
    [self addOrRemoveCountToStartupList:REMOVE withObject:serverCallObject];

}//end responseForGetTopIndiviuals



/******************************************************************************************************
 *
 *                                   HelperMethods Methods
 *
 ******************************************************************************************************/
- (int) getNumberOfPreviousTopicsToRequest:(int) currentMonthNum
{
    int numPreviousMonths = 0;
    
    if (currentMonthNum != BEGINNINGMONTH)
    {
        //calculate how many months back we need to request
        if (currentMonthNum > BEGINNINGMONTH)
        {
            numPreviousMonths = currentMonthNum - BEGINNINGMONTH;
            
        }else
        {
            numPreviousMonths = 12 - BEGINNINGMONTH + currentMonthNum;
        }
    }//end currentMonth != BeginningMonth
    
    return numPreviousMonths;
    
}//end getNumberOfPreviousMonthsToRequest


- (NSMutableDictionary*) getUserProfileDictionary
{
    return _userProfileDictionary;
}

- (NSMutableArray*) getTopicsArray
{
    return _topicsArray;
}

- (NSArray*) getTeamsArray
{
    return _teamsArray;
}

- (NSMutableDictionary*) getTeamsByDict
{
    return _teamsByIdDict;
}

- (NSMutableArray*) getTopUsersCurrentMonth
{
    return _topUsersMonthly;
}

- (NSMutableArray*) getTopUsersAllTime
{
    return _topUsersAllTime;
}

- (NSMutableArray*) getTopTeamsCurrentMonth
{
    return _topTeamsMonthly;
}

- (NSMutableArray*) getTopTeamsAllTime
{
    return _topTeamsAllTime;
}

@end
