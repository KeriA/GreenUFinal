//
//  UUTeamsView.m
//  UUGreenU
//
//  Created by Keri Anderson on 2/11/14.
//  Copyright (c) 2014 University of Utah. All rights reserved.
//

#import "UUTeamsView.h"

@implementation UUTeamsView
{
    UILabel* _teamsLabel;
    UILabel* _currentTeamLabel;
    UITextField* _teamTextField;
    UIButton* _schoolButton;
    UIButton* _businessButton;
    UIButton* _otherButton;

    UILabel* _createYourOwnLabel;
    CGRect _newTeamOriginalFrame;
    CGRect _newTeamLiftedFrame;
    UIView* _newTeamTextFieldFrameView;
    UITextField* _newTeamTextField;
    UILabel* _categoryLabel;
    UILabel* _schoolLabel;
    UILabel* _businessLabel;
    UILabel* _otherLabel;
    UIButton* _newTeamSchoolButton;
    UIButton* _newTeamBusinessButton;
    UIButton* _newTeamOtherButton;
    
    UIButton* _requestNewTeamButton;
    
    
    //for pickerview
    UIView*       _pickerViewFrameView;
    UIPickerView* _schoolPickerView;
    UIPickerView* _businessPickerView;
    UIPickerView* _otherPickerView;
    UIToolbar*    _pickerToolBar;
    UIButton*     _doneButton;
    UIButton*     _selectTeamButton;
    
    CGRect _pickerFrameSchoolShow;
    CGRect _pickerFrameBusinessShow;
    CGRect _pickerFrameOtherShow;
    CGRect _pickerFrameHide;

    
    
    UIColor* _darkGrayColor;
}

