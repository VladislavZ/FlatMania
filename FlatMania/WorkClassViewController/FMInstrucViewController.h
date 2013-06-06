//
//  FMInstrucViewController.h
//  FlatMania
//
//  Created by Vladislav on 26.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMSlideViewController.h"

@interface FMInstrucViewController : FMSlideViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *instructionScrollView;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@end
