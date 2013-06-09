//
//  FMNavigationController.h
//  flatServiceProject
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMSlideViewController.h"

typedef enum footerType{footerAll,footerAdd,footerFavorite,}typeFooter;
@class FMMenuViewController;
@interface FMNavigationController : UIViewController<UINavigationBarDelegate>{
    int type;
}

@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) FMMenuViewController *slideMenuController;
@property (nonatomic, retain,readonly
           ) UIViewController *rootViewController;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)pushViewController:(UIViewController *)controller;
- (UIViewController *)popViewController;
-(UIViewController*)removeTopViewController;
-(void)addActivityIndicator:(BOOL)activity toView:(UIView*)view;
@end
