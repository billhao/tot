//
//  totTimeline.m
//  totdev
//
//  Created by Lixing Huang on 6/29/13.
//  Copyright (c) 2013 tot. All rights reserved.
//

#import "totTimeline.h"
#import "totReviewStory.h"
#import "Global.h"
#import "totTimelineController.h"
#import "totSummaryCard.h"
#import "totSleepCard.h"

@implementation totTimeline

@synthesize controller, sleeping, summaryCard;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        sleeping = FALSE;
        
        lastLoadedEvent = nil;
        
        int h = [UIScreen mainScreen].bounds.size.height;
        self.contentSize = CGSizeMake(320, h);
        mCards = [[NSMutableArray alloc] init];
        [self setBackground];
        [self setDelegate:self];
        [self setupTimer];
    }
    return self;
}

- (void)dealloc {
    // stop and release timer
    [timer stop];
    [timer release];
    timer = nil;
    
    [lastLoadedEvent release];
    lastLoadedEvent = nil;

    [super dealloc];
    [mCards release];
}


// Change the background of the timeline
- (void) setBackground {
    [self setBackgroundColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0f]];
}

- (totReviewCardView*) addEmptyCard:(ReviewCardType)type {
    totReviewCardView* card = [[totReviewCardView createEmptyCard:type timeline:self] autorelease];
    card.parent = self;
    
    // Check whether there already existed an edit card.
    int editCardIndex = [self getEditCardIndex];
    if ( editCardIndex > -1 ) {
        totReviewCardView* cc = [mCards objectAtIndex:editCardIndex];
        [self deleteCard:cc];
    }
    
    int index = [self getSummaryCardIndex] + 1;
    if ([mCards count] > 0) {
        [mCards insertObject:card atIndex:index];  // new card is always under the summary card.
    } else {
        [mCards addObject:card];
    }
    [self addSubview:card];
    [self refreshView];
    
    // no delete for summary
    if( type != SUMMARY )
        [self addDeleteButtonUnderCard:card];
    
    return [[card retain] autorelease];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    totReviewCardView* cv = (totReviewCardView*)context;
    [self deleteCard:cv];
    
    // auto load some cards if # of cards is too few after deletion
    if( [mCards count] < 3 )
        [self loadCardsNumber:10];
}

- (void) handleDeleteButton: (id)button {
    printf("Click delete button\n");
    UIButton* btn = (UIButton*)button;
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        if (cv.associated_delete_button == btn) {
            // Found the right card by comparing its position with the delete button.
            [UIView beginAnimations:@"delete_card" context:cv];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
                cv.frame = CGRectMake(320, cv.frame.origin.y, cv.frame.size.width, cv.frame.size.height);
                CGRect f = cv.associated_delete_button.frame;
                f.origin.x = -f.size.width;
                cv.associated_delete_button.frame = f;
            [UIView commitAnimations];
            
            break;
        }
    }
}

- (void) addDeleteButtonUnderCard: (totReviewCardView*)card {
    int x = card.frame.origin.x;
    int y = card.frame.origin.y;
    UIButton* delete_button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 82, card.bounds.size.height)]; // 82 is the width of delete button in ios' own message app
    delete_button.titleLabel.font = [UIFont fontWithName:@"Raleway" size:16];
    [delete_button setTitle:@"Delete" forState:UIControlStateNormal];
    [delete_button setTitle:@"Delete" forState:UIControlStateHighlighted];
    [delete_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delete_button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    delete_button.backgroundColor = [UIColor colorWithRed:1.0 green:59/255.0 blue:48/255.0 alpha:1.0];
    [delete_button addTarget:self
                      action:@selector(handleDeleteButton:)
            forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:delete_button belowSubview:card];
    card.associated_delete_button = delete_button;
    [delete_button release];
}

- (void) refreshView {
    int x = 0;
    int y = GAP_BETWEEN_CARDS;  // start from the top.
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        int w = [cv width];
        int h = [cv height];
        
        x = (320 - w) / 2;
        cv.frame = CGRectMake(x, y, w, h);
        cv.associated_delete_button.frame =
            CGRectMake(x,
                       y,
                       cv.associated_delete_button.frame.size.width,
                       h);
//        NSLog(@"%.0f %.0f %.0f", cv.frame.size.height,
//              cv.mEditView.view.frame.size.height, cv.mShowView.view.frame.size.height);        
        y = y + h + GAP_BETWEEN_CARDS;
    }
    if (y >= self.contentSize.height) {
        self.contentSize = CGSizeMake(320, y);
    }
}

