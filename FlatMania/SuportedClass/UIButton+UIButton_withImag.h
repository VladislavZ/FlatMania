//
//  UIButton+UIButton_withImag.h
//  dotlang
//
//  Created by admin on 07.10.12.
//
//

#import <UIKit/UIKit.h>

@interface UIButton (UIButton_withImag)

+ (UIButton*)buttonItemWithImage:(NSString*)imageName title:(NSString*)title target:(id)targetNew selector:(SEL)selectorNew position:(CGRect)frame;


@end
