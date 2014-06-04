//
//  UUSpecificChallengeView.m
//  UUGreenU
//
//  Created by Keri Anderson on 5/15/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUSpecificChallengeView.h"

#define notCompleteText @"Complete?"
#define completeText @"This challenge is complete."

@implementation UUSpecificChallengeView
{
    int _challengeType;
    
    UIImageView*    _challengeImageView;
    UIImage*        _challengeImage;
    UILabel*        _challengeLabel;
    UILabel*        _teaserLabel;
    UILabel*        _descriptionLabel;
    UILabel*        _completeLabel;
    UIButton*       _calendarButton;
    UIButton*       _oneTimeButton;
    UIButton*       _submitButton;
    UILabel*        _thanksForParticipatingLabel;
    UILabel*        _pointsLabel;
    UILabel*        _userPointsLabel;
    UILabel*        _totalPointsLabel;
    
    UILabel*        _shareLabel;
    UIButton*       _facebookButton;
    UIButton*       _twitterButton;
    
    //for pop-up calendar
    UIView*          _calendarContainerView;
    UIToolbar*       _calendarToolBar;
    UIButton*        _calendarDoneButton;
    UIButton*        _monthDisplayButton;
    UUCalendarView* _calendarView;
    
    CGRect _CalendarFrameShow;
    CGRect _CalendarFrameHide;
    
}

@synthesize specificChallengeViewDelegate;


/***
 *
 *      Constructor
 */
