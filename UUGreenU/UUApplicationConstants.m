//
//  UUApplicationConstants.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUApplicationConstants.h"


// App images
#define backgroundImage480String @"background320x480.png"
#define backgroundImage568String @"background320x568.png"
#define aboutImage480String @"about320x480.png"
#define aboutImage568String @"about320x568.png"
#define splashImage480String @"greenUSplash320x480.png"
#define splashImage568String @"greenUSplash320x568.png"
#define greenULogoImageString @"logo_greenu_final.png"



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
        _tealColor          = [UIColor colorWithRed:(  0.0/255.0) green:(127.0/255.0) blue:(132.0/255.0) alpha:1.0];
        _seaFoamColor       = [UIColor colorWithRed:(126.0/255.0) green:(199.0/255.0) blue:(148.0/255.0) alpha:1.0];
        _burntOrangeColor   = [UIColor colorWithRed:(247.0/255.0) green:(145.0/255.0) blue:( 63.0/255.0) alpha:1.0];
        _mustardYellowColor = [UIColor colorWithRed:(255.0/255.0) green:(200.0/255.0) blue:( 67.0/255.0) alpha:1.0];
        _brightGreenColor   = [UIColor colorWithRed:( 60.0/255.0) green:(181.0/255.0) blue:( 74.0/255.0) alpha:1.0];
        _cherryRedColor     = [UIColor colorWithRed:(189.0/255.0) green:( 38.0/255.0) blue:( 52.0/255.0) alpha:1.0];
        
        _tealColorFaded          = [UIColor colorWithRed:(  0.0/255.0) green:(127.0/255.0) blue:(132.0/255.0) alpha:.6];
        _seaFoamColorFaded       = [UIColor colorWithRed:(126.0/255.0) green:(199.0/255.0) blue:(148.0/255.0) alpha:.6];
        _burntOrangeColorFaded   = [UIColor colorWithRed:(247.0/255.0) green:(145.0/255.0) blue:( 63.0/255.0) alpha:.6];
        _mustardYellowColorFaded = [UIColor colorWithRed:(255.0/255.0) green:(200.0/255.0) blue:( 67.0/255.0) alpha:.6];
        _brightGreenColorFaded   = [UIColor colorWithRed:( 60.0/255.0) green:(181.0/255.0) blue:( 74.0/255.0) alpha:.6];
        _cherryRedColorFaded     = [UIColor colorWithRed:(189.0/255.0) green:( 38.0/255.0) blue:( 52.0/255.0) alpha:.6];

  
        
        _greenULogoImage = [UIImage imageNamed:greenULogoImageString];
        
        // instantiate the background image
        if (height > 481) //iphone 5  - some sizes depend on the screen size  iphone 5 dimensions:  320 x 568
        {
            _backgroundImage = [UIImage imageNamed:backgroundImage568String];
            _splashImage     = [UIImage imageNamed:splashImage568String];
            //_mainTableCellHeight = 65;
            _mainTableCellHeight = 68;
        }
        else //iphone 4r  320 x 480
        {
            _backgroundImage = [UIImage imageNamed:backgroundImage480String];
            _splashImage     = [UIImage imageNamed:splashImage480String];
            _mainTableCellHeight = 50;
        }
        
        _mainMenuRed =    [UIImage imageNamed:@"mainmenu_red.png"];
        _mainMenuGreen =  [UIImage imageNamed:@"mainmenu_green.png"];
        _mainMenuYellow = [UIImage imageNamed:@"mainmenu_yellow.png"];
        _mainMenuOrange = [UIImage imageNamed:@"mainmenu_orange.png"];
        _mainMenuBlue =   [UIImage imageNamed:@"mainmenu_blue.png"];
        
        //month challenge images
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
        
        //icons
        _calendarIcon      = [UIImage imageNamed:@"calendarIcon.png"];
        _checkBoxEmptyIcon = [UIImage imageNamed:@"checkbox_empty.ico"];
        _checkBoxFullIcon  = [UIImage imageNamed:@"checkbox_full.ico"];
        _facebookSmallIcon = [UIImage imageNamed:@"FacebookIconSmall.png"];
        _twitterSmallIcon  = [UIImage imageNamed:@"TwitterIconSmall.png"];
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

- (UIFont*) getItalicsFontWithSize:(float)size
{
    UIFont* newFont = [UIFont italicSystemFontOfSize:size];
    return newFont;
}

- (float) getMainTableCellHeight
{
    return _mainTableCellHeight;
}

//***** image getters *****//
- (UIImage*) getBackgroundImage  { return _backgroundImage; }
- (UIImage*) getSplashImage {return _splashImage; }
- (UIImage*) getGreenULogoImage {return _greenULogoImage; }


//***** icon getters *****//
- (UIImage*) getCalendarIcon       { return _calendarIcon; }
- (UIImage*) getCheckboxEmptyIcon  { return _checkBoxEmptyIcon; }
- (UIImage*) getCheckboxFullIcon   { return _checkBoxFullIcon; }
- (UIImage*) getFacebookIconSmall  { return _facebookSmallIcon; }
- (UIImage*) getTwitterIconSmall   { return _twitterSmallIcon; }

