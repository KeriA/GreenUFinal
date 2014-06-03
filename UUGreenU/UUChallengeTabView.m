//
//  UUChallengeTabView.m
//  UUGreenU
//
//  Created by Keri Anderson on 5/28/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUChallengeTabView.h"

@implementation UUChallengeTabView
{
    UIButton* _informationButton;
    UIButton* _challengesButton;
    UIImage* _informationImageSelected;
    UIImage* _informationImageNotSelected;
    UIImage* _challengeImageSelected;
    UIImage* _challengeImageNotSelected;
    
    UILabel* _challengesLabel;
    UITableView* _threeChallengesTableView;
    
    UIWebView* _webView;
    
    
}

@synthesize challengeTabViewDelegate;

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
        //first - tabButtons
        _informationImageSelected     = [_appConstants getTabBarImageForChallengesSelected:LEFT];
        _informationImageNotSelected  = [_appConstants getTabBarImageForChallengessNotSelected:LEFT];
        _challengeImageSelected       = [_appConstants getTabBarImageForChallengesSelected:RIGHT];
        _challengeImageNotSelected    = [_appConstants getTabBarImageForChallengessNotSelected:RIGHT];
        
        //this button just looks like a picture
        _informationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_informationButton  setImage: _informationImageNotSelected forState:UIControlStateNormal];
        [_informationButton  setImage: _informationImageSelected forState:UIControlStateSelected];
        // set the text properties
        _informationButton.backgroundColor = [UIColor clearColor];
        //_individualButton.backgroundColor = [UIColor colorWithPatternImage:_individualImageNotSelected];
        [_informationButton  setTitle:@"" forState:UIControlStateNormal];
        _informationButton.selected = true;
        [_informationButton addTarget: challengeTabViewDelegate
                              action:@selector(informationButtonWasPressed)
                    forControlEvents:UIControlEventTouchDown];
        
        //this button just looks like a picture
        _challengesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_challengesButton  setImage: _challengeImageNotSelected forState:UIControlStateNormal];
        [_challengesButton  setImage: _challengeImageSelected forState:UIControlStateSelected];
        // set the text properties
        _challengesButton.backgroundColor = [UIColor clearColor];
        [_challengesButton  setTitle:@"" forState:UIControlStateNormal];
        _challengesButton.selected = false;
        [_challengesButton addTarget: challengeTabViewDelegate
                        action:@selector(challengesButtonWasPressed)
              forControlEvents:UIControlEventTouchDown];
        
        
        
        _challengesLabel = [[UILabel alloc] init];
        [_challengesLabel setBackgroundColor:[UIColor clearColor]];
        [_challengesLabel setText:@"Challenges"];
        [_challengesLabel setTextColor:[UIColor whiteColor]];
        [_challengesLabel setFont:[_appConstants getBoldFontWithSize:TOPLABELFONTSIZE]];
        [_challengesLabel setTextAlignment:NSTextAlignmentLeft];

        
        _threeChallengesTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _threeChallengesTableView.rowHeight = 90;
        _threeChallengesTableView.scrollEnabled = NO;
        _threeChallengesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _threeChallengesTableView.backgroundColor = [UIColor clearColor];

        
        _webView = [[UIWebView alloc] init];
        [_webView setBackgroundColor:[UIColor blackColor]];
        // this helps size the view correctly
        [_webView setScalesPageToFit:TRUE];
        [_webView setAutoresizesSubviews:TRUE];
        [_webView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
        _webView.hidden = false;  //start out with the web view showing
  
        
        
        [self addSubview:_informationButton];
        [self addSubview:_challengesButton];
        [self addSubview:_challengesLabel];
        [self addSubview:_threeChallengesTableView];
        [self addSubview:_webView];
        

        
        
    }
    return self;
    
}//end Constructor


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
    CGRect informationButtonRect = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    CGRect challengesButtonRect = CGRectMake(buttonX + buttonWidth, buttonY, buttonWidth, buttonHeight);
    
    CGFloat heigthAdjust = 10.0;
    CGFloat widthAdjust = 6.0;
    CGFloat xAdjust = 3.0;
    informationButtonRect.size.height = informationButtonRect.size.height + heigthAdjust;
    informationButtonRect.size.width = informationButtonRect.size.width + widthAdjust;
    informationButtonRect.origin.x = informationButtonRect.origin.x - xAdjust;
    challengesButtonRect.size.height = challengesButtonRect.size.height + heigthAdjust;
    challengesButtonRect.size.width = challengesButtonRect.size.width + widthAdjust;
    challengesButtonRect.origin.x = challengesButtonRect.origin.x - xAdjust;
    
    [_informationButton   setFrame:informationButtonRect];
    [_challengesButton    setFrame:challengesButtonRect];
    
    
    //first, remove a strip off of the top to make room for the navigation controller
    CGFloat maxMargin;
    if ( (TOPMARGIN * .5) > buttonHeight )
        maxMargin = (TOPMARGIN * .5);
    else
        maxMargin = buttonHeight;
    
    bounds.size.height = bounds.size.height - (TOPMARGIN  + maxMargin);  //1.5 x so we remove a strip off of the bottom as well
    bounds.origin.y = TOPMARGIN;
    
    //create the rect for the webview
    CGRect webViewRect = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height + 5.0);
    

    
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
    CGRect tableViewRect;
    tableViewRect = CGRectMake(insetBounds.origin.x - 3.0, insetBounds.origin.y + 50.0, insetBounds.size.width + 25.0, 300.00);

    
    // set the frames
    [_challengesLabel             setFrame:topLabelRect];
    [_threeChallengesTableView    setFrame:tableViewRect];
    [_webView                     setFrame:webViewRect];
    
    //now that we have the tableViewRect, fix the edge insets
    _threeChallengesTableView.contentInset = UIEdgeInsetsMake(0.0, -10.0, 0, 0);
    
}// end layout subviews


/******************************************************************************************************
 *
 *                             MethodsForEasyAccessFrom the Controller
 *
 ******************************************************************************************************/


- (void) setInformationButtonToSelected
{
    _informationButton.selected = true;
    [self setNeedsDisplay];
}

- (void) setInformationButtonToNotSelected
{
    _informationButton.selected = false;
    [self setNeedsDisplay];
}

- (void) setChallengesButtonToSelected
{
    _challengesButton.selected = true;
    [self setNeedsDisplay];
}

- (void) setChallengesButtonToNotSelected
{
    _challengesButton.selected = false;
    [self setNeedsDisplay];
}

-(void) setTableViewDelegates:(id)viewController
{
    [_threeChallengesTableView setDataSource:viewController];
    [_threeChallengesTableView setDelegate:viewController];
    
}

- (void) setURl: (NSString*)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
    
    [self setNeedsDisplay];
    
}

- (void) hideWebView
{
    _webView.hidden = true;
    [self setNeedsDisplay];
}

- (void) showWebView
{
    _webView.hidden = false;
    [self setNeedsDisplay];
}

- (void) reloadTableData
{
    [_threeChallengesTableView reloadData];
    [self setNeedsDisplay];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