- (id)initWithAppConstants:(UUApplicationConstants*)appConstants andMonthNumber: (int) monthNumber andType: (int) challengeType
{
    self = [super init];
    if (self) {
        // Initialization code
        
        _appConstants = appConstants;
        _challengeType = challengeType;
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[appConstants getBackgroundImage]]];
        
        //get the appropriate image from the appconstants
        _challengeImage = [_appConstants getChallengeMonthImage:monthNumber];
        
        //create subviews
        _challengeImageView = [[UIImageView alloc]initWithImage:_challengeImage];
        
        _challengeLabel = [[UILabel alloc] init];
        [_challengeLabel setBackgroundColor:[UIColor clearColor]];
        [_challengeLabel setText:@"Challenge!"];
        [_challengeLabel setTextColor:[UIColor whiteColor]];
        [_challengeLabel setFont:[_appConstants getBoldFontWithSize:45.0]];
        [_challengeLabel setTextAlignment:NSTextAlignmentCenter];
        
        _teaserLabel = [[UILabel alloc] init];
        [_teaserLabel setBackgroundColor:[UIColor clearColor]];
        [_teaserLabel setText:@"Need Teaser"];
        [_teaserLabel setTextColor:[_appConstants mustardYellowColor]];
        [_teaserLabel setFont:[_appConstants getStandardFontWithSize:16.0]];
        [_teaserLabel setTextAlignment:NSTextAlignmentCenter];
        
        _descriptionLabel = [[UILabel alloc] init];
        [_descriptionLabel setLineBreakMode:NSLineBreakByWordWrapping];  //for multiple lines
        [_descriptionLabel setNumberOfLines:0];  //for multiple lines
        [_descriptionLabel  setBackgroundColor:[UIColor clearColor]];
        NSString* temp = @"Need Description";
        //[_descriptionLabel  setText:@"Need Description"];
        [_descriptionLabel  setText:temp];
        [_descriptionLabel  setTextColor:[UIColor whiteColor]];
        [_descriptionLabel  setFont:[_appConstants getStandardFontWithSize:12.0]];
        [_descriptionLabel  setTextAlignment:NSTextAlignmentLeft];
        
        _completeLabel = [[UILabel alloc] init];
        [_completeLabel  setBackgroundColor:[UIColor clearColor]];
        [_completeLabel  setText:@"Complete?"];
        //[_completeLabel  setText:@"Need Complete Text"];
        [_completeLabel  setTextColor:[UIColor whiteColor]];
        [_completeLabel  setFont:[_appConstants getStandardFontWithSize:15.0]];
        [_completeLabel  setTextAlignment:NSTextAlignmentRight];
        
        _pointsLabel = [[UILabel alloc] init];
        [_pointsLabel  setBackgroundColor:[UIColor clearColor]];
        [_pointsLabel  setText:@"Points"];
        [_pointsLabel  setTextColor:[UIColor whiteColor]];
        [_pointsLabel  setFont:[_appConstants getStandardFontWithSize:15.0]];
        [_pointsLabel  setTextAlignment:NSTextAlignmentRight];
        
        _userPointsLabel = [[UILabel alloc] init];
        [_userPointsLabel  setBackgroundColor:[UIColor clearColor]];
        //[_userPointsLabel  setText:@"Need User Points"];
        [_userPointsLabel  setText:@"0 "];
        [_userPointsLabel  setTextColor:[_appConstants mustardYellowColor]];
        [_userPointsLabel  setFont:[_appConstants getStandardFontWithSize:15.0]];
        [_userPointsLabel  setTextAlignment:NSTextAlignmentRight];
        
        _totalPointsLabel = [[UILabel alloc] init];
        [_totalPointsLabel  setBackgroundColor:[UIColor clearColor]];
        //[_totalPointsLabel  setText:@"/ Need Total Points"];
        [_totalPointsLabel  setText:@" / 0"];
        [_totalPointsLabel  setTextColor:[UIColor whiteColor]];
        [_totalPointsLabel  setFont:[_appConstants getStandardFontWithSize:15.0]];
        [_totalPointsLabel  setTextAlignment:NSTextAlignmentLeft];
        
        // rounded rect button
        _submitButton = [[UIButton alloc]init];
        _submitButton.layer.borderWidth = .06f; // these two lines
        _submitButton.layer.cornerRadius = 6;   // round the corners
        [_submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:[_appConstants cherryRedColor]];
        [_submitButton.titleLabel setFont:[_appConstants getBoldFontWithSize:12]];
        [_submitButton.titleLabel setTextColor:[UIColor whiteColor]];
        [_submitButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_submitButton addTarget: specificChallengeViewDelegate
                          action:@selector(submitButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];
        
        _thanksForParticipatingLabel = [[UILabel alloc] init];
        [_thanksForParticipatingLabel  setBackgroundColor:[UIColor clearColor]];
        [_thanksForParticipatingLabel setText:@"Thank you for participating!"];
        [_thanksForParticipatingLabel setTextColor:[_appConstants seaFoamColor]];
        [_thanksForParticipatingLabel  setFont:[_appConstants getItalicsFontWithSize:15.0]];
        [_thanksForParticipatingLabel  setTextAlignment:NSTextAlignmentRight];
        _thanksForParticipatingLabel.hidden = true;

        
        _shareLabel = [[UILabel alloc] init];
        [_shareLabel  setBackgroundColor:[UIColor clearColor]];
        [_shareLabel  setText:@"SHARE!"];
        [_shareLabel  setTextColor:[_appConstants mustardYellowColor]];
        [_shareLabel  setFont:[_appConstants getStandardFontWithSize:15.0]];
        [_shareLabel  setTextAlignment:NSTextAlignmentRight];
        
        //this button just looks like a picture
        _facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_facebookButton setImage: [_appConstants getFacebookIconSmall] forState:UIControlStateNormal];
        // set the text properties
        _facebookButton.backgroundColor = [UIColor clearColor];
        [_facebookButton setTitle:@"" forState:UIControlStateNormal];
        [_facebookButton addTarget: specificChallengeViewDelegate
                            action:@selector(facebookButtonWasPressed)
                  forControlEvents:UIControlEventTouchDown];
        
        //this button just looks like a picture
        _twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_twitterButton setImage: [_appConstants getTwitterIconSmall] forState:UIControlStateNormal];
        // set the text properties
        _twitterButton.backgroundColor = [UIColor clearColor];
        [_twitterButton setTitle:@"" forState:UIControlStateNormal];
        [_twitterButton addTarget: specificChallengeViewDelegate
                           action:@selector(twitterButtonWasPressed)
                 forControlEvents:UIControlEventTouchDown];
        
        
        //add the subviews
        [self addSubview:_challengeImageView];
        [self addSubview:_challengeLabel];
        [self addSubview:_teaserLabel];
        [self addSubview:_descriptionLabel];
        [self addSubview:_completeLabel];
        [self addSubview:_pointsLabel];
        [self addSubview:_userPointsLabel];
        [self addSubview:_totalPointsLabel];
        [self addSubview:_submitButton];
        [self addSubview:_thanksForParticipatingLabel];
        [self addSubview:_shareLabel];
        [self addSubview:_facebookButton];
        [self addSubview:_twitterButton];
        
        
        //depending on whether the type == "one time" (1) or "repeat" (2)
        //set the one time button or calendar button
        //Important!  the order that subviews are added determines the hierachy of which view is
        //on top/bottom.  We want the CalendarContainerview to be topmost, so it will
        //cover the over components when shown
        
        if (_challengeType == ONETIME) {
            
            //this button just looks like a picture
            _oneTimeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //[_oneTimeButton setImage: [_appConstants getCheckboxEmptyIcon] forState:UIControlStateNormal];
            //[_oneTimeButton setImage: [_appConstants getCalendarIcon] forState:UIControlStateNormal];
            [_oneTimeButton setImage:[_appConstants getCheckboxEmptyIcon] forState:UIControlStateNormal];
            [_oneTimeButton setImage:[_appConstants getCheckboxFullIcon] forState:UIControlStateSelected];
            _oneTimeButton.selected = false; //opening default
            // set the text properties
            _oneTimeButton.backgroundColor = [UIColor clearColor];
            [_oneTimeButton setTitle:@"" forState:UIControlStateNormal];
            [_oneTimeButton addTarget: specificChallengeViewDelegate
                               action:@selector(oneTimeButtonWasPressed)
                     forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:_oneTimeButton];
            
        }else{ //REPEAT
            
            //this button just looks like a picture
            _calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_calendarButton setImage: [_appConstants getCalendarIcon] forState:UIControlStateNormal];
            // set the text properties
            _calendarButton.backgroundColor = [UIColor clearColor];
            [_calendarButton setTitle:@"" forState:UIControlStateNormal];
            [_calendarButton addTarget: specificChallengeViewDelegate
                                action:@selector(calendarButtonWasPressed)
                      forControlEvents:UIControlEventTouchDown];
            
            [self addSubview:_calendarButton];
            
            //create the calendar view
            _calendarView = [[UUCalendarView alloc] initWithAppConstants:_appConstants];
            
            //for pop-up calendar
            //_pickerViewFrameView holds all the needed components for the picker
            _calendarContainerView = [[UIView alloc]init];
            _calendarContainerView.alpha = 1.0;
            _calendarContainerView.backgroundColor = [UIColor colorWithPatternImage:[_appConstants getBackgroundImage]];
            
            
            
            
            
            
            _calendarDoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_calendarDoneButton setFrame:CGRectMake(0.0, 0.0, 45.0, 25.0)];
            [_calendarDoneButton addTarget:specificChallengeViewDelegate action:@selector(calendarDoneButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
            [_calendarDoneButton setBackgroundImage:[_appConstants getPickerDoneImage] forState:UIControlStateNormal];
            [_calendarDoneButton setTitle:@"Done" forState:UIControlStateNormal];
            [_calendarDoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_calendarDoneButton.titleLabel setFont:[_appConstants getBoldFontWithSize:15.0]];
            UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithCustomView:_calendarDoneButton];
            
            _monthDisplayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_monthDisplayButton setFrame:CGRectMake(0.0, 0.0, 200.0, 25.0)];
            //[_monthDisplayButton addTarget  - target not needed for this button - just a quick and dirty hack to get a label up there
            [_monthDisplayButton setBackgroundColor:[UIColor clearColor]];
            [_monthDisplayButton setTitle:@"March 2014" forState:UIControlStateNormal];
            [_monthDisplayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_monthDisplayButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_monthDisplayButton.titleLabel setFont:[_appConstants getBoldFontWithSize:20.0]];
            _monthDisplayButton.enabled = false;
            UIBarButtonItem* monthItem = [[UIBarButtonItem alloc] initWithCustomView:_monthDisplayButton];
            
            
            _calendarToolBar = [[UIToolbar alloc]init];
            _calendarToolBar.tintColor = [_appConstants cherryRedColor];  //text color
            _calendarToolBar.barTintColor = [UIColor blackColor];  //background color
            [_calendarToolBar setBackgroundImage:[_appConstants getPickerBarImage] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
            //[_calendarToolBar setBackgroundImage:[_appConstants getPickerBarImage] forToolbarPosition:<#(UIBarPosition)#> barMetrics:<#(UIBarMetrics)#>]
            //this button item is used only to force the 'done' button to the right side
            UIBarButtonItem* flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            NSArray* items = [[NSArray alloc]initWithObjects: monthItem, flexibleSpaceLeft, doneItem, nil];
            [_calendarToolBar setItems:items];
            
            
            [_calendarContainerView addSubview:_calendarToolBar];
            [_calendarContainerView addSubview:_calendarView];
            
            [self addSubview:_calendarContainerView];
            
        }//end REPEAT
        
        
    }
    return self;
    
}//end Constructor

