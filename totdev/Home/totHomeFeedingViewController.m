//
//  totHomeFeedingViewController.m
//  totdev
//
//  Created by Yifei Chen on 5/6/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "AppDelegate.h"
#import "totHomeFeedingViewController.h"
#import "totEventName.h"
#import "totEvent.h"
#import "../Utility/totUtility.h"
#import "../Utility/totImageView.h"

#define DEFAULT_QUANTITY  2  //magic number

@implementation totHomeFeedingViewController

@synthesize homeRootController;

#pragma mark - init and aux
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mTotModel = global.model;
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - component response
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)sliderView:(totSliderView*)sv buttonPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag] - 1;
   
    if (sv == mCategoriesSlider) {
        // show a new panel with food slider and picker and ok button
        mChooseFoodView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 260)];
        mChooseFoodView.backgroundColor = [UIColor clearColor];
        mChooseFoodView.alpha = 1.0;
        [self.view addSubview:mChooseFoodView];
        
        // background
        totImageView* popUpBackground = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        [popUpBackground imageFilePath:@"feeding-popup.png"];
        [mChooseFoodView addSubview:popUpBackground];
        [popUpBackground release];
        
        if(tag == 0) categoryChosen = @"cereal";
        else if(tag == 1) categoryChosen = @"dairy";
        else if(tag == 2) categoryChosen = @"fruit";
        else if(tag == 3) categoryChosen = @"juice";
        else if(tag == 4) categoryChosen = @"meat";
        else if(tag == 5) categoryChosen = @"vegetable";
        else categoryChosen = @"cereal";
        
        [self createChooseFoodPanel];
    } else if (sv == mRecentlyUsedSlider) {
    } else if (sv == mChooseFoodSlider) {
        foodSelected = tag;
        
        // show input box
        /*
        text_quantity.placeholder = @"Quantity?";
        [text_quantity setHidden:false];
         */
        
        [mQuantity show];
        
    } else if (sv == mFoodChosenSlider) {
        [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
    }
}

- (void) backButtonClicked:(UIButton *)button {
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

- (void)OKButtonClicked: (UIButton *)button {
    NSLog(@"%@", @"[feeding] ok button clicked");
    
    // do nothing if no food chosen
    // maybe we should give some prompt?
    if([foodChosenList count] == 0) return;
    
    int baby_id = global.baby.babyID;
    NSDate* date = [NSDate date];
    
    NSMutableString* summary = [NSMutableString stringWithFormat:@"**%@", mDatetime.titleLabel.text];
    NSLog(@"%@", summary);

    //generate summary
    if([foodChosenList count] > 0) {
        for(int i = 0; i < [foodChosenList count]; i++) {
            NSString* temp = [NSString stringWithFormat:@"\n%@\t%@", foodChosenList[i][@"name"], foodChosenList[i][@"quantity"] ];
            [summary appendString:temp];
            NSLog(@"%@",summary);
        }
    }
    [mSummary setHidden:false];
    [mSummary setTitle:summary forState:UIControlStateNormal];
    [self.view bringSubviewToFront:mSummary];

    //add to databse by first converting foodChosenList to a JSON string
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:foodChosenList
                                                       options:NSJSONWritingPrettyPrinted error:&error];

    NSString *debug = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", debug);
    [debug release];
    
    [mTotModel addEvent:baby_id
                  event:EVENT_BASIC_FEEDING
               datetime:date
                  value:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] ]; // change value to a JSON

    // TODO:
    // I don't event know what next code is for...
    // return from getEvent is an array of totEvent object
    // a totEvent represents a single event
    NSMutableArray *events = [mTotModel getEvent:0 event:@"feeding"];
    for (totEvent* e in events) {
        NSLog(@"Return from db: %@", [e toString]);
    }
}

