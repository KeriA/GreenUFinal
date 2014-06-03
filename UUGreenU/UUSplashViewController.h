//
//  UUSplashViewController.h
//  UUGreenU
//
//  Created by Keri Anderson on 4/2/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUSplashView.h"
#import "UUMainViewController.h"
#import "UULoginViewController.h"

@interface UUSplashViewController : UIViewController<UUModelForSplashScreenDelegate>
{
    UUModel* _model;
    UUApplicationConstants* _appConstants;
    
    UUMainViewController* _mainViewController;
    UULoginViewController* _loginViewController;
    
    NSString* _userEmail;
    NSString* _userPassword;
    
}

- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants;

@end
