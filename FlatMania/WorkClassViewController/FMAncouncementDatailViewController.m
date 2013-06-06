 //
//  FMAncouncementDatailViewController.m
//  FlatMania
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMAncouncementDatailViewController.h"
#import "SBJson.h"
#import "FMFloopView.h"
#import <MapKit/MapKit.h>
#import "FMAsynhImageView.h"

@interface FMAncouncementDatailViewController (){
    NSInteger countImage;
    CLLocationManager *locationManager;
    NSInteger idFlatParametr;
    NSInteger userIdParametr;
    UIButton *likeButton;
    CGRect visibleRect;
    NSInteger numberImage;
    NSUserDefaults *userDefaults;
    UITableView *infoTableView;
    NSMutableDictionary *infoArray;
    NSString *locationStreet;
    UIAlertView *phoneAlert;
    BOOL Jaloba;
}
@property (nonatomic,retain) NSMutableDictionary *infoFlatDictionary;
@property (nonatomic,retain) NSMutableArray *infoFlatKey;
@property (nonatomic,retain) NSMutableArray *flatImageArray;
@property (nonatomic,readwrite) BOOL favoriteFlag;
@end

@implementation FMAncouncementDatailViewController
@synthesize infoFlatDictionary,infoFlatKey,flatInfoTableView,infoScrollView,toolbarIMageView;
//data
@synthesize flatImageArray;
@synthesize imageScrolView,typeFlatLabel,pageControl,favoriteFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFlatDictionary:(NSMutableDictionary*)flatDictionary andTypeDirection:(BOOL)direction
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        infoFlatDictionary = flatDictionary;
        idFlatParametr = [[infoFlatDictionary objectForKey:@"Id"] integerValue];
        userIdParametr = [[infoFlatDictionary objectForKey:@"UserId"] integerValue];
        self.flatImageArray = [self loadImageFlatByID:idFlatParametr];
        self.favoriteFlag = [self getFavoriteFlagMethod];
        heatButtonHidden = direction;
        infoArray = [self getInfoDictionaryForUserId:userIdParametr];
        [self getCoreLocation];
    }
    return self;
}

-(NSMutableDictionary*)getInfoDictionaryForUserId:(NSInteger)userID {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString =[NSString stringWithFormat:@"action=usergetbyid&id=%d",userID];
    
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *dict = [parser objectWithString:htmlString error:nil];
    return dict;
}

-(BOOL)getFavoriteFlagMethod {
    BOOL value;
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString =[NSString stringWithFormat:@"action=flatfavoritesget&id=%d&uid=%@",idFlatParametr,[userDefaults objectForKey:@"LoginId"]];
    
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSMutableDictionary *dict = [parser objectWithString:htmlString error:nil];
    if ([dict objectForKey:@"code"]) {
        value = NO;
    }
    else
        value = YES;
    return value;
}

-(NSMutableArray*)loadImageFlatByID:(NSInteger)flatId{
    NSMutableArray *imageArray;
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString =[NSString stringWithFormat:@"action=flatimagegetbyflatid&id=%d",flatId];
    
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableArray *loadArray = [parser objectWithString:htmlString error:nil];
    if ([loadArray isKindOfClass:[NSMutableDictionary class]]) {
        
        if ([(NSMutableDictionary*)loadArray objectForKey:@"flatid"]) {
            NSMutableDictionary *buferDict = (NSMutableDictionary*)loadArray;
            imageArray = [[NSMutableArray alloc] initWithObjects:buferDict, nil];
        }
    }
    else imageArray = loadArray;
    return imageArray;
}

#pragma Location Manager 

