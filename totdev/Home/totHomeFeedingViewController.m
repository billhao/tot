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

#define DEFAULT_QUANTITY 2.3 //magic number

//macro to discriminate different buttons pressed
#define BUTTON_CATEGORY_MIN 0
#define BUTTON_CATEGORY_MAX 999
#define BUTTON_RECENTLYUSED_MIN 1000
#define BUTTON_RECENTLYUSED_MAX 1999
#define BUTTON_CHOOSEFOOD_MIN 2000
#define BUTTON_CHOOSEFOOD_MAX 2999
#define BUTTON_FOODCHOSEN_MIN 3000
#define BUTTON_FOODCHOSEN_MAX 3999

@implementation totHomeFeedingViewController

@synthesize homeRootController;
@synthesize mRecentlyUsedSlider;
@synthesize mCategoriesSlider;
@synthesize mFoodChosenSlider;
@synthesize mCurrentFoodID;
@synthesize mChooseFoodSlider;

#pragma mark - init and aux

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        mTotModel = [appDelegate getDataModel];
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - component response

- (void)pickerView:(STHorizontalPicker *)picker didSelectValue:(CGFloat)value {
    NSLog(@"didSelectValue %f", value);
    // change the associate number on buttons
    
    //testing
    //NSString *temp =[[NSString alloc] initWithFormat:@"%.1f", picker_quantity.currentValue];
    //[mOKButton setTitle:temp forState:UIControlStateNormal];
    //[temp release];
    
    //need to expose an API in
    [mFoodChosenSlider setButton:buttonSelected andWithValue:picker_quantity.currentValue];
    
    quantityList[buttonSelected] =picker_quantity.currentValue;
}

