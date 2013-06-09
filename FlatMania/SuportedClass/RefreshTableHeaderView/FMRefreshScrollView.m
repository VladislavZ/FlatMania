//
//  FMRefreshScrollView.m
//  FlatMania
//
//  Created by Vladislav on 13.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMRefreshScrollView.h"
#import <QuartzCore/QuartzCore.h>

#define REFRESH_HEADER_HEIGHT 60.0f

@implementation FMRefreshScrollView

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel, refreshArrow, refreshSpinner,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        textPull = @"Потяните вниз, чтобы обновить список";
        textRelease = @"Отпустите, чтобы обновить список";
        textLoading = @"Загрузка...";
        
        
        refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, REFRESH_HEADER_HEIGHT)];
        refreshLabel.backgroundColor = [UIColor clearColor];
        refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
        refreshLabel.textColor = [[UIColor alloc] initWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
        refreshLabel.textAlignment = NSTextAlignmentCenter;
        
        refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pull-down.png"]];
        refreshArrow.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 30) / 2,
                                        (REFRESH_HEADER_HEIGHT - 30) / 2,
                                        30, 30);
        
        refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        refreshSpinner.frame = CGRectMake((REFRESH_HEADER_HEIGHT - 30) / 2, (REFRESH_HEADER_HEIGHT - 30) / 2, 30, 30);
        refreshSpinner.hidesWhenStopped = YES;
        
        [self addSubview:refreshLabel];
        [self addSubview:refreshArrow];
        [self addSubview:refreshSpinner];
        
        
    }
    return self;
}

-(void)changeArrow:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//        refreshLabel.text = self.textRelease;
    } else {
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
//        refreshLabel.text = self.textPull;
    }
}

-(void)dragMethod {
    refreshLabel.text = self.textPull;
    isDragging = YES;
}

-(void)starting:(UIScrollView*)scrollView{
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading:scrollView];
}
}


- (void)startLoading:(UIScrollView*)scrollView {
    isLoading = YES;
	refreshScrollView = scrollView;
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    scrollView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    refreshArrow.hidden = YES;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
	
    // Refresh action!
    [self performSelector:@selector(refresh:) withObject:scrollView afterDelay:0.3];
//    [self refresh:scrollView];
}

- (void)stopLoading:(UIScrollView*)scrollView {
    isLoading = NO;
	
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    scrollView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh:(UIScrollView*)scrollView {
    [self.delegate updateDatePulldown];
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    [self performSelector:@selector(stopLoading:) withObject:scrollView afterDelay:2.0];
//	[self.delegate1 refreshScrollView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
