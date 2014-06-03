//
//  UUShowTopUsersView.m
//  UUGreenU
//
//  Created by Keri Anderson on 5/26/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUShowTopUsersView.h"


@implementation UUShowTopUsersView
{
    UILabel* _topUsersLabel;
    UILabel* _individualOrTeamLabel;
    UILabel* _yourRankLabel;
    UILabel* _rankValueLabel;
    UILabel* _topTenLabel;
    NSMutableArray* _numberImageViewArray;
    NSMutableArray* _numberLableArray;
    NSMutableArray* _nameArray;
    NSMutableArray* _pointsArray;
    NSMutableArray* _dividerArray;
    UIButton* _individualButton;
    UIButton* _teamButton;
    
    UIImage* _individualImageNotSelected;
    UIImage* _individualImageSelected;
    UIImage* _teamImageNotSelected;
    UIImage* _teamImageSelected;
    
    UIImage* _individualNumberIcon;
    UIImage* _teamNumberIcon;
    UIImage* _dividerImage;
    
 
}

@synthesize showTopUsersViewDelegate;

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
        [self setBackgroundColor:[UIColor colorWithPatternImage:[appConstants getBackgroundImage]]];
        
        
        //create subviews
        _topUsersLabel = [[UILabel alloc] init];
        [_topUsersLabel setBackgroundColor:[UIColor clearColor]];
        [_topUsersLabel setText:@"Top Users"];
        [_topUsersLabel setTextColor:[UIColor whiteColor]];
        [_topUsersLabel setFont:[_appConstants getBoldFontWithSize:TOPLABELFONTSIZE]];
        [_topUsersLabel setTextAlignment:NSTextAlignmentLeft];
        
        _individualOrTeamLabel = [[UILabel alloc] init];
        [_individualOrTeamLabel setBackgroundColor:[UIColor clearColor]];
        [_individualOrTeamLabel setText:@"|  Individual"];
        [_individualOrTeamLabel setTextColor:[UIColor whiteColor]];
        [_individualOrTeamLabel setFont:[_appConstants getStandardFontWithSize:TOPLABELFONTSIZE]];
        [_individualOrTeamLabel setTextAlignment:NSTextAlignmentLeft];
        
        _yourRankLabel = [[UILabel alloc] init];
        [_yourRankLabel setBackgroundColor:[UIColor clearColor]];
        [_yourRankLabel setText:@"Your Rank:  "];
        [_yourRankLabel setTextColor:[_appConstants mustardYellowColor]];
        [_yourRankLabel setFont:[_appConstants getItalicsFontWithSize:15.0]];
        [_yourRankLabel setTextAlignment:NSTextAlignmentLeft];
        
        _rankValueLabel = [[UILabel alloc] init];
        [_rankValueLabel setBackgroundColor:[UIColor clearColor]];
        [_rankValueLabel setText:@""];
        [_rankValueLabel setTextColor:[_appConstants mustardYellowColor]];
        [_rankValueLabel setFont:[_appConstants getItalicsFontWithSize:15.0]];
        [_rankValueLabel setTextAlignment:NSTextAlignmentLeft];
        
        _topTenLabel = [[UILabel alloc] init];
        [_topTenLabel setBackgroundColor:[UIColor clearColor]];
        [_topTenLabel setText:@"Top 10"];
        [_topTenLabel setTextColor:[UIColor whiteColor]];
        [_topTenLabel setFont:[_appConstants getBoldFontWithSize:18.0]];
        [_topTenLabel setTextAlignment:NSTextAlignmentLeft];
        
        [self addSubview:_topUsersLabel];
        [self addSubview:_individualOrTeamLabel];
        [self addSubview:_yourRankLabel];
        [self addSubview:_rankValueLabel];
        [self addSubview:_topTenLabel];

        
        
        //initialize the arrays
        _numberImageViewArray = [[NSMutableArray alloc]init];
        _numberLableArray = [[NSMutableArray alloc]init];
        _nameArray = [[NSMutableArray alloc]init];
        _pointsArray = [[NSMutableArray alloc]init];
        _dividerArray = [[NSMutableArray alloc]init];
        
        _dividerImage = [_appConstants getWhiteLineDividerImage];
        
        for ( int i = 0; i < 10; i++){
            UIImageView* imageView = [[UIImageView alloc]init];
            [_numberImageViewArray addObject:imageView];
            
            UILabel* numberLabel = [[UILabel alloc]init];
            [numberLabel setBackgroundColor:[UIColor clearColor]];
            [numberLabel setText:[NSString stringWithFormat:@"%d", i+1]];
            [numberLabel setTextColor:[UIColor blackColor]];
            [numberLabel setFont:[_appConstants getBoldFontWithSize:16.0]];
            [numberLabel setTextAlignment:NSTextAlignmentCenter];
            [numberLabel setNumberOfLines:1];
            [_numberLableArray addObject:numberLabel];
            
            UILabel* nameLabel = [[UILabel alloc] init];
            [nameLabel setBackgroundColor:[UIColor clearColor]];
            [nameLabel setText:@""];
            [nameLabel setTextColor:[UIColor whiteColor]];
            [nameLabel setFont:[_appConstants getStandardFontWithSize:12.0]];
            [nameLabel setTextAlignment:NSTextAlignmentLeft];
            [nameLabel setNumberOfLines:1];
            [_nameArray addObject:nameLabel];
            
            UILabel* pointsLabel = [[UILabel alloc]init];
            [pointsLabel setBackgroundColor:[UIColor clearColor]];
            [pointsLabel setText:@""];
            [pointsLabel setTextColor:[UIColor whiteColor]];
            [pointsLabel setFont:[_appConstants getStandardFontWithSize:12.0]];
            [pointsLabel setTextAlignment:NSTextAlignmentLeft];
            [pointsLabel setNumberOfLines:1];
            [_pointsArray addObject:pointsLabel];

            UILabel* lineLabel = [[UILabel alloc]init];
            [lineLabel setBackgroundColor:[UIColor colorWithPatternImage:_dividerImage]];
            [lineLabel setText:@""];
            [_dividerArray addObject:lineLabel];
            
            [self addSubview:imageView];
            [self addSubview:numberLabel];
            [self addSubview:nameLabel];
            [self addSubview:pointsLabel];
            [self addSubview:lineLabel];

        }//end for i

        
        
        _individualImageNotSelected = [_appConstants getTabBarImageForTopUsersNotSelected:LEFT];
        _teamImageNotSelected = [_appConstants getTabBarImageForTopUsersNotSelected:RIGHT];
        _individualImageSelected = [_appConstants getTabBarImageForTopUsersSelected:LEFT];
        _teamImageSelected = [_appConstants getTabBarImageForTopUsersSelected:RIGHT];
        
        _individualNumberIcon = [_appConstants getTopIndividualNumberIcon];
        _teamNumberIcon = [_appConstants getTopTeamNumberIcon];
        

        
        //this button just looks like a picture
        _individualButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_individualButton  setImage: _individualImageNotSelected forState:UIControlStateNormal];
        [_individualButton  setImage: _individualImageSelected forState:UIControlStateSelected];
        // set the text properties
        _individualButton.backgroundColor = [UIColor clearColor];
        //_individualButton.backgroundColor = [UIColor colorWithPatternImage:_individualImageNotSelected];
        [_individualButton  setTitle:@"" forState:UIControlStateNormal];
        _individualButton.selected = true;
        [_individualButton addTarget: showTopUsersViewDelegate
                           action:@selector(individualButtonWasPressed)
                 forControlEvents:UIControlEventTouchDown];
        
        //this button just looks like a picture
        _teamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_teamButton  setImage: _teamImageNotSelected forState:UIControlStateNormal];
        [_teamButton  setImage: _teamImageSelected forState:UIControlStateSelected];
        // set the text properties
        _teamButton.backgroundColor = [UIColor clearColor];
        [_teamButton  setTitle:@"" forState:UIControlStateNormal];
        _teamButton.selected = false;
        [_teamButton addTarget: showTopUsersViewDelegate
                              action:@selector(teamsButtonWasPressed)
                    forControlEvents:UIControlEventTouchDown];
        
        
        [self addSubview:_individualButton];
        [self addSubview:_teamButton];


        
    }
    return self;
    
}//end Constructor