@synthesize teamsViewDelegate;


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
        _teamsLabel = [[UILabel alloc] init];
        [_teamsLabel setBackgroundColor:[UIColor clearColor]];
        [_teamsLabel setText:@"Teams"];
        [_teamsLabel setTextColor:[UIColor whiteColor]];
        [_teamsLabel setFont:[_appConstants getBoldFontWithSize:TOPLABELFONTSIZE]];
        [_teamsLabel setTextAlignment:NSTextAlignmentLeft];
        [_teamsLabel setNumberOfLines:1];
        [_teamsLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        _currentTeamLabel = [[UILabel alloc] init];
        [_currentTeamLabel setBackgroundColor:[UIColor clearColor]];
        [_currentTeamLabel setText:@"Current team"];
        [_currentTeamLabel setTextColor:[UIColor whiteColor]];
        [_currentTeamLabel setFont:[_appConstants getStandardFontWithSize:13.0]];
        [_currentTeamLabel setTextAlignment:NSTextAlignmentLeft];
        [_currentTeamLabel setNumberOfLines:1];
        [_currentTeamLabel setLineBreakMode:NSLineBreakByWordWrapping];

        // create the textfields and set its delegates
        _teamTextField = [[UITextField alloc] init];
        _teamTextField.placeholder = @"";
        _teamTextField.backgroundColor = [UIColor grayColor];
        _teamTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _teamTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _teamTextField.font = [_appConstants getStandardFontWithSize:12.0];
        _teamTextField.borderStyle = UITextBorderStyleRoundedRect;
        _teamTextField.keyboardType = UIKeyboardTypeAlphabet;
        _teamTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _teamTextField.returnKeyType = UIReturnKeyDone;
        _teamTextField.textAlignment = NSTextAlignmentLeft;
        _teamTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _teamTextField.tag = TEAMTAG;  // used to identify this text field in the delegate methods
        _teamTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _teamTextField.layer.borderWidth = 0.0;

   
        // rounded rect button
        _schoolButton = [[UIButton alloc]init];
        _schoolButton.layer.borderWidth = .06f; // these two lines
        _schoolButton.layer.cornerRadius = 6;   // round the corners
        [_schoolButton setImage:[_appConstants getDownIconForButton] forState:UIControlStateNormal];
        [_schoolButton setTitle:@"School" forState:UIControlStateNormal];
        [_schoolButton setBackgroundColor:[_appConstants cherryRedColor]];
        [_schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _schoolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_schoolButton.titleLabel setFont:[_appConstants getBoldFontWithSize:18]];
        [_schoolButton addTarget: teamsViewDelegate
                                  action:@selector(schoolButtonWasPressed)
                        forControlEvents:UIControlEventTouchDown];
        
        // rounded rect button
        _businessButton = [[UIButton alloc]init];
        _businessButton.layer.borderWidth = .06f; // these two lines
        _businessButton.layer.cornerRadius = 6;   // round the corners
        [_businessButton setImage:[_appConstants getDownIconForButton] forState:UIControlStateNormal];
        [_businessButton setTitle:@"Business" forState:UIControlStateNormal];
        [_businessButton setBackgroundColor:[_appConstants mustardYellowColor]];
        [_businessButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _businessButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_businessButton.titleLabel setFont:[_appConstants getBoldFontWithSize:18]];
        [_businessButton addTarget: teamsViewDelegate
                          action:@selector(businessButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];
        

        // rounded rect button
        _otherButton = [[UIButton alloc]init];
        _otherButton.layer.borderWidth = .06f; // these two lines
        _otherButton.layer.cornerRadius = 6;   // round the corners
        [_otherButton setImage:[_appConstants getDownIconForButton] forState:UIControlStateNormal];
        [_otherButton setTitle:@"Other" forState:UIControlStateNormal];
        [_otherButton setBackgroundColor:[_appConstants brightGreenColor]];
        [_otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _otherButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_otherButton.titleLabel setFont:[_appConstants getBoldFontWithSize:18]];
        [_otherButton addTarget: teamsViewDelegate
                          action:@selector(otherButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];
        

        _createYourOwnLabel = [[UILabel alloc] init];
        [_createYourOwnLabel setBackgroundColor:[UIColor clearColor]];
        [_createYourOwnLabel setText:@"Create your own"];
        [_createYourOwnLabel setTextColor:[UIColor whiteColor]];
        [_createYourOwnLabel setFont:[_appConstants getStandardFontWithSize:15.0]];
        [_createYourOwnLabel setTextAlignment:NSTextAlignmentLeft];
        [_createYourOwnLabel setNumberOfLines:1];
        [_createYourOwnLabel setLineBreakMode:NSLineBreakByWordWrapping];

   
        _newTeamTextFieldFrameView = [[UIView alloc]init];
        _newTeamTextFieldFrameView .backgroundColor = [UIColor clearColor];
        

        
        // create the textfields and set its delegates
        _newTeamTextField = [[UITextField alloc] init];
        _newTeamTextField.placeholder = @"Enter New Team Name";
        _newTeamTextField.backgroundColor = [UIColor grayColor];
        _newTeamTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _newTeamTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _newTeamTextField.font = [_appConstants getStandardFontWithSize:12.0];
        _newTeamTextField.borderStyle = UITextBorderStyleRoundedRect;
        _newTeamTextField.keyboardType = UIKeyboardTypeAlphabet;
        _newTeamTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newTeamTextField.returnKeyType = UIReturnKeyDone;
        _newTeamTextField.textAlignment = NSTextAlignmentLeft;
        _newTeamTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _newTeamTextField.tag = NEWTEAMTAG;  // used to identify this text field in the delegate methods
        _newTeamTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _newTeamTextField.layer.borderWidth = 0.0;

        
        _categoryLabel = [[UILabel alloc] init];
        [_categoryLabel setBackgroundColor:[UIColor clearColor]];
        [_categoryLabel setText:@"Category:"];
        [_categoryLabel setTextColor:[UIColor whiteColor]];
        [_categoryLabel setFont:[_appConstants getStandardFontWithSize:12.0]];
        [_categoryLabel setTextAlignment:NSTextAlignmentLeft];
        [_categoryLabel setNumberOfLines:1];
        [_categoryLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        _schoolLabel = [[UILabel alloc] init];
        [_schoolLabel setBackgroundColor:[UIColor clearColor]];
        [_schoolLabel setText:@"School"];
        [_schoolLabel setTextColor:[UIColor whiteColor]];
        [_schoolLabel setFont:[_appConstants getStandardFontWithSize:10.0]];
        [_schoolLabel setTextAlignment:NSTextAlignmentRight];
        [_schoolLabel setNumberOfLines:1];
        [_schoolLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        _businessLabel = [[UILabel alloc] init];
        [_businessLabel setBackgroundColor:[UIColor clearColor]];
        [_businessLabel setText:@"Business"];
        [_businessLabel setTextColor:[UIColor whiteColor]];
        [_businessLabel setFont:[_appConstants getStandardFontWithSize:10.0]];
        [_businessLabel setTextAlignment:NSTextAlignmentRight];
        [_businessLabel setNumberOfLines:1];
        [_businessLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        _otherLabel = [[UILabel alloc] init];
        [_otherLabel setBackgroundColor:[UIColor clearColor]];
        [_otherLabel setText:@"Other"];
        [_otherLabel setTextColor:[UIColor whiteColor]];
        [_otherLabel setFont:[_appConstants getStandardFontWithSize:10.0]];
        [_otherLabel setTextAlignment:NSTextAlignmentRight];
        [_otherLabel setNumberOfLines:1];
        [_otherLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        
        //this button just looks like a picture
        _newTeamSchoolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_newTeamSchoolButton setImage: [_appConstants getCheckboxEmptyIcon] forState:UIControlStateNormal];
        [_newTeamSchoolButton setImage: [_appConstants getCheckboxFullIcon] forState:UIControlStateSelected];
        _newTeamSchoolButton.selected = false;
        _newTeamSchoolButton.tag = SCHOOLBUTTONTAG;
        // set the text properties
        _newTeamSchoolButton.backgroundColor = [UIColor clearColor];
        [_newTeamSchoolButton setTitle:@"" forState:UIControlStateNormal];
        [_newTeamSchoolButton addTarget: teamsViewDelegate
                            action:@selector(newTeamCheckBoxButtonWasPressed:)
                  forControlEvents:UIControlEventTouchDown];
        
        //this button just looks like a picture
        _newTeamBusinessButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_newTeamBusinessButton setImage: [_appConstants getCheckboxEmptyIcon] forState:UIControlStateNormal];
        [_newTeamBusinessButton setImage: [_appConstants getCheckboxFullIcon] forState:UIControlStateSelected];
        _newTeamBusinessButton.selected = false;
        _newTeamBusinessButton.tag = BUSINESSBUTTONTAG;
        // set the text properties
        _newTeamBusinessButton.backgroundColor = [UIColor clearColor];
        [_newTeamBusinessButton setTitle:@"" forState:UIControlStateNormal];
        [_newTeamBusinessButton addTarget: teamsViewDelegate
                                 action:@selector(newTeamCheckBoxButtonWasPressed:)
                       forControlEvents:UIControlEventTouchDown];
        
        //this button just looks like a picture
        _newTeamOtherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_newTeamOtherButton setImage: [_appConstants getCheckboxEmptyIcon] forState:UIControlStateNormal];
        [_newTeamOtherButton setImage: [_appConstants getCheckboxFullIcon] forState:UIControlStateSelected];
        _newTeamOtherButton.selected = false;
        _newTeamOtherButton.tag = OTHERBUTTONTAG;
        // set the text properties
        _newTeamOtherButton.backgroundColor = [UIColor clearColor];
        [_newTeamOtherButton setTitle:@"" forState:UIControlStateNormal];
        [_newTeamOtherButton addTarget: teamsViewDelegate
                                 action:@selector(newTeamCheckBoxButtonWasPressed:)
                       forControlEvents:UIControlEventTouchDown];

        
        // rounded rect button
        _requestNewTeamButton = [[UIButton alloc]init];
        _requestNewTeamButton.layer.borderWidth = .06f; // these two lines
        _requestNewTeamButton.layer.cornerRadius = 6;   // round the corners
        [_requestNewTeamButton setTitle:@"Request New Team" forState:UIControlStateNormal];
        [_requestNewTeamButton setBackgroundColor:[_appConstants cherryRedColor]];
        [_requestNewTeamButton.titleLabel setFont:[_appConstants getBoldFontWithSize:15]];
        [_requestNewTeamButton.titleLabel setTextColor:[UIColor whiteColor]];
        [_requestNewTeamButton addTarget: teamsViewDelegate
                          action:@selector(requestNewTeamButtonWasPressed)
                forControlEvents:UIControlEventTouchDown];
        
        
        //_pickerViewFrameView holds all the needed components for the picker
        _pickerViewFrameView = [[UIView alloc]init];
        //_pickerViewFrameView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.6]; //semi-transparent black
        //_pickerViewFrameView.backgroundColor = [UIColor blackColor]; //semi-transparent black
        _pickerViewFrameView.backgroundColor = [UIColor colorWithPatternImage: [_appConstants getBackgroundImage]]; //semi-transparent black
        
        _pickerToolBar = [[UIToolbar alloc]init];
        _pickerToolBar.tintColor = [UIColor whiteColor];  //text color
        _pickerToolBar.barTintColor = [UIColor blackColor];  //background color
        
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setFrame:CGRectMake(0.0, 0.0, 45.0, 25.0)];
        [_doneButton addTarget:teamsViewDelegate action:@selector(pickerDoneButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setBackgroundImage:[_appConstants getPickerDoneImage] forState:UIControlStateNormal];
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:[_appConstants getBoldFontWithSize:15.0]];
        UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithCustomView:_doneButton];
        
        _selectTeamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectTeamButton setFrame:CGRectMake(0.0, 0.0, 90.0, 25.0)];
        [_selectTeamButton addTarget:teamsViewDelegate action:@selector(joinTeamButtonWasPressed) forControlEvents:UIControlEventTouchUpInside];
        [_selectTeamButton setBackgroundColor:[UIColor clearColor]];
        [_selectTeamButton setTitle:@"Select team" forState:UIControlStateNormal];
        [_selectTeamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_selectTeamButton .titleLabel setFont:[_appConstants getItalicsFontWithSize:15.0]];
        UIBarButtonItem* selectItem = [[UIBarButtonItem alloc] initWithCustomView:_selectTeamButton];

        //this button item is used only to force the 'done' button to the right side
        UIBarButtonItem* flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        NSArray* items = [[NSArray alloc]initWithObjects:selectItem, flexibleSpaceLeft, doneItem, nil];
        [_pickerToolBar setItems:items];
        
        _schoolPickerView = [[UIPickerView alloc] init];
        _schoolPickerView.showsSelectionIndicator = YES;
        _schoolPickerView.tag = SCHOOLBUTTONTAG;
        
        _businessPickerView = [[UIPickerView alloc] init];
        _businessPickerView.showsSelectionIndicator = YES;
        _businessPickerView.tag = BUSINESSBUTTONTAG;
        
        _otherPickerView = [[UIPickerView alloc] init];
        _otherPickerView.showsSelectionIndicator = YES;
        _otherPickerView.tag = OTHERBUTTONTAG;
  
        [_pickerViewFrameView addSubview:_pickerToolBar];
        [_pickerViewFrameView addSubview:_schoolPickerView];
        [_pickerViewFrameView addSubview:_businessPickerView];
        [_pickerViewFrameView addSubview:_otherPickerView];
        
        
        [self addSubview: _teamsLabel];
        [self addSubview: _currentTeamLabel];
        [self addSubview: _teamTextField];
        [self addSubview: _createYourOwnLabel];
        [self addSubview: _businessButton];
        [self addSubview: _schoolButton];
        [self addSubview: _otherButton];

        [self addSubview: _categoryLabel];
        [self addSubview: _schoolLabel];
        [self addSubview: _businessLabel];
        [self addSubview: _otherLabel];
        [self addSubview: _newTeamSchoolButton];
        [self addSubview: _newTeamBusinessButton];
        [self addSubview: _newTeamOtherButton];
        [self addSubview: _requestNewTeamButton];

        //order of adding subviews matters here for pop-up components
        [_newTeamTextFieldFrameView addSubview:_newTeamTextField];
        [self addSubview:_newTeamTextFieldFrameView];

        [self addSubview: _pickerViewFrameView];

        
        
        CGFloat colorValue = 0.3;
        _darkGrayColor = [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1.0];

        
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
    CGFloat originalHeight = bounds.size.height; //for use later
    //NSLog(@"width is %f and height is %f", bounds.size.width, bounds.size.height);//for testing
    
    //first, remove a strip off of the top to make room for the navigation controller
    bounds.size.height = bounds.size.height - (TOPMARGIN * 1.5);  //1.5 x so we remove a strip off of the bottom as well
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
    //CGRect insetBounds  = CGRectInset(bounds, bounds.size.width * 0.0, 0.0);
    
    //create the top label margin  (for consistency across pages)
    CGRect topLabelRect = CGRectMake(insetBounds.origin.x, insetBounds.origin.y, insetBounds.size.width, TOPLABELHEIGHT);
    
    //now adjust the inset bounds
    insetBounds.origin.y = insetBounds.origin.y + TOPLABELHEIGHT;  // this can be adjusted as needed per frame
    insetBounds.size.height = insetBounds.size.height - TOPLABELHEIGHT;
    
    
    
    /***  REMAINING RECTS  ***/
    // the specific rects that will be used for subviews

    CGRect topRect;  //for the Current Team info
    CGRect spacerRect;
    CGRect middleRect;  // for the "School", "Business", "Other" buttons
    CGRect bottomRect;  //for "Create your own", ect
 
    CGRect currentTeamLabelRect;
    CGRect currentTeamTextFieldRect;
    CGRect schoolButtonRect;
    CGRect businessButtonRect;
    CGRect otherButtonRect;
    CGRect createYourOwnLabelRect;
    CGRect categoryRect;
    CGRect schoolLabelRect;
    CGRect businessLabelRect;
    CGRect otherLabelRect;
    CGRect newTeamSchoolButtonRect;
    CGRect newTeamBusinessButtonRect;
    CGRect newTeamOtherButtonRect;
    CGRect requestNewTeamButtonRect;
    
    
    CGRectDivide(insetBounds, &topRect, &middleRect, bounds.size.height/ 8.0, CGRectMinYEdge);
    CGRectDivide(topRect, &currentTeamLabelRect, &spacerRect, topRect.size.height / 2.0, CGRectMinYEdge);
    CGRectDivide(middleRect, &middleRect, &bottomRect, middleRect.size.height/ 1.8, CGRectMinYEdge);
    
    //top rect
    CGRectDivide(currentTeamLabelRect, &currentTeamLabelRect, &currentTeamTextFieldRect, currentTeamLabelRect.size.width/3.0, CGRectMinXEdge);
    //currentTeamLabelRect.size.height = currentTeamLabelRect.size.height / 2.2;
    //CGRectDivide(currentTeamLabelRect, &currentTeamLabelRect, &currentTeamTextFieldRect, currentTeamLabelRect.size.width/3.0, CGRectMinXEdge);
    
    //middle rect
    //shorten the middle rect a bit
    CGFloat middleShortenAmount = 20.0;
    middleRect.size.height = middleRect.size.height - middleShortenAmount;
    CGRectDivide(middleRect, &schoolButtonRect, &businessButtonRect, middleRect.size.height/3.0, CGRectMinYEdge);
    CGRectDivide(businessButtonRect, &businessButtonRect, &otherButtonRect, businessButtonRect.size.height/2.0, CGRectMinYEdge);
    CGFloat buttonHeight = schoolButtonRect.size.height / 1.5;
    schoolButtonRect.size.height = buttonHeight;
    businessButtonRect.size.height = buttonHeight;
    otherButtonRect.size.height = buttonHeight;
    
    //bottom rect
    CGRectDivide(bottomRect, &createYourOwnLabelRect, &_newTeamOriginalFrame, bottomRect.size.height/5.0, CGRectMinYEdge);
    CGRectDivide(_newTeamOriginalFrame, &_newTeamOriginalFrame, &categoryRect, _newTeamOriginalFrame.size.height / 4.0, CGRectMinYEdge);
    CGRectDivide(categoryRect, &categoryRect, &requestNewTeamButtonRect, categoryRect.size.height / 2.0, CGRectMinYEdge);
    // create the lifted textfield rect
    CGFloat keyboardHeight = 216.0;
    _newTeamLiftedFrame = CGRectMake(_newTeamOriginalFrame.origin.x, originalHeight - (keyboardHeight + _newTeamOriginalFrame.size.height), _newTeamOriginalFrame.size.width, _newTeamOriginalFrame.size.height);
    
    
    //shorten the category rect a bit
    CGFloat catShortenAmount = 15.0;
    categoryRect.size.height = categoryRect.size.height - catShortenAmount;
    
    CGRectDivide(categoryRect, &categoryRect, &schoolLabelRect, categoryRect.size.width/ 4.3, CGRectMinXEdge);
    CGRectDivide(schoolLabelRect, &schoolLabelRect, &businessLabelRect, schoolLabelRect.size.width/3.1, CGRectMinXEdge);
    CGRectDivide((businessLabelRect), &businessLabelRect, &otherLabelRect, businessLabelRect.size.width/1.8, CGRectMinXEdge);
    //set the size for the check buttons.
    CGFloat checkButtonSize = categoryRect.size.height;
    schoolLabelRect.size.width = schoolLabelRect.size.width - checkButtonSize;
    newTeamSchoolButtonRect.origin.y = schoolLabelRect.origin.y;
    newTeamSchoolButtonRect.origin.x = schoolLabelRect.origin.x + schoolLabelRect.size.width;
    newTeamSchoolButtonRect.size.height = checkButtonSize;
    newTeamSchoolButtonRect.size.width = checkButtonSize;
    
    businessLabelRect.size.width = businessLabelRect.size.width - checkButtonSize;
    newTeamBusinessButtonRect.origin.y = businessLabelRect.origin.y;
    newTeamBusinessButtonRect.origin.x = businessLabelRect.origin.x + businessLabelRect.size.width;
    newTeamBusinessButtonRect.size.width = checkButtonSize;
    newTeamBusinessButtonRect.size.height = checkButtonSize;
    
    otherLabelRect.size.width = otherLabelRect.size.width - checkButtonSize;
    newTeamOtherButtonRect.origin.x = otherLabelRect.origin.x + otherLabelRect.size.width;
    newTeamOtherButtonRect.origin.y = otherLabelRect.origin.y;
    newTeamOtherButtonRect.size.width = checkButtonSize;
    newTeamOtherButtonRect.size.height = checkButtonSize;

    
    //shorten the request team rect
    CGFloat requestShortenAmount = 12.0;
    requestNewTeamButtonRect.size.height = requestNewTeamButtonRect.size.height - requestShortenAmount;
    
    
    
    // set the frames
    [_teamsLabel            setFrame:topLabelRect];
    
    
    [_currentTeamLabel           setFrame:currentTeamLabelRect];
    [_teamTextField              setFrame:currentTeamTextFieldRect];
    [_schoolButton               setFrame:schoolButtonRect];
    [_businessButton             setFrame:businessButtonRect];
    [_otherButton                setFrame:otherButtonRect];
    [_createYourOwnLabel         setFrame:createYourOwnLabelRect];
    [_newTeamTextFieldFrameView  setFrame:_newTeamOriginalFrame];
    [_categoryLabel              setFrame:categoryRect];
    [_schoolLabel                setFrame:schoolLabelRect];
    [_businessLabel              setFrame:businessLabelRect];
    [_otherLabel                 setFrame:otherLabelRect];
    [_newTeamSchoolButton        setFrame:newTeamSchoolButtonRect];
    [_newTeamBusinessButton      setFrame:newTeamBusinessButtonRect];
    [_newTeamOtherButton         setFrame: newTeamOtherButtonRect];
    [_requestNewTeamButton       setFrame:requestNewTeamButtonRect];
    
    _newTeamTextField.frame = CGRectMake(0, 0, _newTeamOriginalFrame.size.width, _newTeamOriginalFrame.size.height);

    //now that we know the frames, set the insets - this puts the image on the right side of the button
    CGFloat imageWidth = 35.0;
    _schoolButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, _schoolButton.frame.size.width - imageWidth, 0.0, 0.0);
    _schoolButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, imageWidth);
    
    _businessButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, _businessButton.frame.size.width - imageWidth, 0.0, 0.0);
    _businessButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, imageWidth);

    
    _otherButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, _otherButton.frame.size.width - imageWidth, 0.0, 0.0);
    _otherButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, imageWidth);


    //Now that we have the large school/business/other buttons, create the show/hide pickerview frames
    CGFloat pickerFrameHeight = 220.0;
    CGFloat pickerFrameWidth = insetBounds.size.width;
    CGFloat pickerX = insetBounds.origin.x;
    CGFloat pickerFrameHideY = bounds.origin.y + bounds.size.height + (TOPMARGIN * 1.5);

    _pickerFrameSchoolShow   = CGRectMake(pickerX, schoolButtonRect.origin.y   + schoolButtonRect.size.height,   pickerFrameWidth, pickerFrameHeight);
    _pickerFrameBusinessShow = CGRectMake(pickerX, businessButtonRect.origin.y + businessButtonRect.size.height, pickerFrameWidth, pickerFrameHeight);
    _pickerFrameOtherShow    = CGRectMake(pickerX, otherButtonRect.origin.y    + otherButtonRect.size.height,    pickerFrameWidth, pickerFrameHeight);
    
    _pickerFrameHide         = CGRectMake(pickerX, pickerFrameHideY, pickerFrameWidth, pickerFrameHeight);
    

    
    [_pickerViewFrameView  setFrame:_pickerFrameHide];
      CGFloat toolbarHeight = 44;
    _pickerToolBar.frame = CGRectMake(0,0, _pickerViewFrameView.frame.size.width, toolbarHeight);
    _schoolPickerView.frame = CGRectMake(0, toolbarHeight, _pickerViewFrameView.frame.size.width, _pickerViewFrameView.frame.size.height - toolbarHeight);
    _businessPickerView.frame = CGRectMake(0, toolbarHeight, _pickerViewFrameView.frame.size.width, _pickerViewFrameView.frame.size.height - toolbarHeight);
    _otherPickerView.frame = CGRectMake(0, toolbarHeight, _pickerViewFrameView.frame.size.width, _pickerViewFrameView.frame.size.height - toolbarHeight);
  
    
}// end layout subviews

