//
//  FMFavoriteViewController.h
//  FlatMania
//
//  Created by Vladislav on 18.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FMSystemDataClass.h"
#import "FMAncouncementDatailViewController.h"
#import "FMFloopView.h"
#import "SBJson.h"


@interface FMFavoriteViewController : FMSlideViewController<UITableViewDataSource,UITableViewDelegate>{
    NSUserDefaults *userDefaults;
}
@property (weak, nonatomic) IBOutlet UILabel *textLabelsOne;
@property (weak, nonatomic) IBOutlet UILabel *textLabeltwo;


@end
