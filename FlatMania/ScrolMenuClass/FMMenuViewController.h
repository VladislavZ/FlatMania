//
//  JWSlideMenuController.h
//  JWSlideMenu
//
//  Created by Jeremie Weldin on 11/14/11.
//  Copyright (c) 2011 Jeremie Weldin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMSlideViewController.h"
#import "FMRentViewController.h"
#import "FMSearchViewController.h"

@interface FMMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,FMSearchDelegate,UIWebViewDelegate>{
    CGPoint previousPoint;
    UIButton *footerAllButton;
    NSMutableArray *infoArray;
    UIActivityIndicatorView *addActive;
    NSUserDefaults *userDefaults;
    UIWebView *authWebView;
}

@property (retain, nonatomic) UITableView *menuTableView;
@property (retain, nonatomic) UIView *menuView;
@property (retain, nonatomic) UIToolbar *contentToolbar;
@property (retain, nonatomic) UIView *contentView;
@property (retain, nonatomic) UIColor *menuLabelColor;
@property (retain,nonatomic) NSArray *menuArraySection1;
@property (retain,nonatomic) NSArray *menuArraySection2;
@property (retain,nonatomic) NSArray *imageNameArray1;
@property (retain,nonatomic) NSArray *imageNameArray2;
@property (retain,nonatomic) UIView *searchView;
@property (readwrite,nonatomic) NSInteger numberViewSelect;
-(IBAction)toggleMenu;
-(IBAction)toggleSearch;
-(FMNavigationController *)addViewController:(FMSlideViewController*)controller withTitle:(NSString *)title;


@end
