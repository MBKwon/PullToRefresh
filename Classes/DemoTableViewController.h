//
//  RootViewController.h
//  PullToRefresh
//
//  Created by Leah Culver on 7/25/10.
//  Copyright Plancast 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableView.h"

@interface DemoTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PullToRefreshDelegate>

@property (nonatomic, strong) IBOutlet PullRefreshTableView *tableView;

@end
