//
//  PullRefreshTableViewController.h
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@protocol PullToRefreshDelegate <NSObject>

- (void)refresh;

@end


@interface PullRefreshTableView : UITableView {
    
    BOOL isDragging;
    BOOL isLoading;
}

@property (nonatomic, strong) id<PullToRefreshDelegate> refreshDelegate;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) NSInteger moreCount;


@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabelHeader;
@property (nonatomic, retain) UIImageView *refreshArrowHeader;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinnerHeader;

@property (nonatomic, retain) UIView *refreshFooterView;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinnerFooter;


-(NSInteger)getShowCount;


- (void)addPullToRefreshHeader;
- (void)startLoadingHeader;
- (void)stopLoadingHeader;


- (void)addPullToRefreshFooter;
- (void)startLoadingFooter;
- (void)stopLoadingFooter;

//these methods will be used for implement a UIScrollViewDelegate.
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
