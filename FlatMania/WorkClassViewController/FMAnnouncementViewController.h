//
//  FMAnnouncementViewController.h
//  FlatMania
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMSlideViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FMFlatInfoView.h"
#import "FMFloopView.h"
#import "FMRefreshScrollView.h"


@interface FMAnnouncementViewController : FMSlideViewController<UIScrollViewDelegate,FMRefreshProtocol>{
    BOOL _reloading;
    NSUserDefaults *userDefaults;
  
    
    __weak IBOutlet UIScrollView *scrollView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andInfoArray:(NSMutableArray*)array;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *nameFlatLabel;
@property (weak, nonatomic) IBOutlet UIImageView *toolbarIMageView;
@property(nonatomic, assign) BOOL ScreenIsLoaded;
@end
