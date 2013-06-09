//
//  FMFlatInfoView.h
//  FlatMania
//
//  Created by Vladislav on 14.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMFlatInfoView : UIView

- (id)initWithFrame:(CGRect)frame image:(NSString*)image price:(NSString*)price privat:(BOOL)privat typeFlat:(NSString*)typeFlat created:(NSString*)created metro:(NSString*)metro;

@end