- (void) moveToTop:(totReviewCardView *)card {
    float card_y = card.frame.origin.y;
    [self setContentOffset:CGPointMake(0, card_y-4) animated:YES];
}

- (void) moveCard:(totReviewCardView *)card To:(int)index {
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        if (cv == card) {
            [mCards removeObjectAtIndex:i];
            if( i < index ) index--; // because all indexes after i have decreased by one
            [mCards insertObject:cv atIndex:index];
            break;
        }
    }
    [self refreshView];
}

- (void) deleteCard:(totReviewCardView *)card {
    if( card.mMode == SHOW ) {
        // delete this record from db
        if( card.mShowView.type == SLEEP ) {
            // also delete last event id so delete in pair
            int event_id = ((totSleepShowCard*)card.mShowView).sleepStartEvent.event_id;
            [global.model deleteEventById:event_id];
        }
        int event_id = card.mShowView.e.event_id;
        if( event_id > 0 )
            [global.model deleteEventById:event_id];
    }

    // delete from the view
    [card removeFromSuperview];
    [card.associated_delete_button removeFromSuperview];
    [mCards removeObject:card];
    
    [self refreshView];
}

- (void) updateSummaryCard:(ReviewCardType)type withValue:(NSString*)value {
    if ([mCards count] > 1) {
        totSummaryCard* summary_card = (totSummaryCard*)summaryCard.mShowView;
        [summary_card updateLabel:type withValue:value];
    }
}

- (int)getSummaryCardIndex {
    // get summary card index
    for( int i=0; i<mCards.count; i++ ) {
        if( summaryCard == mCards[i] )
            return i;
    }
    return -1;
}

// return -1 if no edit card
- (int)getEditCardIndex {
    int index = [self getSummaryCardIndex] + 1;
    if ([mCards count] > index) {
        totReviewCardView* cc = [mCards objectAtIndex:index];
        if (cc.mMode == EDIT) {
            return index;
        }
    }
    return -1;
}

- (totReviewCardView*)getSleepCard {
    for( int i=0; i<mCards.count; i++ ) {
        totReviewCardView* card = mCards[i];
        if( card.mMode == EDIT && card.mEditView.type == SLEEP )
            return [[card retain] autorelease];
    }
    return nil;
}

// load limit number of cards starting from an event
// if start event is nil, insert cards after summary card
- (void) loadCardsNumber:(int)limit {
    NSArray * events = nil;
    
    int displayed_cnt = 0;
    totEvent* nextStartEvent = lastLoadedEvent;

    int index = mCards.count;
    while( displayed_cnt < limit ) {
        // get events older than last event in both event_id and datetime
        events = [global.model getEventWithPagination:global.baby.babyID limit:limit startFrom:nextStartEvent];
        
        int cnt = [events count];
        // If no more events available
        if (cnt == 0)
            break;
        
        for (int i = 0; i<[events count] && displayed_cnt<limit; ++i) {
            // parse the results from db
            
            totEvent * anEvent = (totEvent*)[events objectAtIndex:i];
            //NSLog(@"load event %d", anEvent.event_id);
            
            nextStartEvent = anEvent;
            
//            // this event should have already been fetched if datetime is the same as last one and event_id is greater than last one
//            if( [anEvent.datetime isEqualToDate:startEvent.datetime] && anEvent.event_id > startEvent.event_id )
//                continue;
            
            if( [anEvent.name isEqualToString:EVENT_BASIC_SLEEP] && [anEvent.value isEqualToString:@"start"] )
                // skip start sleep event
                continue;
            
            if( [self addCard:anEvent index:index] ) {
                index++;
                displayed_cnt++;
            }
        }
    }
    
    if( nextStartEvent )
        lastLoadedEvent = [nextStartEvent copy];
    
    [self refreshView];
}

