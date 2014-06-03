//
//  UUChallengeTabViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 5/28/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUChallengeTabViewController.h"

@interface UUChallengeTabViewController ()

@end

@implementation UUChallengeTabViewController
{
    float _tableCellHeight;
    int _topicArrayLocation;
    NSString* _urlString;


}

/***
 *
 *      Constructor:  create a weak reference to the model
 */
- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants andTopicsArrayLocation:(int) topicArrayLocation
{
    self = [super init];
    if (self)
    {
        // Custom initialization
        
        //fill in the data model to use
        _model = model;
        _appConstants = appConstants;
        _topicArrayLocation = topicArrayLocation;
        _urlString = [_model getMonthURLString:topicArrayLocation];
        
        
        //set the height of the tableview cells - (we are supporting both the 3.5 inch and 4.0 inch screen
        _tableCellHeight = 100;

        
        // this removes the space for the header at the top of the table
        //self.edgesForExtendedLayout = UIRectEdgeNone;

        
        
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
    self.view = [[UUChallengeTabView alloc] initWithAppConstants:_appConstants];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    //self.title = @"GreenU";
    
    //set to individual to start
    //[(UUShowTopUsersView*)self.view setTopLabels: _individualTitleArray];
    //[(UUShowTopUsersView*)self.view setViewComponents:_individualArray andIndividualOrTeam:INDIVIDUAL];
    [(UUChallengeTabView*)self.view reloadTableData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set view delegates
    [(UUChallengeTabView*)[self view]setChallengeTabViewDelegate:self];
    [(UUChallengeTabView*)[self view]setTableViewDelegates:self];
    [(UUChallengeTabView*)self.view setURl:_urlString];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/**********************************************************************************************************
 *
 *                          UUChallengeTabView Delegate Methdods
 *
 **********************************************************************************************************/
- (void) informationButtonWasPressed
{
    NSLog(@"Information Button was pressed"); //for testing
    
    [(UUChallengeTabView*)self.view setInformationButtonToSelected];
    [(UUChallengeTabView*)self.view setChallengesButtonToNotSelected];
    [(UUChallengeTabView*)self.view showWebView];
    
} //end informationButtonWasPressed

- (void) challengesButtonWasPressed
{
    NSLog(@"Challenges Button was pressed"); //for testing
    
    [(UUChallengeTabView*)self.view setInformationButtonToNotSelected];
    [(UUChallengeTabView*)self.view setChallengesButtonToSelected];
    [(UUChallengeTabView*)self.view hideWebView];
    
}//end challengesButtonWasPressed




/******************************************************************************************************
 *
 *                             Table View Delegate Methods
 *
 ******************************************************************************************************/
#pragma mark - UITableViewDelegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This just makes it look pretty
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    [self setTitle:@""]; // removes the title from the back bar of the next pages
    
    // Depending upon user selection, create a new view controller.  Animate so it looks pretty.
    switch ([indexPath row])
    {
        case 0: // Challenge 1
            NSLog(@"Challenge 1 was pressed"); //for testing
            _specificChallengeViewController = [[UUSpecificChallengeViewController alloc]initWithModel:_model andAppConstants:_appConstants andTopicsArrayLocation:_topicArrayLocation andChallengeNumber:1];
            [[self navigationController] pushViewController:_specificChallengeViewController animated:TRUE];
            break;
        case 1: // Challenge 2
            NSLog(@"Challenge 2 was pressed"); //for testing
            _specificChallengeViewController = [[UUSpecificChallengeViewController alloc]initWithModel:_model andAppConstants:_appConstants andTopicsArrayLocation:_topicArrayLocation andChallengeNumber:2];
            [[self navigationController] pushViewController:_specificChallengeViewController animated:TRUE];
            break;
        case 2: // Challenge 3
            NSLog(@"Challenge 3 was pressed"); //for testing
            _specificChallengeViewController = [[UUSpecificChallengeViewController alloc]initWithModel:_model andAppConstants:_appConstants andTopicsArrayLocation:_topicArrayLocation andChallengeNumber:3];
            [[self navigationController] pushViewController:_specificChallengeViewController animated:TRUE];
            
            break;
        default:
            break;
    }// end switch
    
}// end didSelectRowAtIndexPath

- (CGFloat) tableView:(UITableView*)tableview heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableCellHeight;
}



- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 0.01;  //for some reason this does not work at 0.0
    else
        return 0.01;
    
}




/******************************************************************************************************
 *
 *                             Table View Data Source Methods
 *
 ******************************************************************************************************/

#pragma mark - UITableViewDataSource methods

/***
 *
 *  get the number of top level rows from our data model
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    
}// end numberOfRowsInSection


/***
 * This method is optional.  (How we create the number of sections needed)
 * Default is 1 if not implemented
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // first section lists the shapes to choose from, second, the shapes selected
    return 1;
    
}// end numberOfSectionsInTableView


/***
 *
 * Create the individual cells.  The cell background needs to incorporate the tops
 * and bottoms of table "sections". For this reason, the backgroundView and
 * selectedBackgroundView normally need to be set on a row-by-row basis.
 *
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
		// Create the cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell textLabel].backgroundColor = [UIColor clearColor];
 		
		// Create a background image view.
		cell.backgroundView = [[UIImageView alloc] init];
		cell.selectedBackgroundView = [[UIImageView alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        
        
	}//end cell == nil
    
    NSInteger row = [indexPath row];
    
    //use the appropriate background image
	UIImage *rowBackground;
	UIImage *selectionBackground;
    NSString* labelString;
    NSString* detailString;
    UIImage* image;
    
    
    if (row == 0) //Challenge 1
	{
        rowBackground = [_appConstants getMainMenuBackground:RED];
		selectionBackground = [_appConstants getMainMenuBackground:RED];
        labelString = [_model getChallengeTeaser:_topicArrayLocation andChallengeNumber:1];
        detailString = [_model getUserStatusForChallenge:_topicArrayLocation andChallengeNumber:1];
        image = [_appConstants getChallengeNumberImage:1];
	}
    else if (row == 1) //Challenge 2
    {
        rowBackground = [_appConstants getMainMenuBackground:YELLOW];
		selectionBackground = [_appConstants getMainMenuBackground:YELLOW];
        labelString = [_model getChallengeTeaser:_topicArrayLocation andChallengeNumber:2];
        detailString = [_model getUserStatusForChallenge:_topicArrayLocation andChallengeNumber:2];
        image = [_appConstants getChallengeNumberImage:2];
    }
    else if (row == 2) //Challenge 3
    {
        rowBackground = [_appConstants getMainMenuBackground:GREEN];
		selectionBackground = [_appConstants getMainMenuBackground:GREEN];
        labelString = [_model getChallengeTeaser:_topicArrayLocation andChallengeNumber:3];
        detailString = [_model getUserStatusForChallenge:_topicArrayLocation andChallengeNumber:3];
        image = [_appConstants getChallengeNumberImage:3];
    }
    
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    cell.textLabel.text = labelString;
    cell.detailTextLabel.text = detailString;
    cell.imageView.image = image;
    cell.textLabel.font = [_appConstants getBoldFontWithSize:14.0];
    cell.detailTextLabel.font = [_appConstants getItalicsFontWithSize:10.0];
    
	return cell;
    
} //end cell for row at index path







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
