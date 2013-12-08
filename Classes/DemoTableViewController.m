//
//  RootViewController.m
//  PullToRefresh
//
//  Created by Leah Culver on 7/25/10.
//  Copyright Plancast 2010. All rights reserved.
//

#import "DemoTableViewController.h"


@implementation DemoTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Pull to Refresh";
    _tableView.items = [[NSMutableArray alloc] initWithObjects:@"What time is it?", nil];
    [_tableView addPullToRefreshFooter];
    [_tableView addPullToRefreshHeader];
    [_tableView setRefreshDelegate:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableView getShowCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    cell.textLabel.text = [_tableView.items objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)refresh
{
    [self performSelector:@selector(addItem) withObject:nil afterDelay:2.0];
}

- (void)addItem
{
    // Add a new time
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *now = [dateFormatter stringFromDate:[NSDate date]];
    [_tableView.items insertObject:[NSString stringWithFormat:@"%@", now] atIndex:0];

    [self.tableView reloadData];
    
    [_tableView stopLoadingHeader];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_tableView scrollViewWillBeginDragging:scrollView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView scrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)dealloc
{
    [_tableView.items release];
    [super dealloc];
}

@end

