//
//  UUShowTopUsersViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 5/26/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUShowTopUsersViewController.h"

@interface UUShowTopUsersViewController ()

@end

@implementation UUShowTopUsersViewController
{
    NSMutableArray* _individualArray;
    NSMutableArray* _teamArray;
    NSMutableArray* _individualTitleArray;
    NSMutableArray* _teamTitleArray;
    int _individualRank;
    int _teamRank;
}

/***
 *
 *      Constructor:  create a weak reference to the model
 */
- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andType: (int)type
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        
        //fill in the data model to use
        _model = model;
        _appConstants = appConstants;
        
        _individualRank = [_model getUserRank:type];
        _teamRank = [_model getUserTeamRank:type];
        
        //initialize the arrays
        _individualArray      = [[NSMutableArray alloc]init];
        _teamArray            = [[NSMutableArray alloc]init];
        _individualTitleArray = [[NSMutableArray alloc]init];
        _teamTitleArray       = [[NSMutableArray alloc]init];
        
        [self fillArrays:type];
        
    }
    
    return self;
    
}// end contstructor


/******************************************************************************************************
 *
 *                              View Handlers
 *
 ******************************************************************************************************/

-(void) loadView
{
    self.view = [[UUShowTopUsersView alloc] initWithAppConstants:_appConstants];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    //self.title = @"GreenU";
    
    //set to individual to start
    [(UUShowTopUsersView*)self.view setTopLabels: _individualTitleArray];
    [(UUShowTopUsersView*)self.view setViewComponents:_individualArray andIndividualOrTeam:INDIVIDUAL];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set view delegates
    [(UUShowTopUsersView*)[self view]setShowTopUsersViewDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**********************************************************************************************************
 *
 *                          UUSpecificChallengeView Delegate Methdods
 *
 **********************************************************************************************************/
- (void) individualButtonWasPressed
{
    NSLog(@"Individual Button was pressed"); //for testing
    
    [(UUShowTopUsersView*)self.view setIndividualButtonBackgroundToSelected];
    [(UUShowTopUsersView*)self.view setTeamButtonBackgroundToNotSelected];
    
    [(UUShowTopUsersView*)self.view setTopLabels: _individualTitleArray];
    [(UUShowTopUsersView*)self.view setViewComponents:_individualArray andIndividualOrTeam:INDIVIDUAL];
    

    
} //end individualButtonWasPressed

- (void) teamsButtonWasPressed
{
    NSLog(@"Team Button was pressed"); //for testing
    
    [(UUShowTopUsersView*)self.view setIndividualButtonBackgroundToNotSelected];
    [(UUShowTopUsersView*)self.view setTeamButtonBackgroundToSelected];

    
    [(UUShowTopUsersView*)self.view setTopLabels: _teamTitleArray];
    [(UUShowTopUsersView*)self.view setViewComponents:_teamArray andIndividualOrTeam:TEAMS];
    

}


/**********************************************************************************************************
 *
 *                          UUSpecificChallengeView Delegate Methdods
 *
 **********************************************************************************************************/

- (void) fillArrays:(int)monthlyORAllTime
{
   // _individualArray = [[NSMutableArray alloc]init];
   // _teamArray = [[NSMutableArray alloc]init];
   // _individualTitleArray = [[NSArray alloc]init];
   // _teamTitleArray = [[NSArray alloc]init];

    NSString* individualTitleString = @"|  Individual";
    NSString* teamTitleString = @"|  Team";
    NSString* indRankString = [NSString stringWithFormat:@"%d", _individualRank];
    NSString* teamRankString = [NSString stringWithFormat:@"%d", _teamRank];
    
    //titles
    [_individualTitleArray addObject:individualTitleString];
    [_individualTitleArray addObject:indRankString];
    
    [_teamTitleArray addObject:teamTitleString];
    [_teamTitleArray addObject:teamRankString];
    
    //body  individual
    int individualCount = [_model getTopIndividualsCount:monthlyORAllTime];
    
    for (int i = 0; i < individualCount; i++)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        NSString* nameString = [_model getTopNames:INDIVIDUAL monthORAllTime:monthlyORAllTime arrayPosition:i];
        NSString* nameStringFinal = [NSString stringWithFormat:@"  %@", nameString];
        NSString* pointsString = [_model getTopPoints:INDIVIDUAL monthORAllTime:monthlyORAllTime arrayPosition:i];
        NSString* pointsStringFinal = [NSString stringWithFormat:@"|  %@ points", pointsString];
        
        [dict setObject:nameStringFinal forKey:nameKey];
        [dict setObject:pointsStringFinal forKey:pointsKey];
        [_individualArray addObject:dict];
        
    }
    
    //body team
    int teamCount = [_model getTopTeamsCount:monthlyORAllTime];
    for (int i = 0; i < teamCount; i++)
    {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
        NSString* nameString = [_model getTopNames:TEAMS monthORAllTime:monthlyORAllTime arrayPosition:i];
        NSString* nameStringFinal = [NSString stringWithFormat:@"  %@", nameString];
        NSString* pointsString = [_model getTopPoints:TEAMS monthORAllTime:monthlyORAllTime arrayPosition:i];
        NSString* pointsStringFinal = [NSString stringWithFormat:@"|  %@ points", pointsString];
        
        [dict setObject:nameStringFinal forKey:nameKey];
        [dict setObject:pointsStringFinal forKey:pointsKey];
        [_teamArray addObject:dict];

    }
    
    
}//end fillArrays


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
