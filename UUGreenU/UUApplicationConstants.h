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

//to keep the titles and layouts of the pages consistent
#define TOPMARGIN 70.0
#define TOPLABELHEIGHT 30.0
#define PAGEINSETAMOUNT .08
#define TOPLABELFONTSIZE 25.0

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

//for ease in accessing main menu images
#define RED    1
#define GREEN  2
#define YELLOW 3
#define ORANGE 4
#define BLUE   5

//for tab bar
#define LEFT 1
#define RIGHT 2

@interface UUApplicationConstants : NSObject
{
    UIColor* _tealColor;
    UIColor* _seaFoamColor;
    UIColor* _burntOrangeColor;
    UIColor* _mustardYellowColor;
    UIColor* _brightGreenColor;
    UIColor* _cherryRedColor;
    
    UIColor* _tealColorFaded;
    UIColor* _seaFoamColorFaded;
    UIColor* _burntOrangeColorFaded;
    UIColor* _mustardYellowColorFaded;
    UIColor* _brightGreenColorFaded;
    UIColor* _cherryRedColorFaded;

    
    UIImage* _backgroundImage;
    UIImage* _splashImage;
    UIImage* _greenULogoImage;
    
    //main menu images
    UIImage* _mainMenuRed;
    UIImage* _mainMenuGreen;
    UIImage* _mainMenuYellow;
    UIImage* _mainMenuOrange;
    UIImage* _mainMenuBlue;
    
    //month images
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
    
    //button images
    UIImage* _calendarIcon;
    UIImage* _checkBoxEmptyIcon;
    UIImage* _checkBoxFullIcon;
    UIImage* _facebookSmallIcon;
    UIImage* _twitterSmallIcon;

}

- (id)initWithHeight:(float)height;
- (UIImage*) getBackgroundImage;
- (UIImage*) getSplashImage;
- (UIImage*) getGreenULogoImage;

- (UIFont*) getStandardFontWithSize:(float)size;
- (UIFont*) getBoldFontWithSize:(float)size;
- (UIFont*) getItalicsFontWithSize:(float)size;
- (float) getMainTableCellHeight;


- (UIColor*) tealColor;
- (UIColor*) seaFoamColor;
- (UIColor*) burntOrangeColor;
- (UIColor*) mustardYellowColor;
- (UIColor*) brightGreenColor;
- (UIColor*) cherryRedColor;

- (UIColor*) tealColorFaded;
- (UIColor*) seaFoamColorFaded;
- (UIColor*) burntOrangeColorFaded;
- (UIColor*) mustardYellowColorFaded;
- (UIColor*) brightGreenColorFaded;
- (UIColor*) cherryRedColorFaded;


- (UIImage*) getMainMenuBackground:(int)color;

- (UIImage*) getChallengeMonthImage:(int)month;
- (NSString*) getMonthText: (int)monthNum;
- (NSString*) getMonthTextForCalendarView: (int)monthNum;

- (UIImage*) getTabBarImage: (int) leftOrRight;

//for the calendar buttons
- (UIImage*) getCalendarButtonStandardImage;
- (UIImage*) getCalendarButtonSelectedImage;
- (UIImage*) getCalendarButtonUserCompletedImage;
- (UIImage*) getCalendarButtonUnavailableImage;



- (UIImage*) getChallengeNumberImage: (int) challengeNumber;

- (UIImage*) getDownIconForButton;
- (UIImage*) getNonActiveTeamsImageRed;
- (UIImage*) getNonActiveTeamsImageYellow;
- (UIImage*) getNonActiveTeamsImageGreen;
- (UIImage*) getPickerDoneImage;
- (UIImage*) getPickerBarImage;


- (UIImage*) getCalendarIcon;
- (UIImage*) getCheckboxEmptyIcon;
- (UIImage*) getCheckboxFullIcon;
- (UIImage*) getFacebookIconSmall;
- (UIImage*) getTwitterIconSmall;

- (UIImage*) getTopIndividualNumberIcon;
- (UIImage*) getTopTeamNumberIcon;
- (UIImage*) getWhiteLineDividerImage;

- (UIImage*) getTabBarImageForChallengessNotSelected:(int)LeftOrRight;
- (UIImage*) getTabBarImageForChallengesSelected:(int)LeftOrRight;

- (UIImage*) getTabBarImageForTopUsersNotSelected:(int)LeftOrRight;
- (UIImage*) getTabBarImageForTopUsersSelected:(int)LeftOrRight;

- (UIImage*) getAboutImage:(int)imageNumber;


@end