-(void)getCoreLocation {
   locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
  
    NSLog(@"%@",locationManager.location);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    [locationManager stopUpdatingLocation];
    
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark  *placemark = [placemarks lastObject];
            
            [self locationStreet:placemark.thoroughfare];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

-(void)locationStreet:(NSString*)location {
    locationStreet = location;
    NSLog(@"StreetLocation = %@",location);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {

}

-(void)viewDidAppear:(BOOL)animated{
   
//    [self.navigationController addActivityIndicator:NO toView:self.view];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.imageScrolView removeFromSuperview];
    self.imageScrolView = nil;
    self.pageControl=nil;
    self.flatImageArray = nil;
    [self.infoScrollView removeFromSuperview];
    self.infoScrollView = nil;
    [infoTableView removeFromSuperview];
    infoTableView = nil;
}

-(void)stopActivityIndicator {
     [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    Jaloba = NO;
    self.view.backgroundColor = [[UIColor alloc] initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    UIImage *burImage = [UIImage imageNamed:@"bgtop.png"];
    CGRect masterRect = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, masterRect.size.width, masterRect.size.height-burImage.size.height-statusBarFrame.size.height);
    self.typeFlatLabel.text = [NSString stringWithFormat:@"%@ квартира",[self.infoFlatDictionary objectForKey:@"FlatTypeName"]];
    self.imageScrolView.contentSize = CGSizeMake(self.view.frame.size.width*[self.flatImageArray count], self.imageScrolView.frame.size.height);
     self.imageScrolView.pagingEnabled = TRUE;
    if ([self.flatImageArray count]<=1) {
        self.imageScrolView.hidden=YES;
        self.pageControl.hidden=YES;
    }
    numberImage=0;
    self.pageControl.numberOfPages = [self.flatImageArray count];
    self.pageControl.currentPage=0;
    CGFloat xPositionImage=0;
    for (NSInteger k=0; k<[self.flatImageArray count]; k++) {
        NSString *imageLink = [NSString stringWithFormat:@"%@/%d/%@",imageUrl,idFlatParametr,[[self.flatImageArray objectAtIndex:k] objectForKey:@"link"]];
        FMAsynhImageView *flatImageView = [[FMAsynhImageView alloc] initWithFrame:CGRectMake(xPositionImage, 0, self.view.frame.size.width, self.imageScrolView.frame.size.height)];
        [flatImageView loadImageFromURL:[NSURL URLWithString:imageLink]];
//        UIImageView *flatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xPositionImage, 0, self.view.frame.size.width, self.imageScrolView.frame.size.height)];
//        [[FMSystemDataClass getSystemData] processImageDataWithURLString:imageLink andBlock:^(NSData *imageData) {
//            if (self.view.window) {
//                flatImageView.image = [UIImage imageWithData:imageData];
//            }
//        }];
        if ([self.flatImageArray count]<=1) {
            [self.infoScrollView addSubview:flatImageView];
        }
        else [self.imageScrolView addSubview:flatImageView];
        xPositionImage+=self.view.frame.size.width;
        if (k==[self.flatImageArray count]-1) {
            [self performSelector:@selector(stopActivityIndicator) withObject:nil afterDelay:1.0f];
        }
    }
    self.infoScrollView.backgroundColor = [UIColor clearColor];
    
    infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.typeFlatLabel.frame.origin.y+50, self.infoScrollView.frame.size.width, 380)];
    infoTableView.delegate = self;
    infoTableView.dataSource = self;
    infoTableView.backgroundView = nil;
    infoTableView.scrollEnabled = NO;
    infoTableView.backgroundColor = [UIColor clearColor];
    [self.infoScrollView addSubview:infoTableView];
   
    UIImage *imageFailButton = [UIImage imageNamed:@"button-claim.png"];
    self.infoScrollView.contentSize = CGSizeMake(self.infoScrollView.frame.size.width, self.imageScrolView.frame.size.height+50+infoTableView.frame.size.height+imageFailButton.size.height*2);
    
    UIButton *failButton = [UIButton buttonWithType:UIButtonTypeCustom];
    failButton.frame = CGRectMake(self.view.frame.size.width/2-imageFailButton.size.width-10, self.infoScrollView.contentSize.height-imageFailButton.size.height-30, imageFailButton.size.width, imageFailButton.size.height)
    ;
    [failButton setBackgroundImage:[UIImage imageNamed:@"button-claim.png"] forState:UIControlStateNormal];
    [failButton addTarget:self action:@selector(failSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.infoScrollView addSubview:failButton];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(self.view.frame.size.width/2+10, self.infoScrollView.contentSize.height-imageFailButton.size.height-30, imageFailButton.size.width, imageFailButton.size.height);
    ;
    [phoneButton setBackgroundImage:[UIImage imageNamed:@"button-call.png"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(phoneSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.infoScrollView addSubview:phoneButton];
    
    self.title = @"Объявления";
    UIImage *likeImage = [UIImage imageNamed:@"heart.png"];
    likeButton = [UIButton buttonItemWithImage:(self.favoriteFlag)?@"heart-active.png":@"heart.png" title:@"" target:self
 selector:@selector(heartSelector) position:CGRectMake(0, 0, likeImage.size.width, likeImage.size.height)];
    UIImage *backImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backSelector) forControlEvents:UIControlEventTouchUpInside];
    if ([userDefaults objectForKey:@"LoginId"]) {
    if (!heatButtonHidden)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:likeButton];
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
    self.infoFlatKey = [[NSMutableArray alloc] initWithObjects:@"Price",@"Address",@"MetroDistanceName",@"HouseTypeName",@"MetroName", nil];
 
    UIImage *addIMage = [UIImage imageNamed:@"footer-all.png"];
    FMFloopView *footerView =[[FMFloopView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-addIMage.size.height, self.view.frame.size.width, addIMage.size.height) andTypeWindow:0];
    [self.view addSubview:footerView];
}


-(void)failSelector{
    if (!Jaloba) {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString =[NSString stringWithFormat:@"action=flatcopmlaintadd&id=%d",idFlatParametr];
    
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FlatMania" message:@"Жалоба добавлена"
													   delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles: nil];
		[alert show];
        Jaloba=YES;
        NSLog(@"%@",htmlString);}
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FlatMania" message:@"Вы не можете больше жаловаться"
													   delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles: nil];
		[alert show];
        
    }
}