// convert a json string to json object
+ (NSArray*)stringToJSON:(NSString*) jsonstring {
    NSError* e = [[NSError alloc] init];
    NSArray* json = [NSJSONSerialization JSONObjectWithData: [jsonstring dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &e];
    return json;
}

- (void)ChooseFoodOKButtonClicked: (UIButton *)button {
    //[text_quantity resignFirstResponder];
    [mQuantity resignFirstResponder];
    
    if([foodSelectedBuffer count] >=1 ){
        NSArray *foodKeys = [foodSelectedBuffer allKeys];
        for (NSString *key in foodKeys) {
            //NSLog(@"%@ is %@",key, [foodSelectedBuffer objectForKey:key]);
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", categoryChosen];
            NSArray *filteredFood = [inventory filteredArrayUsingPredicate:predicate];
            NSString* chosenFoodName = [NSString stringWithString:filteredFood[[key integerValue]][@"name"]];
            
            // insert into a result queue
            NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
            [foodItem setObject:chosenFoodName forKey:@"name"];
            [foodItem setObject:categoryChosen forKey:@"category"];
            [foodItem setObject:[foodSelectedBuffer objectForKey:key] forKey:@"quantity"];
            
            // add to foodChosenList
            [foodChosenList addObject:foodItem];
            [foodItem release];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Selection"
                                                        message:@"Please choose at least one kind of food before submission."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    /*
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if ([formatter numberFromString:text_quantity.text] != nil){
        double q = [text_quantity.text doubleValue];
        NSNumber* tempQ = [NSNumber numberWithDouble:q];
        
        // according to foodSelected, find food name and category
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", categoryChosen];
        NSArray *filteredFood = [inventory filteredArrayUsingPredicate:predicate];
        NSString* chosenFoodName = [NSString stringWithString:filteredFood[foodSelected][@"name"]];

        // insert into a result queue
        NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
        [foodItem setObject:chosenFoodName forKey:@"name"];
        [foodItem setObject:categoryChosen forKey:@"category"];
        [foodItem setObject:[tempQ stringValue] forKey:@"quantity"];

        // add to foodChosenList
        [foodChosenList addObject:foodItem];
        [foodItem release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong input value."
                                                        message:@"Quantity must be numerical"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [formatter release];
    */
    
    
    for (UIView *subview in [mChooseFoodView subviews]) {
        [subview removeFromSuperview];
    }
    [mChooseFoodView removeFromSuperview];
    //mChooseFoodView.hidden = YES;
    //[mChooseFoodView release];
    
    [foodSelectedBuffer removeAllObjects];
}

- (void)ChooseFoodCancelButtonClicked: (UIButton *)button {
    //[text_quantity resignFirstResponder];
    [mQuantity resignFirstResponder];

    for (UIView *subview in [mChooseFoodView subviews]) {
        [subview removeFromSuperview];
    }
    [mChooseFoodView removeFromSuperview];
    [foodSelectedBuffer removeAllObjects];

}


-(void)SummaryButtonClicked:(UIButton *)button {
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

#pragma mark - View lifecycle
-(void)createCategoryPanel {
    mCategoriesSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 155, 244, 120)];
    [mCategoriesSlider setDelegate:self];
    [mCategoriesSlider setBtnPerCol:2];
    [mCategoriesSlider setBtnPerRow:3];
    [mCategoriesSlider setBtnWidthHeightRatio:0.6f];
    
    //load image
    NSMutableArray *categoriesImages = [[NSMutableArray alloc] init];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-cereal"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-dairy.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-fruit.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-juice.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-meat.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-vege.png"]];
    [mCategoriesSlider retainContentArray:categoriesImages];
    [mCategoriesSlider get];
    
    [self.view addSubview:mCategoriesSlider];
}