//used to set the calendar view delegate
- (void) setCalendarViewDelegate:(id)delegate
{
    if (_challengeType == REPEAT)
    {
        [(UUCalendarView*)_calendarView setCalendarViewDelegate:delegate];
    }
    
}//end setCalendarDelegate


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
    
    // Get the bounds of the current view. We will use this to dynamically calculate the frames of our subviews
    CGRect bounds = [self bounds];
    //NSLog(@"width is %f and height is %f", bounds.size.width, bounds.size.height);//for testing
    
    
    //set the frame for the pop-up calendar view
    //we want the calendar frame itself to be 320 x 320 square
    CGFloat barHeight = 38;
    if (_challengeType == REPEAT)
    {
        //create the show/hide pickerview frames
        CGFloat calendarButtonDimension = 320/7.0;
        CGFloat calendarFrameHeight = (5.0 * calendarButtonDimension) + barHeight + barHeight; //first part for calendar buttons, second for title, last for bar
        CGFloat calendarFrameShowY = bounds.origin.y + (bounds.size.height - calendarFrameHeight);
        CGFloat calendarFrameHideY = bounds.origin.y + bounds.size.height;
        _CalendarFrameShow = CGRectMake(bounds.origin.x, calendarFrameShowY, bounds.size.width, calendarFrameHeight);
        _CalendarFrameHide = CGRectMake(bounds.origin.x, calendarFrameHideY, bounds.size.width, calendarFrameHeight);
    }
    
    
    
    
    // We want the background image to show up, so we need to adjust the width and height of the rectangles accordingly.
    // We can get a width adjustment immediately.
    //
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
    
    CGFloat boundsInsetWidth  = bounds.size.width  * PAGEINSETAMOUNT; // take off a percentage of the width
    CGFloat boundsInsetHeight = bounds.size.height * 0.15; // take off a percentage of the height
    
    //CGRectrect, CGFloat dx, CGFloat dy
    CGRect insetBounds = CGRectInset(bounds, boundsInsetWidth, boundsInsetHeight);
    NSLog(@"\ninsetBounds width is %f and height is %f", insetBounds.size.width, insetBounds.size.height); //for testing
    
    // the specific rects that will be used for subviews
    CGRect challengeImageViewRect;
    CGRect challengeLabelRect;
    CGRect teaserLabelRect;
    CGRect descriptionLabelRect;
    CGRect lowerThirdRect ; //for ease in layout
    CGRect completeLabelRect;
    CGRect buttonRect;
    CGRect submitButtonRect;
    CGRect thankYouRect;
    CGRect pointsLabelRect;
    CGRect userPointsLabelRect;
    CGRect totalPointsLabelRect;
    CGRect shareLabelRect;
    CGRect facebookButtonRect;
    CGRect twitterButtonRect;
    
    CGRectDivide(insetBounds, &challengeImageViewRect, &lowerThirdRect,  (2.0 *insetBounds.size.height) / 3.0, CGRectMinYEdge);
    //upper 2/3
    CGRectDivide(challengeImageViewRect, &challengeImageViewRect, &challengeLabelRect,  challengeImageViewRect.size.height / 3.0, CGRectMinYEdge);
    //we need the challengeImageViewRect to be square and centered.
    CGFloat xCenter = challengeImageViewRect.origin.x + challengeImageViewRect.size.width/2.0;
    challengeImageViewRect.size.width = challengeImageViewRect.size.height;
    challengeImageViewRect.origin.x = xCenter - (challengeImageViewRect.size.height/2.0);
    //    first divide the challenge label between the description
    CGRectDivide(challengeLabelRect, &challengeLabelRect, &descriptionLabelRect,  challengeLabelRect.size.height / 2.0, CGRectMinYEdge);
    //move the description label in a bit
    CGFloat descriptionLabelShrinkAmount = descriptionLabelRect.size.width * .03;
    descriptionLabelRect.origin.x = descriptionLabelRect.origin.x + descriptionLabelShrinkAmount;
    descriptionLabelRect.size.width = descriptionLabelRect.size.width - descriptionLabelShrinkAmount;
    
    //    now divide the challenge label with the teaser label
    CGRectDivide(challengeLabelRect, &challengeLabelRect, &teaserLabelRect,  (2.0* challengeLabelRect.size.height) / 3.0, CGRectMinYEdge);
    
    //bottom third
    //first, move the rect over towards the right a bit
    CGFloat lowerThirdShrinkAmount = lowerThirdRect.size.width * .40;
    lowerThirdRect.origin.x = lowerThirdRect.origin.x + lowerThirdShrinkAmount;
    lowerThirdRect.size.width = lowerThirdRect.size.width - lowerThirdShrinkAmount;
    
    
    
    //first divide in half between complete label and points label
    CGRectDivide(lowerThirdRect, &completeLabelRect, &pointsLabelRect, lowerThirdRect.size.height/2.0, CGRectMinYEdge);
    
    //now divide in half again between completeLableRect and submitButtonRect
    CGRectDivide(completeLabelRect, &completeLabelRect, &submitButtonRect, completeLabelRect.size.height/2.0, CGRectMinYEdge);
    //shrink the height of the submit button
    submitButtonRect = CGRectInset(submitButtonRect, 0.0, submitButtonRect.size.height * .10);
    //shrink the width of the submit button
    CGFloat shrinkAmount = submitButtonRect.size.width * .05;
    submitButtonRect.origin.x = submitButtonRect.origin.x + shrinkAmount;
    submitButtonRect.size.width = submitButtonRect.size.width - shrinkAmount;
    
    //right-align fields with the submit button
    CGFloat submitButtonRightX = submitButtonRect.origin.x + submitButtonRect.size.width;
    
    
    //split the width btween the labels
    CGRectDivide(completeLabelRect, &completeLabelRect, &buttonRect, completeLabelRect.size.width/2.0, CGRectMinXEdge);
    //make sure the button is square.
    if (buttonRect.size.width > buttonRect.size.height){
        buttonRect.size.width = buttonRect.size.height;
    }else{
        buttonRect.size.height = buttonRect.size.width;
    }
    
    buttonRect.origin.x = submitButtonRightX - buttonRect.size.width;
    
    //divide in half between pointslabel and share label
    CGRectDivide(pointsLabelRect, &pointsLabelRect, &shareLabelRect, pointsLabelRect.size.height/2.0, CGRectMinYEdge);
    CGRectDivide(pointsLabelRect, &pointsLabelRect, &userPointsLabelRect, pointsLabelRect.size.width/2.0, CGRectMinXEdge);
    CGRectDivide(userPointsLabelRect, &userPointsLabelRect, &totalPointsLabelRect, userPointsLabelRect.size.width/2.0, CGRectMinXEdge);
    totalPointsLabelRect.origin.x = submitButtonRightX - totalPointsLabelRect.size.width;
    
    //scott the user points back over a bit
    userPointsLabelRect.origin.x = userPointsLabelRect.origin.x - 5.0;
    
    CGRectDivide(shareLabelRect, &shareLabelRect, &facebookButtonRect, shareLabelRect.size.width/2.0, CGRectMinXEdge);
    CGRectDivide(facebookButtonRect, &facebookButtonRect, &twitterButtonRect, facebookButtonRect.size.width/2.0, CGRectMinXEdge);
    //make sure the buttons are square
    if (facebookButtonRect.size.width > facebookButtonRect.size.height){
        facebookButtonRect.size.width = facebookButtonRect.size.height;
        twitterButtonRect.size.width = facebookButtonRect.size.height;
    }else{
        facebookButtonRect.size.height = facebookButtonRect.size.width;
        twitterButtonRect.size.height = facebookButtonRect.size.width;
    }
    
    twitterButtonRect.origin.x = submitButtonRightX - twitterButtonRect.size.width;
    facebookButtonRect.origin.x = twitterButtonRect.origin.x - facebookButtonRect.size.width;
    

    //create the thankyou rect from the submit rect
    CGFloat thankYouAdjustAmount = 100.00;
    thankYouRect = CGRectMake(submitButtonRect.origin.x - thankYouAdjustAmount, submitButtonRect.origin.y, submitButtonRect.size.width + thankYouAdjustAmount, submitButtonRect.size.height);
    
    
    // set the frames
    [_challengeImageView  setFrame:challengeImageViewRect];
    [_challengeLabel      setFrame:challengeLabelRect];
    [_teaserLabel         setFrame:teaserLabelRect];
    [_descriptionLabel    setFrame:descriptionLabelRect];
    [_completeLabel       setFrame:completeLabelRect];
    [_submitButton        setFrame:submitButtonRect];
    [_thanksForParticipatingLabel setFrame:thankYouRect];
    [_pointsLabel         setFrame:pointsLabelRect];
    [_userPointsLabel     setFrame:userPointsLabelRect];
    [_totalPointsLabel    setFrame:totalPointsLabelRect];
    [_shareLabel          setFrame:shareLabelRect];
    [_facebookButton      setFrame:facebookButtonRect];
    [_twitterButton       setFrame:twitterButtonRect];
    
    if (_challengeType == ONETIME){
        [_oneTimeButton setFrame:buttonRect];
    }else { //REPEAT
        [_calendarButton setFrame:buttonRect];
        [_calendarContainerView setFrame:_CalendarFrameHide];
        
        _calendarToolBar.frame = CGRectMake(0,0, _calendarContainerView.frame.size.width, barHeight);
        _calendarView.frame = CGRectMake(0, barHeight, _calendarContainerView.frame.size.width, _calendarContainerView.frame.size.height - barHeight);
    }
    
    
    
}// end layout subviews


