//
//  UUTopUsersViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUTopUsersView.h"
#import "UUShowTopUsersViewController.h"

@interface UUTopUsersViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
}

- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants;



@end
