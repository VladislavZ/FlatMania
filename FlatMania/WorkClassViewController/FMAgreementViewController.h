//
//  FMAgreementViewController.h
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"

@interface FMAgreementViewController : FMSlideViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *agreementScrollView;
@property (weak, nonatomic) IBOutlet UILabel *agreementLabel;

@end
