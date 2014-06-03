//
//  UUShowTopUsersViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 5/26/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "UUShowTopUsersView.h"

@interface UUShowTopUsersViewController : UIViewController<UUShowTopUsersViewDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
    id<UUShowTopUsersViewDelegate>showTopUsersViewDelegate;
}

- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andType: (int)type;

@end
