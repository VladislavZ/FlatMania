//
//  FMNavigationController.m
//  flatServiceProject
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMNavigationController.h"
#import "FMMenuViewController.h"

@class FMMenuViewController;
@interface FMNavigationController () {
    UIButton *footerAllButton;
    UIButton *favoriteButton;
    UIButton *addFooterButton;
    FMMenuViewController *slideMenu;
}
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicator;

@end



@implementation FMNavigationController

@synthesize navigationBar;
@synthesize contentView;
@synthesize slideMenuController;
@synthesize rootViewController=_rootViewController;
@synthesize activityIndicator;

- (id)init
{
    self = [super init];
    if (self) {
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        CGRect masterRect = [[UIScreen mainScreen] bounds];
        UIImage *navigationBarImage = [UIImage imageNamed:@"bgtop.png"];
        CGRect contentFrame = CGRectMake(0.0, navigationBarImage.size.height, masterRect.size.width, masterRect.size.height - navigationBarImage.size.height-statusBarFrame.size.height);
        CGRect navBarFrame = CGRectMake(0.0, 0.0, masterRect.size.width, navigationBarImage.size.height);
        
        self.view = [[UIView alloc] initWithFrame:masterRect];
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.view.backgroundColor = [[UIColor alloc] initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
        
        self.contentView = [[UIView alloc] initWithFrame:contentFrame];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.contentView];
        
        self.navigationBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
        self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.navigationBar.delegate = self;
        [self.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
        [self.view insertSubview:self.navigationBar aboveSubview:self.contentView];


        

    }
    return self;
}


-(void)addActivityIndicator:(BOOL)activity toView:(UIView*)view{
    
    if (activity) {
        UIActivityIndicatorView *addActive= [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator = addActive;
    activityIndicator.frame = CGRectMake(10.0, 0.0, 150.0, 150.0);
    activityIndicator.center = self.view.center;
        activityIndicator.layer.zPosition = 200;
    [self.view addSubview: activityIndicator];
    [activityIndicator startAnimating];
    }
    else
    {
        [activityIndicator stopAnimating];
        activityIndicator=nil;
    }
}

#pragma mark - FooterSelector

-(void)footerAllSelector{

    FMRentViewController *controllers = [[FMRentViewController alloc] initWithNibName:@"FMRentViewController" bundle:nil];
    [slideMenu addViewController:controllers withTitle:controllers.title];
}





- (id)initWithRootViewController:(FMSlideViewController *)rootViewController
{
    
    self = [self init];
    if(self) {
        _rootViewController = rootViewController;
         UIImage *settingImage = [UIImage imageNamed:@"settings.png"];
        UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingButton.frame = CGRectMake(0, 0, settingImage.size.width, settingImage.size.height);
        [settingButton addTarget:self.slideMenuController action:@selector(toggleMenu) forControlEvents:
         UIControlEventTouchUpInside];
       
        [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
        rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
        
               [self addChildViewController:rootViewController];
        rootViewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:rootViewController.view];
        [self.navigationBar pushNavigationItem:rootViewController.navigationItem animated:YES];
        rootViewController.navigationController = self;

//        [self addActivityIndicator:YES];
    }
    return self;
}

- (void)pushViewController:(FMSlideViewController *)controller
{
    [self addChildViewController:controller];
    
    [self.navigationBar pushNavigationItem:controller.navigationItem animated:NO];
    controller.navigationController = self;
    
    controller.view.frame = self.contentView.bounds;
    [self.contentView addSubview:controller.view];
    if([self.childViewControllers count] == 1)
    {
        [self.contentView addSubview:controller.view];
    }
    else
    {
        UIViewController *previousController = [self.childViewControllers   objectAtIndex:[self.childViewControllers count]-2];
        [self transitionFromViewController:previousController toViewController:controller duration:0.5 options:UIViewAnimationOptionTransitionNone animations:nil
                                completion:^(BOOL finished) {
                                    [controller didMoveToParentViewController:self];
                                    NSLog(@"%@",self.childViewControllers);
                                }];
//        [self transitionFromViewController:previousController toViewController:controller duration:0.5 options:UIViewAnimationOptionTransitionNone animations:NULL completion:NULL];
    }
}

- (UIViewController *)popViewController
{
    //Can use this to pop manually rather than back button alone
    UIViewController *controller = [self.childViewControllers lastObject];
    UIViewController *previousController = nil;
    if([self.childViewControllers count] > 1)
    {
        previousController = [self.childViewControllers objectAtIndex:[self.childViewControllers count]-2];
        previousController.view.frame = self.contentView.bounds;
    }
    
    [self transitionFromViewController:controller toViewController:previousController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:NULL completion:NULL];
    [controller removeFromParentViewController];
    
    if(self.navigationBar.items.count > self.childViewControllers.count)
        [self.navigationBar popNavigationItemAnimated:YES];
    
    return controller;
}

-(UIViewController*)removeTopViewController
{
    UIViewController *controller = [self.childViewControllers lastObject];
    
    UIViewController *previousController = nil;
    if([self.childViewControllers count] > 1)
    {
        previousController = [self.childViewControllers objectAtIndex:[self.childViewControllers count]-2];
        previousController.view.frame = self.contentView.bounds;
        
        
    }
    
    
    [self transitionFromViewController:controller toViewController:previousController duration:0.3 options:UIViewAnimationOptionTransitionNone animations:NULL completion:NULL];
    [controller removeFromParentViewController];
    
    return controller;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    UIViewController *controller = [self.childViewControllers lastObject];
    
    if (item==controller.navigationItem) //Will now called only if a back button pop happens, not in manual pops
    {
        [self removeTopViewController];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