/******************************************************************************************************
 *
 *                             MethodsForEasyAccessFrom the Controller
 *
 ******************************************************************************************************/

- (void) setViewComponents:(NSMutableArray*)elementsArray andIndividualOrTeam:(int)individualORTeam
{
    int count = (int)[elementsArray count];
    UIImage* iconImage;
    
    if (individualORTeam == INDIVIDUAL){
        iconImage = _individualNumberIcon;
    }else{
        iconImage = _teamNumberIcon;
    }
    
    for (int i = 0; i < 10; i++){
        UIImageView* imageView = [_numberImageViewArray objectAtIndex:i];
        UILabel* numberLabel = [_numberLableArray objectAtIndex:i];
        UILabel* nameLabel = [_nameArray objectAtIndex:i];
        UILabel* pointsLabel = [_pointsArray objectAtIndex:i];
        UILabel* dividerLabel = [_dividerArray objectAtIndex:i];

        if (i < count){
            NSMutableDictionary* dict = [elementsArray objectAtIndex:i];
            
            imageView.image = iconImage;
            imageView.hidden = false;
            
            numberLabel.hidden = false;
            
            [nameLabel setText:[dict objectForKey:nameKey]];
            nameLabel.hidden = false;
            

            [pointsLabel setText:[dict objectForKey:pointsKey]];
            pointsLabel.hidden = false;
            
            if (i < count - 1){
                dividerLabel.hidden = false;
            }else{
                dividerLabel.hidden = true;
            }
            
        }else{  //un-needed labels
            imageView.hidden = true;
            numberLabel.hidden = true;
            nameLabel.hidden = true;
            pointsLabel.hidden = true;
            dividerLabel.hidden = true;
        }
        
    }//end for i
    
    [self setNeedsDisplay];
    
}//end setViewComponents