-(void)phoneSelector {
    phoneAlert = [[UIAlertView alloc] initWithTitle:@"FlatMania" message:[NSString stringWithFormat:@"Вы хотите позвонить по номеру %@", [infoArray objectForKey:@"phone"]]
                                                   delegate:self cancelButtonTitle:@"Нет" otherButtonTitles:@"Да",nil];
    [phoneAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView==phoneAlert) {
    if (buttonIndex==1) {
    NSString *aPhoneNo = [@"tel:" stringByAppendingString:[infoArray objectForKey:@"phone"]] ; NSURL *url= [NSURL URLWithString:aPhoneNo];
    [[UIApplication sharedApplication] openURL:url];
    }
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollerView {
    if (scrollerView==self.imageScrolView) {
     
    NSLog(@"content = %f",scrollerView.contentOffset.y);
    visibleRect.origin = scrollerView.contentOffset;
    visibleRect.size = scrollerView.bounds.size;
    
    numberImage = visibleRect.origin.x/self.imageScrolView.bounds.size.width;
    self.pageControl.currentPage=numberImage;
    }
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        // Do something here......................
    }
    NSString *textString;
    NSString *imageName;
    switch (indexPath.row) {
        case 0:{ if ([[infoFlatDictionary objectForKey:@"Price"] isKindOfClass:[NSNull class]])
            textString = @"";
            else
            textString = [NSString stringWithFormat:@"%@ рублей в месяц",[infoFlatDictionary objectForKey:@"Price"]];
        imageName = @"detailsPrise.png";
        }
            break;
        case 1: {
            if ([[infoFlatDictionary objectForKey:@"Address"] isKindOfClass:[NSNull class]])
                textString = @"";
            else
             textString = [NSString stringWithFormat:@"%@",[infoFlatDictionary objectForKey:@"Address"]];
            imageName = @"detailsAdress.png";
        }
            break;
        case 2:{
            if ([[infoFlatDictionary objectForKey:@"MetroName"] isKindOfClass:[NSNull class]])
                textString = @"";
            else
             textString = [NSString stringWithFormat:@"%@",[infoFlatDictionary objectForKey:@"MetroName"]];
            imageName = @"detailsMetroName.png";
        }
            break;
            
        case 3:{
            if ([[infoFlatDictionary objectForKey:@"MetroDistanceName"] isKindOfClass:[NSNull class]])
                textString = @"";
            else
            textString = [[NSString stringWithFormat:@"%@",[infoFlatDictionary objectForKey:@"MetroDistanceName"]] capitalizedString];
          imageName = @"detailsMetroDistance.png";
        }
            break;
        case 4:{
            if ([[infoFlatDictionary objectForKey:@"HouseTypeName"] isKindOfClass:[NSNull class]])
                textString = @"";
            else
            textString = [NSString stringWithFormat:@"%@",[infoFlatDictionary objectForKey:@"HouseTypeName"]];
            imageName = @"detailsHouseType.png";
        }
            break;
        case 5:{
            textString = [NSString stringWithFormat:@"%@ этаж из %@",[infoFlatDictionary objectForKey:@"Floor"],[infoFlatDictionary objectForKey:@"FloorTotal"]];
            imageName = @"detailsFloor.png";
        }
            break;
        case 6:
            textString = [NSString stringWithFormat:@"%@, %@",[infoArray objectForKey:@"firstname"],[infoArray objectForKey:@"phone"]];
            imageName = @"detailsUser.png";
            break;
        case 7:
            if ([[infoFlatDictionary objectForKey:@"Price"] isKindOfClass:[NSNull class]])
                textString = @"";
            else
            textString = [NSString stringWithFormat:@"%@",([[infoFlatDictionary objectForKey:@"IsGood"] isEqual:@"1"])?@"Либеральные условия":@"Не либеральыне условия"];
            imageName = @"detailsLiberal.png";
            break;
            
        default:
            break;
    }
    if (indexPath.row==1) {
        UIImage *image = [UIImage imageNamed:@"checked.png"];
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 10, image.size.width, image.size.height)];
        if ([[infoFlatDictionary objectForKey:@"Address"] isEqual:locationStreet]) {
            cellImage.image = [UIImage imageNamed:@"checked.png"];
        }
        else
            cellImage.image = [UIImage imageNamed:@"warrning.png"];
        [cell.contentView addSubview:cellImage];
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image =[UIImage imageNamed:imageName];
    cell.textLabel.text = textString;
    
    cell.textLabel.textColor = [[UIColor alloc] initWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    //TODO: either support tabbaritem or a protocol in order to handle images in the menu.
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark  - navBarSelector

-(void)backSelector{
    [self.navigationController popViewController];
}
-(void)heartSelector {
    [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
    [self performSelector:@selector(heartSelectorActivity) withObject:nil afterDelay:0.2];
}

-(void)heartSelectorActivity {
    [likeButton setBackgroundImage:[UIImage imageNamed:(self.favoriteFlag)?@"heart.png":@"heart-active.png"] forState:UIControlStateNormal];
    
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString;
    if (!self.favoriteFlag)
        bodyString =[NSString stringWithFormat:@"action=flatfavoritesadd&id=%d&uid=%@",idFlatParametr,[userDefaults objectForKey:@"LoginId"]];
    else bodyString =[NSString stringWithFormat:@"action=flatfavoritesdelete&id=%d&uid=%@",idFlatParametr,[userDefaults objectForKey:@"LoginId"]];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
//    NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSData *dataget = [userDefaults objectForKey:@"favoritesKey"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:dataget];
    NSMutableArray *favoritesarray = [[NSMutableArray alloc] initWithArray:arr];
//     = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"favoritesKey"]];
    if (!self.favoriteFlag)
        [favoritesarray addObject:infoFlatDictionary];
    else
        [favoritesarray removeObject:infoFlatDictionary];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:favoritesarray];
//    flatArray = nil;
    [userDefaults setObject:data forKey:@"favoritesKey"];
//    [userDefaults setObject:favoritesarray forKey:@"favoritesKey"];
    favoritesarray=nil;
    self.favoriteFlag= !self.favoriteFlag;
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];
}
- (void)didReceiveMemoryWarning
{
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
