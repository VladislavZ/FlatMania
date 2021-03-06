//
//  FMFlatInfoView.m
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import "FMFlatInfoView.h"
#import <QuartzCore/QuartzCore.h>
#import "FMAsynhImageView.h"
#import "UIImage+cache.h"

@implementation FMFlatInfoView

- (id)initWithFrame:(CGRect)frame image:(NSString*)image price:(NSString*)price privat:(BOOL)privat typeFlat:(NSString*)typeFlat created:(NSString*)created metro:(NSString*)metro
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect imageViewFrame = CGRectMake(0, 0, frame.size.width-2, 300);
        
        [UIImage loadImageFromURL:[NSURL URLWithString:image] completion:^(UIImage* loadedImage){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];
            imageView.image = loadedImage;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius=8;
            imageView.layer.zPosition=1;
            [self addSubview:imageView];
        }];
        
        UIImage *priceImage = [UIImage imageNamed:@"price.png"];
        UIImageView *priceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewFrame.size.width-priceImage.size.width+2, imageViewFrame.origin.y+imageViewFrame.size.height-75, priceImage.size.width, priceImage.size.height)];
        priceImageView.layer.zPosition=2;
        priceImageView.image = [UIImage imageNamed:@"price.png"];
        [self addSubview:priceImageView];
         UIImage *istrueImage = [UIImage imageNamed:@"istrue.png"];
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageViewFrame.size.width-istrueImage.size.width+2, imageViewFrame.origin.y+imageViewFrame.size.height-68, istrueImage.size.width, 30)];
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setUsesGroupingSeparator:YES];
        [formatter setGroupingSize:3]; // this line is important!
        [formatter setGroupingSeparator:@"\u00a0"];
        NSString *priceString;
        if (price == nil || [price isKindOfClass:[NSNull class]]) priceString = @"";
       else
        priceString =[NSString stringWithFormat:@"%@",price];
        priceLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:[priceString integerValue]]];
        priceLabel.layer.zPosition=3;
        priceLabel.textColor = [[UIColor alloc] initWithRed:240/255.0f green:248/255.0f blue:255/255.0f alpha:1.0f];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:26];
        [self addSubview:priceLabel];
        if (privat) {
        UIImageView *privatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageViewFrame.size.width-istrueImage.size.width+2, imageViewFrame.origin.y+imageViewFrame.size.height-105, istrueImage.size.width, istrueImage.size.height)];
            privatImageView.image = istrueImage;
            privatImageView.layer.zPosition=2;
            [self addSubview:privatImageView];
        }
        UIView *infobackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, imageViewFrame.origin.y+imageViewFrame.size.height-10, imageViewFrame.size.width, 70)];
        infobackgroundView.layer.borderColor = [UIColor grayColor].CGColor;
        infobackgroundView.layer.borderWidth = 0.5;
        infobackgroundView.layer.cornerRadius = 8;
        infobackgroundView.layer.zPosition=0;
        infobackgroundView.backgroundColor=[UIColor whiteColor];
        [self addSubview:infobackgroundView];
        UILabel *flatTypeLable = [[UILabel alloc] initWithFrame:CGRectMake(20,imageViewFrame.origin.y+imageViewFrame.size.height+4, 300, 30)];
        flatTypeLable.text =[NSString stringWithFormat:@"%@ квартира",typeFlat];
        flatTypeLable.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        flatTypeLable.backgroundColor = [UIColor clearColor];
        [self addSubview:flatTypeLable];
        
        UIImageView *clockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, imageViewFrame.origin.y+imageViewFrame.size.height+flatTypeLable.frame.size.height+6, 15, 15)];
        clockImageView.image = [UIImage imageNamed:@"clock.png"];
        [self addSubview:clockImageView];
        UILabel *clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(24+clockImageView.frame.size.width, imageViewFrame.origin.y+imageViewFrame.size.height+flatTypeLable.frame.size.height+6, 80, 15)];
        clockLabel.textColor = [UIColor grayColor];
        NSTimeInterval _interval=[created doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"dd.MM.yyyy"];
        NSString *_date=[_formatter stringFromDate:date];
        clockLabel.text = _date;
        clockLabel.font = [UIFont systemFontOfSize:14];
        clockLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:clockLabel];
        
        UIImageView *metroImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15+clockLabel.frame.origin.x+clockLabel.frame.size.width, imageViewFrame.origin.y+imageViewFrame.size.height+flatTypeLable.frame.size.height+6, 15, 15)];
        metroImageView.image = [UIImage imageNamed:@"metro.png"];
        [self addSubview:metroImageView];
        
        UILabel *metroNameLable = [[UILabel alloc] initWithFrame:CGRectMake(35+clockLabel.frame.origin.x+clockLabel.frame.size.width, imageViewFrame.origin.y+imageViewFrame.size.height+flatTypeLable.frame.size.height+6, 130, 15)];
        if ([metro isKindOfClass:[NSNull class]])
            metroNameLable.text = @"";
        else
        metroNameLable.text = metro;
        metroNameLable.backgroundColor =[UIColor clearColor];
        metroNameLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:metroNameLable];
    }
    return self;
}

@end
