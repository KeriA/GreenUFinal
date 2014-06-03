//
//  UUSplashView.h
//  UUGreenU
//
//  Created by Keri Anderson on 4/2/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUSplashView : UIView
{
    UUApplicationConstants* _appConstants;
}

- (id)initWithAppConstants:(UUApplicationConstants*)appConstants;

@end
