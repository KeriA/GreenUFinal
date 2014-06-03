//
//  UUNetworkConstants.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

/***
 *
 *  This header file is used to give easy access to network constants, as they
 *  are prone to change.
 *
 */


#ifndef UUGreenU_UUNetworkConstants_h
#define UUGreenU_UUNetworkConstants_h

// SLC's base URL
#define UUNetworkBaseUrl @"https://dotnet.slcgov.com/mayor/sustainabilitypledge/api/challenges" // this is for asynchronous calls

//  define the server method params here for ease and consistency of use
//  and ease in making server requests
#define POST 0
#define GET  1

#define registerParticipant 0
#define participantLogin 1
#define updateUserProfile 2
#define getUserProfile 3
#define forgotPassword 4
#define getAllTeams 5
#define getTeamsByCategory 6
#define requestNewTeam 7
#define getCurrentMonthTopic 8
#define getPastMonthTopics 9
#define getChallengesForTopic 10
#define getUserPointsForChallenge 11
#define setUserPointsForChallenge 12
#define getTeamPointAndRank 13
#define getParticipantPointAndRank 14
#define getTopTenTeams 15
#define getTopTenIndividuals 16



// Request Types  (used in combination with the base url)
#define registerParticipantRequest @"/registerparticipant"
#define participantLoginRequest @"/participantlogin"
#define updateUserProfileRequest @"/updateprofile"
#define getUserProfileRequest @"/getprofile"
#define forgotPasswordRequest @"/forgotpassword"
#define getAllTeamsRequest @"/getallteams"
#define getTeamsByCategoryRequest  @"/getteamsbycategory"
#define requestNewTeamRequest @"/requestnewteam"
#define getCurrentMonthTopicRequest @"/getcurrentmonthtopic"
#define getPastMonthTopicsRequest @"/getpastmonthtopics"
#define getChallengesForTopicRequest @"/getchallengesfortopic"
#define getUserPointForChallengeRequest @"/getuserpointforchallenge"
#define setUserPointForChallengeRequest @"/setuserpointforchallenge"
#define getTeamPointAndRankRequest @"/getteampointandrank"
#define getParticipantPointAndRankRequest @"/getparticipantpointandrank"
#define getTopTenTeamsRequest @"/gettoptenteams"
#define getTopTenIndividualsRequest @"/gettoptenindividuals"



#endif
