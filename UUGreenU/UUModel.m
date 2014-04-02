//
//  UUModel.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUModel.h"

//This app will cycle through a year, beginning
// in August.  This number is important because
// it will be used to determine if there
// are previous month challenges or not
#define BEGINNINGMONTH 8

// for ease and consistency in accessing dictionaries
#define monthNumberKey @"monthNumber"
#define yearKey @"year"
#define topicIDKey @"topicID"
#define topicStringKey @"topicString"
#define topicURLKey @"topicURL"


@implementation UUModel
{
    int _userServerKey;
    NSString* _userDisplayName;
    NSString* _userEmail;
    NSString* _userPassword;
    NSString* _userTeamName;
    UIImage*  _userProfileImage;
    
    //date info
    int _currentMonth;
    int _currentYear;
    NSString* _currentMonthURL;
    
    // this holds the number of previous months available
    int _numberOfPreviousMonths;
    
    //holds Topic Info for current Month
    NSMutableDictionary* _currentMonthTopicDict;
    
    //holds the topic and URL for the previous Months
    //in reversehronoligical order
    NSMutableArray* _previousTopicsArray;
}

@synthesize registerParticipantDataReceivedDelegate;
@synthesize participantLoginDataReceivedDelegate;

/***
*
*      Constructor
*
*/
- (id)init
{
    self = [super init];
    if (self)
    {
        _userDisplayName = @"NEED DISPLAY NAME";  //FIX THIS!!!!!!!!!!!!!!!!!!!!!!!
        _userTeamName = @"NEED TEAM NAME";        //FIX THIS TOO!!!!!!!
        _userProfileImage = nil;
        _userPassword = @"password";
        
        
        //initialize data structures
        _currentMonthTopicDict = [[NSMutableDictionary alloc]init];
        _previousTopicsArray   = [[NSMutableArray alloc]init];
        
        //##############################################
        //#
        //#    Start up functions:
        //#
        //###############################################
         [self callServerStartupFunctions];
        
        
     }
    else //no object
    {
        return nil;
    }
    
    return self;
    
}//end constructor

/******************************************************************************************************
 *
 *                   Startup Functions:  info needed from server on first load
 *
 ******************************************************************************************************/
/**
 *  This method calls all the functions that we want to load when first
 *  opening the app.
 *
 */
 - (void) callServerStartupFunctions
{
    // this will call the server for info about current month topic
    // callback function is "getCurrentMonthAndTopic
    [self sendMessageToServer:getCurrentMonthTopic withDataDictionary:NULL];
    
}//end call server starutp functions
/***
 * This function gets an integer value for the current month, 
 * The associated integer value for the topicID, the topic
 * as a string, and the URL as a string.  It also fills in the 
 * _topicArray for all the previous months
 *
 */
