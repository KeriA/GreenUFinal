//
//  UUMainView.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import <UIKit/UIKit.h>

// we will have the view controller handle all the events of this view
@protocol UUMainViewDelegate
@required
-(void) changeUserButtonWasPressed;

@end // end protocol


@interface UUMainView : UIView
{
    UUApplicationConstants* _appConstants;
    UUModel* _model;
    
    
    id<UUMainViewDelegate>mainViewDelegate;
    
}

// delegate should be a weak reference
@property (readwrite, nonatomic) id mainViewDelegate;


- (id)initWithAppConstants:(UUApplicationConstants*)appConstants andModel:(UUModel*)model;
-(void) setTableViewDelegates:(id)viewController;


@end
