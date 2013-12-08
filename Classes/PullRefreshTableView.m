//
//  PullRefreshTableViewController.m
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

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableView.h"

#define REFRESH_HEADER_HEIGHT 52.0f

#define TEXT_PULL @"Pull down to refresh..."
#define TEXT_RELEASE @"Release to refresh..."
#define TEXT_LOADING @"Loading..."

#define CELL_COUNT 4


@implementation PullRefreshTableView

@synthesize refreshHeaderView, refreshLabelHeader, refreshArrowHeader, refreshSpinnerHeader;
@synthesize refreshFooterView, refreshSpinnerFooter;


-(NSInteger)getShowCount
{
    if (_items.count > CELL_COUNT*_moreCount) {
        return CELL_COUNT*_moreCount;
    } else {
        return [_items count];
    }
}

#pragma mark - about delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (isLoading) {
        return;
    }
    
    isDragging = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (isLoading) {
        
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0) {
            
            self.contentInset = UIEdgeInsetsZero;
            
        } else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT) {
            
            self.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabelHeader.text = TEXT_RELEASE;
                [refreshArrowHeader layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabelHeader.text = TEXT_PULL;
                [refreshArrowHeader layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (isLoading) {
        return;
    }
    
    isDragging = NO;
    
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoadingHeader];
    } else if (scrollView.contentOffset.y >= REFRESH_HEADER_HEIGHT) {
        NSLog(@"END");
        
        
        if (_items.count > CELL_COUNT*_moreCount) {
            
            [self startLoadingFooter];
        }
    }
}


#pragma mark - about header
- (void)addPullToRefreshHeader
{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabelHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabelHeader.backgroundColor = [UIColor clearColor];
    refreshLabelHeader.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabelHeader.textAlignment = NSTextAlignmentCenter;
    
    refreshArrowHeader = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrowHeader.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                          (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                          27, 44);
    
    refreshSpinnerHeader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinnerHeader.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinnerHeader.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabelHeader];
    [refreshHeaderView addSubview:refreshArrowHeader];
    [refreshHeaderView addSubview:refreshSpinnerHeader];
    
    [self addSubview:refreshHeaderView];
}

-(void)startLoadingHeader
{
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabelHeader.text = TEXT_LOADING;
        refreshArrowHeader.hidden = YES;
        [refreshSpinnerHeader startAnimating];
    }];
    
    if ([_refreshDelegate respondsToSelector:@selector(refresh)]==YES) {
        
        // Refresh action!
        [_refreshDelegate refresh];
        
    } else {
        
        [self refresh];
    }
}

-(void)stopLoadingHeader
{
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentInset = UIEdgeInsetsZero;
        [refreshArrowHeader layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(stopLoadingCompleteHeader)];
    }];
}

-(void)stopLoadingCompleteHeader
{
    // Reset the header
    refreshLabelHeader.text = TEXT_PULL;
    refreshArrowHeader.hidden = NO;
    [refreshSpinnerHeader stopAnimating];
}

-(void)refresh
{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoadingHeader) withObject:nil afterDelay:2.0];
}


#pragma mark - about footer
- (void)addPullToRefreshFooter
{
    _moreCount = 1;
    
    if (_items.count > CELL_COUNT*_moreCount) {
        [refreshFooterView setHidden:NO];
    } else {
        [refreshFooterView setHidden:YES];
    }
    
    refreshSpinnerFooter = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinnerFooter.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinnerFooter.hidesWhenStopped = YES;
    
    [refreshFooterView addSubview:refreshSpinnerFooter];
    
    [self addSubview:refreshFooterView];
}

-(void)startLoadingFooter
{
    isLoading = YES;
    
    // Show the footer
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        [refreshSpinnerHeader startAnimating];
    }];
    
    [self seeMore];
}

-(void)stopLoadingFooter
{
    isLoading = NO;
    
    // Hide the footer
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentInset = UIEdgeInsetsZero;
        
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(stopLoadingCompleteFooter)];
    }];
}

-(void)stopLoadingCompleteFooter
{
    // Reset the footer
    [self reloadData];
    [refreshSpinnerFooter stopAnimating];
}

-(void)seeMore
{
    _moreCount++;
    if (_items.count > CELL_COUNT*_moreCount) {
        [refreshFooterView setHidden:NO];
    } else {
        [refreshFooterView setHidden:YES];
    }
    
    [self performSelector:@selector(stopLoadingFooter) withObject:nil afterDelay:2.0];
}

@end