- (void) getCurrentMonthAndTopic:(int) responseType
{

    if (responseType == 1000)//success
    {
        _currentMonth =  [[_currentMonthTopicDict objectForKey:monthNumberKey]intValue];
        _currentYear  =  [[_currentMonthTopicDict objectForKey:yearKey]intValue];
        
        // now that we have the current month, calculate the number of
        // previous months available
        if (_currentMonth != BEGINNINGMONTH)
        {
            //calculate how many months back we need to request
            if (_currentMonth > BEGINNINGMONTH)
            {
                _numberOfPreviousMonths = _currentMonth - BEGINNINGMONTH;
            }else
            {
                _numberOfPreviousMonths = 12 - BEGINNINGMONTH + _currentMonth;
            }
        }//end currentMonth != BeginningMonth
        
        //call sever to populate dictionaries for previous months
        
        
        
        
        
        
    }
    else //unsuccessful call
    {
        
    }
    
    
    //get previousmonths informationfrom the server
    
    //[self sendMessageToServer:getPreviousMonthTopic withDataDictionary:NULL];
    //take this out - will be replaced by server method
    for (int i = 1 ; i <= _numberOfPreviousMonths; i++)
    {
        int monthNumber = _currentMonth - (i);
        if (monthNumber < 1)
        {
            monthNumber += 12;  //start back at December
        }
        NSMutableDictionary* newDict = [self getDictForMonth:5];
        [_previousTopicsArray addObject:newDict];
    }
    
    //end take this out

    
    
    
    
}//end get current month and topic

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
            NSString* username = [dataDictionary objectForKey:@"displayName"];
            NSString* email = [dataDictionary objectForKey:@"email"];
            NSString* password = [dataDictionary objectForKey:@"password"];
            
            dataString = [NSString stringWithFormat:@"{ 'UserName' : '%@', 'Email' : '%@', 'Password' : '%@' }", username, email, password];
            
            break;
        }
        case (participantLogin):
        {
            methodString = [NSString stringWithFormat:@"%@", participantLoginRequest];
            action = POST;
            
            // set up the data to use
            NSString* email = [dataDictionary objectForKey:@"email"];
            NSString* password = [dataDictionary objectForKey:@"password"];
            
            dataString = [NSString stringWithFormat:@"{ 'Email' : '%@', 'Password' : '%@' }", email, password];
            
            break;
        }
        case (updateUserProfile):
        {
            
            
            break;
            
        }
        case (getUserProfile):
        {
            /*
            methodString = [NSString stringWithFormat:@"%@", getUserProfileRequest];
            action = GET;
            int userKey = [self getUserKey];
            dataString = [NSString stringWithFormat:@"{ 'UserKey' : '%d' }", userKey];
            */
            break;
        }
        case (forgotPassword):
        {
            break;
        }
        case (getAllTeams):
        {
            break;
        }
        case (getTeamsByType):
        {
            /*
            methodString = [NSString stringWithFormat:@"%@", getTeamsByTypeRequest];
            action = GET;
            
            NSString* teamType = [dataDictionary objectForKey:@"teamCategory"];
            
            dataString = [NSString stringWithFormat:@"{ '%@' }", teamType];*/
            break;
        }
        case (requestNewTeam):
        {
            /*
            methodString = [NSString stringWithFormat:@"%@", requestNewTeamRequest];
            action = POST;
            
            // set up the data to use
            NSString* userKeyString = [NSString stringWithFormat:@"%d", _userServerKey];
            NSString* teamName = [dataDictionary objectForKey:@"newTeamName"];
            NSString* teamCategory = [dataDictionary objectForKey:@"newTeamType"];
            
            dataString = [NSString stringWithFormat:@"{ 'UserKey' : '%@', 'TeamName' : '%@', 'TeamCategory' : '%@' }", userKeyString, teamName, teamCategory];*/
            
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
                 [self responseForLoginParticipantReceived:data withError:error];
                 break;
             }
             case (updateUserProfile):
             {
                 //[self responseForUpdateProfileReceived:data withError:error];
                 break;
             }
             case (getUserProfile):
             {
                 //[self responseForGetProfileReceived:data withError:error];
                 break;
             }
             case (forgotPassword):
             {
                 //[self responseForForgotPasswordReceived:data withError:error];
                 break;
             }
             case (getAllTeams):
             {
                 //[self responseForGetAllTeamsReceived:data withError:error];
                 break;
             }
             case (getTeamsByType):
             {
                 //[self responseForGetTeamsByTypeReceived:data withError:error];
                 break;
             }
             case (requestNewTeam):
             {
                 //[self responseForRequestNewTeamReceived:data withError:error];
                 break;
             }
             case (getCurrentMonthTopic):
             {
                 [self responseForGetCurrentMonthTopicReceived:data withError:error];
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

-(void) responseForRegisterParticipantReceived: (NSData*)responseData withError:(NSError*)error
{
    //NSLog(@"Error:  %@", error); // for testing
    //NSLog(@"Response data:  %@", responseData); // for testing
    int responseType = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        
        int responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        int userKey         = [[responseDictionary objectForKey:(@"UserKey")]intValue];
        
        //NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        //NSLog(@"responseMessage is: %d\n", responseMessage);        // for testing
        //NSLog(@"userKey         is: %d\n", userKey);                // for testing
        
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
        
        
        if (responseMessage == 1000)//successful register  ??????? is this supposed to be responsemesage?
        {
            _userServerKey = userKey; //store the key
        }
        
        responseType = responseMessage;
        
    }
    else // error not null
    {
        responseType = 9999; // just set to general server error
    }
    
    // inform the CreateUserViewController that server has replied back
    [[self registerParticipantDataReceivedDelegate] registerParticipantServerDataReceived:responseType];
    
}// end responseForRegisterParticipantReceived


