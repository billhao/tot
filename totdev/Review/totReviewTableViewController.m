//
//  totReviewTableViewController.m
//  totdev
//
//  Created by Lixing Huang on 5/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewTableViewController.h"
#import "totReviewStory.h"
#import "totReviewStoryView.h"

#define TABLE_CELL_WIDTH          280
#define TABLE_CELL_DEFAULT_HEIGHT 50
#define TABLE_CELL_START_X        (320-TABLE_CELL_WIDTH)/2

@implementation totReviewTableViewController

@synthesize mReviewTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        mData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setRootController:(totReviewRootController *)parent {
    mRootController = parent;
}

- (void)setData:(NSArray *)dat {
    [mData removeAllObjects];
    [self appendData:dat];
}

- (void)appendData:(NSArray *)dat {
    for (int i=0; i<[dat count]; i++) {
        totReviewStory* story = (totReviewStory*)[dat objectAtIndex:i];
        if (![story isVisibleStory])
            continue;
        
        // have to set the height of each cell manually.
        int cellHeight = [story storyViewHeight];
        
        // constructs the detailed cell view.
        totReviewStoryView *view = [[totReviewStoryView alloc] initWithFrame:CGRectMake(TABLE_CELL_START_X, 0,
                                                                                        TABLE_CELL_WIDTH,
                                                                                        cellHeight)];
        [view setReviewStory:story];
        [mData addObject:view];
        [view release];
    }
}

#pragma mark - UITableView delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    totReviewStoryView* view = (totReviewStoryView*)[mData objectAtIndex:indexPath.row];
    return view.height + 10;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if( mData )
        return [mData count];
    else
        return 0;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"cell_%i", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.contentView addSubview:[mData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    // NSLog(@"offset: %f", offset.y);   
    // NSLog(@"content.height: %f", size.height);   
    // NSLog(@"bounds.height: %f", bounds.size.height);   
    // NSLog(@"inset.top: %f", inset.top);   
    // NSLog(@"inset.bottom: %f", inset.bottom);   
    // NSLog(@"pos: %f of %f", y, h);
    // printf("=====\n");
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        [mRootController loadEvents];
        [mReviewTable reloadData];
    }
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mReviewTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mReviewTable.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [mReviewTable release];
    [mData release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