//*****  color getters  ****//
- (UIColor*) tealColor          { return _tealColor; }
- (UIColor*) seaFoamColor       { return _seaFoamColor; }
- (UIColor*) burntOrangeColor   { return _burntOrangeColor; }
- (UIColor*) mustardYellowColor { return _mustardYellowColor; }
- (UIColor*) brightGreenColor   { return _brightGreenColor; }
- (UIColor*) cherryRedColor     { return _cherryRedColor; }

- (UIColor*) tealColorFaded          { return _tealColorFaded; }
- (UIColor*) seaFoamColorFaded       { return _seaFoamColorFaded; }
- (UIColor*) burntOrangeColorFaded   { return _burntOrangeColorFaded; }
- (UIColor*) mustardYellowColorFaded { return _mustardYellowColorFaded; }
- (UIColor*) brightGreenColorFaded   { return _brightGreenColorFaded; }
- (UIColor*) cherryRedColorFaded     { return _cherryRedColorFaded; }


//****** main menu background getter *****//
- (UIImage*) getMainMenuBackground:(int)color
{
    UIImage* backgroundImage;
    
    switch (color)
    {
        case (RED):
        {
            backgroundImage = _mainMenuRed;
            break;
        }
        case (GREEN):
        {
            backgroundImage = _mainMenuGreen;
            break;
        }
        case (YELLOW):
        {
            backgroundImage = _mainMenuYellow;
            break;
        }
        case (ORANGE):
        {
            backgroundImage = _mainMenuOrange;
            break;
        }
        case (BLUE):
        {
            backgroundImage = _mainMenuBlue;
            break;
        }
            default:  //should never get here
        {
            backgroundImage = _mainMenuRed;
        }
            
    }//end switch
    
    return backgroundImage;
    
}//end getMainMenuBackgroundImage


//for images numbers on three challenges page
- (UIImage*) getChallengeNumberImage: (int) challengeNumber
{
    UIImage* challengeImage;
    
    if (challengeNumber == 1)
        challengeImage = [UIImage imageNamed:@"ChallengeNum1Image.png"];
    else if (challengeNumber == 2)
        challengeImage = [UIImage imageNamed:@"ChallengeNum2Image.png"];
    else
        challengeImage = [UIImage imageNamed:@"ChallengeNum3Image.png"];
    
    return challengeImage;
    
}//end getChallengeNumberImage

//for the tab bar in challenges
- (UIImage*) getTabBarImage: (int) leftOrRight
{
    UIImage* tabBarImage;
    
    if (leftOrRight == LEFT){
        //tabBarImage = [UIImage imageNamed:@"AboutImage.png"];
        tabBarImage = [UIImage imageNamed:@"ChallengesImage.png"];
    }else{//RIGHT
        tabBarImage = [UIImage imageNamed:@"ChallengesImage.png"];
    }
    
    return tabBarImage;
    
}//end getTabBarIamge

//for the calendar buttons
- (UIImage*) getCalendarButtonStandardImage
{
    UIImage* image = [UIImage imageNamed:@"standardCalendarButton.png"];
    return image;
}

- (UIImage*) getCalendarButtonSelectedImage
{
    UIImage* image = [UIImage imageNamed:@"selectedCalendarButton.png"];
    return image;
}

- (UIImage*) getCalendarButtonUserCompletedImage
{
    UIImage* image = [UIImage imageNamed:@"userCompletedButton.png"];
    return image;
}

- (UIImage*) getCalendarButtonUnavailableImage
{
    UIImage* image = [UIImage imageNamed:@"disabledCalendarButton.png"];
    return image;
}

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


- (NSString*) getMonthText: (int)monthNum
{
    NSString* monthText;
    
    switch (monthNum)
    {
        case (1):
        {
            monthText = @"January:";
            break;
        }
        case (2):
        {
            monthText = @"February:";
            break;
        }
        case (3):
        {
            monthText = @"March:";
            break;
        }
        case (4):
        {
            monthText = @"April:";
            break;
        }
        case (5):
        {
            monthText = @"May:";
            break;
        }
        case (6):
        {
            monthText = @"June:";
            break;
        }
        case (7):
        {
            monthText = @"July:";
            break;
        }
        case (8):
        {
            monthText = @"August:";
            break;
        }
        case (9):
        {
            monthText = @"September:";
            break;
        }
        case (10):
        {
            monthText = @"October:";
            break;
        }
        case (11):
        {
            monthText = @"November:";
            break;
        }
        case (12):
        {
            monthText = @"December:";
            break;
        }
        default:
        {
            monthText = @"January:";
        }
            
    }
    
    return monthText;
}//end get MonthText


