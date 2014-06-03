//
//  UUSplashView.m
//  UUGreenU
//
//  Created by Keri Anderson on 4/2/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUSplashView.h"

@implementation UUSplashView

/***
 *
 *      Constructor
 */
- (id)initWithAppConstants:(UUApplicationConstants*)appConstants
{
    self = [super init];
    if (self) {
        // Initialization code
        
        _appConstants = appConstants;
        [self setBackgroundColor:[UIColor colorWithPatternImage:[appConstants getSplashImage]]];
        
    }
    return self;
    
}//end Constructor

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
