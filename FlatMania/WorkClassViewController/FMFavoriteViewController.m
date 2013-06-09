//
//  FMFavoriteViewController.m
//  FlatMania
//
//  Created by Vladislav on 18.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMFavoriteViewController.h"
#import "FMFloopView.h"


@interface FMFavoriteViewController (){
    NSInteger favoriteFlatCount;
    UITableView *favoriteTableView;
    NSMutableArray *imageArray;
}


@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation FMFavoriteViewController

@synthesize textLabelsOne,textLabeltwo;
@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"LoginId"]) {
            NSData *data = [userDefaults objectForKey:@"favoritesKey"];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            self.dataArray = [[NSMutableArray alloc] initWithArray:arr];
            imageArray = [[NSMutableArray alloc] init];
            NSInteger numberinsert = 45;
            for (NSInteger k =0; k<[self.dataArray count];k++) {
            NSString *imageString;
            if ([[dataArray objectAtIndex:k] objectForKey:@"ImageLink"]!=nil) {
                imageString = [[dataArray objectAtIndex:k] objectForKey:@"ImageLink"];
            }
            
            NSString *newString;
            if (![imageString isEqual:NULL]) {
                NSMutableString* mstr2 = [imageString mutableCopy];
                [mstr2 insertString:@"-prv" atIndex:numberinsert];
                newString= mstr2;
            }
            else newString = imageString;
            NSString *imageStringurl = [NSString stringWithFormat:@"%@/%@/%@",imageUrl,[[dataArray objectAtIndex:k] objectForKey:@"Id"],newString];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageStringurl]];
                UIImage *image = [UIImage imageWithData:data];
//            [[FMSystemDataClass getSystemData] processImageDataWithURLString:imageStringurl andBlock:^(NSData *imageData) {
//                    UIImage *imageFlat = [UIImage imageWithData:imageData];
                if (image!=nil)
                [imageArray addObject:image];
                else {
                    [self.dataArray removeObjectAtIndex:k];
                    k =k-1;
                }
                
//            }];
            }
        }
        else
            self.dataArray = nil;
 favoriteFlatCount = [self.dataArray count];
    }
    return self;
}


//-(NSMutableArray*)updateFavorite:(NSDictionary*)flatObject {
////    BOOL value;
//    NSURL *url = [NSURL URLWithString:serverUrl];
//    NSString *bodyString =[NSString stringWithFormat:@"action=flatfavoritesget&uid=%@",[userDefaults objectForKey:@"LoginId"]];
//	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
//    
//	[request1 setHTTPMethod: @"POST"];
//    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
//	NSData *responseData = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
//	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//	SBJsonParser *parser = [[SBJsonParser alloc] init];
//    NSMutableArray *dict = [parser objectWithString:htmlString error:nil];
//    if ([dict objectForKey:@"code"]) {
////        value = NO;
//    }
////    else
////        value = YES;
//    return dict;
//}


-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController addActivityIndicator:NO toView:self.view];
}

-(void)setActivityIndicator {
    [self.navigationController addActivityIndicator:YES toView:self.view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor alloc] initWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    CGRect masterRect = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, -statusBarFrame.size.height, masterRect.size.width, masterRect.size.height-44-statusBarFrame.size.height);
    self.title = @"Избранное";
    UIImage *settingImage = [UIImage imageNamed:@"settings.png"];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    settingButton.frame = CGRectMake(0, 0, settingImage.size.width, settingImage.size.height);
    [settingButton addTarget:self action:@selector(toggleMenu) forControlEvents:
     UIControlEventTouchUpInside];
    
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];

    
    UIImage *flooperImage = [UIImage imageNamed:@"footer-add.png"];
    if (favoriteFlatCount!=0) {
        textLabelsOne.hidden=YES;
        textLabeltwo.hidden=YES;
        favoriteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-flooperImage.size.height)];
        favoriteTableView.delegate = self;
        favoriteTableView.dataSource = self;
        favoriteTableView.backgroundView = nil;
        favoriteTableView.backgroundColor = [UIColor clearColor];
         [self.view addSubview:favoriteTableView];
    }
    
    FMFloopView *footerView =[[FMFloopView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-flooperImage.size.height, self.view.frame.size.width, flooperImage.size.height) andTypeWindow:1];
    [self.view addSubview:footerView];
}

-(void)toggleMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:FMMenuViewShow object:self userInfo:nil];
}


#pragma mark - TableViewDelegate 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count
            ];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [[NSNotificationCenter defaultCenter] postNotificationName:FMAddActivityIndicator object:self userInfo:nil];
    [self performSelector:@selector(pushDatailControllerWithDictionary:) withObject:[self.dataArray objectAtIndex:indexPath.row] afterDelay:0.1];
}