- (void) setTopLabels:(NSArray*)array
{
    [_individualOrTeamLabel setText:[array objectAtIndex:0]];
    [_rankValueLabel setText:[array objectAtIndex:1]];
    
}

- (void) setIndividualButtonBackgroundToSelected
{
    _individualButton.selected = true;
}

- (void) setIndividualButtonBackgroundToNotSelected
{
    _individualButton.selected = false;
}

- (void) setTeamButtonBackgroundToSelected
{
    _teamButton.selected = true;
}

- (void) setTeamButtonBackgroundToNotSelected
{
    _teamButton.selected = false;
}

/**************************************************************************************************
 *
 *                          layout subviews
 *
 **************************************************************************************************/
#pragma - mark layoutSubviews
/***
 *  In the layout subviews, we need to access the original frame, and then do a bunch
 *  of math to properly create the frames for all of the subviews
 *
 */
- (void) layoutSubviews
{
    
    [super layoutSubviews];
    
    /*** TOP LABEL - FOR CONSISTENCY ACROSS FRAMES  ***/
    
    // Get the bounds of the current view. We will use this to dynamically calculate the frames of our subviews
    CGRect bounds = [self bounds];
    //NSLog(@"width is %f and height is %f", bounds.size.width, bounds.size.height);//for testing
    
    
    //first, set the bottom "tab" buttons
    CGFloat buttonHeight = 50.0;
    CGFloat buttonWidth = bounds.size.width/2.0;
    CGFloat buttonX = bounds.origin.x;
    CGFloat buttonY = bounds.origin.y + bounds.size.height - buttonHeight;
    CGRect individualButtonRect = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    CGRect teamButtonRect = CGRectMake(buttonX + buttonWidth, buttonY, buttonWidth, buttonHeight);
    
    CGFloat heigthAdjust = 10.0;
    CGFloat widthAdjust = 6.0;
    CGFloat xAdjust = 3.0;
    individualButtonRect.size.height = individualButtonRect.size.height + heigthAdjust;
    individualButtonRect.size.width = individualButtonRect.size.width + widthAdjust;
    individualButtonRect.origin.x = individualButtonRect.origin.x - xAdjust;
    teamButtonRect.size.height = teamButtonRect.size.height + heigthAdjust;
    teamButtonRect.size.width = teamButtonRect.size.width + widthAdjust;
    teamButtonRect.origin.x = teamButtonRect.origin.x - xAdjust;
    
    [_individualButton setFrame:individualButtonRect];
    [_teamButton       setFrame:teamButtonRect];
    


    //first, remove a strip off of the top to make room for the navigation controller
    CGFloat maxMargin;
    if ( (TOPMARGIN * .5) > buttonHeight )
        maxMargin = (TOPMARGIN * .5);
    else
        maxMargin = buttonHeight;
    
    bounds.size.height = bounds.size.height - (TOPMARGIN  + maxMargin);  //1.5 x so we remove a strip off of the bottom as well
    bounds.origin.y = TOPMARGIN;
    
    // Next, create an inset off of the sides so that there is a bit of an edge
    // The following notes are FYI to explain how CGRectInset works:
    // create the rectangles so that they are a bit smaller (showing more background) and
    // centered on the same point  (using CGRectInset)
    //  CGRectInsetParameters:
    //        rect:  The source CGRect structure.
    //          dx:  The x-coordinate value to use for adjusting the source rectangle.
    //               To create an inset rectangle, specify a positive value. To create a larger,
    //               encompassing rectangle, specify a negative value.
    //          dy:  The y-coordinate value to use for adjusting the source rectangle.
    //               To create an inset rectangle, specify a positive value. To create a larger,
    //               encompassing rectangle, specify a negative value.
    CGRect insetBounds  = CGRectInset(bounds, bounds.size.width * PAGEINSETAMOUNT, 0.0);
    
    //create the top label margin  (for consistency across pages)
    CGRect topLabelRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y, insetBounds.size.width, TOPLABELHEIGHT);
    //NSLog(@"top label Rect .y is %f", topLabelRect.origin.y);
    
    //now adjust the inset bounds
    insetBounds.origin.y = insetBounds.origin.y + TOPLABELHEIGHT;  // this can be adjusted as needed per frame
    insetBounds.size.height = insetBounds.size.height - TOPLABELHEIGHT;
    
    
    
    /***  REMAINING RECTS  ***/
    // the specific rects that will be used for subviews
    CGRect indOrTeamRect;
    CGRect yourRankRect;
    CGRect rankValueRect;
    CGRect top10Rect;
    CGRect tenElementsRect;  //for spacing
    
    CGRectDivide(topLabelRect, &topLabelRect, &indOrTeamRect, topLabelRect.size.width/2.0, CGRectMinXEdge);
    yourRankRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y , insetBounds.size.width/ 3.0, 20.0);
    rankValueRect = CGRectMake(insetBounds.origin.x + yourRankRect.size.width, insetBounds.origin.y, insetBounds.size.width/2.0, 20);
    top10Rect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y + yourRankRect.size.height, insetBounds.size.width, 30.0);
    
    //create the 10 elements rect
    tenElementsRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y + 50.0, insetBounds.size.width, insetBounds.size.height - 60.0);
    
    // set the frames
    [_topUsersLabel             setFrame:topLabelRect];
    [_individualOrTeamLabel     setFrame:indOrTeamRect];
    [_yourRankLabel             setFrame:yourRankRect];
    [_topTenLabel               setFrame:top10Rect];
    [_rankValueLabel            setFrame:rankValueRect];
    
    
    //divide up the 10 elements
    CGFloat elementHeight = tenElementsRect.size.height / 10.0;
    CGFloat elementWidth = tenElementsRect.size.width;
    CGFloat elementX = tenElementsRect.origin.x;
    CGFloat elementFirstY = tenElementsRect.origin.y;
    for (int i = 0; i < 10; i++)
    {
        CGRect elementsRect = CGRectMake(elementX, elementFirstY + (i*elementHeight), elementWidth, elementHeight);
        
        //divide this rect into three sub rects
        CGRect lineRect;
        CGRect numberImageRect;
        CGRect nameRect;
        CGRect pointsRect;
        
        CGRectDivide(elementsRect, &elementsRect, &lineRect, (10.0 * elementsRect.size.height)/11.0, CGRectMinYEdge);
        //the ration of the line image needs to be 620 wide to 2 height, and recenter
        CGFloat lineRectOriginalHeight = lineRect.size.height;
        lineRect.size.height = (2.0 / 620.0) * lineRect.size.width;
        CGFloat difference = lineRectOriginalHeight - lineRect.size.height;
        lineRect.origin.y = lineRect.origin.y + (difference / 2.0);
        
        CGRectDivide(elementsRect, &numberImageRect, &nameRect, elementsRect.size.width/8.0, CGRectMinXEdge);
        CGRectDivide(nameRect, &nameRect, &pointsRect, nameRect.size.width/1.8, CGRectMinXEdge);
        
        //make sure the numberImageRect is square
        if (numberImageRect.size.width > numberImageRect.size.height){
            numberImageRect.size.width = numberImageRect.size.height;
        }else{
            numberImageRect.size.height = numberImageRect.size.width;
        }
        
        //set the frames
        UIImageView* imageView = [_numberImageViewArray objectAtIndex:i];
        UILabel* numberLabel = [_numberLableArray objectAtIndex:i];
        [imageView setFrame:numberImageRect];
        [numberLabel setFrame:numberImageRect];
         
        UILabel* nameLabel = [_nameArray objectAtIndex:i];
        [nameLabel setFrame:nameRect];
        
        UILabel* pointsLabel = [_pointsArray objectAtIndex:i];
        [pointsLabel setFrame:pointsRect];
        UILabel* lineView = [_dividerArray objectAtIndex:i];
        [lineView setFrame:lineRect];
        
    }
    
    
}// end layout subviews

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
