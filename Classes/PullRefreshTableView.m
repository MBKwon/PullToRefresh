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


@implementation PullRefreshTableView

@synthesize refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner;


- (void)addPullToRefreshHeader
{
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
                                    (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
                                    27, 44);
    
    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:refreshArrow];
    [refreshHeaderView addSubview:refreshSpinner];
    
    [self addSubview:refreshHeaderView];
}

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
                refreshLabel.text = TEXT_RELEASE;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = TEXT_PULL;
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
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
        [self startLoading];
    }
}

-(void)startLoading
{
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = TEXT_LOADING;
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    if ([_refreshDelegate respondsToSelector:@selector(refresh)]==YES) {
        
        // Refresh action!
        [_refreshDelegate refresh];
        
    } else {
        
        [self refresh];
    }
}

-(void)stopLoading
{
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(stopLoadingComplete)];
    }];
}

-(void)stopLoadingComplete
{
    // Reset the header
    refreshLabel.text = TEXT_PULL;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

-(void)refresh
{
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

@end
