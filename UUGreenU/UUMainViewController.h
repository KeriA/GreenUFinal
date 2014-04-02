//
//  UUMainViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMainView.h"
#import "UULoginViewController.h"
#import "UUChallengeViewController.h"
#import "UUTopUsersViewController.h"
#import "UUTeamsViewController.h"
#import "UUAboutViewController.h"
#import "UUProfileViewController.h"


@interface UUMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UUMainViewDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
    
    UULoginViewController*     _loginViewController;
    UUChallengeViewController* _challengeViewController;
    UUTopUsersViewController*  _topUsersViewController;
    UUTeamsViewController*     _teamsViewController;
    UUProfileViewController*   _profileViewController;
    UUAboutViewController*     _aboutViewController;
    
    
}

- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants;

@end