- (void)createChooseFoodPanel{
    
    mChooseFoodOKButton = [UIButton buttonWithType:UIButtonTypeCustom];;
    mChooseFoodOKButton.frame = CGRectMake(40, 200, 240, 40);
    [mChooseFoodOKButton setTitle:@"ok" forState:UIControlStateNormal];
    [mChooseFoodOKButton setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    [mChooseFoodOKButton setBackgroundColor:[UIColor whiteColor]];
    [mChooseFoodView addSubview:mChooseFoodOKButton];
    [mChooseFoodOKButton addTarget:self action:@selector(ChooseFoodOKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    mChooseFoodSlider = [[totSliderView alloc] initWithFrame:CGRectMake(20, 10, 280, 160)];
    [mChooseFoodSlider setDelegate:self];
    [mChooseFoodSlider setBtnPerCol:2];
    [mChooseFoodSlider setBtnPerRow:4];
    [mChooseFoodSlider setvMarginBetweenBtn:0];
    [mChooseFoodSlider sethMarginBetweenBtn:0];
    [mChooseFoodSlider setTagOffset:BUTTON_CHOOSEFOOD_MIN];
    
    //load image
    //NSMutableArray *foodImages = [[NSMutableArray alloc] init];
    // [recentlyUsedImages addObject:[UIImage imageNamed:@"feedingcategories-cereal"]];
    // should use plist file to load
    //[foodImages addObject:[UIImage imageNamed:@"feeding-apple.png"]];
    //NSMutableDictionary *foodImages = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableArray *food = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-apple.png"] forKey:@"file"];
    [foodItem setObject:@"apple" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];

    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-apricot.png"] forKey:@"file"];
    [foodItem setObject:@"apricot" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];

    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-artichoke.png"] forKey:@"file"];
    [foodItem setObject:@"artichoke" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-asparagus.png"] forKey:@"file"];
    [foodItem setObject:@"asparagus" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];

    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-avocado.png"] forKey:@"file"];
    [foodItem setObject:@"avocado" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];

    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-banana.png"] forKey:@"file"];
    [foodItem setObject:@"banana" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-beet.png"] forKey:@"file"];
    [foodItem setObject:@"beet" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];

    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-blueberry.png"] forKey:@"file"];
    [foodItem setObject:@"blueberry" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-bread.png"] forKey:@"file"];
    [foodItem setObject:@"bread" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];

    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-broccoli.png"] forKey:@"file"];
    [foodItem setObject:@"broccoli" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];

    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-brussel sprout.png"] forKey:@"file"];
    [foodItem setObject:@"brussel sprout" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-califlower.png"] forKey:@"file"];
    [foodItem setObject:@"califlower" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-carrot.png"] forKey:@"file"];
    [foodItem setObject:@"carrot" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-cheerios.png"] forKey:@"file"];
    [foodItem setObject:@"cheerios" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-cheese.png"] forKey:@"file"];
    [foodItem setObject:@"cheese" forKey:@"name"];
    [foodItem setObject:@"dairy" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-cucumber.png"] forKey:@"file"];
    [foodItem setObject:@"cucumber" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-dry bean.png"] forKey:@"file"];
    [foodItem setObject:@"dry bean" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-eggplant.png"] forKey:@"file"];
    [foodItem setObject:@"eggplant" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-fish.png"] forKey:@"file"];
    [foodItem setObject:@"fish" forKey:@"name"];
    [foodItem setObject:@"meat" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-grape.png"] forKey:@"file"];
    [foodItem setObject:@"grape" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-kiwi.png"] forKey:@"file"];
    [foodItem setObject:@"kiwi" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-lima bean.png"] forKey:@"file"];
    [foodItem setObject:@"lima bean" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-mango.png"] forKey:@"file"];
    [foodItem setObject:@"mango" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-milk.png"] forKey:@"file"];
    [foodItem setObject:@"milk" forKey:@"name"];
    [foodItem setObject:@"dairy" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-oatmeal.png"] forKey:@"file"];
    [foodItem setObject:@"oatmeal" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-onion.png"] forKey:@"file"];
    [foodItem setObject:@"onion" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-orange juice.png"] forKey:@"file"];
    [foodItem setObject:@"orange juice" forKey:@"name"];
    [foodItem setObject:@"juice" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-orange.png"] forKey:@"file"];
    [foodItem setObject:@"orange" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-papaya.png"] forKey:@"file"];
    [foodItem setObject:@"papaya" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-pasta.png"] forKey:@"file"];
    [foodItem setObject:@"pasta" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-peach.png"] forKey:@"file"];
    [foodItem setObject:@"peach" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-pear.png"] forKey:@"file"];
    [foodItem setObject:@"pear" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-green pea.png"] forKey:@"file"];
    [foodItem setObject:@"green pea" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-pineapple.png"] forKey:@"file"];
    [foodItem setObject:@"pineapple" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-plum.png"] forKey:@"file"];
    [foodItem setObject:@"plum" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-potato.png"] forKey:@"file"];
    [foodItem setObject:@"potato" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-pumpkin.png"] forKey:@"file"];
    [foodItem setObject:@"pumpkin" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-rice brown.png"] forKey:@"file"];
    [foodItem setObject:@"brown rice" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-rice white.png"] forKey:@"file"];
    [foodItem setObject:@"white rice" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-sweet potato.png"] forKey:@"file"];
    [foodItem setObject:@"sweet potato" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [food addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feeding-watermelon.png"] forKey:@"file"];
    [foodItem setObject:@"watermelon" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [food addObject:foodItem];
    
    //xxxxxxxxxx
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", categoryChosen];
    NSArray *filteredFood = [food filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *foodImages = [[NSMutableArray alloc] init];
    for(int i=0; i< [filteredFood count]; i++)
        [foodImages addObject:filteredFood[i][@"file"]];
    
    [mChooseFoodSlider setContentArray:foodImages];
    
    /*
    [foodItem release];//adding food items to list done
    [food release];
    [foodImages release];
    [filteredFood release];
    */
    
    [mChooseFoodSlider getWithPositionMemoryIdentifier:@"chooseFood"];
    
    
}

- (void)buttonPressed: (id)sender {
    UIButton *btn = (UIButton*)sender;
    int tag = [btn tag];
    tag -= 1;
    
    if(tag >= BUTTON_CATEGORY_MIN && tag <= BUTTON_CATEGORY_MAX){ //category
        // show a new panel with food slider and picker and ok button
        mChooseFoodView = [[UIView alloc] initWithFrame: CGRectMake(0, 100, 320, 260)];
        //[mChooseFoodView setBackgroundColor:[UIColor grayColor]];
        mChooseFoodView.backgroundColor = [UIColor clearColor];
        mChooseFoodView.alpha = 1.0;
        [self.view addSubview:mChooseFoodView];
        
        //background
        totImageView* popUpBackground = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        [popUpBackground imageFilePath:@"feeding-popup.png"];
        [mChooseFoodView addSubview:popUpBackground];
        [popUpBackground release];
        
        
        if(tag == BUTTON_CATEGORY_MIN + 0)
            categoryChosen = @"cereal";
        else if(tag == BUTTON_CATEGORY_MIN + 1)
            categoryChosen = @"dairy";
        else if(tag == BUTTON_CATEGORY_MIN + 2)
            categoryChosen = @"fruit";
        else if(tag == BUTTON_CATEGORY_MIN + 3)
            categoryChosen = @"juice";
        else if(tag == BUTTON_CATEGORY_MIN + 4)
            categoryChosen = @"meat";
        else if(tag == BUTTON_CATEGORY_MIN + 5)
            categoryChosen = @"vegetable";
        else
            categoryChosen = @"cereal";
        
        [self createChooseFoodPanel];
        [mChooseFoodView addSubview:mChooseFoodSlider];
        
        /*
        picker_quantity = [[STHorizontalPicker alloc] initWithFrame:CGRectMake(20, 170, 280, 31)];
        picker_quantity.name = @"picker_weight";
        [picker_quantity setMinimumValue:0.0];
        [picker_quantity setMaximumValue:6.0];
        [picker_quantity setSteps:60];
        [picker_quantity setDelegate:self];
        [picker_quantity setValue:DEFAULT_QUANTITY];
        //diable picker quantity
        picker_quantity.hidden =YES;
        [mChooseFoodView addSubview:picker_quantity];
         */
        
        for (int i=0; i<DEFAULT_MENU ; i++) {
            quantityList[i]=0;
        }
        
        return; //tag segmentations are mutually exclusive
    }
    
    if(tag >= BUTTON_RECENTLYUSED_MIN && tag <= BUTTON_RECENTLYUSED_MAX){
        
        
        return;
    }
    
    if(tag >= BUTTON_CHOOSEFOOD_MIN & tag <= BUTTON_CHOOSEFOOD_MAX){
        // picker_quantity.hidden = NO;
        // [picker_quantity setValue:DEFAULT_QUANTITY];
        
        buttonSelected = tag;
        
        //reset all button bacground color;
        [mChooseFoodSlider clearButtonBGColor];
        ((UIButton *)sender).backgroundColor = [UIColor redColor];
        
        return;
    }
    
    if(tag >= BUTTON_FOODCHOSEN_MIN && tag <= BUTTON_FOODCHOSEN_MAX){
        
        [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
        
        return;
    }
}

//- (void) navLeftButtonPressed:(id)sender{
//    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
//}

- (void) backButtonClicked:(UIButton *)button {
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

- (void)OKButtonClicked: (UIButton *)button {
    NSLog(@"%@", @"[feeding] ok button clicked");
    int baby_id = 0;
    NSDate* date = [NSDate date];
    
    NSString* summary = [NSString stringWithFormat:@"**%@", mDatetime.titleLabel.text ];
    NSLog(@"%@", summary);
    
    
    for(int i = 0; i < DEFAULT_MENU; i++){
        if(quantityList[i]>0){
            NSString* temp = [NSString stringWithFormat:@"%@-%d:\t%.1f %@", @"food",i, quantityList[i],@"oz" ];
            
            summary = [NSString stringWithFormat:@"%@\n%@",summary,temp ];
            
            NSString* quantity = [NSString stringWithFormat:@"%.1f", picker_quantity.currentValue];
            
            // food list needs renew
            [mTotModel addEvent:baby_id event:EVENT_FEEDING_MILK datetime:date value:quantity];
            NSLog(@"%@",summary);
        }
        
    }
    
    [mSummary setTitle:summary forState:UIControlStateNormal];
    [self.view bringSubviewToFront:mSummary];
    [mSummary setHidden:false];
    
    // get a list of events containing "emotion"
    NSString* event = [[NSString alloc] initWithString:@"fedding"];
    // return from getEvent is an array of totEvent object
    // a totEvent represents a single event
    NSMutableArray *events = [mTotModel getEvent:0 event:event];
    for (totEvent* e in events) {
        NSLog(@"Return from db: %@", [e toString]);
    }
    [event release];
}


- (void)ChooseFoodOKButtonClicked: (UIButton *)button {
    
    for (UIView *subview in [mChooseFoodView subviews])
            [subview removeFromSuperview];
    
    mChooseFoodView.hidden = YES;
    [mChooseFoodView release];
    
}

-(void)SummaryButtonClicked:(UIButton *)button{
    [homeRootController switchTo:kHomeViewEntryView withContextInfo:nil];
}

#pragma mark - View lifecycle
-(void)createCategoryPanel{
    mCategoriesSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 170, 244, 120)];
    [mCategoriesSlider setDelegate:self];
    [mCategoriesSlider setBtnPerCol:2];
    [mCategoriesSlider setBtnPerRow:3];
    [mCategoriesSlider setvMarginBetweenBtn:12];
    [mCategoriesSlider sethMarginBetweenBtn:12];
    [mCategoriesSlider setBtnHeight:33];
    [mCategoriesSlider setTagOffset:BUTTON_CATEGORY_MIN];
    //[mCategoriesSlider enablePageControlOnBottom]; no page control dot
    
    //load image
    NSMutableArray *categoriesImages = [[NSMutableArray alloc] init];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-cereal"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-dairy.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-fruit.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-juice.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-meat.png"]];
    [categoriesImages addObject:[UIImage imageNamed:@"feedingcategories-vege.png"]];
    
    [mCategoriesSlider setContentArray:categoriesImages];
    [categoriesImages release];
    
    [mCategoriesSlider getWithPositionMemoryIdentifier:@"feedingCategories"];
}

-(void)createRecentlyUsedPanel{
    
    mRecentlyUsedSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 95, 244, 60)];
    [mRecentlyUsedSlider setDelegate:self];
    [mRecentlyUsedSlider setBtnPerCol:1];
    [mRecentlyUsedSlider setBtnPerRow:4];
    [mRecentlyUsedSlider setvMarginBetweenBtn:0];
    [mRecentlyUsedSlider sethMarginBetweenBtn:0];
    [mRecentlyUsedSlider setTagOffset:BUTTON_RECENTLYUSED_MIN];
    
    //load image
    NSMutableArray *recentlyUsedImages = [[NSMutableArray alloc] init];
    // [recentlyUsedImages addObject:[UIImage imageNamed:@"feedingcategories-cereal"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-apple.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-blueberry.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-papaya.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-kiwi.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-mango.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-bread.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-banana.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-ricewhite.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-cheerios.png"]];
    [recentlyUsedImages addObject:[UIImage imageNamed:@"feeding-peas.png"]];
    
    
    [mRecentlyUsedSlider setContentArray:recentlyUsedImages];
    [recentlyUsedImages release];
    
    [mRecentlyUsedSlider getWithPositionMemoryIdentifier:@"feedingRecentlyUsed"];
    
}

- (void)createFoodChosenPanel{
    
    mFoodChosenSlider = [[totSliderView alloc] initWithFrame:CGRectMake(38, 285, 244, 60)];
    [mFoodChosenSlider setDelegate:self];
    [mFoodChosenSlider setBtnPerCol:1];
    [mFoodChosenSlider setBtnPerRow:4];
    [mFoodChosenSlider setvMarginBetweenBtn:0];
    [mFoodChosenSlider sethMarginBetweenBtn:0];
    [mFoodChosenSlider setTagOffset:BUTTON_FOODCHOSEN_MIN];
    
    //load  grey-scale image
    NSMutableArray *foodChosen = [[NSMutableArray alloc] init];
    NSMutableDictionary *foodItem = [[NSMutableDictionary alloc] init];
    
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-apple.png"] forKey:@"file"];
    [foodItem setObject:@"apple" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-apricot.png"] forKey:@"file"];
    [foodItem setObject:@"apricot" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-artichoke.png"] forKey:@"file"];
    [foodItem setObject:@"artichoke" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-asparagus.png"] forKey:@"file"];
    [foodItem setObject:@"asparagus" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-avocado.png"] forKey:@"file"];
    [foodItem setObject:@"avocado" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-banana.png"] forKey:@"file"];
    [foodItem setObject:@"banana" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-beet.png"] forKey:@"file"];
    [foodItem setObject:@"beet" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-blueberry.png"] forKey:@"file"];
    [foodItem setObject:@"blueberry" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-bread.png"] forKey:@"file"];
    [foodItem setObject:@"bread" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-broccoli.png"] forKey:@"file"];
    [foodItem setObject:@"broccoli" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-brussel sprout.png"] forKey:@"file"];
    [foodItem setObject:@"brussel sprout" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-califlower.png"] forKey:@"file"];
    [foodItem setObject:@"califlower" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-carrot.png"] forKey:@"file"];
    [foodItem setObject:@"carrot" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-cheerios.png"] forKey:@"file"];
    [foodItem setObject:@"cheerios" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-cheese.png"] forKey:@"file"];
    [foodItem setObject:@"cheese" forKey:@"name"];
    [foodItem setObject:@"dairy" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-cucumber.png"] forKey:@"file"];
    [foodItem setObject:@"cucumber" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-dry bean.png"] forKey:@"file"];
    [foodItem setObject:@"dry bean" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-eggplant.png"] forKey:@"file"];
    [foodItem setObject:@"eggplant" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-fish.png"] forKey:@"file"];
    [foodItem setObject:@"fish" forKey:@"name"];
    [foodItem setObject:@"meat" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-grape.png"] forKey:@"file"];
    [foodItem setObject:@"grape" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-kiwi.png"] forKey:@"file"];
    [foodItem setObject:@"kiwi" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-lima bean.png"] forKey:@"file"];
    [foodItem setObject:@"lima bean" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-mango.png"] forKey:@"file"];
    [foodItem setObject:@"mango" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-milk.png"] forKey:@"file"];
    [foodItem setObject:@"milk" forKey:@"name"];
    [foodItem setObject:@"dairy" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-oatmeal.png"] forKey:@"file"];
    [foodItem setObject:@"oatmeal" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-onion.png"] forKey:@"file"];
    [foodItem setObject:@"onion" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-orange juice.png"] forKey:@"file"];
    [foodItem setObject:@"orange juice" forKey:@"name"];
    [foodItem setObject:@"juice" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-orange.png"] forKey:@"file"];
    [foodItem setObject:@"orange" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-papaya.png"] forKey:@"file"];
    [foodItem setObject:@"papaya" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-pasta.png"] forKey:@"file"];
    [foodItem setObject:@"pasta" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-peach.png"] forKey:@"file"];
    [foodItem setObject:@"peach" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-pear.png"] forKey:@"file"];
    [foodItem setObject:@"pear" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-green pea.png"] forKey:@"file"];
    [foodItem setObject:@"green pea" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-pineapple.png"] forKey:@"file"];
    [foodItem setObject:@"pineapple" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-plum.png"] forKey:@"file"];
    [foodItem setObject:@"plum" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-potato.png"] forKey:@"file"];
    [foodItem setObject:@"potato" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-pumpkin.png"] forKey:@"file"];
    [foodItem setObject:@"pumpkin" forKey:@"name"];
    [foodItem setObject:@"vegetable" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-rice brown.png"] forKey:@"file"];
    [foodItem setObject:@"brown rice" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-rice white.png"] forKey:@"file"];
    [foodItem setObject:@"white rice" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-sweet potato.png"] forKey:@"file"];
    [foodItem setObject:@"sweet potato" forKey:@"name"];
    [foodItem setObject:@"cereal" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    foodItem = [[NSMutableDictionary alloc] init];
    [foodItem setObject:[UIImage imageNamed:@"feedinggrey-watermelon.png"] forKey:@"file"];
    [foodItem setObject:@"watermelon" forKey:@"name"];
    [foodItem setObject:@"fruit" forKey:@"category"];
    [foodChosen addObject:foodItem];
    
    //set content array
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", @"fruit"];
    NSArray *filteredFoodChosen = [foodChosen filteredArrayUsingPredicate:predicate];
    
    NSMutableArray *foodChosenImages = [[NSMutableArray alloc] init];
    for(int i=0; i< [filteredFoodChosen count]; i++)
        [foodChosenImages addObject:filteredFoodChosen[i][@"file"]];
    
    [mFoodChosenSlider setContentArray:foodChosenImages];
    
    /*
    [foodItem release];//adding food items to list done
    [foodChosen release];
    [filteredFoodChosen release];
    [foodChosenImages release];
     */
    
    [mFoodChosenSlider getWithPositionMemoryIdentifier:@"feedingFoodChosen"];
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
        
    // create background
    totImageView* background = [[totImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [background imageFilePath:@"feeding-blank.png"];
    [self.view addSubview:background];
    [background release];
    
    // create categories slider view
    [self createCategoryPanel];
    [self.view addSubview:mCategoriesSlider];
    
    buttonSelected = 0;
    
    // create recently used slider view
    [self createRecentlyUsedPanel];
    [self.view addSubview:mRecentlyUsedSlider];
    
    //add a chosen list slider
    [self createFoodChosenPanel];
    [self.view addSubview:mFoodChosenSlider];
    
    //init categoryChosen
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
    mBackButton.frame = CGRectMake(233, 0, 87, 72);
    [mBackButton setImage:[UIImage imageNamed:@"feeding-back.png"] forState:UIControlStateNormal];
    [self.view addSubview:mBackButton];
    [mBackButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    //create ok button from icons
    mOKButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mOKButton.frame = CGRectMake(220, 360, 40, 40);
    [mOKButton setImage:[UIImage imageNamed:@"icons-ok.png"] forState:UIControlStateNormal];
    [self.view addSubview:mOKButton];
    [mOKButton addTarget:self action:@selector(OKButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //date and time
    mDatetime = [UIButton buttonWithType:UIButtonTypeCustom];
    mDatetime.frame = CGRectMake(100, 40, 120, 30);
    [mDatetime setTitle:[totUtility nowTimeString] forState:UIControlStateNormal];
    [self.view addSubview:mDatetime];
    [mDatetime addTarget:self action:@selector(DatetimeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [mDatetime setBackgroundColor:[UIColor whiteColor]];
    [mDatetime setTitleColor:[UIColor magentaColor] forState:UIControlStateNormal];
    
    // set up date picker
    mWidth = self.view.frame.size.width;
    mHeight= self.view.frame.size.height;
    
    mClock = [[totTimerController alloc] init];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, 480, mClock.mWidth, mClock.mHeight);
    [mClock setMode:kTime];
    [mClock setDelegate:self];
    [mClock setCurrentTime];
    [self.view addSubview:mClock.view];

    //final summary popup
    mSummary = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mSummary.frame = CGRectMake(50, 80, 220, 311);
    [mSummary setHidden:YES];
    mSummary.titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    //mSummary.titleLabel.frame= mSummary.bounds;
    [self.view addSubview:mSummary];
    [mSummary addTarget:self action:@selector(SummaryButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    

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
    NSLog(@"%@", @"[feeding] datetime clicked");
    [self showTimePicker];
}

- (void)hideTimePicker {
    [UIView beginAnimations:@"swipe" context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5f];
    mClock.view.frame = CGRectMake((mWidth-mClock.mWidth)/2, 480, mClock.mWidth, mClock.mHeight);
    [UIView commitAnimations];
}

-(void)saveCurrentTime:(NSString*)time {
    NSLog(@"%@", time);
    NSString *formattedTime;
    //need to parse time before display
    NSArray* timeComponent = [time componentsSeparatedByString: @":"];
    
    formattedTime = [NSString stringWithFormat:@"%@:%@ %@",
                     [timeComponent objectAtIndex:0],
                     [timeComponent objectAtIndex:1],
                     [[timeComponent objectAtIndex:2] uppercaseString]];
    
    [mDatetime setTitle:formattedTime forState:UIControlStateNormal];
    
    //[formattedTime release];
    [self hideTimePicker];
}

-(void)cancelCurrentTime {
    [self hideTimePicker];
}


#pragma mark - clean up
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [mRecentlyUsedSlider release];
    [mFoodChosenSlider release];
    [mCategoriesSlider release];
    [picker_quantity release];
    //[mOKButton release];
    //[mDatetime release];
    //[mSummary release];
    [mClock release];
    //[mNavigationBar release];
    //[mBackButton release];
}


- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@", @"[height] viewWillAppear");
    //[mSummary removeFromSuperview];
    [mSummary setHidden:YES];
    //reset time
    [mDatetime setTitle:[totUtility nowTimeString] forState:UIControlStateNormal];

    //reset time picker
    [mClock setCurrentTime];
    
    //reset quantity on picker
    [picker_quantity setValue:DEFAULT_QUANTITY];
    picker_quantity.hidden = YES;
    
    //reset quantiy on buttons
    [mCategoriesSlider clearButtonLabels];
    [mCategoriesSlider clearButtonBGColor];
    
    //clear quantityList
    for(int i=0;i<DEFAULT_MENU;i++){
        quantityList[i]=0;
    }

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