-(void)createRecentlyUsedPanel {
    NSMutableArray * images = [[NSMutableArray alloc] init];
    // TODO: needs to double check if the UIImage is nil or not.
    // if it is nil, there will be an exception and corrupted memory later. quite difficult to debug and find out. -hao
    
    [images addObject:[UIImage imageNamed:@"feeding-blueberry.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-papaya.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-kiwi.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-mango.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-bread.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-banana.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-rice white.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-cheerios.png"]];
    [images addObject:[UIImage imageNamed:@"feeding-green pea.png"]];
    
    mRecentlyUsedSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 85, 244, 60)];
    [mRecentlyUsedSlider setDelegate:self];
    [mRecentlyUsedSlider setBtnPerCol:1];
    [mRecentlyUsedSlider setBtnPerRow:4];
    [mRecentlyUsedSlider retainContentArray:images];
    
    [mRecentlyUsedSlider get];
    
    [self.view addSubview:mRecentlyUsedSlider];
    
    [images release];
}

- (void)createChooseFoodPanel {
    mChooseFoodOKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mChooseFoodOKButton.frame = CGRectMake(140, 190, 170, 40);
    [mChooseFoodOKButton setTitle:@"OK" forState:UIControlStateNormal];
    [mChooseFoodOKButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [mChooseFoodOKButton setBackgroundColor:[UIColor whiteColor]];
    [mChooseFoodOKButton addTarget:self action:@selector(ChooseFoodOKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mChooseFoodView addSubview:mChooseFoodOKButton];
    
    mChooseFoodCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mChooseFoodCancelButton.frame = CGRectMake(30,190, 110, 40);
    [mChooseFoodCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [mChooseFoodCancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [mChooseFoodCancelButton setBackgroundColor:[UIColor whiteColor]];
    [mChooseFoodCancelButton addTarget:self action:@selector(ChooseFoodCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mChooseFoodView addSubview:mChooseFoodCancelButton];

    /*
    text_quantity = [[UITextField alloc] initWithFrame:CGRectMake(30, 190, 110, 40)];
    text_quantity.borderStyle = UITextBorderStyleRoundedRect;
    text_quantity.textColor = [UIColor blackColor];
    text_quantity.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
    text_quantity.backgroundColor = [UIColor clearColor];
    text_quantity.keyboardType = UIKeyboardTypeDecimalPad;
    text_quantity.returnKeyType = UIReturnKeyDone;
    text_quantity.clearButtonMode = UITextFieldViewModeWhileEditing;
    [text_quantity addTarget:self action:@selector(TextQuantityClicked:) forControlEvents:UIControlEventTouchUpInside];
    text_quantity.delegate = self;
    [text_quantity setHidden:true];
    [mChooseFoodView addSubview:text_quantity];
     */
    
    
    
    
    mQuantity = [[totQuantityController alloc] init:self.view];
    mQuantity.view.frame = CGRectMake(0, 0, mQuantity.mWidth, mQuantity.mHeight);
    [mQuantity setDelegate:self];
    
    mChooseFoodSlider = [[totSliderView alloc] initWithFrame:CGRectMake(20, 10, 280, 160)];
    [mChooseFoodSlider setDelegate:self];
    [mChooseFoodSlider setBtnPerCol:2];
    [mChooseFoodSlider setBtnPerRow:4];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", categoryChosen];
    NSArray *filteredFood = [inventory filteredArrayUsingPredicate:predicate];
    NSMutableArray *foodImages = [[NSMutableArray alloc] init];
    
    // in order to set labels for button, we have to set the labels first here.
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [filteredFood count]; i++) {
        [foodImages addObject:filteredFood[i][@"file"]];
        [labels addObject:@""];
    }
    [mChooseFoodSlider retainContentArray:foodImages];
    [mChooseFoodSlider retainLabelArray:labels];
    
    [labels release];
    [foodImages release];
    [mChooseFoodSlider get];
    [mChooseFoodView addSubview:mChooseFoodSlider];
}

- (void)createFoodChosenPanel {
    mFoodChosenSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 275, 244, 60)];
    [mFoodChosenSlider setDelegate:self];
    [mFoodChosenSlider setBtnPerCol:1];
    [mFoodChosenSlider setBtnPerRow:4];
    
    //set content array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", @"fruit"];
    NSArray *filteredFoodChosen = [inventoryGrey filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *foodChosenImages = [[NSMutableArray alloc] init];
    for (int i = 0; i < [filteredFoodChosen count]; i++) {
        [foodChosenImages addObject:filteredFoodChosen[i][@"file"]];
    }
    [mFoodChosenSlider retainContentArray:foodChosenImages];
    [foodChosenImages release];
    
    [mFoodChosenSlider get];
    
    [self.view addSubview:mFoodChosenSlider];
}

- (void)addFoodToInventory {
    NSMutableArray *database = [NSMutableArray array];
    [database addObject: [NSArray arrayWithObjects:@"feeding-apple.png", @"apple", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-apricot.png", @"apricot", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-artichoke.png", @"artichoke", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-asparagus.png", @"asparagus", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-avocado.png", @"avocado", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-banana.png", @"banana", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-beet.png", @"beet", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-blueberry.png", @"blueberry", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-bread.png", @"bread", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-broccoli.png", @"broccoli", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-brussel sprout.png", @"brussel sprout", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-califlower.png", @"califlower", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-carrot.png", @"carrot", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-cheerios.png", @"cheerios", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-cheese.png", @"cheese", @"dairy", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-cucumber.png", @"cucumber", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-dry bean.png", @"dry bean", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-eggplant.png", @"eggplant", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-fish.png", @"fish", @"meat", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-grape.png", @"grape", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-kiwi.png", @"kiwi", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-lima bean.png", @"lima bean", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-mango.png", @"mango", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-milk.png", @"milk", @"dairy", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-oatmeal.png", @"oatmeal", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-onion.png", @"onion", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-orange juice.png", @"orange juice", @"juice", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-orange.png", @"orange", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-papaya.png", @"papaya", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-pasta.png", @"pasta", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-peach.png", @"peach", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-pear.png", @"pear", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-green pea.png", @"green pea", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-pineapple.png", @"pineapple", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-plum.png", @"plum", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-potato.png", @"potato", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-pumpkin.png", @"pumpkin", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-rice brown.png", @"brown rice", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-rice white.png", @"white rice", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-sweet potato.png", @"sweet potato", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feeding-watermelon.png", @"watermelon", @"fruit", nil]];
    
    inventory = [[NSMutableArray alloc] init];
    for (int i = 0; i < [database count]; i++) {
        NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
        [foodItem setObject:[UIImage imageNamed:[[database objectAtIndex:i] objectAtIndex:0]] forKey:@"file"];
        [foodItem setObject:[[database objectAtIndex:i] objectAtIndex:1] forKey:@"name"];
        [foodItem setObject:[[database objectAtIndex:i] objectAtIndex:2] forKey:@"category"];
        [inventory addObject:foodItem];
        [foodItem release];
    }
}

- (void)addFoodToInventoryGrey {
    NSMutableArray *database = [NSMutableArray array];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-apple.png", @"apple", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-apricot.png", @"apricot", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-artichoke.png", @"artichoke", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-asparagus.png", @"asparagus", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-avocado.png", @"avocado", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-banana.png", @"banana", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-beet.png", @"beet", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-blueberry.png", @"blueberry", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-bread.png", @"bread", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-broccoli.png", @"broccoli", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-brussel sprout.png", @"brussel sprout", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-califlower.png", @"califlower", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-carrot.png", @"carrot", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-cheerios.png", @"cheerios", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-cheese.png", @"cheese", @"dairy", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-cucumber.png", @"cucumber", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-dry bean.png", @"dry bean", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-eggplant.png", @"eggplant", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-fish.png", @"fish", @"meat", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-grape.png", @"grape", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-kiwi.png", @"kiwi", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-lima bean.png", @"lima bean", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-mango.png", @"mango", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-milk.png", @"milk", @"dairy", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-oatmeal.png", @"oatmeal", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-onion.png", @"onion", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-orange juice.png", @"orange juice", @"juice", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-orange.png", @"orange", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-papaya.png", @"papaya", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-pasta.png", @"pasta", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-peach.png", @"peach", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-pear.png", @"pear", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-green pea.png", @"green pea", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-pineapple.png", @"pineapple", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-plum.png", @"plum", @"fruit", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-potato.png", @"potato", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-pumpkin.png", @"pumpkin", @"vegetable", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-rice brown.png", @"brown rice", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-rice white.png", @"white rice", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-sweet potato.png", @"sweet potato", @"cereal", nil]];
    [database addObject: [NSArray arrayWithObjects:@"feedinggrey-watermelon.png", @"watermelon", @"fruit", nil]];
    
    inventoryGrey = [[NSMutableArray alloc] init];
    for (int i = 0; i < [database count]; i++) {
        NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
        [foodItem setObject:[UIImage imageNamed:[[database objectAtIndex:i] objectAtIndex:0]] forKey:@"file"];
        [foodItem setObject:[[database objectAtIndex:i] objectAtIndex:1] forKey:@"name"];
        [foodItem setObject:[[database objectAtIndex:i] objectAtIndex:2] forKey:@"category"];
        [inventoryGrey addObject:foodItem];
        [foodItem release];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // food inventory
    [self addFoodToInventory];
    [self addFoodToInventoryGrey];
    
    // create background
    UIImage* img = [UIImage imageNamed:@"feeding_bg"];
    UIImageView* bgview = [[UIImageView alloc] initWithImage:img];
    bgview.frame = CGRectMake(0, 0, img.size.width, img.size.height);    
    [self.view addSubview:bgview];
    [bgview release];
    
    // create recently used slider view
    [self createRecentlyUsedPanel];
    
    // create categories slider view
    [self createCategoryPanel];

    // add a chosen list slider
    [self createFoodChosenPanel];
    
    // init categoryChosen
    categoryChosen = @"cereal";
    
    //create title navigation bar
    //navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    //[self.view addSubview:navigationBar];
    /*
    mNavigationBar= [[totNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [mNavigationBar setLeftButtonImg:@"return.png"];
    [mNavigationBar setBackgroundColor:[UIColor whiteColor]];
    [mNavigationBar setDelegate:self];
    [self.view addSubview:mNavigationBar];
     */
    mBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mBackButton.frame = CGRectMake(233, 0, 87, 62);
    [mBackButton setBackgroundColor:[UIColor clearColor]];
    //[mBackButton setImage:[UIImage imageNamed:@"feeding-back.png"] forState:UIControlStateNormal];
    [self.view addSubview:mBackButton];
    [mBackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //create ok button from icons
    mOKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mOKButton.frame = CGRectMake(210, 348, 60, 45);
    [mBackButton setBackgroundColor:[UIColor clearColor]];
    //[mOKButton setImage:[UIImage imageNamed:@"icons-ok.png"] forState:UIControlStateNormal];
    [self.view addSubview:mOKButton];
    [mOKButton addTarget:self action:@selector(OKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //date and time
    mDatetime = [UIButton buttonWithType:UIButtonTypeCustom];
    mDatetime.frame = CGRectMake(100, 28, 120, 30);
    [mDatetime.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:16.0]];
    [mDatetime setTitle:[totUtility nowTimeString] forState:UIControlStateNormal];
    [self.view addSubview:mDatetime];
    [mDatetime addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetime setBackgroundColor:[UIColor clearColor]];
    [mDatetime setTitleColor:[UIColor colorWithRed:147.0/255 green:149.0/255 blue:152.0/255 alpha:1] forState:UIControlStateNormal];
    [mDatetime setTitleColor:[UIColor colorWithRed:255/255 green:0/255 blue:0/255 alpha:1] forState:UIControlStateHighlighted];
    
    // set up date picker
    mWidth = self.view.frame.size.width;
    mHeight= self.view.frame.size.height;
    
    mClock = [[totTimerController alloc] init:self.view];
    mClock.view.frame = CGRectMake(0, 0, mClock.mWidth, mClock.mHeight);
    [mClock setMode:kTime];
    [mClock setDelegate:self];
    [mClock setCurrentTime];

    //final summary popup
    mSummary = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mSummary.frame = CGRectMake(50, 80, 220, 311);
    [mSummary setHidden:YES];
    mSummary.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    [self.view addSubview:mSummary];
    [mSummary addTarget:self action:@selector(SummaryButtonClicked:) forControlEvents: UIControlEventTouchUpInside];

    foodChosenList = [[NSMutableArray alloc]init];
    foodSelectedBuffer = [[NSMutableDictionary alloc] init];
}

#pragma mark - totQuantityControllerDelegate
/*
- (void)TextQuantityClicked: (UIButton *)button {
    [mQuantity show];
}
*/
 
- (void)showQuantityPicker {
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mQuantity.view.frame = CGRectMake((mWidth-mQuantity.mWidth)/2, mHeight-mQuantity.mHeight, mQuantity.mWidth, mQuantity.mHeight);
    [UIView commitAnimations];
}

-(void)saveQuantity:(NSString *)qu{
    NSLog(@"%@", qu);
    //need to parse time before display

    //[text_quantity setText:qu];
    [mChooseFoodSlider changeButton:foodSelected withNewLabel:qu];
    
    //TODO: save quantity to a dictionary
    [foodSelectedBuffer setObject:qu forKey:[NSString stringWithFormat:@"%d", foodSelected]];
    
    [self hideQuantityPicker];
}

- (void)hideQuantityPicker {
    [mQuantity dismiss];
}

-(void)cancelQuantity {
    [self hideQuantityPicker];
}

#pragma mark - totTimerControllerDelegate
- (void)showTimePicker {
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, mHeight-mClock.mHeight, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

// display date selection
- (void)DatetimeClicked: (UIButton *)button {
    [mClock show];
}

- (void)hideTimePicker {
    [mClock dismiss];
}


-(void)saveCurrentTime:(NSString*)time datetime:(NSDate*)datetime {
    NSLog(@"%@", time);
    //need to parse time before display
    NSArray* timeComponent = [time componentsSeparatedByString: @" "];
    
    NSString *formattedTime = [NSString stringWithFormat:@"%@ %@",
                               [timeComponent objectAtIndex:0], [[timeComponent objectAtIndex:1] uppercaseString]];
    [mDatetime setTitle:formattedTime forState:UIControlStateNormal];
    [self hideTimePicker];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}


#pragma mark - clean up
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [inventory release];
    [inventoryGrey release];
    
    [mRecentlyUsedSlider release];
    [mFoodChosenSlider release];
    [mCategoriesSlider release];
    [mChooseFoodSlider release];
    //[text_quantity release];
    [mClock release];
    [mQuantity release];
    [foodChosenList release];
    
    [foodSelectedBuffer release];
}


- (void)viewWillAppear:(BOOL)animated {
    //[mSummary removeFromSuperview];
    [mSummary setHidden:YES];
    //reset time
    [mDatetime setTitle:[totUtility nowTimeString] forState:UIControlStateNormal];

    //reset time picker
    [mClock setCurrentTime];
    
    //reset quantity on picker
    //[picker_quantity setValue:DEFAULT_QUANTITY];
    //picker_quantity.hidden = YES;
    
    //reset quantiy on buttons
    [mCategoriesSlider clearAllButtonLabels];
    
    if (foodChosenList) {
        [foodChosenList removeAllObjects];
    }
    
    [foodSelectedBuffer removeAllObjects];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
