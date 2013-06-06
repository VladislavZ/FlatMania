//
//  FMAnnouncementViewController.m
//  FlatMania
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMAnnouncementViewController.h"
#import "FMAncouncementDatailViewController.h"
#import "SBJson.h"
#import "FMRefreshScrollView.h"
#import "FMFloopView.h"
#import "FMMenuViewController.h"
#import "mach/mach.h"

#define countFlatAdd 10




@interface FMAnnouncementViewController ()
{
    NSInteger count;
    NSMutableArray *jsonDictionary;
    NSInteger numberImage;
    CGPoint previousPoint;
    CGFloat moveView;
    UIImageView *previousImageView;
    UIImageView *nextImageView;
    BOOL updateFlag;
    FMRefreshScrollView *refreshView;
        CGRect visibleRect;
    BOOL searchState;
    NSInteger startNumberFlat;
    NSInteger endNumberFlat;
    BOOL loadFlag;
    NSInteger numberFlatAdd;
   
}
@property (nonatomic,retain) NSMutableArray *flatArray;
@property (nonatomic,retain) NSMutableArray *imageArray;

@end

@implementation FMAnnouncementViewController
@synthesize scrollView,ScreenIsLoaded;
@synthesize nameFlatLabel;
@synthesize toolbarIMageView;
@synthesize flatArray,imageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andInfoArray:(NSMutableArray*)array
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        if (array==nil) {
                self.flatArray = [self loadFlatList];
        }
        else
            flatArray=array;
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

-(void)viewDidAppear:(BOOL)animated{
//    [self.navigationController addActivityIndicator:NO];
}

//- (void)clearCaches {
//	// clear any URL caches
//	[[NSURLCache sharedURLCache] removeAllCachedResponses];
//	
//	// clear any cookie caches
//	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", imageUrl]];
//	for (NSHTTPCookie *cookie in [cookieStorage cookiesForURL:url]) {
//        
//		[cookieStorage deleteCookie:cookie];
//	}
//    
//	// attempt to clear any credential caches
//	NSURLCredentialStorage *credentialStorage = [NSURLCredentialStorage sharedCredentialStorage];
//	NSDictionary *credentialsDicationary = [credentialStorage allCredentials];
//    
//	for (NSURLProtectionSpace *space in [credentialsDicationary allKeys]) {
//		NSDictionary *spaceDictionary = [credentialsDicationary objectForKey:space];
//		for (id userName in [spaceDictionary allKeys]) {
//			NSURLCredential *credential = [spaceDictionary objectForKey:userName];
//			[credentialStorage removeCredential:credential forProtectionSpace:space];
//		}
//	}
//}

-(void)viewDidUnload{
    
}

-(void) report_memory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        NSLog(@"Memory in use (in bytes): %u", info.resident_size);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self report_memory];
    startNumberFlat = 0;
    endNumberFlat = 2;
    moveView = 0;
    updateFlag = YES;
    ScreenIsLoaded = YES;
    searchState = NO;
    numberFlatAdd=0;
//    [self clearCaches];
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 60, 30);
    [searchButton addTarget:self action:@selector(searchSelector) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];

    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
     CGRect masterRect = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, masterRect.size.width, masterRect.size.height-44-statusBarFrame.size.height);
    count = 0;
     self.title = @"Объявления";
    self.scrollView.delegate =self;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,410*(([self.flatArray count]==0)?self.scrollView.frame.size.height:[self.flatArray count]));
    self.scrollView.layer.cornerRadius = 8;
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    if (!refreshView) {
    refreshView = [[FMRefreshScrollView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
        refreshView.delegate = self;
    [self.scrollView addSubview:refreshView];
    }
    self.view.backgroundColor = [[UIColor alloc] initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    
    for (NSInteger k=0; k<[self.flatArray count]; k++) {
    [self addFlatInfoviewWithNumber:k];
        numberFlatAdd++;
    }
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache removeAllCachedResponses];

    
    
     UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(handleSingleTap:)];
    [self.scrollView addGestureRecognizer:gesture];
     
    UIImage *image = [UIImage imageNamed:@"footer-all.png"];
    NSLog(@"%f",image.size.height);
    FMFloopView *footerView =[[FMFloopView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-image.size.height, self.view.frame.size.width, image.size.height) andTypeWindow:0];
    [self.view addSubview:footerView];
    
    
}

-(void)stopActivityIndicator {
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];
}



