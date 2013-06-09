//
//  JWSlideMenuController.m
//  JWSlideMenu
//
//  Created by Jeremie Weldin on 11/14/11.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"
#import "FMMenuViewController.h"
#import "FMAnnouncementViewController.h"
#import "FMMyFlatViewController.h"
#import "FMFavoriteViewController.h"
#import "FMAgreementViewController.h"
#import "FMAboutAppViewController.h"
#import "FMInstrucViewController.h"
#import "FMAuthorizationViewController.h"
#import "FMAppDelegate.h"
#import "SBJsonParser.h"

@interface FMMenuViewController () {
    FMNavigationController *navController;
    FMAppDelegate  *delegate;
}

@end

@implementation FMMenuViewController

@synthesize menuTableView;
@synthesize menuView;
@synthesize contentToolbar;
@synthesize contentView;
@synthesize menuLabelColor;
@synthesize menuArraySection1,menuArraySection2,imageNameArray1,imageNameArray2;
@synthesize searchView,numberViewSelect;

- (id)init
{
    self = [super init];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        CGRect masterRect = self.view.bounds;
        float menuWidth = 267.0; //masterRect.size.width - 53
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flatmania.logo.png"]];
        logoImageView.frame = CGRectMake(35, 15, menuWidth-60
                                         , 35);
        self.menuArraySection1 = [NSArray arrayWithObjects:@"Объявления",@"Избранные объявления",@"Сдать квартиру",@"Мои объявления", nil];
        self.menuArraySection2 = [NSArray arrayWithObjects:@"О приложении",@"Инструкция",@"Соглашение",@"Выход", nil];
        self.imageNameArray1 = [NSArray arrayWithObjects:@"menu-all.png",@"menu-fav.png",@"menu-add.png",@"menu-my.png", nil];
        self.imageNameArray2 = [NSArray arrayWithObjects:@"menu-sog.png",@"menu-qer.png",@"menu-3.png",@"menu-icons.png", nil];
        CGRect menuFrame = CGRectMake(0.0, 0.0, menuWidth, masterRect.size.height);
        CGRect searchFrame = CGRectMake(53, 0, self.view.frame.size.width-53, masterRect.size.height);
        CGRect contentFrame = CGRectMake(0.0, 0.0, masterRect.size.width, masterRect.size.height-[[UIApplication sharedApplication] statusBarFrame].size.height);
        
        
        
        FMSearchViewController *searchViewController = [[FMSearchViewController alloc] initWithNibName:@"FMSearchViewController" bundle:nil];
        searchViewController.delegate = self;
        self.searchView = searchViewController.view;
        self.searchView.hidden=YES;
        
        self.searchView.frame=searchFrame;
        self.searchView.layer.zPosition=0;
        [self addChildViewController:searchViewController];
        [self.view addSubview:searchView];
        
        self.menuLabelColor = [UIColor whiteColor];
        
        self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 60, menuFrame.size.width, menuFrame.size.height)];
        self.menuTableView.dataSource = self;
        self.menuTableView.delegate = self;
        self.menuTableView.scrollEnabled = NO;
        self.menuTableView.backgroundColor = [UIColor clearColor];
        self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.menuTableView.separatorColor = [UIColor blackColor];
        self.menuTableView.tableHeaderView.backgroundColor = [UIColor blackColor];
        
        self.menuView = [[UIView alloc] initWithFrame:menuFrame];
        self.menuView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bgmenu.jpg"]];
        [self.menuView addSubview:self.menuTableView];
        [self.menuView addSubview:logoImageView];
        
        self.contentView = [[UIView alloc] initWithFrame:contentFrame];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor grayColor];
        
        [self.view addSubview:self.menuView];
        [self.view insertSubview:self.contentView aboveSubview:self.menuView];
        
        
//        [self.view insertSubview:self.menuView aboveSubview:self.searchView];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneSelectorNotification:) name:@"dfdf" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu) name:FMCallMoveMethod object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSearch) name:FMSearchViewShow object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addActivityIndicatorMethod) name:FMAddActivityIndicator object:nil];
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeActivityIndicator) name:FMRemoveActivityIndicator object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(autorization) name:@"autorization" object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu) name:FMMenuViewShow object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(datailViewPush:) name:FMDatailView object:nil];
        
    }
    return self;
}

-(void)datailViewPush:(NSNotification*)notification {
     FMSlideViewController *datailController = [[notification userInfo] valueForKey:@"controller" ];
    [self addViewController:datailController withTitle:datailController.title];
    
}

-(void)autorization {
    FMSlideViewController *pushViewController = [[FMAuthorizationViewController alloc] initWithNibName:@"FMAuthorizationViewController" bundle:nil andTypeView:self.numberViewSelect];
    [self addViewController:pushViewController withTitle:pushViewController.title];
}

-(void)addActivityIndicatorMethod {
  delegate = (FMAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate showProgressHUD:@"Загрузка..."];
}

-(void)removeActivityIndicator {
    [delegate hideProgressHUD];
}

