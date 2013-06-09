//
//  FMImageView.m
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+UIButton_withImag.h"

@implementation FMImageView
@synthesize image,ISsetImage,delegate;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *backgroundIMage = [UIImage imageNamed:@"image-border.png"];
        NSLog(@"size = %f   %f",backgroundIMage.size.width,backgroundIMage.size.height);
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backgroundIMage.size.width, backgroundIMage.size.height)];
        imageView.image = backgroundIMage;
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 8;
        self.layer.cornerRadius =8;
        [self addSubview:imageView];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
        [imageView addGestureRecognizer:gesture];
        self.ISsetImage =NO;
    }
    return self;
}

-(void)cancelSelector {
    [delegate delateImage:imageView.image];
imageView.image = [UIImage imageNamed:@"image-border.png"];
    [cancelButton removeFromSuperview];
    cancelButton = nil;
    ISsetImage = NO;
}

-(void)setIMageViewImage:(UIImage*)images{
    if (!cancelButton) {
        self.ISsetImage = YES;
    imageView.image = images;
        self.image = images;
        UIImage *imageButtonCancel = [UIImage imageNamed:@"x-big.png"];
        cancelButton = [UIButton buttonItemWithImage:@"x-big.png" title:@"" target:self selector:@selector(cancelSelector) position:CGRectMake(imageView.frame.size.width-imageButtonCancel.size.width-15, 15, imageButtonCancel.size.width, imageButtonCancel.size.height)];
        [self addSubview:cancelButton];
    }
}

@end