/**************************************************************************************************
 *
 *                          methods to allow easy access from the controller
 *
 **************************************************************************************************/
- (void) setChallengeTeaser:(NSString*)teaser andDescription:(NSString*)description
{
    [_teaserLabel setText:teaser];
    [_descriptionLabel setText: description];
    
    [self setNeedsDisplay];
    
}

- (void) updatePointsForChallenge:(int)userPoints andChallengePoints:(int)challengePoints
{
    NSString* userPointsString = [NSString stringWithFormat:@"%d ",userPoints];
    NSString* challengePointsString = [NSString stringWithFormat:@"/ %d",challengePoints];
    [_userPointsLabel setText:userPointsString];
    [_totalPointsLabel setText:challengePointsString];
    
    [self setNeedsDisplay];
}


- (void) toggleCheckBox
{
    _oneTimeButton.selected = !_oneTimeButton.selected;
    [self setNeedsDisplay];
    
}//end toggleChekcBox

- (BOOL)oneTimeBoxIsSelected
{
    return _oneTimeButton.selected;
}

- (void) showCalendarView
{
    
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    _calendarContainerView.frame = _CalendarFrameShow;
    
    [UIView commitAnimations];
    
}//end showORHidePickerView

- (void) hideCalendarView
{
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _calendarContainerView.frame = _CalendarFrameHide;
    
    [UIView commitAnimations];
    
}

