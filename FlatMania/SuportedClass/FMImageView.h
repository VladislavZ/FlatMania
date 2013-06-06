//
//  FMImageView.h
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMImageView : UIView{
    UIImageView *imageView;
    UIButton *cancelButton;
}
-(void)setIMageViewImage:(UIImage*)images;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic,readwrite) BOOL ISsetImage;
@end
