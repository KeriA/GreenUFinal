//
//  UUSpecificChallengeViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 5/15/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "UUSpecificChallengeView.h"


@interface UUSpecificChallengeViewController : UIViewController<UUSpecificChallengeViewDelegate, UUCalendarViewDelegate, UUModelForChallengePointsUpdatedDelegate>
{
    UUModel*                _model;
    UUApplicationConstants* _appConstants;
}

- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andTopicsArrayLocation:(int) topicArrayLocation andChallengeNumber:(int) challengeNumber;


@end
