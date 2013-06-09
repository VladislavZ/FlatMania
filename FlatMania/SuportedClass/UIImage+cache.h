//
//  UIImage+cache.h
//  ios_hdi_player
//
//  Created by Alexander Stepanitsa on 7/31/12.
//  Copyright (c) 2012 FilmOn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (cache)

+ (void)loadImageFromURL:(NSURL*)url completion:(void(^)(UIImage *image))completion;

@end