/**************************************************************************************************
 *
 *                          Set delegate for the text fields and picker view
 *
 **************************************************************************************************/
#pragma - mark setSubviewDelegates
/***
 *  This method is used for easy access to the subviews by the controller.
 *  The method is called by the controller in the 'view did load' method
 *
 */
-(void) setTextFieldDelegates:(id)delegate
{
    
    [_teamTextField setDelegate:delegate];
    [_newTeamTextField  setDelegate:delegate];
    
    
}// end set delegates

- (void) setPickerDataSource:(id<UIPickerViewDataSource>)pickerDataSource
{
    [_schoolPickerView setDataSource:pickerDataSource];
    [_businessPickerView setDataSource:pickerDataSource];
    [_otherPickerView setDataSource:pickerDataSource];
}


- (void) setPickerDelegate:(id<UIPickerViewDelegate>)pickerDelegate
{
    [_schoolPickerView setDelegate:pickerDelegate];
    [_businessPickerView setDelegate:pickerDelegate];
    [_otherPickerView setDelegate:pickerDelegate];
}


/**************************************************************************************************
 *
 *                          access methods for the controller
 *
 **************************************************************************************************/
- (void) setSchoolButtonPressedResults
{
    _newTeamSchoolButton.selected = true;
    _newTeamBusinessButton.selected = false;
    _newTeamOtherButton.selected = false;
    
    [self setNeedsDisplay];
}

