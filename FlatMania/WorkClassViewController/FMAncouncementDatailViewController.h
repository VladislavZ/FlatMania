//
//  FMAncouncementDatailViewController.h
//  FlatMania
//
//  Created by Vladislav on 12.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMSlideViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIButton+UIButton_withImag.h"
#import "FMSystemDataClass.h"

@interface FMAncouncementDatailViewController : FMSlideViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource,MKReverseGeocoderDelegate> {
    BOOL heatButtonHidden;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFlatDictionary:(NSMutableDictionary*)flatDictionary andTypeDirection:(BOOL)direction;
@property (weak, nonatomic) IBOutlet UIScrollView *infoScrollView;
@property (weak, nonatomic) IBOutlet UITableView *flatInfoTableView;
@property (weak, nonatomic) IBOutlet UIImageView *toolbarIMageView;
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrolView;
@property (weak, nonatomic) IBOutlet UILabel *typeFlatLabel;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end