-(void) addActivity:(NSString*)string {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[string dataUsingEncoding:NSUTF8StringEncoding]];
	////
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
    
	NSMutableArray *loadDict = [parser objectWithString:htmlString error:nil];
    if ([loadDict isKindOfClass:[NSMutableDictionary class]]) {

        if ([(NSMutableDictionary*)loadDict objectForKey:@"Id"]) {
            NSMutableDictionary *buferDict = (NSMutableDictionary*)loadDict;
            infoArray = [[NSMutableArray alloc] initWithObjects:buferDict, nil];
        }
        if ([(NSMutableDictionary*)loadDict objectForKey:@"code"]) {
            infoArray = [[NSMutableArray alloc] initWithObjects:nil, nil];
        }
    }
    else infoArray = loadDict;
    FMAnnouncementViewController *ancounceControleller = [[FMAnnouncementViewController alloc]initWithNibName:@"FMAnnouncementViewController" bundle:nil andInfoArray:infoArray];
    [self addViewController:ancounceControleller withTitle:ancounceControleller.title];
    [self toggleSearch];
        [self performSelector:@selector(removeActivityIndicator) withObject:nil afterDelay:2.0f];
}

#pragma mark - SearchViewDelegate

-(void)searchResultArray:(NSString*)searchString{
    [self addActivityIndicatorMethod];

    [self performSelector:@selector(addActivity:) withObject:searchString afterDelay:1];
}


-(void)doneSelectorNotification:(NSNotification*)notification {
    if ([[notification userInfo] valueForKey:@"controller" ]) {
         self.numberViewSelect = [[[notification userInfo] valueForKey:@"controller" ] integerValue];
    }
    [self addActivityIndicatorMethod];
    if ([userDefaults objectForKey:@"LoginId"]==nil) {
        if (self.numberViewSelect!=0){
        [self autorization];
            [self performSelector:@selector(removeActivityIndicator) withObject:nil afterDelay:0.6];
//            [self removeActivityIndicator];
            return;
        }
    }
    [self performSelector:@selector(addViewForNamber:) withObject:[[notification userInfo] valueForKey:@"controller" ] afterDelay:0];
}

-(void)addViewForNamber:(NSInteger)number {
    FMSlideViewController *pushViewController;
    switch (self.numberViewSelect) {
        case 0:{
            pushViewController = [[FMAnnouncementViewController alloc]
                                  initWithNibName:@"FMAnnouncementViewController" bundle:nil andInfoArray:nil];
        }
            break;
        case 1:{
            pushViewController = [[FMFavoriteViewController alloc] initWithNibName:@"FMFavoriteViewController" bundle:nil];
        }
            break;
        case 2:{
            pushViewController = [[FMRentViewController alloc] initWithNibName:@"FMRentViewController" bundle:nil];
        }
            break;
        case 3:{
            pushViewController = [[FMMyFlatViewController alloc] initWithNibName:@"FMMyFlatViewController" bundle:nil];
           
        }
            break;
            
        default:
            break;
    }
        [self addViewController:pushViewController withTitle:pushViewController.title];
    if (self.numberViewSelect!=0)
        [self performSelector:@selector(removeActivityIndicator) withObject:nil afterDelay:0.6];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    previousPoint = touchPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    NSLog(@"%f",previousPoint.y-touchPoint.y); 
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    if (abs(previousPoint.x-touchPoint.x)>50)
        [self toggleMenu];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)toggleSearch {
    [UIView beginAnimations:@"Menu Slide" context:nil];
    [UIView setAnimationDuration:0.2];
    
    if(self.contentView.frame.origin.x == 0) //Menu is hidden
    {
        self.menuView.hidden =YES;
        self.searchView.hidden=NO;
        CGRect newFrame = CGRectOffset(self.contentView.frame, -self.searchView.frame.size.width, 0.0);
        self.contentView.frame = newFrame;
    }
    else //Menu is shown
    {
        [menuTableView reloadData];
        CGRect newFrame = CGRectOffset(self.contentView.frame, +(self.searchView.frame.size.width), 0.0);
        self.contentView.frame = newFrame;
//        [self performSelector:@selector(setHiddenView) withObject:nil afterDelay:0.5];
    }
    [UIView commitAnimations];
    
}

-(void)setHiddenView{
    self.searchView.hidden=!self.searchView.hidden;
    self.menuView.hidden=!self.menuView.hidden;

}

-(IBAction)toggleMenu
{
    
    [UIView beginAnimations:@"Menu Slide" context:nil];
    [UIView setAnimationDuration:0.2];
    
    if(self.contentView.frame.origin.x == 0) //Menu is hidden
    {
        self.menuView.hidden=NO;
        self.searchView.hidden=YES;
        CGRect newFrame = CGRectOffset(self.contentView.frame, self.menuView.frame.size.width, 0.0);
        self.contentView.frame = newFrame;
        self.menuTableView.userInteractionEnabled = YES;
    }
    else //Menu is shown
    {
        [menuTableView reloadData];
        CGRect newFrame = CGRectOffset(self.contentView.frame, -(self.menuView.frame.size.width), 0.0);
        self.contentView.frame = newFrame;
        self.menuTableView.userInteractionEnabled = NO;
    }
    
    [UIView commitAnimations];
}

