//
//  FMMyFlatViewController.h
//  FlatMania
//
//  Created by Vladislav on 17.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMSlideViewController.h"
#import "SBJson.h"
#import "FMAncouncementDatailViewController.h"
#import "FMRefreshScrollView.h"

@interface FMMyFlatViewController : FMSlideViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate,FMRefreshProtocol>
@property (weak, nonatomic) IBOutlet UIView *notView;
@property (nonatomic,retain) NSMutableArray *arrayActive;
@property(nonatomic,retain) NSMutableArray *arrayDraf;
@property (nonatomic,retain) NSMutableArray *deletearray;
@property (weak, nonatomic) IBOutlet UITableView *myFlatTableView;
@property (weak, nonatomic) IBOutlet UIButton *button;


@end
