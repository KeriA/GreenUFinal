//
//  UUNavigationController.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUNavigationController : UINavigationController
{
    UUApplicationConstants* _appConstants;
    
}


- (id)initWithAppConstants:(UUApplicationConstants*)appConstants andRootViewController:(UIViewController*)rootController;

@end
