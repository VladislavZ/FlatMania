//
//  FMAboutAppViewController.h
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"

@interface FMAboutAppViewController : FMSlideViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *aboutScrollView;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;

@end