-(void)addFlatInfoviewWithNumber:(NSInteger)number {
//    NSInteger numberinsert = 45;
    NSString *imageString;
    imageString = [[self.flatArray objectAtIndex:number] objectForKey:@"ImageLink"];
    
//    NSString *newString;
//    if (![imageString isKindOfClass:[NSNull class]]) {
//        NSMutableString* mstr2 = [imageString mutableCopy];
//        [mstr2 insertString:@"-prv" atIndex:numberinsert];
//        newString= mstr2;
//    }
//    else newString = imageString;
    NSString *imageLink = [NSString stringWithFormat:@"%@/%@/%@",imageUrl,[[self.flatArray objectAtIndex:number] objectForKey:@"Id"],imageString];
            FMFlatInfoView *flatView = [[FMFlatInfoView alloc]
                                        initWithFrame:CGRectMake(0, 400*number+10,
                                                                 self.scrollView.frame.size.width, 400)
                                        image:imageLink
                                        price:[[self.flatArray objectAtIndex:number] objectForKey:@"Price"]
                                        privat:(BOOL)[[self.flatArray objectAtIndex:number] objectForKey:@"IsPrivate"]
                                        typeFlat:[[self.flatArray objectAtIndex:number] objectForKey:@"FlatTypeName" ]
                                        created:[[self.flatArray objectAtIndex:number] objectForKey:@"Created" ]
                                        metro:[[self.flatArray objectAtIndex:number] objectForKey:@"MetroName" ]];
            [self.scrollView addSubview:flatView];
            if (number==[self.flatArray count]-1)
                [self performSelector:@selector(stopActivityIndicator) withObject:nil afterDelay:1.0f];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"frameuyuy = %f",self.view.frame.origin.x);
    if (!searchState) {
     [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
    [self performSelector:@selector(pushDatailView:) withObject:recognizer afterDelay:0.1];
    }
}

-(void)pushDatailView:(UITapGestureRecognizer*)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    NSInteger numberFlat = (visibleRect.origin.y-location.y)/400;
    NSLog(@"number = %d",numberFlat);
    FMSlideViewController *controller = [[FMAncouncementDatailViewController alloc] initWithNibName:@"FMAncouncementDatailViewController" bundle:nil andFlatDictionary:[self.flatArray objectAtIndex:numberFlat] andTypeDirection:NO];
    [self.navigationController pushViewController:controller];
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollsView {
    [refreshView dragMethod];

    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollsView willDecelerate:(BOOL)decelerate {
    [refreshView starting:scrollsView];
}


#pragma  mark - FMRefreshViewDelegate
-(void)updateDatePulldown{
    self.flatArray = [self loadFlatList];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,410*[self.flatArray count]);
    [userDefaults setObject:self.flatArray forKey:@"allFlatKey"];
    [self viewDidLoad];
}


-(NSMutableArray*)loadFlatList {
    NSURL *url = [NSURL URLWithString:serverUrl];
NSString *bodyString = [NSString stringWithFormat:@"action=flatsgetfull&start=%d&count=10&sort=Flats.Created DESC",startNumberFlat];

	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableArray *loadDict = [parser objectWithString:htmlString error:nil];
    //    if ([listarray count]==1) {
    NSLog(@"%d",[loadDict isKindOfClass:[NSMutableDictionary class]]);
    
    if ([loadDict isKindOfClass:[NSMutableDictionary class]]) {
        
        if ([(NSMutableDictionary*)loadDict objectForKey:@"Id"]) {
            NSMutableDictionary *buferDict = (NSMutableDictionary*)loadDict;
            jsonDictionary = [[NSMutableArray alloc] initWithObjects:buferDict, nil];
        }
        if ([(NSMutableDictionary*)loadDict objectForKey:@"code"]) {
            jsonDictionary = [[NSMutableArray alloc] initWithObjects:nil, nil];
        }
    }
    else jsonDictionary = loadDict;
    return jsonDictionary;
}

-(void)imageSelector:(UIButton*)button{
    
}
-(void)numberFlatMethod:(CGRect)rect{
    numberImage = rect.origin.y/self.scrollView.bounds.size.height;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollerView{
    if (updateFlag==NO) return;
    visibleRect.origin = scrollerView.contentOffset;
    visibleRect.size = scrollerView.bounds.size;
     numberImage = visibleRect.origin.y/400;
    NSLog(@"qqwqwqw = %d",numberImage);
    [refreshView changeArrow:scrollerView];
    if (updateFlag) {
        NSLog(@"flatArray count = %d",[self.flatArray count]);
    if (numberImage==[self.flatArray count]-1) {
         updateFlag=!updateFlag;
         [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
        [self performSelector:@selector(addFlatAfterScroll) withObject:nil afterDelay:0.1];
            }
    }
}


-(void)addFlatAfterScroll {
   
    startNumberFlat+=countFlatAdd;
    
    NSMutableArray *updatearray = [self loadFlatList];
    for (NSInteger k =0; k<[updatearray count]; k++) {
        [self.flatArray addObject:[updatearray objectAtIndex:k]];
        [self addFlatInfoviewWithNumber:numberFlatAdd];
        numberFlatAdd++;
    }
    
    if ([updatearray count]>0){
        self.scrollView.contentSize =CGSizeMake(self.scrollView.frame.size.width,410*(startNumberFlat+[updatearray count]));
        updateFlag=!updateFlag;
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    [sharedCache removeAllCachedResponses];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollerView {

    NSLog(@"content = %f",scrollerView.contentOffset.y);
}


- (void)didReceiveMemoryWarning
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navBar Selector

-(void)searchSelector {
    searchState = !searchState;;
      [[NSNotificationCenter defaultCenter] postNotificationName:FMSearchViewShow object:self userInfo:nil];
}

@end