- (NSString*) getMonthTextForCalendarView: (int)monthNum
{
    NSString* monthText;
    
    switch (monthNum)
    {
        case (1):
        {
            monthText = @"January";
            break;
        }
        case (2):
        {
            monthText = @"February";
            break;
        }
        case (3):
        {
            monthText = @"March";
            break;
        }
        case (4):
        {
            monthText = @"April";
            break;
        }
        case (5):
        {
            monthText = @"May";
            break;
        }
        case (6):
        {
            monthText = @"June";
            break;
        }
        case (7):
        {
            monthText = @"July";
            break;
        }
        case (8):
        {
            monthText = @"August";
            break;
        }
        case (9):
        {
            monthText = @"September";
            break;
        }
        case (10):
        {
            monthText = @"October";
            break;
        }
        case (11):
        {
            monthText = @"November";
            break;
        }
        case (12):
        {
            monthText = @"December";
            break;
        }
        default:
        {
            monthText = @"January";
        }
            
    }
    
    return monthText;
}//end get MonthText


//For top Teams
- (UIImage*) getTabBarImageForChallengessNotSelected:(int)LeftOrRight
{
    UIImage* tabBarImage;
    
    if (LeftOrRight == LEFT){
        tabBarImage = [UIImage imageNamed:@"button-challenge-information_NOTSELECTED.png"];
    }else{
        tabBarImage = [UIImage imageNamed:@"button-challenge-challenges_NOTSELECTED.png"];
    }
    
    return tabBarImage;
}//


- (UIImage*) getTabBarImageForChallengesSelected:(int)LeftOrRight
{
    UIImage* tabBarImage;
    
    if (LeftOrRight == LEFT){
        tabBarImage = [UIImage imageNamed:@"button-challenge-information_SELECTED.png"];
    }else{
        tabBarImage = [UIImage imageNamed:@"button-challenge-challenges_SELECTED.png"];
    }
    
    return tabBarImage;
}//


//For top Teams
- (UIImage*) getTabBarImageForTopUsersNotSelected:(int)LeftOrRight
{
    UIImage* tabBarImage;
    
    if (LeftOrRight == LEFT){
        tabBarImage = [UIImage imageNamed:@"button-topusers-individual_NOTSELECTED.png"];
    }else{
        //tabBarImage = [UIImage imageNamed:@"button-team_NOTselected.png"];
        tabBarImage = [UIImage imageNamed:@"button-topusers-team_NOTSELECTED.png"];
    }
    
    return tabBarImage;
}//


- (UIImage*) getTabBarImageForTopUsersSelected:(int)LeftOrRight
{
    UIImage* tabBarImage;
    
    if (LeftOrRight == LEFT){
        tabBarImage = [UIImage imageNamed:@"button-topusers-individual_SELECTED.png"];
    }else{
        //tabBarImage = [UIImage imageNamed:@"button-team_NOTselected.png"];
        tabBarImage = [UIImage imageNamed:@"button-topusers-team_SELECTED.png"];
    }
    
    return tabBarImage;
}//

- (UIImage*) getTopIndividualNumberIcon
{
    UIImage* image = [UIImage imageNamed:@"topusers-green.png"];
    return image;
}

- (UIImage*) getTopTeamNumberIcon
{
    UIImage* image = [UIImage imageNamed:@"topusers-yellow.png"];
    return image;
}

- (UIImage*) getWhiteLineDividerImage
{
    UIImage* image = [UIImage imageNamed:@"whiteline620pxwide.png"];
    return image;

}

//for Teams


- (UIImage*) getDownIconForButton
{
    UIImage* image = [UIImage imageNamed:@"inverted_triangle.png"];
    return image;
}

- (UIImage*) getNonActiveTeamsImageRed
{
    UIImage* image = [UIImage imageNamed:@"teams-notactivered.png"];
    return image;
}

- (UIImage*) getNonActiveTeamsImageYellow
{
    UIImage* image = [UIImage imageNamed:@"teams-notactiveyellow.png"];
    return image;
}

- (UIImage*) getNonActiveTeamsImageGreen
{
    UIImage* image = [UIImage imageNamed:@"teams-notactivegreen.png"];
    return image;
}

- (UIImage*) getPickerDoneImage
{
    UIImage* image = [UIImage imageNamed:@"donebutton.png"];
    return image;

}

- (UIImage*) getPickerBarImage
{
    UIImage* image = [UIImage imageNamed:@"calendargradient.png"];
    return image;

}

//For the "About" page
- (UIImage*) getAboutImage:(int)imageNumber
{
    UIImage* image;
    
    switch (imageNumber)
    {
        case 1: //UU Sustainability
        {
            //image = [UIImage imageNamed:@"logo_SRC_white.png"];
            image = [UIImage imageNamed:@"logo_SRCwhitetextredU.png"];
            break;
        }
        case 2: //SLC
        {
            //image = [UIImage imageNamed:@"logo_SLCseal-white.png"];
            image = [UIImage imageNamed:@"SimpleSeal_whitew-transp.png"];
            break;
        }
        case 3: //Verizon
        {
            image = [UIImage imageNamed:@"logo_verizon-white.png"];
            break;
        }
            
        default:  //should never reach here
        {
            break;
        }
    }//end switch
    
    return image;
}

@end