-(void) responseForLoginParticipantReceived:(NSData*)responseData withError:(NSError*)error
{
    int responseType = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        int responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];
        int userKey         = [[responseDictionary objectForKey:(@"UserKey")]intValue];
        NSString* userName  = [responseDictionary objectForKey:(@"UserName")];
        
        
        //NSLog(@"responseMessage is: %d\n", responseMessage);        // for testing
        //NSLog(@"userKey         is: %d\n", userKey);                // for testing
        //NSLog(@"userName        is: %d\n", userName);               // for testing
        
        // notes:
        //   message values:
        //  1000:  success:  participant successfully logged in
        //  1001:  failure:  invalid email format
        //  1005:  failure:  login failure
        //  9999:  failure:  general failure
        //   userkey values:
        //  100001:   some user key starting with 100001 if successful
        //  0:        0 upon failure
        
        
        if (responseMessage == 1000)//successful register
        {
            _userServerKey = userKey; //store the key
            _userDisplayName = userName;
        }
        
        responseType = responseMessage;
        
    }
    else // error not null
    {
        responseType = 9999; // just set to general server error
    }
    
    // inform the CreateUserViewController that server has replied back
    [[self participantLoginDataReceivedDelegate] ParticipantLoginServerDataReceived:responseType];
    
    
}// end responseForLoginParticipantReceived



-(void) responseForGetCurrentMonthTopicReceived:(NSData*)responseData withError:(NSError*)error
{
    int responseType = 0;
    
    if(error == NULL) //everything ok
    {
        // the data sent back to us is a dictionary with two keys: Message and UseKey
        NSError* jsonError;
        NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        NSLog(@"Response Dictionary is: %@\n", responseDictionary); // for testing
        
        int responseMessage = [[responseDictionary objectForKey:(@"Message")]intValue];

        
        //NSLog(@"responseMessage is: %d\n", responseMessage);      // for testing
        //NSLog(@"month           is: %d\n", month);                // for testing
        //NSLog(@"sequence        is: %d\n", sequence);             // for testing
        //NSLog(@"topicKey        is: %d\n", topicKey);             // for testing
        //NSLog(@"year            is: %d\n", year);                 // for testing
        //NSLog(@"monthURL        is: %@\n", monthURL);             // for testing
        //NSLog(@"topicTitle      is: %@\n", topicTitle);           // for testing
        
        // notes:
        //   message values:
        //  1000:  success:  participant successfully logged in
        //  9999:  failure:  general failure
        
        
        if (responseMessage == 1000)//successful
        {
            NSArray* topicsListArray = [responseDictionary objectForKey:(@"TopicsList")];
            NSDictionary* topicsListDict = topicsListArray[0];
            int month    = [[topicsListDict objectForKey:(@"Month")]intValue];
            int sequence = [[topicsListDict objectForKey:(@"Sequence")]intValue];
            int topicKey = [[topicsListDict objectForKey:(@"TopicKey")]intValue];
            int year     = [[topicsListDict objectForKey:(@"Year")]intValue];
            NSString* monthURL   = [topicsListDict objectForKey:(@"TopicPage")];
            NSString* topicTitle = [topicsListDict objectForKey:(@"TopicTitle")];
            NSString* monthString = [NSString stringWithFormat:@"%d", month];
            NSString* yearString  = [NSString stringWithFormat:@"%d", year];
            NSString* topicKeyString = [NSString stringWithFormat:@"%d", topicKey];
            
            
            
            //set the dictionary values
            [_currentMonthTopicDict setObject:monthString forKey:monthNumberKey];
            [_currentMonthTopicDict setObject:yearString forKey:yearKey];
            [_currentMonthTopicDict setObject:topicKeyString forKey:topicIDKey];
            [_currentMonthTopicDict setObject:topicTitle forKey:topicStringKey];
            [_currentMonthTopicDict setObject:monthURL forKey:topicURLKey];
            
            //tell the model that information has been returned

        }//end success
        else  //unsuccessful call
        {
            
            
        }
        
        responseType = responseMessage;
        
    }
    else // error not null
    {
        responseType = 9999; // just set to general server error
    }
    
    // inform the CreateUserViewController that server has replied back
    //[[self participantLoginDataReceivedDelegate] ParticipantLoginServerDataReceived:responseType];
    
}// end responseForGetCurrentMonthTopicReceived