-(void)pushDatailControllerWithDictionary:(NSMutableDictionary*)dictionary {
    UIViewController *controller = [[FMAncouncementDatailViewController alloc] initWithNibName:@"FMAncouncementDatailViewController" bundle:nil andFlatDictionary:dictionary andTypeDirection:YES andTypeFooter:1];
    NSMutableDictionary *pushControllerDict = [[NSMutableDictionary alloc] init];
    [pushControllerDict setObject:controller forKey:@"controller"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FMDatailView object:self userInfo:pushControllerDict];
//    [self.navigationController pushViewController:controller];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifireCell = @"CellIdentifire";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifireCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifireCell];
        UILabel *typeflatLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 250, 20)];
        typeflatLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:14];
        typeflatLabel.tag = 1;
        typeflatLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:typeflatLabel];
        
        UIImageView *timesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(85, 50, 15, 15)];
        timesImageView.image = [UIImage imageNamed:@"clock.png"];
        [cell.contentView addSubview:timesImageView];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 65, 65)];
        imageView.tag=2;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius=8;
        [cell.contentView addSubview:imageView];
        NSInteger numberinsert = 45;
        NSString *imageString;
        if ([[dataArray objectAtIndex:indexPath.row] objectForKey:@"ImageLink"]!=nil) {
            imageString = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"ImageLink"];
        }
        
        NSString *newString;
        if (![imageString isEqual:NULL]) {
            NSMutableString* mstr2 = [imageString mutableCopy];
            [mstr2 insertString:@"-prv" atIndex:numberinsert];
            newString= mstr2;
        }
        else newString = imageString;
//        NSString *imageStringurl = [NSString stringWithFormat:@"%@/%@/%@",imageUrl,[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Id"],newString];
//        [[FMSystemDataClass getSystemData] processImageDataWithURLString:imageStringurl andBlock:^(NSData *imageData) {
//            if (cell.contentView.window) {
//                UIImage *imageFlat = [UIImage imageWithData:imageData];
//                imageView.image = imageFlat;
//            }
//            
//        }];
        imageView.image = [imageArray objectAtIndex:indexPath.row];
        
        UILabel *timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 50, 70, 15)];
        timesLabel.font = [UIFont systemFontOfSize:12];
        timesLabel.textColor = [UIColor grayColor];
        timesLabel.backgroundColor = [UIColor clearColor];
        timesLabel.tag = 3;
        [cell.contentView addSubview:timesLabel];
        
        UIImageView *metroImageView = [[UIImageView alloc] initWithFrame:CGRectMake(185, 50, 15, 15)];
        metroImageView.image = [UIImage imageNamed:@"metro.png"];
        [cell.contentView addSubview:metroImageView];
        
        UILabel *metroNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 50, 120, 15)];
        metroNameLabel.font = [UIFont systemFontOfSize:12];
        metroNameLabel.textColor = [UIColor grayColor];
        metroNameLabel.backgroundColor = [UIColor clearColor];
        metroNameLabel.tag = 4;
        [cell.contentView addSubview:metroNameLabel];
        
        
    }
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *metro = (UILabel*)[cell viewWithTag:4];
    metro.text = [NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"MetroName"]];
    
    UILabel *timesLabel = (UILabel*)[cell viewWithTag:3];
    NSTimeInterval _interval=[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"Created"] doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *_date=[_formatter stringFromDate:date];
    timesLabel.text = _date;
    
    UILabel *typeFlat = (UILabel*)[cell viewWithTag:1];
    typeFlat.text = [NSString stringWithFormat:@"%@ квартира",[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"FlatTypeName"]];
//    UIImageView *imageView = (UIImageView*)[cell viewWithTag:2];
    NSLog(@"%@",[dataArray objectAtIndex:indexPath.row]);
    NSLog(@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"ImageLink"]);
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Удалить";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removeFavoriteFlat:indexPath];
        [self.dataArray removeObjectAtIndex:indexPath.row];
NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.dataArray];
         [userDefaults setObject:data forKey:@"favoritesKey"];
        NSIndexPath *dalateIndexPath = indexPath;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:dalateIndexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
    }
    if ([self.dataArray count]==0) {
        [tableView removeFromSuperview];
        textLabelsOne.hidden=NO;
        textLabeltwo.hidden=NO;
    }
}


-(void)removeFavoriteFlat:(NSIndexPath*)indexPath {
    NSURL *url = [NSURL URLWithString:serverUrl];
    NSString *bodyString =[NSString stringWithFormat:@"action=flatfavoritesdelete&id=%d&uid=%@",[[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"Id"] integerValue],[userDefaults objectForKey:@"LoginId"]];
	NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL:url];
	[request1 setHTTPMethod: @"POST"];
    [request1 setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
	[NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
//	NSString *htmlString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning
{
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
