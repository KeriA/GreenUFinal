//
//  UUMainViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUMainViewController.h"



@interface UUMainViewController ()
{
    int _numberOfCells;
}

@end

@implementation UUMainViewController
{
    float _tableCellHeight;
}
/***
 *
 *      Constructor:  create a weak reference to the model
 */
- (id)initWithModel:(UUModel*)model andAppConstants:(UUApplicationConstants *)appConstants
{
    self = [super init];
    if (self)
    {
        
        // Custom initialization
        
        //fill in the data model to use
        _model = model;
        _appConstants = appConstants;
        
        //set the height of the tableview cells - (we are supporting both the 3.5 inch and 4.0 inch screen
        _tableCellHeight = [_appConstants getMainTableCellHeight];
        
        // this removes the space for the header at the top of the table
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        
        
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
    self.view = [[UUMainView alloc] initWithAppConstants:_appConstants andModel:_model];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"";
}

/******************************************************************************************************
 *
 *                              Auto Generated View Handlers
 *
 ******************************************************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set view delegates
    [(UUMainView*)[self view]setTableViewDelegates:self];
    [(UUMainView*)[self view]setMainViewDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/******************************************************************************************************
 *
 *                              Main View Delegate Methods
 *
 ******************************************************************************************************/
- (void) changeUserButtonWasPressed
{
    NSLog(@"change user button was pressed"); //for testing
    _loginViewController = [[UULoginViewController alloc]initWithModel:_model andAppConstants:_appConstants];
    [[self navigationController] pushViewController:_loginViewController animated:TRUE];
    
    //should it be this instead?
    // launch the login view
    //This method will replace the whole view controller stack inside the navigation controller.
    //The "old" controllers get released. The stack array begins with the root controller and its
    //last element is the topmost view controller.
    // _loginViewController = [[UULoginViewController alloc]initWithModel:_model andAppConstants:_appConstants];
    // [self.navigationController setViewControllers: [NSArray arrayWithObject: _loginViewController] animated: YES];
}

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
 
        case 0: // Challenges
            _challengeViewController = [[UUChallengeViewController alloc]initWithModel:_model andAppConstants:_appConstants andTopicsArrayLocation:CURRENTMONTHLOCATION];
            [[self navigationController] pushViewController:_challengeViewController animated:TRUE];
            break;
        case 1: // Top Users
            _topUsersViewController = [[UUTopUsersViewController alloc]initWithModel:_model andAppConstants:_appConstants];
            [[self navigationController] pushViewController:_topUsersViewController animated:TRUE];
            break;
        case 2: // Teams
            _teamsViewController = [[UUTeamsViewController alloc] initWithModel:_model andAppConstants:_appConstants];
            [[self navigationController] pushViewController:_teamsViewController animated:TRUE];
            break;
        case 3: // Profile  FB/Twitter
            _profileViewController = [[UUProfileViewController alloc] initWithModel:_model andAppConstants:_appConstants];
            [[self navigationController] pushViewController:_profileViewController animated:TRUE];
            break;
        case 4: // About
            _aboutViewController = [[UUAboutViewController alloc] initWithModel:_model andAppConstants:_appConstants];
            [[self navigationController] pushViewController:_aboutViewController animated:TRUE];
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
    return 5;
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [cell textLabel].backgroundColor = [UIColor clearColor];
        [cell textLabel].font = [_appConstants getBoldFontWithSize:22.0];
 		
		// Create a background image view.
		cell.backgroundView = [[UIImageView alloc] init];
		cell.selectedBackgroundView = [[UIImageView alloc] init];
        cell.backgroundColor = [UIColor clearColor];
           
	}//end cell == nil
    
    NSInteger row = [indexPath row];
    
    //use the appropriate background image
	UIImage *rowBackground;
	UIImage *selectionBackground;
    NSString* cellText;
    

    if (row == 0) //Challenges
	{
        rowBackground = [_appConstants getMainMenuBackground:RED];
        selectionBackground = [_appConstants getMainMenuBackground:RED];
        cellText = @"  Challenges";  //spaces move the text over a bit
        //rowBackground = [UIImage imageNamed:@"challengewtext.png"];
		//selectionBackground = [UIImage imageNamed:@"challengewtext.png"];
	}
    else if (row == 1) // Top Users
    {
        //rowBackground = [UIImage imageNamed:@"topuserswtext.png"];
		//selectionBackground = [UIImage imageNamed:@"topuserswtext.png"];
        rowBackground = [_appConstants getMainMenuBackground:GREEN];
        selectionBackground = [_appConstants getMainMenuBackground:GREEN];
        cellText = @"  Top Users";  //spaces move the text over a bit
    }
    else if (row == 2) //Teams
    {
        //rowBackground = [UIImage imageNamed:@"teamswtext.png"];
		//selectionBackground = [UIImage imageNamed:@"teamswtext.png"];
        rowBackground = [_appConstants getMainMenuBackground:YELLOW];
        selectionBackground = [_appConstants getMainMenuBackground:YELLOW];
        cellText = @"  Teams";  //spaces move the text over a bit
    }
    else if (row == 3) //Profile
    {
        rowBackground = [UIImage imageNamed:@"profilewtext.png"];
		selectionBackground = [UIImage imageNamed:@"profilewtext.png"];
        rowBackground = [_appConstants getMainMenuBackground:ORANGE];
        selectionBackground = [_appConstants getMainMenuBackground:ORANGE];

        cellText = @"  Profile";  //spaces move the text over a bit
    }
    else{ // About GreenU
        rowBackground = [UIImage imageNamed:@"aboutwtext.png"];
        selectionBackground = [UIImage imageNamed:@"aboutwtext.png"];
        rowBackground = [_appConstants getMainMenuBackground:BLUE];
        selectionBackground = [_appConstants getMainMenuBackground:BLUE];
        cellText = @"  About GreenU";  //spaces move the text over a bit
    }
    
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    [cell textLabel].text = cellText;
    
   
	return cell;
   
} //end cell for row at index path


@end