- (void) refreshNewCards {
    NSArray * events = nil;
    
    NSDate* startdate;
    totEvent* firstEvent = [self getFirstEventInTimeline];
    if( firstEvent )
        startdate = firstEvent.datetime;
    else
        startdate = [NSDate dateWithTimeIntervalSince1970:0];

    // get events older than last event in both event_id and datetime
    events = [global.model getEvent:global.baby.babyID startDate:startdate endDate:[NSDate date]];
    
    int index = [self getSummaryCardIndex] + 1;
    for (int i = 0; i<events.count; ++i) {
        // parse the results from db
        totEvent * anEvent = (totEvent*)[events objectAtIndex:i];
        //NSLog(@"load event %d", anEvent.event_id);
        
        if( [anEvent.name isEqualToString:EVENT_BASIC_SLEEP] && [anEvent.value isEqualToString:@"start"] )
            // skip start sleep event
            continue;
        
        if( anEvent.event_id == firstEvent.event_id )
            continue;
        
        if( [self addCard:anEvent index:index] )
            index++;
    }
    
    [self refreshView];
}

// add a new card
- (totReviewCardView*)addCard:(totEvent*)e index:(int)index {
    // for debug
    //NSLog(@"counts = %d, index = %d, eid = %d", mCards.count, index, e.event_id);
    
    totReviewStory *story = [[totReviewStory alloc] init];
    story.mEventType = e.name;
    story.mRawContent = e.value;
    story.mWhen = e.datetime;
    story.mBabyId = e.baby_id;
    story.mEventId = e.event_id;
    
    // change it to different type.
    totReviewCardView* card = [totReviewCardView loadCard:story.mEventType story:story timeline:self];
    if (card) {
        card.parent = self;
        card.mShowView.e = e;
        [card.mShowView viewWillAppear:YES];
        [self addSubview:card];
        [self addDeleteButtonUnderCard:card];
        [mCards insertObject:card atIndex:index];
    }
    else {
        NSLog(@"[Timeline] Cannot load card %d %@", e.event_id, e.name);
    }
    [story release];
    return card;
}

- (totEvent*)getFirstEventInTimeline {
    int index = [self getSummaryCardIndex] + 1;
    if( mCards.count > index ) {
        totReviewCardView* c = (totReviewCardView*)mCards[index];
        totEvent* e = c.mShowView.e;
        return ((totReviewCardView*)mCards[index]).mShowView.e;
    }
    else
        return nil;
}

- (totEvent*)getLastEventInTimeline {
    int index = mCards.count - 1;
    return ((totReviewCardView*)mCards[index]).mShowView.e;
}

#pragma mark - UIScrollViewDelegate

// this is not needed any more. moved to scrollViewWillBeginDecelerating (Hao)
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scroll view scroll");
//    // TODO(lxhuang) add loading button and wait for a second.
//    if (scrollView.contentOffset.y + 389 > scrollView.contentSize.height) {
//        [self loadCardsNumber:10 startFrom:lastLoadedEvent];
//        
//
//        int cards_num = [mCards count];
//        if (cards_num > 1) {
//            totReviewCardView* card = [mCards objectAtIndex:1];
//            cards_num--;  // don't consider the summary card
//            for (int i = 1; i < [mCards count]; ++i) {
//                if (((totReviewCardView*)[mCards objectAtIndex:i]).mMode == EDIT) {
//                    cards_num--;
//                } else {
//                    break;
//                }
//            }
//        }
//    }
//}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + 389 > scrollView.contentSize.height) {
        [self loadCardsNumber:10];
    }
}

#pragma mark - Timer delegate

- (void)timerCallback: (totTimer*)timer {
    for (int i = 0; i < [mCards count]; ++i) {
        totReviewCardView* cv = [mCards objectAtIndex:i];
        // update
        if( cv.mMode == EDIT && cv.mEditView != nil) {
            [cv.mEditView updateCard];
        }
        else if( cv.mMode == SHOW && cv.mShowView != nil) {
            [cv.mShowView updateCard];
        }
    }
}

- (void)setupTimer {
    timer = [[totTimer alloc] init];
    [timer setDelegate:self];
    [timer startWithInternalInSeconds:60];
}

@end
