//
//  UUChallengeViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUChallengeView.h"
#import "UUChallengeTabViewController.h"


@interface UUChallengeViewController : UIViewController<UUChallengeViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
    UUChallengeTabViewController* _challengeTabViewController;
}

- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andTopicsArrayLocation: (int) topicsArrayLocation;


@end