-(FMNavigationController *)addViewController:(FMSlideViewController *)controller withTitle:(NSString *)title
{
    BOOL zevsFlag = YES;
    if (zevsFlag) {
        if (navController) {
            [navController pushViewController:controller];
        }
        else {
            navController = [[FMNavigationController alloc] initWithRootViewController:controller];
            navController.slideMenuController = self;
            navController.title = title;
            [self.contentView addSubview:navController.view];
            [self presentModalViewController:navController animated:NO];
        }
    }
    else {
        [navController removeFromParentViewController];
        [navController.view removeFromSuperview];
        navController.view = nil;
        navController = nil;
        //    NSArray *childViewController = self.childViewControllers;
        //    [[self.childViewControllers lastObject] removeFromParentViewController];
        navController = [[FMNavigationController alloc] initWithRootViewController:controller];
        navController.slideMenuController = self;
        navController.title = title;
    
        [self addChildViewController:navController];
        [self.contentView addSubview:navController.view];
    }
    
    return navController;
}

#pragma mark - UITableViewDataSource/Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuTableView.bounds.size.width, 20)];
    headerView.backgroundColor = [UIColor blackColor];
    headerView.alpha = 0.8;
    UILabel *tittleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.menuTableView.bounds.size.width, 20)];
    tittleHeaderLabel.backgroundColor = [UIColor clearColor];
    tittleHeaderLabel.textColor = [UIColor grayColor];
    tittleHeaderLabel.font = [UIFont systemFontOfSize:14];
    tittleHeaderLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [headerView addSubview:tittleHeaderLabel];
    return headerView;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *titleString;
    if (section==0)
        titleString = @"Главное меню";
    else
        titleString = @"Дополнительное";
    return titleString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    if (indexPath.section ==0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.menuArraySection1 objectAtIndex:indexPath.row]];
        cell.imageView.image = [UIImage imageNamed:[self.imageNameArray1 objectAtIndex:indexPath.row]];
    }
    else {cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.menuArraySection2 objectAtIndex:indexPath.row]];
        cell.imageView.image = [UIImage imageNamed:[self.imageNameArray2 objectAtIndex:indexPath.row]];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{ NSInteger numberRowInSection;
    if (section==0) {
        numberRowInSection = [menuArraySection1 count];
    }
    else
        numberRowInSection = [menuArraySection2 count];
    return numberRowInSection;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section==0) {
        self.numberViewSelect = indexPath.row;
        [self doneSelectorNotification:nil];
        }
        else {
            FMSlideViewController *pushViewController;
            if (indexPath.row==0) {
        pushViewController = [[FMAboutAppViewController alloc] initWithNibName:@"FMAboutAppViewController" bundle:nil];
            }
            if (indexPath.row==1) {
                pushViewController = [[FMInstrucViewController alloc] initWithNibName:@"FMInstrucViewController" bundle:nil];
            }
            if (indexPath.row==2) {
                pushViewController = [[FMAgreementViewController alloc] initWithNibName:@"FMAgreementViewController" bundle:nil];
            }
            if (indexPath.row==3) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flatmania" message:@"Вы действительно хотите выйти?"
                                                               delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да", nil];
                [alert show];
                       }
            if (indexPath.row!=3) {
            [self addViewController:pushViewController withTitle:pushViewController.title];
            pushViewController=nil;
            }
        }
//        [self performSelector:@selector(toggleMenu) withObject:nil afterDelay:0.1];
    if (indexPath.row==3&indexPath.section==1) return;
        [self toggleMenu];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies])
        {
            NSString* domainName = [cookie domain];
            NSRange domainRange = [domainName rangeOfString:@"vk"];
            if(domainRange.length > 0)
            {
                NSLog(@"YES");
                [storage deleteCookie:cookie];
            }
            NSRange domainRange1 = [domainName rangeOfString:@"facebook"];
            if(domainRange1.length > 0)
            {
                [storage deleteCookie:cookie];
            }
        }
        [userDefaults setObject:@"" forKey:@"fbID"];
        [userDefaults setObject:@"" forKey:@"vkID"];
        [userDefaults setObject:@"" forKey:@"phone"];
        [userDefaults setObject:nil forKey:@"ActiveKey"];
        [userDefaults setObject:nil forKey:@"draftKey"];
        [userDefaults setObject:nil forKey:@"LoginId"];
        [userDefaults setObject:nil forKey:@"favoritesKey"];
        [userDefaults objectForKey:@"favoritesKey"];
        [userDefaults  setObject:nil forKey:@"UserInfo"];
      FMSlideViewController*  pushViewController = [[FMAnnouncementViewController alloc]
                              initWithNibName:@"FMAnnouncementViewController" bundle:nil andInfoArray:nil];
        [self addViewController:pushViewController withTitle:pushViewController.title];
        pushViewController=nil;
        [self toggleMenu];

    }
    
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setMenuView:nil];
    [self setContentView:nil];
    [self setMenuTableView:nil];
    [self setMenuLabelColor:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