- (void) setBusinessButtonPressedResults
{
    _newTeamSchoolButton.selected = false;
    _newTeamBusinessButton.selected = true;
    _newTeamOtherButton.selected = false;
    
    [self setNeedsDisplay];
}

- (void) setOtherButtonPressedResults
{
    _newTeamSchoolButton.selected = false;
    _newTeamBusinessButton.selected = false;
    _newTeamOtherButton.selected = true;
    
    [self setNeedsDisplay];
}

- (void) setCurrentTeam:(NSString*)currentTeam
{
    _teamTextField.text = currentTeam;
    [self setNeedsDisplay];
}


- (void) disableSchoolsButton
{
    _schoolButton.enabled = false;
    [_schoolButton setBackgroundColor:[UIColor clearColor]];
    [_schoolButton setBackgroundImage:[_appConstants getNonActiveTeamsImageRed] forState:UIControlStateDisabled];
    [self setNeedsDisplay];
   
}

- (void) enableSchoolsButton
{
    _schoolButton.enabled = true;
    [_schoolButton setBackgroundColor:[_appConstants cherryRedColor]];
    [self setNeedsDisplay];
}

- (void) disableBusinessButton
{
    _businessButton.enabled = false;
    [_businessButton setBackgroundColor:[UIColor clearColor]];
    [_businessButton setBackgroundImage:[_appConstants getNonActiveTeamsImageYellow] forState:UIControlStateDisabled];
    [self setNeedsDisplay];
    
}

