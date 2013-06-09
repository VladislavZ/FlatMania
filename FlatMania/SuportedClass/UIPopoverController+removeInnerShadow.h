//
//  UIPopoverController+removeInnerShadow.h
//  FlatMania
//
//  Created by Vladislav on 09.06.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPopoverController (removeInnerShadow)
- (void)removeInnerShadow;
- (void)presentPopoverWithoutInnerShadowFromRect:(CGRect)rect
                                          inView:(UIView *)view
                        permittedArrowDirections:(UIPopoverArrowDirection)direction
                                        animated:(BOOL)animated;

- (void)presentPopoverWithoutInnerShadowFromBarButtonItem:(UIBarButtonItem *)item
                                 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                                 animated:(BOOL)animated;
@end
