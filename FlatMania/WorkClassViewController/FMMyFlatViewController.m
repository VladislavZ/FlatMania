//
//  FMMyFlatViewController.m
//  FlatMania
//
//  Created by Vladislav on 17.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMMyFlatViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FMFloopView.h"
#import "FMSystemDataClass.h"

@interface FMMyFlatViewController (){
    UIWebView *authWebView;
    NSMutableDictionary *bufer;
    UIImage *image;
    FMRefreshScrollView *refreshView;
    NSUserDefaults *userDefaults;
}

@end

@implementation FMMyFlatViewController
@synthesize arrayActive,arrayDraf,deletearray,myFlatTableView,notView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"LoginId"]) {
            if (![userDefaults objectForKey:@"ActiveMyAncountmentKey"]) {
            self.arrayActive = [self getListFlatfromStatus:1];
                if ([self.arrayActive count]!=0) {
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.arrayActive];
            [userDefaults setObject:data forKey:@"ActiveMyAncountmentKey"];
                }
        }
        else{
            NSData *data = [userDefaults objectForKey:@"ActiveMyAncountmentKey"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            self.arrayActive = [[NSMutableArray alloc] initWithArray:arr];
        }
        if (![userDefaults objectForKey:@"draftAncountmentKey"]) {
            self.arrayDraf = [self getListFlatfromStatus:2];
            if ([self.arrayDraf count]!=0) {
            NSData *dataDraf = [NSKeyedArchiver archivedDataWithRootObject:self.arrayDraf];
            [userDefaults setObject:dataDraf forKey:@"draftAncountmentKey"];
            }
        }
        else{
            NSData *dataDraf = [userDefaults objectForKey:@"draftAncountmentKey"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:dataDraf];
            self.arrayDraf = [[NSMutableArray alloc] initWithArray:arr];
        }
        }
        else {
    self.arrayActive = nil;
            self.arrayDraf = nil;
        }
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self.arrayActive count]==0&[self.arrayDraf count]==0) {
        self.notView.hidden = NO;
    }
    else{
        self.notView.hidden=YES;
        [userDefaults removeObjectForKey:@"ActiveMyAncountmentKey"];
        [userDefaults removeObjectForKey:@"draftAncountmentKey"];
    }
    
    image = [UIImage imageNamed:@"bg-my-active-draft.png"];
    self.view.backgroundColor = [[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:244/255.0F alpha:1.0f];
    self.title = @"Мое";
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect masterRect = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 0, masterRect.size.width, masterRect.size.height-44-statusBarFrame.size.height);
    UIImage *addImage = [UIImage imageNamed:@"add.png"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(addSelector) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(0, 0, addImage.size.width, addImage.size.height);
    self.myFlatTableView.backgroundColor = [UIColor clearColor];
    self.myFlatTableView.backgroundView = nil;
   
    [addButton setBackgroundImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    UIImage *flooperImage = [UIImage imageNamed:@"footer-add.png"];
    FMFloopView *footerView =[[FMFloopView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-flooperImage.size.height, self.view.frame.size.width, flooperImage.size.height) andTypeWindow:3];
    [self.view addSubview:footerView];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(moveSelector:)];
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight|UISwipeGestureRecognizerDirectionLeft);
    
    if (!refreshView) {
        refreshView = [[FMRefreshScrollView alloc] initWithFrame:CGRectMake(0, -60, 320, 60)];
        refreshView.delegate = self;
        [self.myFlatTableView addSubview:refreshView];
    }
//    [self.myFlatTableView addGestureRecognizer:swipeGesture];
}

