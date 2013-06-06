//
//  UIButton+UIButton_withImag.m
//  dotlang
//
//  Created by admin on 07.10.12.
//
//

#import "UIButton+UIButton_withImag.h"

@implementation UIButton (UIButton_withImag)

+ (UIButton*)buttonItemWithImage:(NSString*)imageName title:(NSString*)title target:(id)targetNew selector:(SEL)selectorNew position:(CGRect)frame
{
	UIImage* buttonImage = [UIImage imageNamed:imageName];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
	[button setTitle:title forState:UIControlStateNormal];
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button addTarget:targetNew action:selectorNew
     forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}



@end
