//
//  totReviewTableViewController.m
//  totdev
//
//  Created by Lixing Huang on 5/28/12.
//  Copyright (c) 2012 USC. All rights reserved.
//

#import "totReviewTableViewController.h"

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

- (void)setData:(NSArray *)dat {
    [mData removeAllObjects];
    
    for (int i=0; i<[dat count]; i++) {
        [mData addObject:[dat objectAtIndex:i]];
    }
}

#pragma mark - UITableView delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
    static NSString *identifier = @"review_table_row";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = [mData objectAtIndex:indexPath.row];
    
    return cell;
}

static bool once = YES;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    NSLog(@"offset: %f", offset.y);   
    NSLog(@"content.height: %f", size.height);   
    NSLog(@"bounds.height: %f", bounds.size.height);   
    NSLog(@"inset.top: %f", inset.top);   
    NSLog(@"inset.bottom: %f", inset.bottom);   
    NSLog(@"pos: %f of %f", y, h);
    printf("=====\n");
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        NSLog(@"load more rows");
        
        if (once) {
            [mData addObject:@"loading"];
            [mReviewTable reloadData];
            once = NO;
        }
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
    
    mReviewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
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