/******************************************************************************************************
 *
 *                                   Getters  on local device
 *
 ******************************************************************************************************/
 -(BOOL) hasUserKey
{
    //The path to the NSDocuments directory in the user domain, ie this is our documents path
//    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) objectAtIndex:0];
    //NSLog(@"Documents Path is: %@", documentsPath); // for testing
    
    /*
    // next load the teams
    _modelDataFilePath = [documentsPath stringByAppendingPathComponent:@"SignInInfo.plist"];
    // verifyFileExists:@"SignInInfo.plist";
    if ([[NSFileManager defaultManager] fileExistsAtPath:_modelDataFilePath] == FALSE)
    {
        
        // If the data file doesn't exist, copy it from the bundle.
        NSString* seedDataPath = [[NSBundle mainBundle] pathForResource:@"SignInInfo" ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:seedDataPath toPath:_modelDataFilePath error:NULL];
        
    }
    
    NSLog(@"\nThe path is:  %@\n", _modelDataFilePath); // for testing
    // now that we know the data file exists, load it from the documents directory
    NSMutableArray* _rawData = [[NSMutableArray alloc] initWithContentsOfFile:_modelDataFilePath];
    
    // now abstract the user login, password, and server key from the array
    //NSString* _userLogin     = [[_rawData objectAtIndex:0] objectForKey:@"UserLogin"];
    //NSLog(@"User Login is: %@\n", _userLogin);  // for testing
    // NSString* _userPassword  = [[_rawData objectAtIndex:1] objectForKey:@"UserPassword"];
    /// NSLog(@"User Password is: %@\n", _userPassword);  // for testing
    // NSNumber* _userServerKey = [[_rawData objectAtIndex:2] objectForKey:@"UserServerKey"];
    // NSLog(@"User ServerKey is: %@\n", _userServerKey);  // for testing
    
    
    // [_signInInfoArray addObject:_userLogin];
    //[_signInInfoArray addObject:_userPassword];
    //[_signInInfoArray addObject:_userServerKey];
    //NSLog(@"%@", [_signInInfoArray description]);   // for testing  - output what the sign in data is
    
    
    // check with the server to make sure user info is valid
    */
    
    return FALSE;  // this needs to be changed, for now, always return false
}



/******************************************************************************************************
 *
 *                                   Getters & Setters
 *
 ******************************************************************************************************/

- (NSString*) getUserName
{
    return _userDisplayName;
}

- (NSString*) getUserTeamName
{
    return _userTeamName;
}

- (void) setUserProfileImage:(UIImage*)newImage
{
    _userProfileImage = newImage;
}

- (UIImage*) getUserImage
{
    return _userProfileImage;
}

- (void) setUserPassword: (NSString*)newPassword
{
    _userPassword = newPassword;
    
}

- (NSString*) getUserPassword
{
    return _userPassword;
}

/***
 *
 * This method is called from the LoginViewController if the response was '1000'
 *  from "responseForLoginParticipantRecived"
 */
- (void) storeEmail:(NSString*)email andPassword: (NSString*)password
{
    _userEmail = email;
    _userPassword = password;
    
    
}//end storeEmailAndPassword

/***
 *
 * This method is called from the CreateUserViewController if the response was '1000'
 *  from "responseForRegisterParticipantRecived"
 */
- (void) storeUserName: (NSString*)userName
{
    _userDisplayName = userName;
    
}

/***
 *  Current date information
 */

- (int) getCurrentMonth
{
    
    return _currentMonth;
}

- (int) getCurrentYear
{
    
    return _currentYear;
}
/****
 *
 *  Challenge information
 */
- (NSString*) getCurrentChallengeTopic
{
    return [_currentMonthTopicDict objectForKey:topicStringKey];

}// end get challenge topic