- (void) enableBusinessButton
{
    _businessButton.enabled = true;
    [_businessButton setBackgroundColor:[_appConstants mustardYellowColor]];
    [self setNeedsDisplay];
}


- (void) disableOtherButton
{
    _otherButton.enabled = false;
    [_otherButton setBackgroundColor:[UIColor clearColor]];
    [_otherButton setBackgroundImage:[_appConstants getNonActiveTeamsImageGreen] forState:UIControlStateDisabled];
    [self setNeedsDisplay];
    
}

- (void) enableOtherButton
{
    _otherButton.enabled = true;
    [_otherButton setBackgroundColor:[_appConstants brightGreenColor]];
    [self setNeedsDisplay];
}

- (void) enableLowerButtons
{
   
    _requestNewTeamButton.enabled = true;
    [_requestNewTeamButton setBackgroundColor:[_appConstants cherryRedColor]];
    [_requestNewTeamButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _newTeamTextField.enabled = true;
    _newTeamSchoolButton.enabled = true;
    _newTeamBusinessButton.enabled = true;
    _newTeamOtherButton.enabled = true;
    
    [self setNeedsDisplay];
}

- (void) disableLowerButtons
{
    
    _requestNewTeamButton.enabled = false;
    [_requestNewTeamButton setBackgroundColor:[UIColor clearColor]];
    [_requestNewTeamButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    [_requestNewTeamButton setBackgroundImage:[_appConstants getNonActiveTeamsImageRed] forState:UIControlStateDisabled];
    
    _newTeamTextField.enabled = false;
    _newTeamSchoolButton.enabled = false;
    _newTeamBusinessButton.enabled = false;
    _newTeamOtherButton.enabled = false;

    [self setNeedsDisplay];
}

- (void) resetTextFieldColor
{
    _newTeamTextField.backgroundColor = [UIColor grayColor];
}

- (void) showPickerView: (int) atLocation
{
    
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    if (atLocation == 1) //school
        _pickerViewFrameView.frame = _pickerFrameSchoolShow;
    else if (atLocation == 2)
        _pickerViewFrameView.frame = _pickerFrameBusinessShow;
    else
        _pickerViewFrameView.frame = _pickerFrameOtherShow;
    
    [UIView commitAnimations];
    
}//end showORHidePickerView

- (void) hidePickerView
{
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _pickerViewFrameView.frame = _pickerFrameHide;
    
    [UIView commitAnimations];
    
}


- (void) liftTextField
{
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _newTeamTextFieldFrameView.frame = _newTeamLiftedFrame;
    
    [UIView commitAnimations];
    
   
}

- (void) returnTextField
{
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    _newTeamTextFieldFrameView.frame = _newTeamOriginalFrame;
    
    [UIView commitAnimations];

}

- (bool) categorySelected
{
    if (_newTeamSchoolButton.selected == false && _newTeamBusinessButton.selected == false && _newTeamOtherButton.selected == false)
        return false;
    else
        return true;
}

- (int) teamNameLength
{
    
    int textLength = (int)_newTeamTextField.text.length;
    
    //make sure not all spaces
    int realCharacterCount = 0;
    
    for (int i = 0; i < textLength; i++)
    {
        char currentChar;
        currentChar = [_newTeamTextField.text characterAtIndex:i];
        
        if (currentChar != ' ')
            realCharacterCount++;
    }
    
    return realCharacterCount;
}

-(NSString*) getNewTeamName
{
    return _newTeamTextField.text;
}

-(NSString*) getNewTeamType
{
    if (_newTeamSchoolButton.selected)
    {
        return @"SCHOOL";
    }else if (_newTeamBusinessButton.selected)
    {
        return @"BUSINESS";
    }else
    {
        return @"OTHER";
    }
}//end getNewTeamType


-(void) setPickersForCategory:(int)category
{
    if (category == SCHOOLBUTTONTAG){
        _schoolPickerView.hidden = false;
        _businessPickerView.hidden = true;
        _otherPickerView.hidden = true;
        
    }else if (category == BUSINESSBUTTONTAG){
        _schoolPickerView.hidden = true;
        _businessPickerView.hidden = false;
        _otherPickerView.hidden = true;
        
    }else{ //other
        _schoolPickerView.hidden = true;
        _businessPickerView.hidden = true;
        _otherPickerView.hidden = false;
       
    }
    
}

/**************************************************************************************************
 *
 *                          Draw Rect
 *
 **************************************************************************************************/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
