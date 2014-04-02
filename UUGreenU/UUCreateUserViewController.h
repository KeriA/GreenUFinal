//
//  UUCreateUserViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/12/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUCreateUserView.h"

@interface UUCreateUserViewController : UIViewController<UUCreateUserViewDelegate, UURegisterParticipantDataReceivedDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
}

- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants;

@end