- (int) getTopicIDForCurrentMonth: (int) month
{
    return [[_currentMonthTopicDict objectForKey:topicIDKey]intValue];

}//end getTopicIDForMonth

- (NSString*) getCurrentMonthURL: (int) month
{
    return [_currentMonthTopicDict objectForKey:topicURLKey];
    
}//end getURL for Month










/*******
 *
 *   THIS IS FOR TESTING  - TO BE REPLACED WITH SERVER FUNTIONS
 *
 */

- (NSMutableDictionary*) getDictForMonth: (int)month
{

    NSMutableDictionary* newDict = [[NSMutableDictionary alloc]init];
    switch (month)
    {
        case (JAN):
        {
            [newDict setObject:@"1" forKey:monthNumberKey];
            [newDict setObject:@"10" forKey:topicIDKey];
            [newDict setObject:@"Green New Year" forKey:topicStringKey];
            [newDict setObject:@"JAN URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (FEB):
        {
            [newDict setObject:@"2" forKey:monthNumberKey];
            [newDict setObject:@"20" forKey:topicIDKey];
            [newDict setObject:@"Reusable Thinking" forKey:topicStringKey];
            [newDict setObject:@"Feb URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (MAR):
        {
            [newDict setObject:@"3" forKey:monthNumberKey];
            [newDict setObject:@"30" forKey:topicIDKey];
            [newDict setObject:@"Green Products" forKey:topicStringKey];
            [newDict setObject:@"Mar URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (APR):
        {
            [newDict setObject:@"4" forKey:monthNumberKey];
            [newDict setObject:@"40" forKey:topicIDKey];
            [newDict setObject:@"Earth Day - Enjoy the Trees" forKey:topicStringKey];
            [newDict setObject:@"Apr URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (MAY):
        {
            [newDict setObject:@"5" forKey:monthNumberKey];
            [newDict setObject:@"50" forKey:topicIDKey];
            [newDict setObject:@"Water" forKey:topicStringKey];
            [newDict setObject:@"May URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (JUN):
        {
            [newDict setObject:@"6" forKey:monthNumberKey];
            [newDict setObject:@"60" forKey:topicIDKey];
            [newDict setObject:@"Power Down for Summer" forKey:topicStringKey];
            [newDict setObject:@"Jun URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (JUL):
        {
            [newDict setObject:@"7" forKey:monthNumberKey];
            [newDict setObject:@"70" forKey:topicIDKey];
            [newDict setObject:@"Air Quality" forKey:topicStringKey];
            [newDict setObject:@"Jul URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (AUG):
        {
            [newDict setObject:@"8" forKey:monthNumberKey];
            [newDict setObject:@"80" forKey:topicIDKey];
            [newDict setObject:@"Green Communities and Businesses" forKey:topicStringKey];
            [newDict setObject:@"Aug URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (SEP):
        {
            [newDict setObject:@"9" forKey:monthNumberKey];
            [newDict setObject:@"80" forKey:topicIDKey];
            [newDict setObject:@"Idle Free & Transportation" forKey:topicStringKey];
            [newDict setObject:@"Sep URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (OCT):
        {
            [newDict setObject:@"10" forKey:monthNumberKey];
            [newDict setObject:@"100" forKey:topicIDKey];
            [newDict setObject:@"Food for Thought" forKey:topicStringKey];
            [newDict setObject:@"Oct URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (NOV):
        {
            [newDict setObject:@"11" forKey:monthNumberKey];
            [newDict setObject:@"110" forKey:topicIDKey];
            [newDict setObject:@"Recycling" forKey:topicStringKey];
            [newDict setObject:@"Nov URL GOES HERE" forKey:topicURLKey];
            break;
        }
        case (DEC):
        {
            [newDict setObject:@"12" forKey:monthNumberKey];
            [newDict setObject:@"120" forKey:topicIDKey];
            [newDict setObject:@"Winterize your Home" forKey:topicStringKey];
            [newDict setObject:@"Dec URL GOES HERE" forKey:topicURLKey];
            break;
        }
        default:
        {
            break;
        }
    }//end switch
    
    return newDict;
    
    
}//end getDictForMonth


@end
