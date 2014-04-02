//
//  UUApplicationConstants.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUApplicationConstants.h"


// background image
#define backgroundImage480String @"background320x480.png"
#define backgroundImage568String @"background320x568.png"


#define JanImageString @"01January-greennewyear.png"
#define FebImageString @"02February-reusablethinking.png"
#define MarImageString @"03March-greenproducts.png"
#define AprImageString @"04April-EnjoytheTrees.png"
#define MayImageString @"05May-water.png"
#define JunImageString @"06June-SummerPowerdown.png"
#define JulImageString @"07July-AirQuality.png"
#define AugImageString @"08August-GreenCommunities.png"
#define SepImageString @"09September-IdleFree.png"
#define OctImageString @"10October-FoodforThought.png"
#define NovImageString @"11Novemeber-RecycleThat.png"
#define DecImageString @"12December-WinterizeYourHome.png"

@implementation UUApplicationConstants
{
    float _mainTableCellHeight;
}

- (id)initWithHeight:(float)height
{
    self = [super init];
    if (self)
    {
        
        //instantiate the color palet - used by the graphics designers for the images
        // we use these colors for backgrounds, button colors, bars, etc
        _tealColor          = [UIColor colorWithRed:(  0.0/255.0) green:(132.0/255.0) blue:(134.0/255.0) alpha:1.0];
        _seaFoamColor       = [UIColor colorWithRed:(117.0/255.0) green:(214.0/255.0) blue:(153.0/255.0) alpha:1.0];
        _burntOrangeColor   = [UIColor colorWithRed:(255.0/255.0) green:(139.0/255.0) blue:( 40.0/255.0) alpha:1.0];
        _mustardYellowColor = [UIColor colorWithRed:(247.0/255.0) green:(206.0/255.0) blue:(  0.0/255.0) alpha:1.0];
        _brightGreenColor   = [UIColor colorWithRed:( 52.0/255.0) green:(202.0/255.0) blue:( 52.0/255.0) alpha:1.0];
        _cherryRedColor     = [UIColor colorWithRed:(231.0/255.0) green:( 51.0/255.0) blue:( 41.0/255.0) alpha:1.0];
        
        // instantiate the background image
        if (height > 481) //iphone 5  - some sizes depend on the screen size
        {
            _backgroundImage = [UIImage imageNamed:backgroundImage568String];
            _mainTableCellHeight = 65;
        }
        else //iphone 4
        {
            _backgroundImage = [UIImage imageNamed:backgroundImage480String];
            _mainTableCellHeight = 50;
        }
        
        //challenge images
        _janChallengeImage = [UIImage imageNamed:JanImageString];
        _febChallengeImage = [UIImage imageNamed:FebImageString];
        _marChallengeImage = [UIImage imageNamed:MarImageString];
        _aprChallengeImage = [UIImage imageNamed:AprImageString];
        _mayChallengeImage = [UIImage imageNamed:MayImageString];
        _junChallengeImage = [UIImage imageNamed:JunImageString];
        _julChallengeImage = [UIImage imageNamed:JulImageString];
        _augChallengeImage = [UIImage imageNamed:AugImageString];
        _sepChallengeImage = [UIImage imageNamed:SepImageString];
        _octChallengeImage = [UIImage imageNamed:OctImageString];
        _novChallengeImage = [UIImage imageNamed:NovImageString];
        _decChallengeImage = [UIImage imageNamed:DecImageString];
        
    }
    else //no object
    {
        return nil;
    }
    return self;
}// end contstructor




/*********************************************************************************************************
 *
 *                                       Getters
 *
 *********************************************************************************************************/

//Font getters

- (UIFont*) getStandardFontWithSize:(float)size
{
    UIFont* newFont = [UIFont systemFontOfSize: size];
    return newFont;
    
}// end getStandardFontWithSize

- (UIFont*) getBoldFontWithSize:(float)size
{
    
    UIFont* newFont = [UIFont boldSystemFontOfSize:size];
    return newFont;
    
}// end getBoldFontWithSize

- (float) getMainTableCellHeight
{
    return _mainTableCellHeight;
}

//***** background image getter *****//
- (UIImage*) getBackgroundImage  { return _backgroundImage; }

//*****  color getters  ****//
- (UIColor*) tealColor          { return _tealColor; }
- (UIColor*) seaFoamColor       { return _seaFoamColor; }
- (UIColor*) burntOrangeColor   { return _burntOrangeColor; }
- (UIColor*) mustardYellowColor { return _mustardYellowColor; }
- (UIColor*) brightGreenColor   { return _brightGreenColor; }
- (UIColor*) cherryRedColor     { return _cherryRedColor; }

//****** month image getter ********//
- (UIImage*) getChallengeMonthImage:(int)month
{
    UIImage* monthImage;
    
    switch (month)
    {
        case (JAN):
        {
            monthImage = _janChallengeImage;
            break;
        }
        case (FEB):
        {
            monthImage = _febChallengeImage;
            break;
        }
        case (MAR):
        {
            monthImage = _marChallengeImage;
            break;
        }
        case (APR):
        {
            monthImage = _aprChallengeImage;
            break;
        }
        case (MAY):
        {
            monthImage = _mayChallengeImage;
            break;
        }
        case (JUN):
        {
            monthImage = _junChallengeImage;
            break;
        }
        case (JUL):
        {
            monthImage = _julChallengeImage;
            break;
        }
        case (AUG):
        {
            monthImage = _augChallengeImage;
            break;
        }
        case (SEP):
        {
            monthImage = _sepChallengeImage;
            break;
        }
        case (OCT):
        {
            monthImage = _octChallengeImage;
            break;
        }
        case (NOV):
        {
            monthImage = _novChallengeImage;
            break;
        }
        case (DEC):
        {
            monthImage = _decChallengeImage;
            break;
        }
        default:
        {}
    }//end switch
    
    return monthImage;

}//end getMonthImage



@end
