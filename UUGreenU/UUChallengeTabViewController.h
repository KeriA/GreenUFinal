//
//  UUChallengeTabViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 5/28/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "UUChallengeTabView.h"
#include "UUSpecificChallengeViewController.h"

@interface UUChallengeTabViewController : UIViewController<UUChallengeTabViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
    UUSpecificChallengeViewController* _specificChallengeViewController;
}



- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andTopicsArrayLocation:(int) topicArrayLocation;

@end
