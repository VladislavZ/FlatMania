//
//  FMImageView.h
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FMImageViewDelegate <NSObject>
-(void)delateImage:(UIImage*)image;

@end

@interface FMImageView : UIView{
    UIImageView *imageView;
    UIButton *cancelButton;
    id<FMImageViewDelegate> delegate;
}
-(void)setIMageViewImage:(UIImage*)images;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,readwrite) BOOL ISsetImage;
@property (nonatomic,retain) id <FMImageViewDelegate> delegate;
@end
