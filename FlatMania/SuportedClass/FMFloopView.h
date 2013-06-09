//
//  FMFloopView.h
//  FlatMania
//
//  Created by Vladislav on 15.05.13.
//  Copyright (c) 2013 Vladislav. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol FMFlooperDelegate <NSObject>
//
//-(void)setActivityIndicator;
//
//@end

@interface FMFloopView : UIView{
    UIButton *footerAllButton;
    UIButton *favoriteButton;
    UIButton *addFooterButton;
    UIButton *myButton;
        UIButton *addFooterButton1;
    UIButton *therthButton;
    int typeWindow;
//    id <FMFlooperDelegate> delegate;
}
//@property (nonatomic,retain) id <FMFlooperDelegate> delegate;
- (id)initWithFrame:(CGRect)frame andTypeWindow:(int)type;

@end
