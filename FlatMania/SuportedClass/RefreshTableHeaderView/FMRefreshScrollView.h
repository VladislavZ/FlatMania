//
//  FMRefreshScrollView.h
//  FlatMania
//
//  Created by Vladislav on 13.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMRefreshProtocol <NSObject>

-(void)updateDatePulldown;

@end

@interface FMRefreshScrollView : UIView{
    UIScrollView *refreshScrollView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textPull;
    NSString *textRelease;
    NSString *textLoading;
    id <FMRefreshProtocol> delegate;
}
@property (nonatomic,retain) id <FMRefreshProtocol> delegate;
@property (nonatomic, retain) UIView *refreshHeaderView;
@property (nonatomic, retain) UILabel *refreshLabel;
@property (nonatomic, retain) UIImageView *refreshArrow;
@property (nonatomic, retain) UIActivityIndicatorView *refreshSpinner;
@property (nonatomic, copy) NSString *textPull;
@property (nonatomic, copy) NSString *textRelease;
@property (nonatomic, copy) NSString *textLoading;

- (void)startLoading:(UIScrollView*)scrollView;
- (void)stopLoading:(UIScrollView*)scrollView;
-(void)dragMethod;
-(void)starting:(UIScrollView*)scrollView;
-(void)changeArrow:(UIScrollView*)scrollView;

@end