- (void) setCalendar:(int)monthFirstDay numDays:(int)numDays daysCompleted:(NSMutableArray*)daysCompleted andMonthString:(NSString*)monthString
{
    [_calendarView setCalendar:monthFirstDay numDays:numDays daysCompleted:daysCompleted andMonthString:monthString];
}

- (void)setButtonToSelectedState:(int)buttonID
{
    [_calendarView setButtonToSelectedState:buttonID];
}

- (void)setButtonToUnselectedState:(int)buttonID
{
    [_calendarView setButtonToUnselectedState:buttonID];
}

- (void) setComponentsToComplete
{
    _submitButton.hidden = true;
    [_completeLabel setText:@"Complete!"];
    _thanksForParticipatingLabel.hidden = false;
     
    if (_challengeType == ONETIME)
    {
        [_oneTimeButton setImage:[_appConstants getCheckboxFullIcon] forState:UIControlStateNormal];
        //_oneTimeButton.selected = true;
        _oneTimeButton.enabled = false;
    }else{ //REPEAT

        _calendarButton.enabled = false;
    }
    [self setNeedsDisplay];
    
}

- (void) setComponentsToInComplete
{
    _submitButton.hidden = false;
    [_completeLabel setText:@"Complete?"];
    _thanksForParticipatingLabel.hidden = true;
    
    if (_challengeType == ONETIME)
    {
        _oneTimeButton.selected = false;
        [_oneTimeButton setImage:[_appConstants getCheckboxEmptyIcon] forState:UIControlStateNormal];
        _oneTimeButton.enabled = true;
    }else{ //REPEAT
        _calendarButton.enabled = true;
    }
    [self setNeedsDisplay];
    
}

- (void) setCalendarMonthAndYear:(NSString*)monthAndYearString
{
    [_monthDisplayButton setTitle:monthAndYearString forState:UIControlStateNormal];
}

//- (void) setCalendarDelegate:(id)delegate
//{
//    [_calendarView setCalendarViewDelegate:delegate];
//}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