#pragma mark -refreshView Delegate
-(void)updateDatePulldown{
    self.arrayActive = [self getListFlatfromStatus:1];
    NSData *dataActive = [NSKeyedArchiver archivedDataWithRootObject:self.arrayActive];
    [userDefaults setObject:dataActive forKey:@"ActiveMyAncountmentKey"];
    dataActive = nil;
    
    self.arrayDraf = [self getListFlatfromStatus:2];
    NSData *dataDraf = [NSKeyedArchiver archivedDataWithRootObject:self.arrayDraf];
    [userDefaults setObject:dataDraf forKey:@"draftAncountmentKey"];
    [self.myFlatTableView reloadData];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollsView {
    //if (isLoading) return;
    [refreshView dragMethod];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollsView willDecelerate:(BOOL)decelerate {
    [refreshView starting:scrollsView];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollerView{
    [refreshView changeArrow:scrollerView];
}


-(void)moveSelector:(UIGestureRecognizer*)gesture {
   CGPoint point = [gesture locationInView:self.myFlatTableView];
 
    if (point.x<50) {

        [[NSNotificationCenter defaultCenter] postNotificationName:FMCallMoveMethod object:self userInfo:nil];
    }else{
        NSIndexPath *swipedIndexPath = [self.myFlatTableView indexPathForRowAtPoint:point];
        [self tableView:self.myFlatTableView editingStyleForRowAtIndexPath:swipedIndexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return UITableViewCellEditingStyleDelete;
    
}

-(NSMutableArray*)getListFlatfromStatus:(NSInteger)status{
    NSMutableArray *listarray;
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString = [NSString stringWithFormat:@"action=flatsgetbyuseridfull&id=%@&start=0&condition=Flats.Status=%d&sort=Flats.Id DESC",[userDefaults objectForKey:@"LoginId"],status];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableArray *loadDict = [parser objectWithString:htmlString error:nil];
    NSLog(@"%d",[loadDict isKindOfClass:[NSMutableDictionary class]]);
    
    if ([loadDict isKindOfClass:[NSMutableDictionary class]]) {
        
        if ([(NSMutableDictionary*)loadDict objectForKey:@"Id"]) {
            NSMutableDictionary *buferDict = (NSMutableDictionary*)loadDict;
            listarray = [[NSMutableArray alloc] initWithObjects:buferDict, nil];
        }
        if ([(NSMutableDictionary*)loadDict objectForKey:@"code"]) {
            listarray = [[NSMutableArray alloc] initWithObjects:nil, nil];
        }
    }
    else listarray = loadDict;
    return listarray;
}

-(void)addSelector {
    NSMutableDictionary *pushControllerDict = [[NSMutableDictionary alloc] init];
    [pushControllerDict setObject:[NSString stringWithFormat:@"2"] forKey:@"controller"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dfdf" object:self userInfo:pushControllerDict];
}

#pragma mark - TableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString;
    switch (section) {
        case 0: headerString=@"Активные"; break;
        case 1: headerString=@"Черновик"; break;
        default:
            break;
    }
    return headerString;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return image.size.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width,image.size.height)];
    imageView.image = image;
    [headerView addSubview:imageView];
    UILabel *tittleHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.myFlatTableView.bounds.size.width, image.size.height)];
    tittleHeaderLabel.backgroundColor = [UIColor clearColor];
    tittleHeaderLabel.textColor = [[UIColor alloc] initWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f
                ];
    tittleHeaderLabel.font = [UIFont systemFontOfSize:14];
    tittleHeaderLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    [headerView addSubview:tittleHeaderLabel];
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger NumberRowInSection = 0;
    if (section==0) NumberRowInSection = [self.arrayActive count];
    if (section==1) NumberRowInSection = [self.arrayDraf count];
    return NumberRowInSection;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
    NSMutableDictionary *dictionary;
    if (indexPath.section==0) dictionary = [self.arrayActive objectAtIndex:indexPath.row];
    if (indexPath.section==1) dictionary = [self.arrayDraf objectAtIndex:indexPath.row];
    [self performSelector:@selector(pushDatailControllerWithDictionary:) withObject:dictionary afterDelay:0.1];
}

-(void)pushDatailControllerWithDictionary:(NSMutableDictionary*)dictionary {
    UIViewController *controller = [[FMAncouncementDatailViewController alloc] initWithNibName:@"FMAncouncementDatailViewController" bundle:nil andFlatDictionary:dictionary andTypeDirection:NO];
    [self.navigationController pushViewController:controller];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier =@"Cell";
    NSMutableArray *dataArray;
    switch (indexPath.section) {
        case 0: dataArray = self.arrayActive; break;
        case 1: dataArray = self.arrayDraf; break;
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UILabel *typeflatLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 250, 20)];
        typeflatLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        typeflatLabel.tag = 1;
        typeflatLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:typeflatLabel];
        
        UIImageView *timesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 50, 15, 15)];
        timesImageView.image = [UIImage imageNamed:@"clock.png"];
        [cell.contentView addSubview:timesImageView];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 65, 65)];
        imageView.tag=2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius=8;
        [cell.contentView addSubview:imageView];
      
        

        
        UILabel *timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 70, 15)];
        timesLabel.font = [UIFont systemFontOfSize:12];
        timesLabel.textColor = [UIColor grayColor];
        timesLabel.tag = 3;
        timesLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:timesLabel];
        
        UIImageView *metroImageView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 50, 15, 15)];
        metroImageView.image = [UIImage imageNamed:@"metro.png"];
        [cell.contentView addSubview:metroImageView];
        
        UILabel *metroNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 50, 120, 15)];
        metroNameLabel.font = [UIFont systemFontOfSize:12];
        metroNameLabel.textColor = [UIColor grayColor];
        metroNameLabel.tag = 4;
        metroNameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:metroNameLabel];
    }
   cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *metro = (UILabel*)[cell viewWithTag:4];
    metro.text = [NSString stringWithFormat:@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"MetroName"]];
    
    UILabel *timesLabel = (UILabel*)[cell viewWithTag:3];
    NSTimeInterval _interval=[[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Created"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *_date=[_formatter stringFromDate:date];

    timesLabel.text = _date;
    
    UILabel *typeFlat = (UILabel*)[cell viewWithTag:1];
    typeFlat.text = [NSString stringWithFormat:@"%@ квартира",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"FlatTypeName"]];
    
    NSInteger numberinsert = 45;
    NSString *imageString;
        imageString = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"ImageLink"];
    
    NSString *newString;
    if (![imageString isKindOfClass:[NSNull class]]) {
        NSMutableString* mstr2 = [imageString mutableCopy];
        [mstr2 insertString:@"-prv" atIndex:numberinsert];
        newString= mstr2;
    }
    else newString = imageString;
    NSString *imageStringurl = [NSString stringWithFormat:@"%@/%@/%@",imageUrl,[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Id"],newString];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:2];
    [[FMSystemDataClass getSystemData] processImageDataWithURLString:imageStringurl andBlock:^(NSData *imageData) {
        if (cell.contentView.window) {
            imageView.image = [UIImage imageWithData:imageData];
        }
        
    }];
    NSLog(@"%@",[dataArray objectAtIndex:indexPath.row]);
    NSLog(@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"ImageLink"]);
       
    if (indexPath.section==0) {
        typeFlat.textColor = [UIColor blackColor];
        timesLabel.textColor = [[UIColor alloc] initWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
        metro.textColor = [[UIColor alloc] initWithRed:128/255.0f green:128/255.0f blue:128/255.0f alpha:1.0f];
    }
    else{
        imageView.alpha = 0.6;
        typeFlat.textColor = [[UIColor alloc] initWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
        timesLabel.textColor = [[UIColor alloc] initWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
        metro.textColor = [[UIColor alloc] initWithRed:170/255.0f green:170/255.0f blue:170/255.0f alpha:1.0f];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
     [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self performSelector:@selector(editTableViewCellFromIndex:) withObject:indexPath afterDelay:0.3];
    }
   
}

-(void)editTableViewCellFromIndex:(NSIndexPath*)indexPath {
    [self.myFlatTableView beginUpdates];
    [self.myFlatTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    [self dalateFlatMethod:indexPath];
    [self.myFlatTableView endUpdates];
    [self performSelector:@selector(updateTableView:) withObject:indexPath afterDelay:0.3];
}

-(void)updateTableView:(NSIndexPath*)indexPath {
    switch (indexPath.section) {
        case 0: {
            [self.arrayDraf addObject:bufer];
            NSData *dataDraf = [NSKeyedArchiver archivedDataWithRootObject:self.arrayDraf];
            [userDefaults setObject:dataDraf forKey:@"draftAncountmentKey"];
        }
            break;
        default:
            break;
    }
    if ([self.arrayActive count]==0&[self.arrayDraf count]==0) {
        self.notView.hidden = NO;
    }
    else{
        self.notView.hidden=YES;
        [userDefaults removeObjectForKey:@"ActiveMyAncountmentKey"];
        [userDefaults removeObjectForKey:@"draftAncountmentKey"];

    }
[self.myFlatTableView reloadData];
}

-(void)dalateFlatMethod:(NSIndexPath*)indexPath {
    switch (indexPath.section) {
        case 0: {
            bufer = [self.arrayActive objectAtIndex:indexPath.row];
            [self updateFlatStatus:indexPath.section+2 byFlatId:[[bufer objectForKey:@"Id"] integerValue] ];
            [self.arrayActive removeObjectAtIndex:indexPath.row];
            NSData *activeData = [NSKeyedArchiver archivedDataWithRootObject:self.arrayActive];
            [userDefaults setObject:activeData forKey:@"ActiveMyAncountmentKey"];
        }
            break;
        case 1: {bufer = [self.arrayDraf objectAtIndex:indexPath.row];
            [self.arrayDraf removeObjectAtIndex:indexPath.row];
            [self delateFlatById:[[bufer objectForKey:@"Id"] integerValue]];
        }
            break;
        default:
            break;
    }
}

-(void)delateFlatById:(NSInteger)flatId {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString = [NSString stringWithFormat:@"action=flatdelete&id=%d",flatId];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];
}

-(void)updateFlatStatus:(NSInteger)statusSet byFlatId:(NSInteger)flatId  {
    NSURL *url = [NSURL URLWithString:serverUrl];
   NSString *bodyString = [NSString stringWithFormat:@"action=flatstatuschange&id=%d&status=%d",flatId,statusSet];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	////
	[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
//	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    [[NSNotificationCenter defaultCenter] postNotificationName:FMRemoveActivityIndicator object:self userInfo:nil];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Удалить";
}


- (void)didReceiveMemoryWarning {
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
//    [self setNotView:nil];
    [super viewDidUnload];
}
@end
