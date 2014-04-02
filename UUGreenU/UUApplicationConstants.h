//
//  UUApplicationConstants.h
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//
/****
 *  This class is used for constants that are used throughout the app
 *  that do not involve calls to the server.  An example:  for easy
 *  access to app colors, background images, etc.
 *
 */


#import <Foundation/Foundation.h>

//for ease in accessing month images
#define JAN 1
#define FEB 2
#define MAR 3
#define APR 4
#define MAY 5
#define JUN 6
#define JUL 7
#define AUG 8
#define SEP 9
#define OCT 10
#define NOV 11
#define DEC 12


@interface UUApplicationConstants : NSObject
{
    UIColor* _tealColor;
    UIColor* _seaFoamColor;
    UIColor* _burntOrangeColor;
    UIColor* _mustardYellowColor;
    UIColor* _brightGreenColor;
    UIColor* _cherryRedColor;
    
    UIImage* _backgroundImage;
    
    UIImage* _janChallengeImage;
    UIImage* _febChallengeImage;
    UIImage* _marChallengeImage;
    UIImage* _aprChallengeImage;
    UIImage* _mayChallengeImage;
    UIImage* _junChallengeImage;
    UIImage* _julChallengeImage;
    UIImage* _augChallengeImage;
    UIImage* _sepChallengeImage;
    UIImage* _octChallengeImage;
    UIImage* _novChallengeImage;
    UIImage* _decChallengeImage;

}

- (id)initWithHeight:(float)height;
- (UIImage*) getBackgroundImage;

- (UIFont*) getStandardFontWithSize:(float)size;
- (UIFont*) getBoldFontWithSize:(float)size;
- (float) getMainTableCellHeight;


- (UIColor*) tealColor;
- (UIColor*) seaFoamColor;
- (UIColor*) burntOrangeColor;
- (UIColor*) mustardYellowColor;
- (UIColor*) brightGreenColor;
- (UIColor*) cherryRedColor;

- (UIImage*) getChallengeMonthImage:(int)month;


@end
