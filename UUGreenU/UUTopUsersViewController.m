//
//  UUTopUsersViewController.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUTopUsersViewController.h"

@interface UUTopUsersViewController ()

@end

@implementation UUTopUsersViewController
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
    self.view = [[UUTopUsersView alloc] initWithAppConstants:_appConstants];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    //UIViewController has a title property that will be displayed by the
    //NavigationController. So when pushing a new UIViewController onto the
    //navigation stack set the title of that UIViewController
    self.title = @"GreenU";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // set view delegates
    [(UUTopUsersView*)[self view]setTableViewDelegates:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        case 0: // Monthly
        {
            //NSLog(@"Monthly was pressed"); //for testing
            UUShowTopUsersViewController* _showTopUsersViewController = [[UUShowTopUsersViewController alloc]initWithModel:_model andAppConstants:_appConstants andType:MONTHLY];
            [[self navigationController] pushViewController: _showTopUsersViewController animated:TRUE];
            
           
            break;
        }
        case 1: // All-Time
        {
            //NSLog(@"All-Time was pressed"); //for testing
            UUShowTopUsersViewController* _showTopUsersViewController = [[UUShowTopUsersViewController alloc]initWithModel:_model andAppConstants:_appConstants andType:ALLTIME];
            [[self navigationController] pushViewController: _showTopUsersViewController animated:TRUE];
            
            break;
        }
        default:
            break;
    }// end switch
    
}// end didSelectRowAtIndexPath



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
    return 2;
    
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone; //???
        
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
    
    if (row == 0) //Monthly
	{
        rowBackground = [_appConstants getMainMenuBackground:YELLOW];
		selectionBackground = [_appConstants getMainMenuBackground:YELLOW];
        labelString = @"   Monthly";
 	}
    else// (row == 1) AllTime
    {
        rowBackground = [_appConstants getMainMenuBackground:GREEN];
		selectionBackground = [_appConstants getMainMenuBackground:GREEN];
        labelString = @"   All-Time";
    }
    
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
    cell.textLabel.text = labelString;
    cell.textLabel.font = [_appConstants getBoldFontWithSize:20.0];
    
	return cell;
    
} //end cell for row at index path



@end
